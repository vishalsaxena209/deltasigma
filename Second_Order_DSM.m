%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% A second-order DSM 
% NTF(z) = (1-z^-1)^2
% Vishal Saxena, BSU
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
clear all; clc; close all;

%% User params
OSR = 32;   % OSR
nLev = 2^3;   % Number of quantizer levels

% Creating NTF(z) = (1-z^-1)^2 = 1 - 2z^-1 + z^-1
b = [1 -2 1]; a = 1;
Ha = tf(b,a,[],'variable','z^-1');
Ha = zpk(Ha);

% Visualize NTF
% fvtool(b,a);

%% Simulate the DSM in time
Nfft = 2^13;
tone_bin = 31;

t = [0:Nfft-1];

u = 1*(nLev-1)*sin(2*pi*tone_bin/Nfft*t);
v = simulateDSM(u,Ha,nLev);

figure()
n=1:1000;
plot(t(n), u(n), 'r');
hold on; grid on;
stairs(t(n), v(n), 'b');

%% Simulate the Spectrum
spec = fft(v.*ds_hann(Nfft))/(Nfft*(nLev-1)/4);
snr = calculateSNR(spec(1:ceil(Nfft/(2*OSR))+1), tone_bin)
Neff = (snr-1.76)/6.02

NBW = 1.5/Nfft;
f = linspace(0, 0.5, (Nfft/2)+1);
Sqq = 4*(evalTF(Ha, exp(2i*pi*f))/(nLev-1)).^2/3;

figure()
semilogx(f, dbv(spec(1:Nfft/2+1)), 'b')
hold on; grid on;
semilogx(f, dbp(Sqq*NBW), 'm', 'Linewidth', 1);
xlim([0 0.5]);

%% EOF

