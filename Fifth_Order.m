%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% A second order DSM with dynamic range scaling
% Vishal Saxena, BSU
% Assumes 1-path equivalent and ideal components
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
clear all; clc; close all;

%% Synthesize a single-bit second order DSM
order = 3;  % Seond order
OSR = 64;   % OSR
opt = 1;    % Dont optimize the zeros
nLev = 2;   % Number of quantizer levels
xLim = 0.8; % Limits on integrator output level
f0 = 0;     % Center frequency
fs = 100e6;

% Synthesize the initial design
H = synthesizeNTF(order, OSR, opt); 
form = 'CIFB';  % CIFB modulator structure

% Find the coefficients a,g,b,c. 
% Use only single input feed-forward path
[a,g,b,c] = realizeNTF(H, form);
b(2:end) = 0;

% Find ABCD Matrix
ABCD = stuffABCD(a,g,b,c,form);

%% Scale the ABCD matrix
[ABCDs umax] = scaleABCD(ABCD, nLev, f0, xLim);
% Map the scaled design back to the coefficients
[a,g,b,c] = mapABCD(ABCDs, form);
% Find NTF and STF
[Ha Ga] = calculateTF(ABCDs, 1);

plotPZ_VS(Ha,{'r','b'},10,0)

f = linspace(0, 0.5, 1000);
z = exp(2i*pi*f);
figure(2);
plot(f, dbv(evalTF(Ha,z)));
% sigma_H = dbv(rmsGain(Ha, 0, 0.5/OSR))

%% Simulate the DSM in time
Nfft = 2^13;
tone_bin = 31;

t = [0:Nfft-1];

u = 0.5*(nLev-1)*sin(2*pi*tone_bin/Nfft*t);
v = simulateDSM(u,Ha,nLev);

% figure(2)
% n=1:150;
% stairs(t(n), u(n), 'g');
% hold on; grid on;
% stairs(t(n), v(n), 'b');

%% Simulate the Spectrum
spec = fft(v.*ds_hann(Nfft))/(Nfft*(nLev-1)/4);
snr = calculateSNR(spec(1:ceil(Nfft/(2*OSR))+1), tone_bin)
Neff = (snr-1.76)/6.02;

NBW = 1.5/Nfft;
f = linspace(0, 0.5, Nfft/2+1);
f1 = f*fs;
Sqq = 4*(evalTF(Ha, exp(2i*pi*f))/(nLev-1)).^2/3;
figure()
plot(f1, dbv(spec(1:Nfft/2+1)), 'b')
hold on; grid on;
plot(f1, dbp(Sqq*NBW), 'r', 'Linewidth', 2);
xlim([1e5 fs/2]);
xlabel ('Frequency'); ylabel ('dB');
title ('5th-Order DSM Output Spectrum'); 
text_handle = text(floor(fs/3),-110, sprintf('SNDR = %4.1f dB \nENOB = %2.2f bits \n@OSR = %2.0f',snr,Neff,OSR),'FontWeight','bold','EdgeColor','red','LineWidth',3,'BackgroundColor',[1 1 1],'Margin',10);

figure()
semilogx(f1, dbv(spec(1:Nfft/2+1)), 'b')
hold on; grid on;
semilogx(f1, dbp(Sqq*NBW), 'r', 'Linewidth', 2);
xlim([1e5 fs/2]);
xlabel ('Frequency'); ylabel ('dB');
title ('5th-Order DSM Output Spectrum'); 
text_handle = text(floor(2*fs/40),-120, sprintf('SNDR = %4.1f dB \nENOB = %2.2f bits \n@OSR = %2.0f',snr,Neff,OSR),'FontWeight','bold','EdgeColor','red','LineWidth',3,'BackgroundColor',[1 1 1],'Margin',10);




