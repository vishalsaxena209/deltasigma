%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Second-order CT DSM Design Example
% Using the Toolbox function
% Green Book, pgs. 318-320
%
% Vishal Saxena, 2010.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; clear all;

% NTF(z) = ((1-z^-1)/(1-(z^-1)/3))^2

order = 3;

tau = 0.5; % ELD

% Define DAC pulse
tdac = [tau 1+tau];

ntf = zpk([1 1 1], [0 0 0], 1, 1);
[ABCDc,tdac2] = realizeNTF_ct(ntf, 'FF', tdac)


[Ac Bc Cc Dc] = partitionABCD(ABCDc, order);
sysc = ss(Ac, Bc, Cc, Dc);
Ls = tf(sysc) % 2X1 loop-filer
% L1s = Ls(2) % loop-filer seen by the feedback (v)
