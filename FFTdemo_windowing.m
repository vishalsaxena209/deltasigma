%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% FFT Demo with Windowing
% Incoherent sampling of sine signal
% Reduction of FFT leakage by using windows
% Here, the normalizing factors for the windows 
% haven't been considered.
% Vishal Saxena 2010
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

clear all; clc; close all;

%% Define params

ampl = 1;       % Amplitude

Nfft = 2^10;    % Record length or FFT size
% norm = Nfft;  % FFT normalizing coeff
tone_bin = 129.01;  
t = [0:Nfft-1];

x1 = ampl*sin(2*pi*tone_bin/Nfft*t);
X1dB = 20*log10(abs(fft(x1)));

x2 = x1.*ds_hann(Nfft);
X2dB = 20*log10(abs(fft(x2)));

x3 = x1.*blackmanharris(Nfft)';
X3dB = 20*log10(abs(fft(x3)));

numOfSamples = 50; 
n=1:numOfSamples;

figure(2)
plot(X1dB, 'b', 'LineWidth', 2);
% plot(X1dB, 'bo');  % Just show the points without connecting them
grid on; hold on;
plot(X2dB, 'r', 'LineWidth', 2);
plot(X3dB, 'g', 'LineWidth', 2);
xlim([1 Nfft]);
xlabel('FFT bins (k)'); ylabel('20*log_{10}|X(k)|, dB'); 
legend('Rect','Hann', 'Blackman-Harris');

