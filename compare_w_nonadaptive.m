close all; clear; clc;

%% --- user inputs (edit these) ---
fixation = 'fixed';
matA   = ['Data\' fixation '_noestimate.mat'];
matB   = ['Data\' fixation '_adaptive.mat'];
labelA = 'Fixed parameters';
labelB = 'Adaptive';

prefix       = ['Results\' fixation 'arm_'];
fontSize     = 11;

Period       = [];   % If known, set e.g., 2*pi/w. If [], auto-estimate for periodic check.
pct          = 0.05; % 8% band (periodic) and 6% of peak (nonperiodic fallback)
Kss          = 20;    % steady-state defined by last Kss periods (periodic method)
tail_sec     = 15;   % if not settled, compute RMSE over last 15 s

set(0,'DefaultTextInterpreter','latex');

%% --- load & norms ---
%% --- load & normalized norms (includes psi) ---
A  = load_run(matA); 
B  = load_run(matB);

% Build normalization factors from peak desired magnitudes (per channel).
% Fallback to 1 if a desired channel is ~all zeros.
normA = build_des_norm_factors(A);
normB = build_des_norm_factors(B);

% Normalize signals BEFORE error calc
[pA_n, pdA_n, psiA_n, psi_dA_n] = normalize_signals(A, normA);
[pB_n, pdB_n, psiB_n, psi_dB_n] = normalize_signals(B, normB);

% 4D error: [p1 p2 p3 psi] after normalization
eA = vecnorm([pA_n - pdA_n, psiA_n - psi_dA_n], 2, 2);
eB = vecnorm([pB_n - pdB_n, psiB_n - psi_dB_n], 2, 2);

%% --- pick settling using periodic-first, else fallback ---
[tsA, rmseA, methodA] = choose_settling(A.t, eA, Period, pct, Kss, tail_sec);
[tsB, rmseB, methodB] = choose_settling(B.t, eB, Period, pct, Kss, tail_sec);

%% --- plot ---
fig = figure('Name','Normalized Error Norm');
plot(A.t, eA, 'LineWidth',1.3); hold on
plot(B.t, eB, 'LineWidth',1.3);
if ~isnan(tsA), xline(tsA, '--', sprintf('%s $t_s$',labelA), 'LabelVerticalAlignment','middle','Interpreter','latex'); end
if ~isnan(tsB), xline(tsB, '--', sprintf('%s $t_s$',labelB), 'LabelVerticalAlignment','middle','Interpreter','latex'); end
xlabel('time $(s)$','fontsize',fontSize)
ylabel('$\|\epsilon\|_2$','fontsize',fontSize)
legend({labelA,labelB}, 'Location','east','fontsize',fontSize); grid on
xlim([min([A.t;B.t]) max([A.t;B.t])])
if ~exist(fileparts(strcat(prefix,'dummy.txt')),'dir'); mkdir(fileparts(prefix)); end
saveFigureAsPDF(fig, strcat(prefix,'error_compare.pdf'));


% 2D top-view comparison on a single plot
fig = figure('Name','2D Top-View: Both Controllers','Color','w');
if exist('template','var'), setprinttemplate(fig, template); end

hold on; grid on;

% Plot actual paths for both controllers
h_A = plot(A.p(:,1), A.p(:,2), 'b-',  'LineWidth', 1.4);
h_B = plot(B.p(:,1), B.p(:,2), 'g-',  'LineWidth', 1.4);
% Plot desired path (assume same pd for A & B; use A.pd)
h_des = plot(A.pd(:,1), A.pd(:,2), 'r-', 'LineWidth', 1);

% Formatting
% axis equal;
xlabel('$p_1$ $(m)$','Interpreter','latex','FontSize',fontSize)
ylabel('$p_2$ $(m)$','Interpreter','latex','FontSize',fontSize)
legend([h_des, h_A, h_B], {'$p_d$ (desired)', labelA, labelB}, ...
       'Interpreter','latex','Location','best','FontSize',fontSize);

set(findall(fig,'-property','FontName'),'FontName','Times')

% Save
if ~exist(fileparts(strcat(prefix,'dummy.txt')),'dir'); mkdir(fileparts(prefix)); end
saveFigureAsPDF(fig, strcat(prefix,'2Dposition_compare.pdf'));

%% --- print summary ---
fprintf('\n=== Settling on ||error|| ===\n');
print_summary(labelA, tsA, rmseA, methodA);
print_summary(labelB, tsB, rmseB, methodB);

%% --- CSV ---
T = table( ...
    {labelA; labelB}, ...
    [tsA; tsB], ...
    [rmseA; rmseB], ...
    string({methodA; methodB}), ...
    'VariableNames', {'Case','Settling_s','RMSE_norm','Method'} ...
);
csvfile = strcat(prefix,'norm_metrics.csv');
if ~exist(fileparts(csvfile),'dir'); mkdir(fileparts(csvfile)); end
writetable(T, csvfile);
fprintf('Metrics saved to: %s\n', csvfile);

%% ======================= helpers =======================

function S = load_run(matfile)
    L = load(matfile);               % expects L.out with fields p,pd,psi,psi_d (timeseries)
    out = L.out;

    % position
    t   = out.p.time(:);
    p   = out.p.signals.values;      % Nx3

    td  = out.pd.time(:);
    pd  = out.pd.signals.values;

    if numel(td) ~= numel(t) || any(td~=t)
        pd = interp1(td, pd, t, 'linear', 'extrap');
    end

    % yaw (psi)
    tpsi   = out.psi.time(:);
    psi    = out.psi.signals.values(:);
    tpsid  = out.psi_d.time(:);
    psi_d  = out.psi_d.signals.values(:);

    % align/interp to t
    if numel(tpsi) ~= numel(t) || any(tpsi~=t)
        psi = interp1(tpsi, psi, t, 'linear', 'extrap');
    end
    if numel(tpsid) ~= numel(t) || any(tpsid~=t)
        psi_d = interp1(tpsid, psi_d, t, 'linear', 'extrap');
    end



    S = struct('t',t,'p',p,'pd',pd,'psi',psi,'psi_d',psi_d);
end

function nf = build_des_norm_factors(S)
% Build per-channel normalization from PEAK desired magnitudes.
% Using peak desired avoids division by (near) zero and matches “normalize by desired value factor”.
% Fallback to 1 if a channel’s desired is ~all zeros.
    peak_pd = max(max(abs(S.pd),[],1), 1e-9);    % 1x3 (p1,p2,p3)
    peak_psi_d = max(max(abs(S.psi_d)), 1e-9);   % scalar
    nf = struct('p', peak_pd, 'psi', peak_psi_d);
end

function [p_n, pd_n, psi_n, psi_d_n] = normalize_signals(S, nf)
% Normalize actual & desired BEFORE error calc, using desired-value factors.
% Position normalized per-axis; psi normalized by its own peak factor.
    p_n    = S.p   ./ nf.p;       % Nx3
    pd_n   = S.pd  ./ nf.p;       % Nx3
    psi_n  = S.psi ./ nf.psi;     % Nx1
    psi_d_n= S.psi_d ./ nf.psi;   % Nx1
end

function print_summary(name, ts, rmse, method)
    fprintf('\n%s\n', name);
    fprintf('  Method:          %s\n', method);
    if isnan(ts)
        fprintf('  Settling:        NON-CONVERGED\n');
        fprintf('  nRMSE (tail):    %.4g\n', rmse); % normalized RMSE
    else
        fprintf('  Settling:        %.4f s\n', ts);
        fprintf('  nRMSE (SS/tail): %.4g\n', rmse); % normalized RMSE
    end
end
