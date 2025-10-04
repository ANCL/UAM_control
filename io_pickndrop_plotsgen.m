set(0,'DefaultTextInterpreter','latex')
%set(0,'Stylesheet','default2')
fontSize = 11;
load('myprinttemplate2.mat');
t_end = 100;
lnwidth = 1;
prefix = 'io_pickndrop_';
%prefix = 'io_fixedarm_';
%set(groot, 'defaultAxesTickLabelInterpreter','latex'); set(groot, 'defaultLegendInterpreter','latex');
%close all
%%
figure;
setprinttemplate(gcf,template);
%set(gcf,'Position',[10,50,600,230])
%set(gca,'Position',[.18 .17 .70 .74]);
%subplot(1,2,1)
plot(out.p.signals.values(:,1),out.p.signals.values(:,2), 'b-', 'LineWidth',1.3);
hold on
plot(out.pd.signals.values(:,1),out.pd.signals.values(:,2), 'r--', 'LineWidth',1.3);
xlabel('$p_1$ (m)','Interpreter','latex','fontsize', fontSize)
ylabel('$p_2$ (m)' ,'fontsize', fontSize)
legend({'$p$','$p_d$'},'interpreter', 'latex','fontsize',fontSize);
%ylim([-1.5 2.2]);
saveas(gcf, strcat(prefix,'2Dposition.pdf'));


figure
setprinttemplate(gcf,template);
plot3(out.pd.signals.values(:,1),out.pd.signals.values(:,2),-out.pd.signals.values(:,3),'--', 'LineWidth',1.3);
hold on
plot3(out.p.signals.values(:,1),out.p.signals.values(:,2),-out.p.signals.values(:,3), 'LineWidth',1.3);
xlabel('$p_1$ (m)','Interpreter','latex','fontsize', fontSize)
ylabel('$p_2$ (m)','Interpreter','latex','fontsize', fontSize)
zlabel('$-p_3$ (m)','Interpreter','latex','fontsize', fontSize)
legend({'$p_d$','$p$'},'interpreter', 'latex','fontsize',fontSize);
%sgtitle('Quad Position')
% xlim([0 t_end]);
% %ylim([-2.2 1.3]);
% zlim([0 t_end]);
saveas(gcf, strcat(prefix,'3Dposition.pdf'));


figure;
setprinttemplate(gcf,template);
%set(gcf,'Position',[10,50,600,230])
%set(gca,'Position',[.18 .17 .70 .74]);
%subplot(1,2,1)
plot(out.torque_dist_est.time,out.torque_dist_est.signals.values, '--', 'LineWidth',1.3);
hold on
plot(out.arm_actuator_torque.time,-out.arm_actuator_torque.signals.values, 'LineWidth',1.3);
xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
ylabel('Disturbance (Nm)' ,'fontsize', fontSize)
legend({'$\hat{d}_{\tau_1}$','$\hat{d}_{\tau_2}$','$\hat{d}_{\tau_3}$','${d}_{\tau_2}=-{\tau}_{{\alpha}_1}$'},'interpreter', 'latex','fontsize',fontSize);
%sgtitle('Quad Position')
%% Position plots
close all

fp=figure;
%setprinttemplate(gcf,template);

% 
%subplot(3,1,1)
h1 = plot(out.p.time,out.p.signals.values(:,1)-out.pd.signals.values(:,1), 'LineWidth',1.3);

%xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
%ylabel('${\tilde{p}_1} = p_1 - p_{d1}$ (m)' ,'fontsize', fontSize)
%ylabel('${\tilde{p}}$ (m)' ,'fontsize', fontSize)
%xlim([0 t_end]);
%ylim([-2.3 0.4]);
% 
% 
xline([0 20 29 33 40 60 70 73 80],'m-',{'To Table 1','Extend Arm','Pick mass','Retract Arm','Table 2', 'Extend Arm', 'Drop mass', 'Retract Arm', 'Home'}, 'interpreter', 'latex', 'Linewidth', lnwidth, 'fontsize', fontSize)

hold on
%subplot(3,1,2)
h2 = plot(out.p.time,out.p.signals.values(:,2)-out.pd.signals.values(:,2), 'LineWidth',1.3);
%xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
%ylabel('${\tilde{p}_2} = p_2 - p_{d2}$ (m)' ,'fontsize', fontSize)
%ylabel('${\tilde{p}_2}$ (m)' ,'fontsize', fontSize)
%xlim([0 t_end]);
%ylim([-0.3 2.2]);



