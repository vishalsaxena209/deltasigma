%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Systematic NTF Design Procedure
% Butterworth Response
% Vishal Saxena, BSU
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
clear all; clc; close all;


% DSM Specifications
% SNDR > 120 dB, some signal BW.

%% User params
L = 3;          % Modulator Order
OSR = 64;       % OSR
nLev = 2^4;     % Number of quantizer levels

% Create a HPF filter, H(z) with w3dB = pi/8
[b,a] = butter(L,1/8,'high');
H = tf(b,a,[],'variable','z^-1');
H = zpk(H);

% Enforcing b0 = 1
NTF = H/b(1);

%% Plot NTF Response
figure();
w = [linspace(0,0.75/OSR,100) linspace(0.75/OSR,1,100)]; % Normalized w
z = exp(i*w*pi);
plot(w,abs(evalTF(H,z)), 'b', 'LineWidth', 2);
grid on; hold on;
plot(w,abs(evalTF(NTF,z)), 'r',  'LineWidth', 2);
legend('H(z)', 'NTF(z)');
xlabel('\omega / \pi'), ylabel('Magnitude');


%% Simulate DSM in time
% Specify input amplitude levels
amp = [-120:10:-10 -9:1:-5 -4.5:0.25:0];    
% Simulate SNR
[snr,amp] = simulateSNR(NTF,OSR,amp,0,nLev,1/(4*OSR),13);

% Find maximum SNR index
[snr_max max_index] = max(snr);
% Estimate MSA from the max SNR index
MSA_dB = amp(max_index);
MSA = 10^(MSA_dB/20);

figure()
plot(amp,snr,'b-s');

grid on;
figureMagic([-100 0], 10, 2, ...
[0 140], 10, 1);
xlabel('Input Level, dB');
ylabel('SNR dB');
s=sprintf('peak SNR = %4.1fdB\n', max(snr))
s1=sprintf('MSA = %4.1f\n',MSA)
text(-65,15,s);

%% EOF