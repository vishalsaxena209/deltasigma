%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Quantizer characteristics : Ramp input
% Uses delta-sigma toolbox
% Vishal Saxena 2010
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
clear all; clc; close all;

%% Define params
nLev = 15;          % Number of quantizer levels
amplitude = 1;    % Sine amplitude wrt the full scale
% Note that in the toolbox, the quantizer has LSB=2.

% Housekeeping
M = nLev-1      % Number of steps
LSB = 2;
FS = 2*M        % Full scale range


%% Simulate in time
Nfft = 2^13;    % Record length aka FFT size
tone_bin = 31;  % prime wrt Nfft 
t = [0:Nfft-1];
numOfSamples = 750; 

% Slow ramp input
y1=-1.5*M; y2=1.5*M; t1=t(1); t2=numOfSamples; 
y = y1 + ((y2-y1)/(t2-t1))*t;

% Quantize
v = ds_quantize(y, nLev);
v1 = vs_quantize(y, nLev, LSB);
% Quantization error
e = v-y;
e1 = v1-y;

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


figure(2)

subplot(2,1,1);
plot(t(n), y(n), 'b');
hold on; grid on;
stairs(t(n), v1(n), 'r');
xlabel('samples'), 
legend('y[n]','v1[n]');
title('Quantization');

subplot(2,1,2);
plot(t(n), e1(n), 'b');grid on;
xlabel('samples'), 
legend('e1[n]');