%subplot(3,1,3)
h3 = plot(out.p.time,out.p.signals.values(:,3)-out.pd.signals.values(:,3), 'LineWidth',1.3);
xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
%ylabel('${\tilde{p}_3} = p_3 - p_{d3}$ (m)' ,'fontsize', fontSize)
ylabel('${\tilde{p}}$ (m)' ,'fontsize', fontSize)

legend([h1,h2,h3],{'$\tilde{p}_1$','$\tilde{p}_2$','$\tilde{p}_3$'}, 'interpreter', 'latex');
%xlim([0 t_end]);
%ylim([-0.3 1.2]);
%sgtitle('Quad Position')

%t_end = 20;
saveFigureAsPDF(fp, strcat(prefix,'position_error.pdf'), 8, 4*8/6)

fpp = figure;
%setprinttemplate(gcf,template);
subplot(5,1,1)
xline([0 20 29 33 40 60 70 73 80],'m-',{'To Table 1','Extend Arm','Pick mass','Retract Arm','Table 2', 'Extend Arm', 'Drop mass', 'Retract Arm', 'Home'}, 'interpreter', 'latex', 'LineWidth', lnwidth, 'fontsize', fontSize)
axis off;
xlim([0 t_end])
subplot(5,1,2)

h1 = plot(out.p.time,out.p.signals.values(:,1), 'LineWidth',1.3);


hold on
h2 = plot(out.pd.time,out.pd.signals.values(:,1),'--', 'LineWidth',1.3);
xline([0 20 29 33 40 60 70 73 80],'m-','LineWidth', lnwidth)%,{'To Table 1','Extend Arm','Pick mass','Retract Arm','Table 2', 'Extend Arm', 'Drop mass', 'Retract Arm', 'Home'}, 'interpreter', 'latex')
%xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
ylabel('$p_1$ (m)' ,'fontsize', fontSize)
legend([h1,h2], {'$p_1$','$p_{d1}$'},'interpreter', 'latex','fontsize',fontSize);
%xlim([0 t_end]);
ylim([-2.2 3.3]);

subplot(5,1,3)
h1 = plot(out.p.time,out.p.signals.values(:,2), 'LineWidth',1.3);
hold on
h2 = plot(out.pd.time,out.pd.signals.values(:,2),'--', 'LineWidth',1.3);
xline([0 20 29 33 40 60 70 73 80],'m-','LineWidth', lnwidth)%,{'To Table 1','Extend Arm','Pick mass','Retract Arm','Table 2', 'Extend Arm', 'Drop mass', 'Retract Arm', 'Home'}, 'interpreter', 'latex')
%xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
ylabel('$p_2$ (m)' ,'fontsize', fontSize)
legend([h1, h2], {'$p_2$','$p_{d2}$'},'interpreter', 'latex','fontsize',fontSize);
%xlim([0 t_end]);
% %%ylim([-2.2 1.3]);

subplot(5,1,4)
h1 = plot(out.p.time,out.p.signals.values(:,3), 'LineWidth',1.3);
hold on
h2 = plot(out.pd.time,out.pd.signals.values(:,3),'--', 'LineWidth',1.3);
xline([0 20 29 33 40 60 70 73 80],'m-', 'LineWidth', lnwidth)%,{'To Table 1','Extend Arm','Pick mass','Retract Arm','Table 2', 'Extend Arm', 'Drop mass', 'Retract Arm', 'Home'}, 'interpreter', 'latex')

%xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
ylabel('$p_3$ (m)' ,'fontsize', fontSize)
legend([h1,h2], {'$p_3$','$p_{d3}$'},'interpreter', 'latex','fontsize',fontSize);
%xlim([0 t_end]);
% %%ylim([-2.2 1.3]);

subplot(5,1,5)
h1 = plot(out.psi.time,out.psi.signals.values(:), 'LineWidth',1.3);
%set(gca,'Clipping','Off')
hold on
h2 = plot(out.psi_d.time,out.psi_d.signals.values(:),'--', 'LineWidth',1.3);
xline([0 20 29 33 40 60 70 73 80],'m-', 'LineWidth', lnwidth) %,{'To Table 1','Extend Arm','Pick mass','Retract Arm','Table 2', 'Extend Arm', 'Drop mass', 'Retract Arm', 'Home'}, 'interpreter', 'latex')

xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
ylabel('$\psi$ (rad)' ,'fontsize', fontSize)
legend([h1 h2], {'$\psi$','$\psi_d$'},'interpreter', 'latex','fontsize',fontSize);
%xlim([0 t_end]);
%%ylim([-1.3 0.2]);
saveFigureAsPDF(fpp, strcat(prefix,'pose.pdf'), 8, 4*8/6)


%% Attitude plots
t_end1 = 100;

% fatt=figure;
% setprinttemplate(gcf,template);
% subplot(3,2,1)
% % plot(out.att.time,out.att.signals.values(:,1), 'LineWidth',1.3);
% % hold on
% % plot(out.att_d.time,out.att_d.signals.values(:,1), 'LineWidth',1.3);
% % xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
% % ylabel('$\phi$, $\phi_d$ (rad)' ,'fontsize', fontSize)
% % legend({'$\phi$','$\phi_d$'},'interpreter', 'latex','fontsize',fontSize);
% % xlim([0 t_end]);
% % %%ylim([-2.2 1.3]);
% 
% subplot(3,1,1)
% plot(out.att.time,out.att.signals.values(:,1)-out.att_d.signals.values(:,1), 'LineWidth',1.3);
% %xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
% %ylabel('${\tilde{p}_1} = p_1 - p_{d1}$ (rad)' ,'fontsize', fontSize)
% ylabel('${\tilde{\phi}}$ (rad)' ,'fontsize', fontSize)
% xlim([0 t_end1]);
% %%ylim([-2.3 0.2]);
% 
% 
% % subplot(3,2,3)
% % plot(out.att.time,out.att.signals.values(:,2), 'LineWidth',1.3);
% % hold on
% % plot(out.att_d.time,out.att_d.signals.values(:,2), 'LineWidth',1.3);
% % xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
% % ylabel('$\theta$, $\theta_d$ (rad)' ,'fontsize', fontSize)
% % legend({'$\theta$','$\theta_d$'},'interpreter', 'latex','fontsize',fontSize);
% % xlim([0 t_end]);
% % %%ylim([-1.2 2.2]);
% 
% subplot(3,1,2)
% plot(out.att.time,out.att.signals.values(:,2)-out.att_d.signals.values(:,2), 'LineWidth',1.3);
% %xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
% %ylabel('${\tilde{p}_2} = p_2 - p_{d2}$ (rad)' ,'fontsize', fontSize)
% ylabel('${\tilde{\theta}}$ (rad)' ,'fontsize', fontSize)
% xlim([0 t_end1]);
% %%ylim([-0.2 1.2]);
% 
% % subplot(3,2,5)
% % plot(out.att.time,out.att.signals.values(:,3), 'LineWidth',1.3);
% % hold on
% % plot(out.att_d.time,out.att_d.signals.values(:,3), 'LineWidth',1.3);
% % xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
% % ylabel('$\psi$, $\psi_d$ (rad)' ,'fontsize', fontSize)
% % legend({'$\psi$','$\psi_d$'},'interpreter', 'latex','fontsize',fontSize);
% % xlim([0 t_end]);
% %%ylim([-1.3 0.2]);
% 
% subplot(3,1,3)
% plot(out.att.time,out.att.signals.values(:,3)-out.att_d.signals.values(:,3), 'LineWidth',1.3);
% xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
% %ylabel('${\tilde{p}_3} = p_3 - p_{d3}$ (rad)' ,'fontsize', fontSize)
% ylabel('${\tilde{\psi}}$ (rad)' ,'fontsize', fontSize)
% xlim([0 t_end1]);
% %ylim([-3 1.2]);
% %sgtitle('Quad Position')
% %saveas(gcf, strcat(prefix,'attitude.pdf'));

%% Torque Disturbance plots

ftau=figure;
setprinttemplate(gcf,template);
% subplot(3,2,1)
% plot([0 5 10 15],[d_tau(1) d_tau(1) d_tau(1) d_tau(1)], 'LineWidth',1.3);
% hold on
% plot(out.torque_dist_est.time,out.torque_dist_est.signals.values(:,1), 'LineWidth',1.3);
% xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
% ylabel('$d_{\tau 1}$ , $\hat{d}_{\tau 1}$ (N m)' ,'fontsize', fontSize)
% legend({'$d_{\tau 1}$','$\hat{d}_{\tau 1}$'},'interpreter', 'latex','fontsize',fontSize);
% xlim([0 t_end]);
% %%ylim([-0.1 0.4]);


