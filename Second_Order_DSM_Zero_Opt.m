%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Second-order Delta-Sigma Modulator Example
% No dynamic range-scaling applied
% Vishal Saxena
% BSU 2009
% Uses Richard Schreier's Delta-Sigma Toolbox
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
clear all; clc; close all;

% Synthesize a single-bit second order DSM
order = 2;  % Second order
OSR = 32;   % OSR
opt = 1;    % Dont optimize the zeros
OBG = 3;    % OBG=4, No poles in the NTF
nLev = 2^3; % Number of quantizer levels
f0 = 0;     % Center frequency

% Synthesize the initial design
H = synthesizeNTF(order, OSR, opt, OBG); 
form = 'CIFB';  % CIFB modulator structure

% Find the coefficients a,g,b,c. 
[a,g,b,c] = realizeNTF(H, form);
% Use only single input feed-forward path
b(2) = 0;

% Find ABCD Matrix
ABCD = stuffABCD(a,g,b,c,form);

% Find NTF and STF from the ABCD Matrix
[Ha Ga] = calculateTF(ABCD, 1);
plotPZ(Ha,'b',10,0);

% Simulate the DSM in time using ABCD1 matrix
Nfft = 2^13;
tone_bin = 31;
t = [0:Nfft-1];

u = 0.5*(nLev-1)*sin(2*pi*tone_bin/Nfft*t);
u1 = u;
[v,xn,xmax,y] = simulateDSM(u,ABCD,nLev);

[Ha Ga] = calculateTF(ABCD, 1);

% Get num den data for NTF
[b, a] = tfdata(Ha, 'v');
% fvtool(b,a);

% Plot time-domain simulation results
figure()
n=1:500;
stairs(t(n), v(n), 'b');
hold on; grid on;
stairs(t(n), u(n), 'r', 'LineWidth', 2);
legend('v', 'u');

% Simulate the Spectrum
spec = fft(v.*ds_hann(Nfft))/(Nfft*(nLev-1)/4);
snr = calculateSNR(spec(1:ceil(Nfft/(2*OSR))+1), tone_bin);
Neff = (snr-1.76)/6.02;

NBW = 1.5/Nfft;
f = linspace(0, 0.5, Nfft/2+1);
Sqq = 4*(evalTF(Ha, exp(2i*pi*f))/(nLev-1)).^2/3;

figure()
semilogx(f, dbv(spec(1:Nfft/2+1)), 'b')
hold on; grid on;
semilogx(f, dbp(Sqq*NBW), 'r', 'Linewidth', 2);
text_handle = text(2*10^-2,-140, ...
    sprintf('SNDR = %4.1f dB \nENOB = %2.2f bits \n@OSR = %2.0f',snr,Neff,OSR),...
    'FontWeight','bold','EdgeColor','red','LineWidth',3,'BackgroundColor',[1 1 1],'Margin',10);
xlabel ('Frequency'); ylabel ('dB');
xlim([10^-4 0.5]); ylim([-170 0]);
title ('Second-Order DSM Output Spectrum'); 


%% EOF
