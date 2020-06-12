%% Read in the mesh and solution data
close all;
clear all;
run=sprintf('run_14'); % run_1 has a synchronous oscillation for I=0 (phi starts at 0.3), 
% run_2 has Igrad = gradient(x/L, 0.4, 0.8, 0, 0.005), run_3 is a longer run_1 (max 2500), run_4 replaces phi by phizero (max 1500), 
% run_5 has advection and the new term both zero'ed out, run_6 has new term instead of advection but same IC
% as run_5 for comparison purposes (max 850), run_7 has the advection term
% run 8 is a long run (max 3000)
% run_9 is testing a sharper initial condition
% run_10 has code changes and impulse IC
% run_11 has code changes and uses meshL class, i=2000
% run_12 tries to eliminate the gradient that solidifies in phi, i = 550
addpath('ffmatlib');
addpath('output_folder');

subplot_vis = struct('cdata',[],'colormap',[]);
vid = VideoWriter(strcat(run,'movie_DP.avi'));
vid.FrameRate = 32;
open(vid);
Table_u=[];
Table_v=[];

nx = 100+1;

for i=1:1:2500
    time=sprintf('%d',i*200); % time frames are 50, 100, 150, etc.
    
    f = figure(1);
    f.Name = ['Simulation time: t = ', num2str(i*200*0.001)]; % h = 0.01
    %Load the mesh
    %[p,b,t,nv,nbe,nt,labels]=ffreadmesh(strcat('Epstein_mesh', run,'.mesh'));
    %Load the finite element space connectivity
    vh=ffreaddata(strcat('Epstein_vh', run,'.txt'));
    %Load scalar data
    u = ffreaddata(strcat('solution_u', num2str(time),run,'.txt'));
    v = ffreaddata(strcat('solution_v', num2str(time),run,'.txt'));
    phi = ffreaddata(strcat('solution_phi', num2str(time),run,'.txt'));
    %% Plots

    subplot(3,1,1), plot(1:nx,u(1:nx),'LineWidth',2), title('U');
    ylim([-0.01 0.3]);
    xlim([1 nx]);
    Table_u(:,i)=u(1:nx);

    subplot(3,1,2), plot(1:nx,v(1:nx),'LineWidth',2), title('V');
    ylim([-0.01 0.3]);
    xlim([1 nx]);
    Table_v(:,i)=v(1:nx);
    
    subplot(3,1,3), plot(1:nx,phi(1:nx),'LineWidth',2), title('Phi');
    %axis tight;
    ylim([0 0.4]);
    xlim([1 nx]);
    Table_phi(:,i)=phi(1:nx);
    
    temp_frame = getframe(gcf);
    writeVideo(vid,temp_frame);
    hold off;
end

close(vid);

figure(2);
imagesc(Table_u');
title('U');
caxis([0 0.3]);
colormap jet;
colorbar;
ylabel('time');
xlabel('space');
set(gca,'FontSize',18);

figure(3);
imagesc(Table_v');
title('V');
caxis([0 0.3]);
colormap jet;
colorbar;
ylabel('time');
xlabel('space');
set(gca,'FontSize',18);

figure(4);
imagesc(Table_phi');
title('Phi');
caxis([0 1]);
colormap jet;
colorbar;
ylabel('time');
xlabel('space');
set(gca,'FontSize',18);

% figure(5);
% Igrad = ffreaddata(strcat('gradient', run,'.txt'));
% plot(Igrad(1:nx));
% axis tight;