subplot(3,1,1)
%plot(out.torque_dist_est.time,d_tau(1)-out.torque_dist_est.signals.values(:,1), 'LineWidth',1.3);
plot(out.torque_dist_est.time,out.torque_dist_est.signals.values(:,1), 'LineWidth',1.3);
%xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
ylabel('$\hat{d}_{\tau 1}$ (N m)' ,'fontsize', fontSize)
xlim([0 t_end]);
%%ylim([-0.4 0.1]);


% subplot(3,2,3)
% plot(out.arm_actuator_torque.time,d_tau(2)+out.arm_actuator_torque.signals.values, 'LineWidth',1.3);
% hold on
% plot(out.torque_dist_est.time,out.torque_dist_est.signals.values(:,2), 'LineWidth',1.3);
% xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
% ylabel('$d_{\tau 2}$ , $\hat{d}_{\tau 2}$ (N m)' ,'fontsize', fontSize)
% legend({'$d_{\tau 2}=-{\tau}_{\alpha 1}$','$\hat{d}_{\tau 2}$'},'interpreter', 'latex','fontsize',fontSize);
% xlim([0 t_end]);
% %ylim([-3 3.2]);

subplot(3,1,2)
plot(out.torque_dist_est.time, out.torque_dist_est.signals.values(:,2), 'LineWidth',1.3);
%xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
ylabel('$\hat{d}_{\tau 2}$ (Nm)' ,'fontsize', fontSize)
xlim([0 t_end]);
%%ylim([-2.5 3]);


% subplot(3,2,5)
% plot([0 5 10 15],[d_tau(3) d_tau(3) d_tau(3) d_tau(3)], 'LineWidth',1.3);
% hold on
% plot(out.torque_dist_est.time,out.torque_dist_est.signals.values(:,3), 'LineWidth',1.3);
% xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
% ylabel('$d_{\tau 3}$ , $\hat{d}_{\tau 3}$ (N m)' ,'fontsize', fontSize)
% legend({'$d_{\tau 3}$','$\hat{d}_{\tau 3}$'},'interpreter', 'latex','fontsize',fontSize);
% xlim([0 t_end]);
%%ylim([-1 0.1]);

subplot(3,1,3)
plot(out.torque_dist_est.time, out.torque_dist_est.signals.values(:,3), 'LineWidth',1.3);
xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
%ylabel('$\tilde{d}_{\tau 3} = d_{\tau 3}-\hat{d}_{\tau 3}$' ,'fontsize', fontSize)
ylabel('$\hat{d}_{\tau 3}$ (N m)' ,'fontsize', fontSize)
xlim([0 t_end]);
%%ylim([-0.2 0.9]);
saveas(gcf, strcat(prefix,'d_tau.pdf'));

%% Force Disturbance plots
t_end = 100;
ftau=figure;
setprinttemplate(gcf,template);
subplot(4,1,1)
plot(out.hat_df.time, out.hat_df.signals.values(:,1), 'LineWidth',1.3);
%xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
ylabel('$\hat{d}_{f1} $ $(m/s^2)$' ,'fontsize', fontSize)
xlim([0 t_end]);
%%ylim([-0.4 0.1]);

subplot(4,1,2)
plot(out.hat_df.time, out.hat_df.signals.values(:,2), 'LineWidth',1.3);
%xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
ylabel('$\hat{d}_{f2}$ $(m/s^2)$' ,'fontsize', fontSize)
xlim([0 t_end]);
%%ylim([-0.4 0.1]);


subplot(4,1,3)
plot(out.hat_df.time, out.hat_df.signals.values(:,3), 'LineWidth',1.3);
%xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
ylabel('$\hat{d}_{f3}$ $(m/s^2)$' ,'fontsize', fontSize)
xlim([0 t_end]);
%%ylim([-0.4 0.1]);

