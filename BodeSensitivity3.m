%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Bode Senstivity Integral Demo 3
% Vishal Saxena, BSU
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
clear all; clc; close all;

%% User params
L = 3;          % Modulator Order
OSR = 64;       % OSR
nLev = 2^4;     % Number of quantizer levels

% Create a HPF filter, H(z) with w3dB = pi/8
[b,a] = cheby2(L,50,1/8,'high');
H = tf(b,a,[],'variable','z^-1');
H = zpk(H);

% Enforcing b0 = 1
NTF = H/b(1);

%% Bode Sensitivity Calcs
w = linspace(0, 1, 1000);
NTF_mag = evalTF(NTF, exp(i*pi*w));
S1 = 10*log10(abs(NTF_mag));

zerodB = 0.*w;  % 0 dB line

wpos_index = find(S1>0);
wpos = w(wpos_index);
wneg_index = find(S1<=0);
wneg = w(wneg_index);

del_w = w(2)-w(1);
C1 = sum(S1(wpos_index))*del_w
C2 = sum(abs(S1(wneg_index)))*del_w

%% Plot 
figure()
% area(w, S1);
plot(w, S1, 'r', 'LineWidth', 2);
hold on; grid on;
colormap summer
plot(w, zerodB, 'k', 'LineWidth', 2)
xlim([0 1]); ylim([-70 20]);
xlabel('\omega / \pi'); ylabel('10 log|H|');
title(['C_{1}=', num2str(C1),',  C_{2}=', num2str(C2)]);



%% EOF