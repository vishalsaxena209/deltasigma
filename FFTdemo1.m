%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% FFT Demo 1
% Sampled sine signal and its spectrum
% Vishal Saxena 2010
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
clear all; clc; close all;

%% Define params

ampl = 1;       % Amplitude

Nfft = 2^10;    % Record length or FFT size
tone_bin = 129;  % prime wrt Nfft 
t = [0:Nfft-1];
norm = Nfft;  % FFT normalizing coeff

x = ampl*sin(2*pi*tone_bin/Nfft*t);
X = fft(x)/norm;
XdB = 20*log10(abs(X));

numOfSamples = 50; 
n=1:numOfSamples;

figure(1)
subplot(2,1,1)
stem(t(n), x(n), 'b');
grid on;
xlabel('samples (n)'), ylabel('x[n]')
% legend('x[n]');

subplot(2,1,2)
plot(XdB);
grid on; xlim([1 Nfft]);
xlabel('FFT bins (k)'); ylabel('20*log_{10}|X(k)|, dB'); 
% legend('X[k]');

