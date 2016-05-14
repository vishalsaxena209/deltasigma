%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Quantization Noise Simulation 1
% Uses delta-sigma toolbox
% Vishal Saxena 2010
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
clear all; clc; close all;

%% Define params
nLev = 17;       % Number of quantizer levels
amplitude = 1;   % Sine amplitude wrt the full scale
% Note that in the toolbox, the quantizer has LSB = 2.

%% Simulate in time
Nfft = 2^8;       % Record length aka FFT size

m = 9;          % prime wrt Nfft 
% m = 9.1;      % irrationally related to fs 
% m = Nfft/8;   % fs/8  

fs = 1;           % Normalized to 1Hz    
fin = (m/Nfft)*fs; 

t = [0:Nfft-1];
y = amplitude*(nLev-1)*sin(2*pi*fin*t);

% Quantize
v = ds_quantize(y, nLev);
e = y-v;

e_rms = mean(e.^2)

%% Time domain plots
numOfSamples = 32; 
n=1:numOfSamples;

figure(1)
subplot(2,1,1)
plot(t(n), y(n), 'g'); hold on;
stem(t(n), v(n), 'b');
grid on;
xlabel('samples'); xlim([1 numOfSamples]);
legend('y[n]','v[n]');
title('Quantization');

subplot(2,1,2)
stem(t(n), e(n), 'b');
grid on;
text_handle = text(25,-0.7, sprintf('E(e^2) = %1.3f',e_rms),'EdgeColor','red','LineWidth',2,'BackgroundColor',[1 1 1],'Margin',5);
xlabel('samples'); xlim([1 numOfSamples]);
legend('e[n]');

%% Frequency domain plots
V = fft(v);

figure(2)
stem(dbv(V), 'b'); 
grid on; hold on; 
xlim([1 Nfft]);ylim([0 80]);
xlabel('FFT bins (k)'); ylabel('20*log_{10}|V(k)|, dB'); 
legend('V[k]'); 
title('Quantized Signal Spectrum');



