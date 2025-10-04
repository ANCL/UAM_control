set(0,'DefaultTextInterpreter','latex')
%set(0,'Stylesheet','default2')
fontSize = 11;
%load('myprinttemplate2.mat');
t_end = 20;
% prefix = 'movingarm_';
prefix = 'Results\fixedarm_';
%set(groot, 'defaultAxesTickLabelInterpreter','latex'); set(groot, 'defaultLegendInterpreter','latex');
close all
load('myprinttemplate.mat');

%%
figure;
setprinttemplate(gcf,template);
%set(gcf,'Position',[10,50,600,230])
%set(gca,'Position',[.18 .17 .70 .74]);
%subplot(1,2,1)
plot(out.p.signals.values(:,1),out.p.signals.values(:,2), 'b-', 'LineWidth',1.3);
hold on
plot(out.pd.signals.values(:,1),out.pd.signals.values(:,2), 'r--', 'LineWidth',1.3);
xlabel('$p_1$ $(m)$','Interpreter','latex','fontsize', fontSize)
ylabel('$p_2$ $(m)$' ,'fontsize', fontSize)
legend({'$p$','$p_d$'},'interpreter', 'latex','fontsize',fontSize);
% ylim([-1.5 2.2]);
saveas(gcf, strcat(prefix,'2Dposition.pdf'));


figure
setprinttemplate(gcf,template);
plot3(out.pd.signals.values(:,1),out.pd.signals.values(:,2),-out.pd.signals.values(:,3),'--', 'LineWidth',1.3);
hold on
plot3(out.p.signals.values(:,1),out.p.signals.values(:,2),-out.p.signals.values(:,3), 'LineWidth',1.3);
xlabel('$p_1$ $(m)$','Interpreter','latex','fontsize', fontSize)
ylabel('$p_2$ $(m)$','Interpreter','latex','fontsize', fontSize)
zlabel('$-p_3$ $(m)$','Interpreter','latex','fontsize', fontSize)
legend({'$p_d$','$p$'},'interpreter', 'latex','fontsize',fontSize);
%sgtitle('Quad Position')
% xlim([0 t_end]);
% ylim([-2.2 1.3]);
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
ylabel('Disturbance $(Nm)$' ,'fontsize', fontSize)
legend({'$\hat{d}_{\tau_1}$','$\hat{d}_{\tau_2}$','$\hat{d}_{\tau_3}$','${d}_{\tau_2}=-{\tau}_{{\alpha}_1}$'},'interpreter', 'latex','fontsize',fontSize);
%sgtitle('Quad Position')
%% Position plots

fp=figure;
setprinttemplate(gcf,template);

% 
subplot(4,1,1)
plot(out.p.time,out.p.signals.values(:,1)-out.pd.signals.values(:,1), 'LineWidth',1.3);
%xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
%ylabel('${\tilde{p}_1} = p_1 - p_{d1}$ (m)' ,'fontsize', fontSize)
ylabel('${z_1}$ $(m)$' ,'fontsize', fontSize)
xlim([0 t_end]);
ylim([-2.3 0.4]);
% 
% 



subplot(4,1,2)
plot(out.p.time,out.p.signals.values(:,2)-out.pd.signals.values(:,2), 'LineWidth',1.3);
%xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
%ylabel('${\tilde{p}_2} = p_2 - p_{d2}$ (m)' ,'fontsize', fontSize)
ylabel('${z_2}$ $(m)$' ,'fontsize', fontSize)
xlim([0 t_end]);
ylim([-0.3 2.2]);



subplot(4,1,3)
plot(out.p.time,out.p.signals.values(:,3)-out.pd.signals.values(:,3), 'LineWidth',1.3);
xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
%ylabel('${\tilde{p}_3} = p_3 - p_{d3}$ (m)' ,'fontsize', fontSize)
ylabel('${z_3}$ $(m)$' ,'fontsize', fontSize)
xlim([0 t_end]);
ylim([-0.3 1.5]);
%sgtitle('Quad Position')

