%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Quantizer demo : Sampled sine input
% Uses delta-sigma toolbox
% Vishal Saxena 2010
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
clear all; clc; close all;

%% Define params
nLev = 7;          % Number of quantizer levels
amplitude = 1;    % Sine amplitude wrt the full scale
% Note that in the toolbox, the quantizer has LSB=2.

% Housekeeping
M = nLev-1      % Number of steps
FS = 2*M        % Full scale range


%% Simulate in time
Nfft = 2^13;    % Record length aka FFT size
tone_bin = 31;  % prime wrt Nfft 
fs = 1;         % 1 Hz    
fin = (tone_bin/Nfft)*fs; 

t = [0:Nfft-1];

y = amplitude*(nLev-1)*sin(2*pi*fin*t);

% Quantize
v = ds_quantize(y, nLev);
e = y-v;

numOfSamples = 750; 
n=1:numOfSamples;

figure(1)

subplot(2,1,1);
plot(t(n), y(n), 'b');
hold on; grid on;
stairs(t(n), v(n), 'r');
xlabel('samples'), 
legend('y[n]','v[n]');
title('Quantization');

subplot(2,1,2);
plot(t(n), e(n), 'b');grid on;
xlabel('samples'), 
legend('e[n]');

