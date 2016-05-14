%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Describing Function Method
% Vishal Saxena, BSU
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
clear all; clc; close all;

%% User params
OSR = 32;   % OSR
nLev = 2^3;   % Number of quantizer levels
amplitude = 0.9;

Nfft = 2^10;
tone_bin = 13;

t = [0:Nfft-1];

% Generate noise
rand('twister', Nfft); % reset seed for rand
n1 = 2*rand(1, Nfft)-1; % Uniformly distributed pseudorandom noise


u = amplitude*(nLev-1)*sin(2*pi*tone_bin/Nfft*t);
y = u + n1;

% Apply the hard non-linearity
% Gain in the linear portion = 1
v = applyQuantizerNL(y,nLev, 1);

%% Describing Function Method
A = [u' n1'];
b = inv(A'*A)*(A'*v');
k0 = b(1);
k1 = b(2);
v1 = k0*u + k1*n1;
err = v1 - v; % Fitting error


%% Plot results
figure(1)
n=1:120;
plot(t(n), u(n), 'b', 'LineWidth', 1);
hold on; grid on;
plot(t(n), n1(n), 'g');
plot(t(n), v(n), 'm', 'LineWidth', 2);
plot(t(n), v1(n), 'r', 'LineWidth', 2);
legend('u1', 'n1', 'v', 'v1');
title(['k_{0}=', num2str(k0),',  k_{1}=', num2str(k1)]);

% figure(2)
% n=1:120;
% plot(t(n), v(n), 'r', 'LineWidth', 2);
% hold on; grid on;
% plot(t(n), v1(n), 'm', 'LineWidth', 2);
% plot(t(n), err(n), 'g', 'LineWidth', 1);
% legend('v', 'v1', 'Fitting error');
% title(['k_{0}=', num2str(k0),',  k_{1}=', num2str(k1)]);

%% EOF


