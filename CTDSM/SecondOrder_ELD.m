%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Second-order CT DSM Design Example with 
% Using the Toolbox function
% Excess Loop Delay Compensation with direct feedback around quantizer
% 
% Vishal Saxena, 2010.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; clear all;

% NTF(z) = ((1-z^-1)/(1-(z^-1)/3))^2

order = 2;

tau = 0.5; % ELD

% Define DAC pulse
tdac = [tau 1+tau];   % NRZ
% tdac = [tau 0.5+tau];   % RZ

ntf = zpk([1 1], [0 0], 1, 1);
[ABCDc,tdac2] = realizeNTF_ct(ntf, 'FF', tdac)

[Ac Bc Cc Dc] = partitionABCD(ABCDc, order);
sysc = ss(Ac, Bc, Cc, Dc);
Ls = tf(sysc); % 2X1 loop-filer
L1s = Ls(2) % loop-filer seen by the feedback (v)

ki = [-Dc(2) Cc] % Loop filter coefficients