subplot(4,1,4)
plot(out.hat_a.time, out.hat_a.signals.values(:,1), 'LineWidth',1.3);
xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
ylabel('$\hat{a} $ $(kg^{-1})$' ,'fontsize', fontSize)
xlim([0 t_end]);
%%ylim([-0.4 0.1]);
saveas(gcf, strcat(prefix,'outer_estimates.pdf'));

%% Vehicle Input plots
t_end = 100;
ftau=figure;
setprinttemplate(gcf,template);
subplot(4,1,1)
plot(out.u.time, out.u.signals.values(:,1), 'LineWidth',1.3);
%xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
ylabel('$u$ (N)' ,'fontsize', fontSize)
xlim([0 t_end]);
%%ylim([-0.4 0.1]);

subplot(4,1,2)
plot(out.tau.time, out.tau.signals.values(:,1), 'LineWidth',1.3);
%xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
ylabel('$\tau_{q1}$ (Nm)' ,'fontsize', fontSize)
xlim([0 t_end]);
%ylim([-4 3]);


subplot(4,1,3)
plot(out.tau.time, out.tau.signals.values(:,2), 'LineWidth',1.3);
%xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
ylabel('$\tau_{q2}$ (Nm)' ,'fontsize', fontSize)
xlim([0 t_end]);
%ylim([-4 3]);

subplot(4,1,4)
plot(out.tau.time, out.tau.signals.values(:,3), 'LineWidth',1.3);
%xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
ylabel('$\tau_{q3}$ (Nm)' ,'fontsize', fontSize)
xlim([0 t_end]);
%ylim([-4 3]);
saveas(gcf, strcat(prefix,'inputs.pdf'));

%% Inertia Estimate plots
t_end = 100
ftau=figure;
setprinttemplate(gcf,template);
subplot(3,2,1)
% plot([0 5 10 15],[Jv(1) Jv(1) Jv(1) Jv(1)], 'LineWidth',1.3);
% hold on
plot(out.hat_Jv.time,out.hat_Jv.signals.values(:,1), 'LineWidth',1.3);
%xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
ylabel('$\hat{J}_{xx}$' ,'fontsize', fontSize);
%legend({'$d_{\tau 1}$','$\hat{d}_{\tau 1}$'},'interpreter', 'latex','fontsize',fontSize);
xlim([0 t_end]);
%%ylim([-0.1 0.4]);


subplot(3,2,3)
plot(out.hat_Jv.time,out.hat_Jv.signals.values(:,2), 'LineWidth',1.3);
%xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
ylabel('$\hat{J}_{yy}$' ,'fontsize', fontSize);
xlim([0 t_end]);
%%ylim([-0.4 0.1]);


subplot(3,2,5)
plot(out.hat_Jv.time,out.hat_Jv.signals.values(:,3), 'LineWidth',1.3);
xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
ylabel('$\hat{J}_{zz}$' ,'fontsize', fontSize);
%legend({'$d_{\tau 2}=-{\tau}_{\alpha 1}$','$\hat{d}_{\tau 2}$'},'interpreter', 'latex','fontsize',fontSize);
xlim([0 t_end]);
%%ylim([-3 3.2]);

subplot(3,2,2)
plot(out.hat_Jv.time,out.hat_Jv.signals.values(:,4), 'LineWidth',1.3);
%xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
ylabel('$\hat{J}_{xy}$' ,'fontsize', fontSize);
xlim([0 t_end]);
%%ylim([-2.5 3]);

subplot(3,2,4)
plot(out.hat_Jv.time,out.hat_Jv.signals.values(:,5), 'LineWidth',1.3);
%xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
ylabel('$\hat{J}_{yz}$' ,'fontsize', fontSize);
xlim([0 t_end]);
%%ylim([-2.5 3]);

subplot(3,2,6)
plot(out.hat_Jv.time,out.hat_Jv.signals.values(:,6), 'LineWidth',1.3);
xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
ylabel('$\hat{J}_{zx}$' ,'fontsize', fontSize);
xlim([0 t_end]);
%%ylim([-2.5 3]);
saveas(gcf, strcat(prefix,'J_estimate.pdf'));

%% Arm Angle plots
t_end = 100;
figure;
setprinttemplate(gcf,template);