subplot(4,1,4)
plot(out.p.time,out.psi.signals.values-out.psi_d.signals.values, 'LineWidth',1.3);
xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
%ylabel('${\tilde{p}_3} = p_3 - p_{d3}$ (m)' ,'fontsize', fontSize)
ylabel('$\tilde{\psi}$ $(rad)$' ,'fontsize', fontSize)
xlim([0 t_end]);
ylim([-2.5 0.5]);
%t_end = 20;
saveas(gcf, strcat(prefix,'position_error.pdf'));

figure;
setprinttemplate(gcf,template);
subplot(4,1,1)
plot(out.p.time,out.p.signals.values(:,1), 'LineWidth',1.3);
hold on
plot(out.pd.time,out.pd.signals.values(:,1), 'LineWidth',1.3);
%xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
ylabel('$p_1$ $(m)$' ,'fontsize', fontSize)
legend({'Actual','Desired'},'interpreter', 'latex','fontsize',fontSize);
xlim([0 t_end]);
% %ylim([-2.2 1.3]);

subplot(4,1,2)
plot(out.p.time,out.p.signals.values(:,2), 'LineWidth',1.3);
hold on
plot(out.pd.time,out.pd.signals.values(:,2), 'LineWidth',1.3);
%xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
ylabel('$p_2$ $(m)$' ,'fontsize', fontSize)
% legend({'$p_2$','$p_{d2}$'},'interpreter', 'latex','fontsize',fontSize);
xlim([0 t_end]);
% %ylim([-2.2 1.3]);

subplot(4,1,3)
plot(out.p.time,out.p.signals.values(:,3), 'LineWidth',1.3);
hold on
plot(out.pd.time,out.pd.signals.values(:,3), 'LineWidth',1.3);
%xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
ylabel('$p_3$ $(m)$' ,'fontsize', fontSize)
% legend({'$p_3$','$p_{d3}$'},'interpreter', 'latex','fontsize',fontSize);
xlim([0 t_end]);
% %ylim([-2.2 1.3]);

subplot(4,1,4)
plot(out.psi.time,out.psi.signals.values, 'LineWidth',1.3);
hold on
plot(out.psi_d.time,out.psi_d.signals.values, 'LineWidth',1.3);
xlabel('time $(s)$','Interpreter','latex','fontsize', fontSize)
ylabel('$\psi$ $(rad)$' ,'fontsize', fontSize)
% legend({'$\psi$','$\psi_d$'},'interpreter', 'latex','fontsize',fontSize);
xlim([0 t_end]);
% ylim([-1.3 0.2]);
saveas(gcf, strcat(prefix,'pose.pdf'));

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
% %ylim([-0.1 0.4]);


subplot(3,1,1)
%plot(out.torque_dist_est.time,d_tau(1)-out.torque_dist_est.signals.values(:,1), 'LineWidth',1.3);
plot(out.torque_dist_est.time,out.torque_dist_est.signals.values(:,1), 'LineWidth',1.3);
%xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
ylabel('$\hat{d}_{\tau 1}$ $(Nm)$' ,'fontsize', fontSize)
xlim([0 t_end]);
%ylim([-0.4 0.1]);


% subplot(3,2,3)
% plot(out.arm_actuator_torque.time,d_tau(2)+out.arm_actuator_torque.signals.values, 'LineWidth',1.3);
% hold on
% plot(out.torque_dist_est.time,out.torque_dist_est.signals.values(:,2), 'LineWidth',1.3);
% xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
% ylabel('$d_{\tau 2}$ , $\hat{d}_{\tau 2}$ (N m)' ,'fontsize', fontSize)
% legend({'$d_{\tau 2}=-{\tau}_{\alpha 1}$','$\hat{d}_{\tau 2}$'},'interpreter', 'latex','fontsize',fontSize);
% xlim([0 t_end]);
% ylim([-3 3.2]);

subplot(3,1,2)
plot(out.torque_dist_est.time, out.torque_dist_est.signals.values(:,2), 'LineWidth',1.3);
%xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
ylabel('$\hat{d}_{\tau 2}$ $(Nm)$' ,'fontsize', fontSize)
xlim([0 t_end]);
%ylim([-2.5 3]);


