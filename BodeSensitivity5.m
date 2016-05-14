%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Bode Senstivity Integral Demo 5
% Shows comparison when complex NTF zeros are used
% Vishal Saxena, BSU
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
clear all; clc; close all;

%% User params
order = 3;          % Modulator Order
OSR = 16;       % OSR
nLev = 2^4;     % Number of quantizer levels

% Create NTF with all NTF zeros at z=1
OBG = 3; opt=0;
NTF1 = synthesizeNTF(order,OSR,opt,OBG);
%NTF1 = zpk(NTF1);

% Create NTF with optimized NTF zeros 
OBG = 3; opt=1;
NTF2 = synthesizeNTF(order,OSR,opt,OBG);
%NTF1 = zpk(NTF1);


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
xlim([0 1]); ylim([-70 20]);
xlabel('\omega / \pi'); ylabel('10*log|H|');


%% EOF