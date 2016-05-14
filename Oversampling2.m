%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Oversampling 2
% Vishal Saxena, BSU
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
clear all; clc; close all;

%% Define params
OSR = 32;   % OSR
nLev = 2^3;   % Number of quantizer levels

%% Simulate in time
Nfft = 2^13;
tone_bin = 31;          % tone bin
fs = 1;           
fin = (tone_bin/Nfft)*fs; 

t = [0:Nfft-1];

u = (nLev-1)*sin(2*pi*tone_bin/Nfft*t);
v = ds_quantize(u, nLev);
e = v-u;
e_rms = mean(e.^2);

% Design a Butterworth filter 
[z,p,k] = butter(8, 1/OSR);

% Obtain numerator and denominator coeffs
[b,a] = zp2tf(z,p,k);

u_f = filter(b,a,u);
v_f = filter(b,a,v);
e_f = v_f-u_f;
e_f_rms = mean(e_f.^2);

%% Time-domain plots
numOfSamples = 1000;  % to be plotted

figure();
n=1:numOfSamples;
plot(t(n), u(n), 'g', 'LineWidth', 1);
hold on; grid on;
stairs(t(n), v(n), 'b', 'LineWidth', 1);
xlim([0 numOfSamples]);

%% Frequency-domain plots
norm = (Nfft*(nLev-1)/4); % FFT normalization factor

V = fft(v.*ds_hann(Nfft))/norm; % spectrum
V_f = fft(v_f.*ds_hann(Nfft))/norm; % spectrum

% snr = calculateSNR(V(1:ceil(Nfft/(2*OSR))+1), tone_bin)
% Neff = (snr-1.76)/6.02

f = linspace(0, 0.5, Nfft/2+1); % fs/2 is 1 

figure()
plot(f, dbv(V(1:Nfft/2+1)), 'b')
hold on; grid on;
xlim([0 0.5]), ylim([-80 10]);
legend('V(f)');
text(0.2,-10, ['\sigma_{e}^{2}=', num2str(e_rms)],'EdgeColor','red','LineWidth',2,'BackgroundColor',[1 1 1],'Margin',5);

%%
e_rms/e_f_rms
