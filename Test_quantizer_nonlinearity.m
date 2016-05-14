%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Test Quantizer Non-linearity
% Vishal Saxena, BSU
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
clear all; clc; close all;

%% User params
nLev = 2^3;   % Number of quantizer levels
amplitude = 1.2;
Nfft = 2^10;
tone_bin = 31;

t = [0:Nfft-1];

u = amplitude*(nLev-1)*sin(2*pi*tone_bin/Nfft*t);

% Apply the hard non-linearity
% Gain in the linear portion = 1
v = applyQuantizerNL(u,nLev, 1);

y = -(1.5*nLev):1:(1.5*nLev);
v1 = applyQuantizerNL(y, nLev, 1);

%% Plot results
figure(1)
n=1:80;
plot(t(n), u(n), 'r', 'LineWidth', 2);
hold on; grid on;
plot(t(n), v(n), 'm', 'LineWidth', 2);
legend('u', 'v');

figure(2)
plot(y, v1, 'LineWidth', 2);
grid on;
xlabel('Y'), ylabel('V')
%% EOF