% %%number of features: 1280, 640, 384, 16, 8, 2
% EERs = [0.377, 0.3855, 0.3835, 0.398, 0.41, 0.43;                   %% without rounding
%     0.3765, 0.3855, 0.384, 0.4005, 0.4045, 0.4295];                       %% with rounding
% env = ["without rounding", "with rounding"];
% features = [1280, 640, 384, 16, 8, 2];
% 
% plot3(EERs, env, features);

% %%number of features: 1280, 640, 384, 16, 8, 2
EERs = [0.377, 0.3855, 0.3835, 0.398, 0.41, 0.43];                       %% without rounding
% env = ["without rounding","without rounding", "without rounding", "without rounding", "without rounding", "without rounding"];
env = [0,0,0,0,0,0];
features = [1280, 640, 384, 16, 8, 2];

EERs2 = [ 0.3765, 0.3855, 0.384, 0.4005, 0.4045, 0.4295];                       %% without rounding
% env = ["without rounding","without rounding", "without rounding", "without rounding", "without rounding", "without rounding"];
env2 = [1,1,1,1,1,1];
features2 = [1280, 640, 384, 16, 8, 2];

grid on
% 
% pts = [EERs; features];
% 
% plot3(pts(:,1), pts(:,2), pts(:,3));

plot3(features, env, EERs, '-o');
hold on
plot3(features2, env2, EERs2, '-o');
ylim([-0.5 1.5])
ax = gca;
ax.ZGrid = 'on';
ax.XGrid = 'on';
ax.YGrid = 'on';
set(gca,'yticklabel',[])
set(gca,'FontSize', 24)
set(findall(gca, 'Type', 'Line'),'LineWidth',3);
% plot3(temp1, temp2, temp3, '-o');

legend('Using doubles','Using integers');

% plot3([0.36, 0.24], [0.45,0.235], [0.31,0.12], '-o');
xlabel('features');
% ylabel('env');
zlabel('EER');


% %%number of features: 1280, 640, 384, 16, 8, 2
% EERs = [0.377, 0.3855, 0.3835, 0.398, 0.41, 0.43;                   %% without rounding
%     0.3765, 0.3855, 0.384, 0.4005, 0.4045, 0.4295];                       %% with rounding
% env = ["without rounding", "with rounding"];
% features = [1280, 640, 384, 16, 8, 2];
% 
% plot3(EERs, env, features);

% % %%number of features: 1280, 640, 384, 16, 8, 2
% EERs = [0.377, 0.3855, 0.3835, 0.398, 0.41, 0.43];                       %% without rounding
% env = ["without rounding","without rounding", "without rounding", "without rounding", "without rounding", "without rounding"];
% % env = [0,0,0,0,0,0];
% features = [1280, 640, 384, 16, 8, 2];
% 
% % EERs2 = [ 0.3765, 0.3855, 0.384, 0.4005, 0.4045, 0.4295];                       %% without rounding
% % % env = ["without rounding","without rounding", "without rounding", "without rounding", "without rounding", "without rounding"];
% % env2 = [1,1,1,1,1,1];
% % features2 = [1280, 640, 384, 16, 8, 2];
% 
% grid on
% % 
% % pts = [EERs; features];
% % 
% % plot3(pts(:,1), pts(:,2), pts(:,3));
% 
% plot(features, EERs, '-o');
% % set(gca,'yticklabel',env.')
% hold on
% plot(features2, EERs2, '-o')
% % plot3(features2, env2, EERs2, '-o');
% ax = gca;
% ax.ZGrid = 'on';
% ax.XGrid = 'on';
% ax.YGrid = 'on';
% % plot3(temp1, temp2, temp3, '-o');
% 
% % plot3([0.36, 0.24], [0.45,0.235], [0.31,0.12], '-o');
% xlabel('features');
% ylabel('env');
% zlabel('EER');