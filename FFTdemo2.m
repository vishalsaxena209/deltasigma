%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% FFT Demo 2
% Sampled sine signal and its spectrum 
% Demonstration of non-coherent sampling
% Vishal Saxena 2010
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

clear all; clc; close all;

%% Define params

ampl = 1;       % Amplitude

Nfft = 2^10;    % Record length or FFT size
norm = Nfft;  % FFT normalizing coeff
tone_bin1 = 129;  
tone_bin2 = 129.01;  
tone_bin3 = 129.001
t = [0:Nfft-1];

x1 = ampl*sin(2*pi*tone_bin1/Nfft*t);
X1dB = 20*log10(abs(fft(x1)/norm));

x2 = ampl*sin(2*pi*tone_bin2/Nfft*t);
X2dB = 20*log10(abs(fft(x2)/norm));

x3 = ampl*sin(2*pi*tone_bin3/Nfft*t);
X3dB = 20*log10(abs(fft(x3)/norm));

numOfSamples = 50; 
n=1:numOfSamples;

% figure(1)
% stem(t(n), x1(n), 'b');
% grid on;
% xlabel('samples (n)'), ylabel('x[n]')

figure(2)
plot(X1dB, 'b');
% plot(X1dB, 'bo');  % Just show the points without connecting them
grid on; hold on;
plot(X2dB, 'r', 'LineWidth', 2);
plot(X3dB, 'g', 'LineWidth', 2);
xlim([1 Nfft]);
xlabel('FFT bins (k)'); ylabel('20*log_{10}|X(k)|, dB'); 
legend('129','129.01','129.001');

