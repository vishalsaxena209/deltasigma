%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% NTF design with :
% Optimized zeros and maximally flat pole locations
% Vishal Saxena, BSU
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
clear all; clc; close all;

%% User params
order = 5;  % Order
OSR = 16;   % OSR
OBG = 3;    % OBG
opt = 1;    % Choose 1 or 2

%% Find optimal zeros
dw = pi/OSR;
z = dw*ds_optzeros(order,opt);
z = exp(j*z);
ntf0 = zpk(z,zeros(1,order),1,1);

%% Maximally flat poles
Wn = 0.35;   % Cutoff frequency
[b,a] = maxflat(0,order,Wn);
P = tf(b,a,[],'variable','z^-1');
P = zpk(P);

%% NTF
ntf = ntf0*P;
ntf1 = tf(ntf);
[num, den] = tfdata(ntf1, 'v');
b0 = num(1);
ntf = ntf/b0;

%% PZplot
plotPZ(ntf);

%% Plot NTF Response
figure();
w = [linspace(0,0.75/OSR,100) linspace(0.75/OSR,1,100)]; % Normalized w
z = exp(i*w*pi);
plot(w,abs(evalTF(ntf0,z)), 'b', 'LineWidth', 2);
grid on; hold on;
plot(w,abs(evalTF(P,z)), 'g', 'LineWidth', 2);
plot(w,abs(evalTF(ntf,z)), 'r', 'LineWidth', 2);
legend('NTF_{0}(z)','P(z)','NTF(z)');
xlabel('\omega / \pi'), ylabel('Magnitude');

figure();
w = [linspace(0,0.75/OSR,100) linspace(0.75/OSR,1,100)]; % Normalized w
z = exp(i*w*pi);
plot(w,dbv(abs(evalTF(ntf0,z))), 'b', 'LineWidth', 2);
grid on; hold on;
plot(w,dbv(abs(evalTF(P,z))), 'g', 'LineWidth', 2);
plot(w,dbv(abs(evalTF(ntf,z))), 'r', 'LineWidth', 2);
legend('NTF_{0}(z)','P(z)','NTF(z)');
xlabel('\omega / \pi'), ylabel('Magnitude');

%% EOF


