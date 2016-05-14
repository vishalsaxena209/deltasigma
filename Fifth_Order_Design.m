%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% A fifth-order DSM with dynamic range scaling
% Vishal Saxena, BSU
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
clear all; clc; close all;

%% Synthesize a single-bit second order DSM
order = 5;  % Second order
OSR = 16;   % OSR
opt = 1;    % Dont optimize the zeros
nLev = 15;   % Number of quantizer levels
xLim = 0.6; % Limits on integrator output level
f0 = 0;     % Center frequency
H_inf = 3;  % OBG

% Synthesize the initial design
H = synthesizeNTF(order, OSR, opt, H_inf); 
form = 'CRFF';  % CRFF modulator structure

% Find the coefficients a,g,b,c. 
% Use only single input feed-forward path
[a,g,b,c] = realizeNTF(H, form);
b(2:end-1) = 0;
kq = 1;
% b(end) = 1/kq;

% Find ABCD Matrix
ABCD = stuffABCD(a,g,b,c,form);

%% Scale the ABCD matrix
[ABCDs umax] = scaleABCD(ABCD, nLev, f0, xLim);
% Map the scaled design back to the coefficients
[a,g,b,c] = mapABCD(ABCDs, form);
% Find NTF and STF
[Ha Ga] = calculateTF(ABCDs, kq);

plotPZ(Ha);

f = linspace(0, 0.5, 1000);
z = exp(2i*pi*f);

figure();
plot(f, abs(evalTF(Ha,z))); hold on; grid on;
plot(f, abs(evalTF(Ga,z)),'r');
legend('NTF', 'STF');

figure();
plot(f, dbv(evalTF(Ha,z))); hold on; grid on;
plot(f, dbv(evalTF(Ga,z)),'r');
legend('NTF', 'STF');
% sigma_H = dbv(rmsGain(Ha, 0, 0.5/OSR))

%% Simulate the DSM in time
Nfft = 2^13;
tone_bin = 31;

t = [0:Nfft-1];

u = 0.5*(nLev-1)*sin(2*pi*tone_bin/Nfft*t);
[v,xn,xmax,y] = simulateDSM(u,Ha,nLev);
kq = mean(v.*y)/mean(y.^2);

% figure(2)
% n=1:150;
% stairs(t(n), u(n), 'g');
% hold on; grid on;
% stairs(t(n), v(n), 'b');

%% Simulate the Spectrum
spec = fft(v.*ds_hann(Nfft))/(Nfft*(nLev-1)/4);
snr = calculateSNR(spec(1:ceil(Nfft/(2*OSR))+1), tone_bin)
Neff = (snr-1.76)/6.02

NBW = 1.5/Nfft;
f = linspace(0, 0.5, Nfft/2+1);
Sqq = 4*(evalTF(Ha, exp(2i*pi*f))/(nLev-1)).^2/3;

figure()
plot(f, dbv(spec(1:Nfft/2+1)), 'b')
hold on; grid on;
plot(f, dbp(Sqq*NBW), 'm', 'Linewidth', 1);

% EOF
