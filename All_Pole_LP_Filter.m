%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% All pole low pass transfer function
% P(z)*P(1/z) = P(1) + a*(z-1)^n*((z^-1)-1)^n
% Vishal Saxena, BSU
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
clear all; clc; close all;

%% User params
a = 1;      % Sharpness factor
n = 4;      % Order
Wn = 0.3;   % Cutoff frequency

% P(z)
[b,a] = maxflat(0,n,Wn);
P = tf(b,a,[],'variable','z^-1');
P = zpk(P);

% Visualize NTF
fvtool(b,a);

% %% Plot the Spectrum
% spec = fft(v.*ds_hann(Nfft))/(Nfft*(nLev-1)/4);
% snr = calculateSNR(spec(1:ceil(Nfft/(2*OSR))+1), tone_bin);
% Neff = (snr-1.76)/6.02;
% 
% NBW = 1.5/Nfft;
% f = linspace(0, 0.5, Nfft/2+1);
% Sqq = 4*(evalTF(Ha, exp(2i*pi*f))/(nLev-1)).^2/3;
% 
% figure()
% semilogx(f, dbv(spec(1:Nfft/2+1)), 'b')
% hold on; grid on;
% semilogx(f, dbp(Sqq*NBW), 'm', 'Linewidth', 1);
% xlim([0 0.5]);
% title('DSM Output Spectrum');
% 
% %% EOF
% 
% 
