%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% A simple third-order DSM
% with root locus w.r.t the 'noise quantizer gain' k1
% Read DSM stability theory from Schreier's books.
% NTF(z) = (1-z^-1)^3
% Vishal Saxena, BSU
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
clear all; clc; close all;

%% User params
OSR = 32;   % OSR
nLev = 2^3;   % Number of quantizer levels

% Creating NTF(z) = (1-z^-1)^3 = 1 - 3z^-1 + 3z^-2 -z^-1
b = [1 -3 3 -1]; a = 1;
NTF1 = tf(b,a,[],'variable','z^-1'); % NTF for quantizer gain 1

%% Root Locus
% MATLAB's rlocus function can be used to plot the root locus of the 
% linear model of the quantizer with the noise gain obtained from the
% decribing function analysis. Discuss with the author for further 
% clarification.
rlocus(NTF1);

% EOF
