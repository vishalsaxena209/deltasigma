%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Oversampling and Filtering of Quantization Noise
% Vishal Saxena, BSU
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
clear all; clc; close all;

%% Define params
OSR = 16;   % OSR
nLev = 2^4;   % Number of quantizer levels

%% Simulate in time
Nfft = 2^10;
tone_bin = 7;          % tone bin
fs = 1;           
fin = (tone_bin/Nfft)*fs; 
t = [0:Nfft-1];

% Input sine-wave
u = (nLev-1)*sin(2*pi*tone_bin/Nfft*t);

% Quantize the input u
v = ds_quantize(u, nLev);
e = v-u;
e_rms = mean(e.^2);

% Design a Butterworth filter 
[z,p,k] = butter(8, 1/OSR);

% Obtain numerator and denominator coeffs
[b,a] = zp2tf(z,p,k);

% Filter the input and the quantizer outputs
u_f = filter(b,a,u);
v_f = filter(b,a,v);
% fvtool(b,a) % Verify filter response

% Calculate the filtered quantization noise
e_f = v_f-u_f;
e_f_rms = mean(e_f.^2);

%% Time-domain plots
numOfSamples = 500;  % plot 3 cycles 

figure();
n=1:numOfSamples;
subplot(2,1,1)
plot(t(n), u(n), 'g', 'LineWidth', 1);
hold on; grid on;
stairs(t(n), v(n), 'b', 'LineWidth', 1);
plot(t(n), v_f(n), 'r', 'LineWidth', 2);
xlim([0 numOfSamples]);
legend('u[n]','v[n]','v_f[n]');
title('Oversampling: Time-domain waveforms');

subplot(2,1,2)
plot(t(n), e(n), 'b');
hold on; grid on;
plot(t(n), e_f(n), 'r', 'LineWidth', 2);
xlim([0 numOfSamples]);
legend('e[n]', 'e_f[n]');

%% Apply FFT and Calculate SNR
norm = (Nfft*(nLev-1)/4); % FFT/Hann normalization factor

% Apply Hann window to avoid FFT leakage
V = fft(v.*ds_hann(Nfft))/norm; % spectrum
V_f = fft(v_f.*ds_hann(Nfft))/norm; % spectrum

% Estimate SNR and ENOB
snr = calculateSNR(V_f(1:ceil(Nfft/2)+1), tone_bin); % Assumes Hann window
Neff = (snr-1.76)/6.02;

sprintf('SNDR = %f dB', snr)
sprintf('ENOB = %f bits', Neff)

%% Frequency-domain plots
f = linspace(0, 0.5, Nfft/2+1); % fs/2 is 1 

figure()
subplot(1,2,1)
plot(f, dbv(V(1:Nfft/2+1)), 'b')
hold on; grid on;
xlim([0 0.5]), ylim([-80 10]);
legend('V(f)');
text(0.2,-10, ['\sigma_{e}^{2}=', num2str(e_rms)],'EdgeColor','red','LineWidth',2,'BackgroundColor',[1 1 1],'Margin',5);
title('Quantization Noise Spectrum');
subplot(1,2,2)

plot(f, dbv(V_f(1:Nfft/2+1)), 'r')
hold on; grid on;
xlim([0 0.5]), ylim([-80 10]);
legend('V_f(f)');
text(0.2,-10, ['\sigma_{q}^{2}=', num2str(e_f_rms)],'EdgeColor','red','LineWidth',2,'BackgroundColor',[1 1 1],'Margin',5);
title('Filtered Quantization Noise Spectrum');

%% EOF
sprintf('Quantization Noise reduction by %f times.', e_rms/e_f_rms)
