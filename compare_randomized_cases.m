close all; clear; clc;

%% === user inputs (edit these) ===
fixation   = 'moving';                         % just for naming outputs
fontSize   = 11;
Period     = [];      % [] => auto-estimate inside choose_settling
pct        = 0.05;    % band
Kss        = 20;      % last Kss periods define SS amplitude
tail_sec   = 15;      % fallback tail window for RMSE
prefix     = ['Results\' fixation 'arm_multi_'];   % output prefix

% Option A (loop): build list of adaptive runs
N = 10;  % <-- set how many cases you have
matCases = cell(1, N);
for k = 1:N
    % use %d for case1,case2,... or %02d for case01,case02,...
    matCases{k} = fullfile('Data', sprintf('%s_adaptive_case%d.mat', fixation, k));
    % matCases{k} = fullfile('Data', sprintf('%s_adaptive_case%02d.mat', fixation, k)); % zero-padded
end

%% === compute errors & metrics (normalized; includes psi) ===
N = numel(matCases);
if N == 0, error('No adaptive cases found. Populate matCases or enable wildcard scan.'); end

TS     = nan(N,1);
NRMSE  = nan(N,1);
METHOD = strings(N,1);
labels = strings(N,1);

E = cell(N,1);   % normalized error-norm vectors
T = cell(N,1);   % time vectors
A = cell(N,1);   % (optional) actual pos
PD = cell(N,1);  % (optional) desired pos

for k = 1:N
    labels(k) = "Case " + string(k);

    % load and align signals (p, pd, psi, psi_d)
    S  = load_run(matCases{k});
    t  = S.t(:);

    % build normalization factors from desired peaks (per channel)
    nf = build_des_norm_factors(S);

    % normalize BEFORE error calculation
    [p_n, pd_n, psi_n, psi_d_n] = normalize_signals(S, nf);

    % 4D normalized error: [p1 p2 p3 psi]
    e  = vecnorm([p_n - pd_n, psi_n - psi_d_n], 2, 2);

    % settling + normalized RMSE (because e is normalized)
    [ts, rmse, method] = choose_settling(t, e, Period, pct, Kss, tail_sec);

    % stash
    T{k} = t;  E{k} = e;  A{k} = S.p;  PD{k} = S.pd;
    TS(k) = ts;  NRMSE(k) = rmse;  METHOD(k) = string(method);

    % console summary (normalized)
    fprintf('\n%s\n', labels(k));
    fprintf('  Method:          %s\n', METHOD(k));
    if isnan(TS(k))
        fprintf('  Settling:        NON-CONVERGED\n');
        fprintf('  nRMSE (tail):    %.4g\n', NRMSE(k));
    else
        fprintf('  Settling:        %.4f s\n', TS(k));
        fprintf('  nRMSE (SS/tail): %.4g\n', NRMSE(k));
    end
end

%% === overlay plot: normalized error norms for all adaptive cases ===
fig = figure('Name','Adaptive Cases: Normalized Error Norm Overlay','Color','w');
hold on; grid on;

h = gobjects(N,1);
for k = 1:N
    h(k) = plot(T{k}, E{k}, 'LineWidth', 1.3);
end

xlabel('time $(s)$','Interpreter','latex','FontSize',fontSize)
ylabel('Normalized $\|[p,\psi](t)-[p_d,\psi_d](t)\|_2$','Interpreter','latex','FontSize',fontSize)
legend(h, cellstr(labels), 'Location','east', 'Interpreter','none', 'FontSize',fontSize);

xlo = min(cellfun(@(tt) tt(1), T));
xhi = max(cellfun(@(tt) tt(end), T));
xlim([xlo xhi]);

set(findall(fig,'-property','FontName'),'FontName','Times')
if ~exist(fileparts(strcat(prefix,'dummy.txt')),'dir'); mkdir(fileparts(prefix)); end
saveFigureAsPDF(fig, strcat(prefix,'error_compare_multi.pdf'));

%% === CSV export (normalized) ===
Tbl = table( ...
    labels(:), ...
    TS(:), ...
    NRMSE(:), ...
    METHOD(:), ...
    'VariableNames', {'Case','Settling_s','RMSE_norm','Method'} ...
);
csvfile = strcat(prefix,'norm_metrics_multi.csv');
if ~exist(fileparts(csvfile),'dir'); mkdir(fileparts(csvfile)); end
writetable(Tbl, csvfile);
fprintf('\nMetrics saved to: %s\n', csvfile);

muTS  = mean(TS,   'omitnan');
sdTS  = std(TS,    'omitnan');
muNR  = mean(NRMSE,'omitnan');
sdNR  = std(NRMSE, 'omitnan');

fprintf('\n=== Aggregate across %d cases ===\n', N);
fprintf('Mean settle:   %.3f s   (std %.3f)\n', muTS, sdTS);
fprintf('Mean SS nRMSE: %.4g     (std %.4g)\n', muNR, sdNR);

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
% Per-channel normalization from PEAK desired magnitudes.
% Fallback floors avoid divide-by-zero when desired is tiny/zero.
    peak_pd   = max(max(abs(S.pd),[],1), 1e-9);  % 1x3 (p1,p2,p3)
    peak_psiD = max(max(abs(S.psi_d)),   1e-9);  % scalar
    nf = struct('p', peak_pd, 'psi', peak_psiD);
end

function [p_n, pd_n, psi_n, psi_d_n] = normalize_signals(S, nf)
% Normalize actual & desired BEFORE error calc, using desired-value factors.
    p_n     = S.p    ./ nf.p;     % Nx3
    pd_n    = S.pd   ./ nf.p;     % Nx3
    psi_n   = S.psi  ./ nf.psi;   % Nx1
    psi_d_n = S.psi_d./ nf.psi;   % Nx1
end