% 
subplot(2,1,1)
plot(out.alpha1.time,out.alpha1.signals.values(1,:).', 'LineWidth',1.3);
%xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
%ylabel('${\tilde{p}_1} = p_1 - p_{d1}$ (m)' ,'fontsize', fontSize)
ylabel('${\alpha_1}$ (rad)' ,'fontsize', fontSize)
xlim([0 t_end]);
%%ylim([-2.3 0.4]);
% 
% 



subplot(2,1,2)
plot(out.alpha2.time,out.alpha2.signals.values, 'LineWidth',1.3);
%xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
%ylabel('${\tilde{p}_1} = p_1 - p_{d1}$ (m)' ,'fontsize', fontSize)
ylabel('${\alpha_2}$ (rad)' ,'fontsize', fontSize)
xlim([0 t_end]);
%% Video Plots Position
% 
% 
fontSize = 20;
fnew=figure('Renderer', 'painters', 'Position', [20 20 800 1000]);
 rec = 1;
if rec == 1 
     v = VideoWriter('myvideo1'); 
     open(v); 
%v.Height=800;
%v.Width=600;
 t_end = 100;
 
 
 for i = 1:3:length(out.p.time)
     clf(fnew)
     
subplot(5,1,1)
plot([0 100], [-2 -2]);
xlim([0 t_end]);
ylim([-1 1]);
xline([0 20 29 33 40 60 70 73 80],'b-',{'To Table 1','Extend Arm','Pick mass','Retract Arm','Table 2', 'Extend Arm', 'Drop mass', 'Retract Arm', 'Home'}, 'interpreter', 'latex')

subplot(5,1,2)

h1 = plot(out.p.time(1:i),out.p.signals.values(1:i,1), 'LineWidth',1.3);


hold on
h2 = plot(out.pd.time(1:i),out.pd.signals.values(1:i,1), 'LineWidth',1.3);
%xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
xline([0 20 29 33 40 60 70 73 80],'b-');
ylabel('$p_1$ (m)' ,'fontsize', fontSize)
legend([h1 h2],{'$p_1$','$p_{d1}$'},'interpreter', 'latex','fontsize',fontSize);
xlim([0 t_end]);
ylim([-2.2 2.2]);
%xline([0 20 29 33 40 60 70 73 80],'b-');


subplot(5,1,3)
h1 = plot(out.p.time(1:i),out.p.signals.values(1:i,2), 'LineWidth',1.3);
hold on
h2 = plot(out.pd.time(1:i),out.pd.signals.values(1:i,2), 'LineWidth',1.3);
%xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
xline([0 20 29 33 40 60 70 73 80],'b-');
ylabel('$p_2$ (m)' ,'fontsize', fontSize)
legend([h1 h2],{'$p_2$','$p_{d2}$'},'interpreter', 'latex','fontsize',fontSize);
xlim([0 t_end]);
ylim([-1.6 2.2]);
%xline([0 20 29 33 40 60 70 73 80],'b-');

subplot(5,1,4)
h1 = plot(out.p.time(1:i),out.p.signals.values(1:i,3), 'LineWidth',1.3);
hold on
h2 = plot(out.pd.time(1:i),out.pd.signals.values(1:i,3), 'LineWidth',1.3);
xline([0 20 29 33 40 60 70 73 80],'b-');
%xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
ylabel('$p_3$ (m)' ,'fontsize', fontSize)
legend([h1 h2],{'$p_3$','$p_{d3}$'},'interpreter', 'latex','fontsize',fontSize);
xlim([0 t_end]);
ylim([-1.7 0.1]);


subplot(5,1,5)
h1 = plot(out.att.time(1:i),out.att.signals.values(1:i,3), 'LineWidth',1.3);
%set(gca,'Clipping','Off')
hold on
h2 = plot(out.att_d.time(1:i),out.att_d.signals.values(1:i,3),'--', 'LineWidth',1.3);
xline([0 20 29 33 40 60 70 73 80],'b-');%,{'To Table 1','Extend Arm','Pick mass','Retract Arm','Table 2', 'Extend Arm', 'Drop mass', 'Retract Arm', 'Home'}, 'interpreter', 'latex')

xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
ylabel('$\psi$ (rad)' ,'fontsize', fontSize)
legend([h1 h2], {'$\psi$','$\psi_d$'},'interpreter', 'latex','fontsize',fontSize);
xlim([0 t_end]);
ylim([-2 0.2]);
saveas(gcf, strcat(prefix,'pose.pdf'));

