%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Second-order CT DSM Design Example
% Using the Toolbox function
%
% Vishal Saxena, 2010.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; clear all;

% NTF(z) = (1-z^-1)^2
% L(z) = (-2*z + 1)/(z-1)^2

% Define DAC pulse
tdac = [0 1];

ntf = zpk([1 1],[0 0], 1, 1);
[ABCDc,tdac2] = realizeNTF_ct(ntf, 'FB', tdac)
% tf(sysc)