%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Bode Senstivity Integral Demo 4
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
NTF1 = H/b(1);

% Create a HPF filter, H(z) with w3dB = pi/8
[b,a] = cheby2(L,60,1/8,'high');
H = tf(b,a,[],'variable','z^-1');
H = zpk(H);
NTF2 = H/b(1);


%% Bode Sensitivity Calcs
w = linspace(0, 1, 1000);

NTF1_mag = evalTF(NTF1, exp(i*pi*w));
S1 = 20*log10(abs(NTF1_mag));

NTF2_mag = evalTF(NTF2, exp(i*pi*w));
S2 = 20*log10(abs(NTF2_mag));

zerodB = 0.*w;  % 0 dB line

%% Plot 
figure()
% area(w, S1);
plot(w, S1, 'b', 'LineWidth', 2);
hold on; grid on;
plot(w, S2, 'r', 'LineWidth', 2);
plot(w, zerodB, 'k', 'LineWidth', 2)
xlim([0 1]); ylim([-70 25]);
xlabel('\omega / \pi'); ylabel('10*log|H|');


%% EOF