% 
 sgtitle(['time = ',num2str(round(out.p.time(i),1)), '(s)'],'fontsize',fontSize);
 drawnow;
 if rec==1
         frame = getframe(gcf);
         writeVideo(v,frame);
 end 
 pause(0.001);
 end
% 
end
 if rec==1; close(v); end
 
% %% Video Plots Disturbance
% fdis=figure;
% rec = 1;
% if rec == 1 
%     v = VideoWriter('disvideo'); 
%     open(v); 
% end
% 
% torque_dist = [zeros(size(out.p.time)) -out.arm_actuator_torque.signals.values  zeros(size(out.p.time))];
% 
% for i = 1:11:length(out.p.time)
%     clf(fdis)
%     
% subplot(3,2,1)
% plot(out.torque_dist_est.time(1:i), torque_dist(1:i,1), 'LineWidth',1.3);
% hold on
% plot(out.torque_dist_est.time(1:i),out.torque_dist_est.signals.values(1:i,1), 'LineWidth',1.3);
% xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
% ylabel('$d_{\tau 1}$ , $\hat{d}_{\tau 1}$ (N m)' ,'fontsize', fontSize)
% legend({'$d_{\tau 1}$','$\hat{d}_{\tau 1}$'},'interpreter', 'latex','fontsize',fontSize);
% xlim([0 t_end]);
% %ylim([-0.1 0.4]);
% 
% 
% subplot(3,2,2)
% plot(out.torque_dist_est.time(1:i),torque_dist(1:i,1)-out.torque_dist_est.signals.values(1:i,1), 'LineWidth',1.3);
% xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
% ylabel('$\tilde{d}_{\tau 1} (N m)$' ,'fontsize', fontSize)
% xlim([0 t_end]);
% %ylim([-0.4 0.1]);
% 
% 
% subplot(3,2,3)
% plot(out.torque_dist_est.time(1:i), torque_dist(1:i, 2), 'LineWidth',1.3);
% hold on
% plot(out.torque_dist_est.time(1:i),out.torque_dist_est.signals.values(1:i,2), 'LineWidth',1.3);
% xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
% ylabel('$d_{\tau 2}$ , $\hat{d}_{\tau 2}$ (N m)' ,'fontsize', fontSize)
% legend({'$d_{\tau 2}=-{\tau}_{\alpha 1}$','$\hat{d}_{\tau 2}$'},'interpreter', 'latex','fontsize',fontSize);
% xlim([0 10]);
% %ylim([-3 3.2]);
% 
% 
% subplot(3,2,4)
% plot(out.torque_dist_est.time(1:i), torque_dist(1:i,2)-out.torque_dist_est.signals.values(1:i,2), 'LineWidth',1.3);
% xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
% ylabel('$\tilde{d}_{\tau 2} (N m)$' ,'fontsize', fontSize)
% xlim([0 10]);
% %ylim([-2.5 3]);
% 
% 
% subplot(3,2,5)
% plot(out.torque_dist_est.time(1:i), torque_dist(1:i, 3), 'LineWidth',1.3);
% hold on
% plot(out.torque_dist_est.time(1:i), out.torque_dist_est.signals.values(1:i,3), 'LineWidth',1.3);
% xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
% ylabel('$d_{\tau 3}$ , $\hat{d}_{\tau 3}$ (N m)' ,'fontsize', fontSize)
% legend({'$d_{\tau 3}$','$\hat{d}_{\tau 3}$'},'interpreter', 'latex','fontsize',fontSize);
% xlim([0 10]);
% %ylim([-1 0.1]);
% 
% 
% subplot(3,2,6)
% plot(out.torque_dist_est.time(1:i),torque_dist(1:i,3)-out.torque_dist_est.signals.values(1:i,3), 'LineWidth',1.3);
% xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
% %ylabel('$\tilde{d}_{\tau 3} = d_{\tau 3}-\hat{d}_{\tau 3}$' ,'fontsize', fontSize)
% ylabel('$\tilde{d}_{\tau 3} (N m)$' ,'fontsize', fontSize)
% xlim([0 10]);
% %ylim([-0.2 0.9]);
% 
% sgtitle(['time = ',num2str(round(out.p.time(i),1)), '(s)']);
% drawnow;
% if rec==1
%         frame = getframe(gcf);
%         writeVideo(v,frame);
% end 
% pause(0.001);
% end
% 
% if rec==1; close(v); end
% 
% %% Video Plots Position and Disturbance No error
% fnew=figure;
% rec = 1;
% if rec == 1 
%     v = VideoWriter('pdvideo'); 
%     open(v); 
% end
% 
% 
% 
% for i = 1:11:length(out.p.time)
%     clf(fnew)
%     
% subplot(3,2,1)
% h1 = plot(out.p.time(1:i),out.p.signals.values(1:i,1), 'LineWidth',1.3);
% hold on
% h2 = plot(out.pd.time(1:i),out.pd.signals.values(1:i,1), 'LineWidth',1.3);
% xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
% ylabel('$p_1$, $p_{d1}$ (m)' ,'fontsize', fontSize)
% legend({'$p_1$','$p_{d1}$'},'interpreter', 'latex','fontsize',fontSize);
% xlim([0 10]);
% %ylim([-2.2 1.3]);
% 
% subplot(3,2,2)
% plot(out.torque_dist_est.time(1:i), torque_dist(1:i,1), 'LineWidth',1.3);
% hold on
% plot(out.torque_dist_est.time(1:i),out.torque_dist_est.signals.values(1:i,1), 'LineWidth',1.3);
% xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
% ylabel('$d_{\tau 1}$ , $\hat{d}_{\tau 1}$ (N m)' ,'fontsize', fontSize)
% legend({'$d_{\tau 1}$','$\hat{d}_{\tau 1}$'},'interpreter', 'latex','fontsize',fontSize);
% xlim([0 10]);
% %ylim([-0.1 0.4]);
% 
% 
% 
% subplot(3,2,3)
% plot(out.p.time(1:i),out.p.signals.values(1:i,2), 'LineWidth',1.3);
% hold on
% plot(out.pd.time(1:i),out.pd.signals.values(1:i,2), 'LineWidth',1.3);
% xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
% ylabel('$p_2$, $p_{d2}$ (m)' ,'fontsize', fontSize)
% legend({'$p_2$','$p_{d2}$'},'interpreter', 'latex','fontsize',fontSize);
% xlim([0 10]);
% %ylim([-1.2 2.2]);
% 
% 
% subplot(3,2,4)
% plot(out.torque_dist_est.time(1:i), torque_dist(1:i, 2), 'LineWidth',1.3);
% hold on
% plot(out.torque_dist_est.time(1:i),out.torque_dist_est.signals.values(1:i,2), 'LineWidth',1.3);
% xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
% ylabel('$d_{\tau 2}$ , $\hat{d}_{\tau 2}$ (N m)' ,'fontsize', fontSize)
% legend({'$d_{\tau 2}=-{\tau}_{\alpha 1}$','$\hat{d}_{\tau 2}$'},'interpreter', 'latex','fontsize',fontSize);
% xlim([0 10]);
% %ylim([-3 3.2]);
% 
% 
% subplot(3,2,5)
% plot(out.p.time(1:i),out.p.signals.values(1:i,3), 'LineWidth',1.3);
% hold on
% plot(out.pd.time(1:i),out.pd.signals.values(1:i,3), 'LineWidth',1.3);
% xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
% ylabel('$p_3$, $p_{d3}$ (m)' ,'fontsize', fontSize)
% legend({'$p_3$','$p_{d3}$'},'interpreter', 'latex','fontsize',fontSize);
% xlim([0 10]);
% %ylim([-1.3 0.2]);
% 
% subplot(3,2,6);
% plot(out.torque_dist_est.time(1:i), torque_dist(1:i, 3), 'LineWidth',1.3);
% hold on
% plot(out.torque_dist_est.time(1:i), out.torque_dist_est.signals.values(1:i,3), 'LineWidth',1.3);
% xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
% ylabel('$d_{\tau 3}$ , $\hat{d}_{\tau 3}$ (N m)' ,'fontsize', fontSize)
% legend({'$d_{\tau 3}$','$\hat{d}_{\tau 3}$'},'interpreter', 'latex','fontsize',fontSize);
% xlim([0 10]);
% %ylim([-1 0.1]);
% 
% sgtitle(['time = ',num2str(round(out.p.time(i),1)), '(s)']);
% drawnow;
% if rec==1
%         frame = getframe(gcf);
%         writeVideo(v,frame);
% end 
% pause(0.001);
% end
% 
% if rec==1; close(v); end
% % 
