% Rigid body model parameters

%README: This file shows convergence for UAV trajectory tracking with
%unknow parameters. In this file UAV tracks a circle trajectory without
%arm. Mass, inertia and disturbance are unknown


clear all
close all
addpath('..\robotics_lib');
g = 9.81;
gravity_vector = [0 0 g]; % g is positive becuase reference frame +Z-axis points downward.

% Quadrotor model params
quadrotor_dim = [0.45 0.45 0.1]; % Quadrotor box size;
quadrotor_mass = 1.6; %mass in kg ANCL1
quadrotor_com = [0 0 0]; %Center of Mass in meters
quadrotor_moi = [0.03 0.03 0.05]; %Moments of inertia in kg*m^2 
quadrotor_poi = [0 0 0]; %Products of inertia in kg*m^2;
link0_mass=0.1;
link1_mass=0.1;
link2_mass=0.1;

link1_len = 0.3;
link2_len = 0.3;

m = quadrotor_mass+link0_mass+link1_mass;%+link2_mass;

m0 = 0.7*m;

d_f = 0.2*[1 1 1].';
d_tau = 0.2*[1 1 1].';

run quad_extract.m
%manip_arm_cross_sec = Arm_with_holes(15, 3, 1, 2);

%%% Control paramters
% k_dtau = 5;
% % 
% k1 = 1*0.4;
% k2 = 1*0.5;
% k3 = 1*0.5;
% k4 = 1;
% % %Increasing k4 scales down the steady state oscillations without much
% % %effect on delay rate of those oscillations
%  k5 = 1;
% %Increasing k5 scales down the steady state oscillations without much
% %effect on delay rate of those oscillations
% Gamma = 0.1*eye(6);
% lambda = 3; 
% k_psi1 = 1;
% k_psi2 = 1;

%%%%%%%%%%%%%%%%%%%%% Gains similar to the io

k_dtau = 5;
k_df = 1;
% 
k1 = 1*0.4;
k2 = 1*0.5;
k3 = 1*0.5;
k4 = 12;
% %Increasing k4 scales down the steady state oscillations without much
% %effect on delay rate of those oscillations
 k5 = 1*20;
%Increasing k5 scales down the steady state oscillations without much
%effect on delay rate of those oscillations
Gamma = 1* 0.01*eye(6);
% Gamma = 1* 0.0001*eye(6);

lambda = 3;
% lambda = 0.001; 
k_psi1 = 1;
k_psi2 = 1;


% k1 = diag(0.4*[1 1 1]);
% k2 = diag(0.5*[1 1 1]);
% k3 = diag(0.5*[1 1 1]);
% k4 = diag(2*[1 1 1]);
% k5 = diag(1*[1 1 1]);

%Gamma = 0.1*eye(6);
%Increasing Gamma makes steady state oscillations in z1 decay faster.

% k1 = 5*0.4;
% k2 = 5*0.5;
% 
% lambda = 1/0.0055; 
% k_df = 5*5;
% 
% 
% k3 = 7;
% k4 = 7;
% 
% Gamma = 0.1*eye(6);
% k_dtau = 5*eye(3);




J = [0.0169572, 0 0; 0 0.0169572 0; 0 0 0.0338078];
Jv0=0.6*[J(1,1) J(2,2) J(3,3) J(1,2) J(2,3) J(1,3)].';
p_0 = 1*[-2 2 0].';
v_0 = [0 0 0].';
omega_0 = 0*[0.1 -0.1 0.1].';
R_0 = eye(3);


omega_d0 = [0 0 0].';
hat_dtau0 = [0 0 0].';
hat_df0 = [0 0 0].';
hat_a0 = 1/m0;


%pickndrop related things
table1_radius = 0.5; %meter
table1_height = 1; %meter
table1_loc = [2 2 -table1_height/2]; %meter

table2_radius = 0.5; %meter
table2_height = 0.5; %meter
table2_loc = [-2 -2 -table2_height/2]; %meter
mass_length = 0.1;

table1_mass_loc = [table1_loc(1) table1_loc(2) -(table1_height+mass_length)];
table2_mass_loc = [table2_loc(1) table2_loc(2) -(table2_height+mass_length)];
