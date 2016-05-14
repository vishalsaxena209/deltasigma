%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Bode Senstivity Integral Demo 1
% Vishal Saxena, BSU
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; clc; close all;

% Creating H(z) = 1 + a1*z^-1
a1 = 0.6;
b = [1 a1]; a = [1]; 
H1 = tf(b,a,[],'variable','z^-1');
H1 = zpk(H1);

w = linspace(0, 1, 1000);
H1_mag = evalTF(H1, exp(i*pi*w));
S1 = log10(abs(H1_mag));

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
xlim([0 1]);
xlabel('\omega / \pi'); ylabel('log|H|');
title(['C_{1}=', num2str(C1),',  C_{2}=', num2str(C2)]);

