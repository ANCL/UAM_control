%% Rigid body model parameters (randomized true params + bookkeeping)
% README: UAV trajectory tracking with unknown parameters.
% Circle trajectory without arm. Mass, inertia, and disturbance are unknown.

clear; close all;
addpath('..\robotics_lib');

%% Constants / gravity
g = 9.81;
gravity_vector = [0 0 g]; % g positive because +Z points downward.

%% ---------- Nominal (baseline) parameters ----------
% Quadrotor geometry and nominal "true" params
quadrotor_dim = [0.45 0.45 0.1];     % box size (m)
quadrotor_mass = 1.6;                % kg (ANCL1)
quadrotor_com  = [0 0 0];            % CoM (m)
quadrotor_moi  = [0.03 0.03 0.05];   % nominal principal MOI (kg*m^2)
quadrotor_poi  = [0 0 0];            % products of inertia (unused)

% Links (nominal)
link0_mass = 0.1;
link1_mass = 0.1;
link2_mass = 0.1;    

link1_len  = 0.3;
link2_len  = 0.3;

% Total mass used elsewhere (nominal baseline)
m  = quadrotor_mass + link0_mass + link1_mass; % + link2_mass if used

% Nominal “prior” mass used in your estimator
m0 = 0.7*m;

% Disturbances (nominal baselines)
d_f  = 0.2*[1 1 1].';
d_tau = 0.2*[1 1 1].';

% Inertia matrix (nominal, diagonal)
J = [0.0169572, 0, 0;
     0, 0.0169572, 0;
     0, 0, 0.0338078];

% Vectorized inertia prior used in your code
Jv0 = 0.6*[J(1,1) J(2,2) J(3,3) J(1,2) J(2,3) J(1,3)].';

%% ---------- Gains (as you had them) ----------
k_dtau = 5;
k_df   = 1;

k1 = 1*0.4;
k2 = 1*0.5;
k3 = 1*0.5;
k4 = 12;          % larger k4 reduces SS oscillations
k5 = 20;          % larger k5 reduces SS oscillations

Gamma  = 0.01*eye(6);  % adaptation gain (you can tweak)
lambda = 3;
k_psi1 = 1;
k_psi2 = 1;

%% ---------- Initial conditions ----------
Jv0 = 0.6*[J(1,1) J(2,2) J(3,3) J(1,2) J(2,3) J(1,3)].';
p_0     = 1*[-2 2 0].';
v_0     = [0 0 0].';
omega_0 = 0*[0.1 -0.1 0.1].';
R_0     = eye(3);

omega_d0 = [0 0 0].';
hat_dtau0 = [0 0 0].';
hat_df0   = [0 0 0].';
hat_a0    = 1/m0;

%% ---------- Environment / props ----------
table1_radius = 0.5;  % m
table1_height = 1.0;  % m
table1_loc    = [2 2 -table1_height/2];

table2_radius = 0.5;  % m
table2_height = 0.5;  % m
table2_loc    = [-2 -2 -table2_height/2];

mass_length   = 0.1;
table1_mass_loc = [table1_loc(1) table1_loc(2) -(table1_height+mass_length)];
table2_mass_loc = [table2_loc(1) table2_loc(2) -(table2_height+mass_length)];

%% ---------- Extract robot geometry (your file) ----------
run quad_extract.m
% manip_arm_cross_sec = Arm_with_holes(15, 3, 1, 2);

%% ========== RANDOMIZE TRUE PHYSICAL PARAMETERS ==========
% Randomization affects the *true* system params; your estimates can remain biased.
% Reproducibility: set a seed (or use rng('shuffle') for fresh draws each run).

minSeed = 1000;
maxSeed = 999999;

seed = randi([minSeed maxSeed], 1, 'uint32');   % bounded seed
rng(double(seed), 'twister');                   % set RNG

% Helper inlines
urand  = @(lo,hi) lo + (hi-lo).*rand;                  % scalar uniform
uvec3  = @(lo,hi) [urand(lo,hi) urand(lo,hi) urand(lo,hi)];  % 3-vector
scale3 = @(base,span) base .* (1 + uvec3(-span, span));       % ±span rel.

% Relative/absolute perturbation magnitudes (edit to taste)
SPAN.mass_rel  = 0.30*1;   % ±30% on masses
SPAN.moi_rel   = 0.40*1;   % ±40% on principal inertias
SPAN.linkL_rel = 0.15*1;   % ±15% on link lengths
SPAN.df_abs    = 0.5;    % N    range on each force component
SPAN.dtau_abs  = 0.5;    % N*m  range on each torque component

