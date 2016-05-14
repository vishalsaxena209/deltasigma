%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Quantization Noise
% Uses delta-sigma toolbox
% Vishal Saxena 2010
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
clear all; clc; close all;

%% Define params
nLev = 2^6;          % Number of quantizer levels
amplitude = 1;    % Sine amplitude wrt the full scale
% Note that in the toolbox, the quantizer has LSB=2.

LSB = 0.1;

%% Simulate in time
Nfft = 2^10;    % Record length aka FFT size
tone_bin = 1;  % prime wrt Nfft 
fs = 1;         % 1 Hz    
fin = (tone_bin/Nfft)*fs; 

t = [0:Nfft-1];

y = amplitude*sin(2*pi*fin*t);

% Quantize
v = vs_quantize(y, nLev, LSB);
e = y-v;

%% Time domain plots
numOfSamples = Nfft; 
n=1:numOfSamples;

figure(1)
plot(t(n), y(n), 'g');
hold on; grid on;
stairs(t(n), v(n), 'r');
plot(t(n), e(n), 'b');
xlabel('samples'); xlim([1 numOfSamples]);
legend('y[n]','v[n]', 'e[n]');
title('Quantization');

%% Frequency domain plots
norm = Nfft/2; % FFT normalization factor

V = fft(v)/norm;

% Adding machine epsilon to V so that 0's are avoided 
% as argument to the log10() resulting in Inf.
V = V + size(V,1)*eps; 

figure(2)
plot(dbv(V), 'b'); 
grid on; hold on; 
xlim([1 150]), ylim([-80 0]);
xlabel('FFT bins (k)'); ylabel('20*log_{10}|V(k)|, dB'); 
legend('V[k]'); 
title('Quantized Signal Spectrum');