% subplot(3,2,5)
% plot([0 5 10 15],[d_tau(3) d_tau(3) d_tau(3) d_tau(3)], 'LineWidth',1.3);
% hold on
% plot(out.torque_dist_est.time,out.torque_dist_est.signals.values(:,3), 'LineWidth',1.3);
% xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
% ylabel('$d_{\tau 3}$ , $\hat{d}_{\tau 3}$ (N m)' ,'fontsize', fontSize)
% legend({'$d_{\tau 3}$','$\hat{d}_{\tau 3}$'},'interpreter', 'latex','fontsize',fontSize);
% xlim([0 t_end]);
%ylim([-1 0.1]);

subplot(3,1,3)
plot(out.torque_dist_est.time, out.torque_dist_est.signals.values(:,3), 'LineWidth',1.3);
xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
%ylabel('$\tilde{d}_{\tau 3} = d_{\tau 3}-\hat{d}_{\tau 3}$' ,'fontsize', fontSize)
ylabel('$\hat{d}_{\tau 3}$ $(Nm)$' ,'fontsize', fontSize)
xlim([0 t_end]);
%ylim([-0.2 0.9]);
saveas(gcf, strcat(prefix,'d_tau.pdf'));

%% Force Disturbance plots
%t_end = 10;
ftau=figure;
setprinttemplate(gcf,template);
subplot(4,1,1)
plot(out.hat_df.time, out.hat_df.signals.values(:,1), 'LineWidth',1.3);
%xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
ylabel('$\hat{d}_{f1} $ $(m/s^2)$' ,'fontsize', fontSize)
xlim([0 t_end]);
%ylim([-0.4 0.1]);

subplot(4,1,2)
plot(out.hat_df.time, out.hat_df.signals.values(:,2), 'LineWidth',1.3);
%xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
ylabel('$\hat{d}_{f2}$ $(m/s^2)$' ,'fontsize', fontSize)
xlim([0 t_end]);
%ylim([-0.4 0.1]);


subplot(4,1,3)
plot(out.hat_df.time, out.hat_df.signals.values(:,3), 'LineWidth',1.3);
%xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
ylabel('$\hat{d}_{f3}$ $(m/s^2)$' ,'fontsize', fontSize)
xlim([0 t_end]);
%ylim([-0.4 0.1]);

subplot(4,1,4)
plot(out.hat_a.time, out.hat_a.signals.values(:,1), 'LineWidth',1.3);
xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
ylabel('$\hat{a} $ $(kg^{-1})$' ,'fontsize', fontSize)
xlim([0 t_end]);
%ylim([-0.4 0.1]);
saveas(gcf, strcat(prefix,'outer_estimates.pdf'));

%% Vehicle Input plots
%t_end = 5;
ftau=figure;
setprinttemplate(gcf,template);
subplot(4,1,1)
plot(out.u.time, out.u.signals.values(:,1), 'LineWidth',1.3);
%xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
ylabel('$u$ (N)' ,'fontsize', fontSize)
xlim([0 t_end]);
ylim([0 35]);

subplot(4,1,2)
plot(out.tau.time, out.tau.signals.values(:,1), 'LineWidth',1.3);
%xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
ylabel('$\tau_{q1}$ $(Nm)$' ,'fontsize', fontSize)
xlim([0 t_end]);
%ylim([-4 3]);


subplot(4,1,3)
plot(out.tau.time, out.tau.signals.values(:,2), 'LineWidth',1.3);
%xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
ylabel('$\tau_{q2}$ $(Nm)$' ,'fontsize', fontSize)
xlim([0 t_end]);
%ylim([-4 3]);

subplot(4,1,4)
plot(out.tau.time, out.tau.signals.values(:,3), 'LineWidth',1.3);
%xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
ylabel('$\tau_{q3}$ $(Nm)$' ,'fontsize', fontSize)
xlim([0 t_end]);
%ylim([-4 3]);
saveas(gcf, strcat(prefix,'inputs.pdf'));

%% Inertia Estimate plots
%t_end = 5
ftau=figure;
setprinttemplate(gcf,template);
subplot(3,2,1)
% plot([0 5 10 15],[Jv(1) Jv(1) Jv(1) Jv(1)], 'LineWidth',1.3);
% hold on
plot(out.hat_Jv.time,out.hat_Jv.signals.values(:,1), 'LineWidth',1.3);
%xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
ylabel('$\hat{J}_{xx}$ $(Kgm^2)$' ,'fontsize', fontSize);
%legend({'$d_{\tau 1}$','$\hat{d}_{\tau 1}$'},'interpreter', 'latex','fontsize',fontSize);
xlim([0 t_end]);
%ylim([-0.1 0.4]);
ylim('auto');