% Save nominals (optional)
quadrotor_mass_nom = quadrotor_mass;
link0_mass_nom     = link0_mass;
link1_mass_nom     = link1_mass;
link2_mass_nom     = link2_mass;
link1_len_nom      = link1_len;
link2_len_nom      = link2_len;
quadrotor_moi_nom  = quadrotor_moi;
J_nom              = J;
d_f_nom            = d_f;
d_tau_nom          = d_tau;

% --- Randomize masses & lengths (keep physically sensible lower bounds)
quadrotor_mass = max(0.2, quadrotor_mass_nom * (1 + urand(-SPAN.mass_rel,  SPAN.mass_rel)));
link0_mass     = max(0.02, link0_mass_nom     * (1 + urand(-SPAN.mass_rel,  SPAN.mass_rel)));
link1_mass     = max(0.02, link1_mass_nom     * (1 + urand(-SPAN.mass_rel,  SPAN.mass_rel)));
link2_mass     = max(0.02, link2_mass_nom     * (1 + urand(-SPAN.mass_rel,  SPAN.mass_rel))); % if used

link1_len      = max(0.05, link1_len_nom     * (1 + urand(-SPAN.linkL_rel, SPAN.linkL_rel)));
link2_len      = max(0.05, link2_len_nom     * (1 + urand(-SPAN.linkL_rel, SPAN.linkL_rel)));

% Total mass reflecting randomized components
m  = quadrotor_mass + link0_mass + link1_mass; % + link2_mass if used

% --- Randomize principal MOI (keep diagonal, SPD)
quadrotor_moi = max([1e-4 1e-4 1e-4], scale3(quadrotor_moi_nom, SPAN.moi_rel));
J = diag(quadrotor_moi);

% Update inertia prior vector (still biased as per your code)
Jv0 = 0.6 * [J(1,1) J(2,2) J(3,3) J(1,2) J(2,3) J(1,3)].';

% --- Randomize disturbances (true unknowns)
d_f   = (uvec3(-SPAN.df_abs,   SPAN.df_abs)).';     % N
d_tau = (uvec3(-SPAN.dtau_abs, SPAN.dtau_abs)).';   % N*m

% --- Keep your estimator bias relation
m0 = 0.7 * m;

% --- Tag string for quick identification in filenames/logs
rand_tag = sprintf('seed%d_m%.2f_J[%.3f_%.3f_%.3f]_df[%.2f,%.2f,%.2f]', ...
    seed, m, J(1,1), J(2,2), J(3,3), d_f(1), d_f(2), d_f(3));

%% ========= (YOUR) SIMULATION CALLS GO HERE =========
% Run your Simulink sim / script that produces outputs and (optionally) metrics.
% For example:
% sim('your_model.slx');
% ... compute ts and rmse here if applicable ...
% Ensure variables 'ts' and 'rmse' exist if you want them logged below.

%% ========= BOOKKEEPING: append random draw (+ metrics if available) =========
bkfile = fullfile('Results','bookkeeping_random_params.csv');
if ~exist(fileparts(bkfile),'dir'); mkdir(fileparts(bkfile)); end

% Optional performance metrics (if defined by your simulation block)
if exist('ts','var');   settle_s = ts;   else; settle_s = NaN; end
if exist('rmse','var'); rmse_ss  = rmse; else; rmse_ss  = NaN; end

row = table( ...
    datetime('now','Format','yyyy-MM-dd HH:mm:ss'), ...
    seed, ...
    quadrotor_mass, link0_mass, link1_mass, ...
    link1_len, link2_len, ...
    J(1,1), J(2,2), J(3,3), ...
    d_f(1), d_f(2), d_f(3), ...
    d_tau(1), d_tau(2), d_tau(3), ...
    m, m0, ...
    string(rand_tag), ...
    'VariableNames', { ...
      'timestamp','seed', ...
      'qr_mass','link0_mass','link1_mass', ...
      'link1_len','link2_len', ...
      'Jxx','Jyy','Jzz', ...
      'df_x','df_y','df_z', ...
      'dtau_x','dtau_y','dtau_z', ...
      'm_total','m0_est', ...
      'rand_tag' ...
    } ...
);

if isfile(bkfile)
    try
        writetable(row, bkfile, 'WriteMode','append');  % R2020a+
    catch
        Tprev = readtable(bkfile);
        writetable([Tprev; row], bkfile);
    end
else
    writetable(row, bkfile);
end

fprintf('Bookkeeping appended to: %s\n', bkfile);
