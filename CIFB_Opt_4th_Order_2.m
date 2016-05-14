%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% A fourth-order DSM with CIFB Architecture and
% all NTF zeros at DC.
% Vishal Saxena, BSU
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
clear all; clc; close all;

%% Input params
order = 4;  % Second order
OSR = 16;   % OSR
opt = 1;    % Don't optimize the zeros
nLev = 15;  % Number of quantizer levels
f0 = 0;     % Center frequency
OBG = 3;    % OBG

%% Synthesize the initial design
H = synthesizeNTF(order, OSR, opt, OBG); 
form = 'CIFB';  % CIFB modulator structure

%% Find the coefficients a,g,b,c. 
[a,g,b,c] = realizeNTF(H, form);

% Use all input feed-in paths
% b(2:end) = 0;

%% Find ABCD Matrix
ABCD = stuffABCD(a,g,b,c,form);

fprintf(1,'\n Modulator NTF mapped to CIFB architecture \n');
fprintf(1,'   DAC feedback coefficients (a) = ');
for l=1:order
    fprintf(1,' %.6f',a(l));
end
fprintf(1,'\n   feed-in coefficients (b) = ');
for l=1:order
    fprintf(1,' %.6f',b(l));
end
fprintf(1,'\n   resonator feedback coefficients (g) = ');
for l=1:order/2
    fprintf(1,' %.6f',g(l));
end
fprintf(1,'\n   interstage coefficients (c) = ');
for l=1:order
    fprintf(1,' %.6f',c(l));
end
fprintf(1,'\n');

% Calculate NTF and STF with quantizer gain of 1
% ABCD Matrix in not range scaled
[NTF STF] = calculateTF(ABCD, 1);

% Find L0 and L1
L0 = STF/NTF;
L1 = (1/NTF)-1;


%% Pole NTF, STF, L0 and L1 PZ plots
figure()
subplot(2,2,1)
plotPZ(NTF, {'r' 'b'}); title('NTF(z)');

subplot(2,2,2)
plotPZ(STF, {'r' 'b'}); title('STF(z)');

subplot(2,2,3)
plotPZ(L0, {'r' 'b'}); title('L_{0}(z)');

subplot(2,2,4)
plotPZ(L1, {'r' 'b'}); title('L_{1}(z)');

%% Plot Spectrum
f = linspace(0, 1, 1000);
z = exp(i*pi*f);

figure();
plot(f, abs(evalTF(NTF,z)), 'LineWidth', 2); hold on; grid on;
plot(f, abs(evalTF(STF,z)),'r', 'LineWidth', 2);
xlabel('\omega/\pi'); ylabel('Mag');
legend('NTF', 'STF');

figure();
plot(f, dbv(evalTF(NTF,z)), 'LineWidth', 2); hold on; grid on;
plot(f, dbv(evalTF(STF,z)),'r', 'LineWidth', 2);
xlabel('\omega/\pi'); ylabel('Mag, dB');
legend('NTF', 'STF');

sigma_H = dbv(rmsGain(NTF, 0, 0.5/OSR))

%% Simulate the DSM in time
Nfft = 2^13;
tone_bin = 31;

t = [0:Nfft-1];

u = 0.5*(nLev-1)*sin(2*pi*tone_bin/Nfft*t);
[v,xn,xmax,y] = simulateDSM(u,ABCD,nLev);
kq = mean(v.*y)/mean(y.^2); % Estimate quantizer gain

figure()
n=1:1000;
stairs(t(n), u(n), 'r');
hold on; grid on;
stairs(t(n), v(n), 'b');
title('Transient Simulation');
legend('u', 'v');
xlabel('samples, n');

figure(); clf
plot(t(n), xn(1, n), 'g'); hold on; grid on;
plot(t(n), xn(2, n), 'b');
plot(t(n), xn(3, n), 'm');
plot(t(n), xn(4, n), 'r');
title('Integrator States');
legend('x1', 'x2', 'x3', 'x4');
xlabel('samples, n');
   
%% Simulate the Spectrum
spec = fft(v.*ds_hann(Nfft))/(Nfft*(nLev-1)/4);
snr = calculateSNR(spec(1:ceil(Nfft/(2*OSR))+1), tone_bin)
Neff = (snr-1.76)/6.02

NBW = 1.5/Nfft;
f = linspace(0, 1, Nfft/2+1);
Sqq = 4*(evalTF(NTF, exp(i*pi*f))/(nLev-1)).^2/3;

figure()
plot(f, dbv(spec(1:Nfft/2+1)), 'b')
hold on; grid on;
plot(f, dbp(Sqq*NBW), 'm', 'Linewidth', 1);
text_handle = text(0.6,-160, ...
    sprintf('SNDR = %4.1f dB \nENOB = %2.2f bits \n@OSR = %2.0f',snr,Neff,OSR),...
    'FontWeight','bold','EdgeColor','red','LineWidth',3,'BackgroundColor',[1 1 1],'Margin',10);
xlabel('\omega / \pi'), ylabel('dBFS'); 
title ('Modulator Output Spectrum'); 
ylim([-200 0]);

% EOF