subplot(3,2,3)
plot(out.hat_Jv.time,out.hat_Jv.signals.values(:,2), 'LineWidth',1.3);
%xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
ylabel('$\hat{J}_{yy}$ $(Kgm^2)$' ,'fontsize', fontSize);
xlim([0 t_end]);
%ylim([-0.4 0.1]);
ylim('auto');

subplot(3,2,5)
plot(out.hat_Jv.time,out.hat_Jv.signals.values(:,3), 'LineWidth',1.3);
xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
ylabel('$\hat{J}_{zz}$ $(Kgm^2)$' ,'fontsize', fontSize);
%legend({'$d_{\tau 2}=-{\tau}_{\alpha 1}$','$\hat{d}_{\tau 2}$'},'interpreter', 'latex','fontsize',fontSize);
xlim([0 t_end]);
%ylim([-3 3.2]);
ylim('auto');

subplot(3,2,2)
plot(out.hat_Jv.time,out.hat_Jv.signals.values(:,4), 'LineWidth',1.3);
%xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
ylabel('$\hat{J}_{xy}$ $(Kgm^2)$' ,'fontsize', fontSize);
xlim([0 t_end]);
%ylim([-2.5 3]);
ylim('auto');

subplot(3,2,4)
plot(out.hat_Jv.time,out.hat_Jv.signals.values(:,5), 'LineWidth',1.3);
%xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
ylabel('$\hat{J}_{yz}$ $(Kgm^2)$' ,'fontsize', fontSize);
xlim([0 t_end]);
%ylim([-2.5 3]);
ylim('auto');

subplot(3,2,6)
plot(out.hat_Jv.time,out.hat_Jv.signals.values(:,6), 'LineWidth',1.3);
xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
ylabel('$\hat{J}_{zx}$ $(Kgm^2)$' ,'fontsize', fontSize);
xlim([0 t_end]);
%ylim([-2.5 3]);
ylim('auto');

saveas(gcf, strcat(prefix,'J_estimate.pdf'));

return;
%% Arm Angle plots
t_end = 20;
figure;
setprinttemplate(gcf,template);

% 
subplot(2,1,1)
plot(out.alpha1.time,out.alpha1.signals.values(1,:).', 'LineWidth',1.3);
%xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
%ylabel('${\tilde{p}_1} = p_1 - p_{d1}$ (m)' ,'fontsize', fontSize)
ylabel('${\alpha_1}$ $(rad)$' ,'fontsize', fontSize)
xlim([0 t_end]);
%ylim([-2.3 0.4]);
% 
% 



subplot(2,1,2)
plot(out.alpha2.time,out.alpha2.signals.values, 'LineWidth',1.3);
%xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
%ylabel('${\tilde{p}_1} = p_1 - p_{d1}$ (m)' ,'fontsize', fontSize)
ylabel('${\alpha_2}$ $(rad)$' ,'fontsize', fontSize)
xlim([0 t_end]);
%% Video Plots Position
% 
% 
% fnew=figure;
% rec = 1;
% if rec == 1 
%     v = VideoWriter('myvideo'); 
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
% xlim([0 t_end]);
% ylim([-2.2 1.3]);
% 
% subplot(3,2,2)
% plot(out.p.time(1:i),out.p.signals.values(1:i,1)-out.pd.signals.values(1:i,1), 'LineWidth',1.3);
% xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
% %ylabel('${\tilde{p}_1} = p_1 - p_{d1}$ (m)' ,'fontsize', fontSize)
% ylabel('${\tilde{p}_1}$ (m)' ,'fontsize', fontSize)
% xlim([0 t_end]);
% ylim([-2.3 0.2]);
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
% xlim([0 t_end]);
% ylim([-1.2 2.2]);
% 
% 
% subplot(3,2,4)
% plot(out.p.time(1:i),out.p.signals.values(1:i,2)-out.pd.signals.values(1:i,2), 'LineWidth',1.3);
% xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
% %ylabel('${\tilde{p}_2} = p_2 - p_{d2}$ (m)' ,'fontsize', fontSize)
% ylabel('${\tilde{p}_2}$ (m)' ,'fontsize', fontSize)
% xlim([0 t_end]);
% ylim([-0.2 1.2]);
% 
% 
% subplot(3,2,5)
% plot(out.p.time(1:i),out.p.signals.values(1:i,3), 'LineWidth',1.3);
% hold on
% plot(out.pd.time(1:i),out.pd.signals.values(1:i,3), 'LineWidth',1.3);
% xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
% ylabel('$p_3$, $p_{d3}$ (m)' ,'fontsize', fontSize)
% legend({'$p_3$','$p_{d3}$'},'interpreter', 'latex','fontsize',fontSize);
% xlim([0 t_end]);
% ylim([-1.3 0.2]);
% 
% subplot(3,2,6);
% plot(out.p.time(1:i),out.p.signals.values(1:i,3)-out.pd.signals.values(1:i,3), 'LineWidth',1.3);
% xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
% %ylabel('${\tilde{p}_3} = p_3 - p_{d3}$ (m)' ,'fontsize', fontSize)
% ylabel('${\tilde{p}_3}$ (m)' ,'fontsize', fontSize)
% xlim([0 t_end]);
% ylim([-0.3 1.2]);
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
% ylim([-0.1 0.4]);
% 
% 
% subplot(3,2,2)
% plot(out.torque_dist_est.time(1:i),torque_dist(1:i,1)-out.torque_dist_est.signals.values(1:i,1), 'LineWidth',1.3);
% xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
% ylabel('$\tilde{d}_{\tau 1} (N m)$' ,'fontsize', fontSize)
% xlim([0 t_end]);
% ylim([-0.4 0.1]);
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
% ylim([-3 3.2]);
% 
% 
% subplot(3,2,4)
% plot(out.torque_dist_est.time(1:i), torque_dist(1:i,2)-out.torque_dist_est.signals.values(1:i,2), 'LineWidth',1.3);
% xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
% ylabel('$\tilde{d}_{\tau 2} (N m)$' ,'fontsize', fontSize)
% xlim([0 10]);
% ylim([-2.5 3]);
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
% ylim([-1 0.1]);
% 
% 
% subplot(3,2,6)
% plot(out.torque_dist_est.time(1:i),torque_dist(1:i,3)-out.torque_dist_est.signals.values(1:i,3), 'LineWidth',1.3);
% xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
% %ylabel('$\tilde{d}_{\tau 3} = d_{\tau 3}-\hat{d}_{\tau 3}$' ,'fontsize', fontSize)
% ylabel('$\tilde{d}_{\tau 3} (N m)$' ,'fontsize', fontSize)
% xlim([0 10]);
% ylim([-0.2 0.9]);
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
% ylim([-2.2 1.3]);
% 
% subplot(3,2,2)
% plot(out.torque_dist_est.time(1:i), torque_dist(1:i,1), 'LineWidth',1.3);
% hold on
% plot(out.torque_dist_est.time(1:i),out.torque_dist_est.signals.values(1:i,1), 'LineWidth',1.3);
% xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
% ylabel('$d_{\tau 1}$ , $\hat{d}_{\tau 1}$ (N m)' ,'fontsize', fontSize)
% legend({'$d_{\tau 1}$','$\hat{d}_{\tau 1}$'},'interpreter', 'latex','fontsize',fontSize);
% xlim([0 10]);
% ylim([-0.1 0.4]);
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
% ylim([-1.2 2.2]);
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
% ylim([-3 3.2]);
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
% ylim([-1.3 0.2]);
% 
% subplot(3,2,6);
% plot(out.torque_dist_est.time(1:i), torque_dist(1:i, 3), 'LineWidth',1.3);
% hold on
% plot(out.torque_dist_est.time(1:i), out.torque_dist_est.signals.values(1:i,3), 'LineWidth',1.3);
% xlabel('time (s)','Interpreter','latex','fontsize', fontSize)
% ylabel('$d_{\tau 3}$ , $\hat{d}_{\tau 3}$ (N m)' ,'fontsize', fontSize)
% legend({'$d_{\tau 3}$','$\hat{d}_{\tau 3}$'},'interpreter', 'latex','fontsize',fontSize);
% xlim([0 10]);
% ylim([-1 0.1]);
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
