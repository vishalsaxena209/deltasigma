%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% A trivially designed fourth-order DSM showing 
% poles and zeros locations.
% Read DSM stability theory from Schreier's books.
% NTF(z) = (1-z^-1)^4
% Vishal Saxena, BSU
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
clear all; clc; close all;

%% User params
OSR = 32;   % OSR
nLev = 2^3;   % Number of quantizer levels

% Creating NTF(z) = (1-z^-1)^4 
b = [1 -4 6 -4 1]; a = 1;
NTF = tf(b,a,[],'variable','z^-1');
NTF = zpk(NTF);

% Creating STF(z) = z^-2 
b = [0 1]; a = 1;
STF = tf(b,a,[],'variable','z^-1');
STF = zpk(STF);

L0 = STF/NTF;
L1 = (1/NTF)-1;

figure()
plotPZ(L0, 'b', 20);
title('L_{0}(z)');

figure()
plotPZ(L1, 'r', 20);
title('L_{1}(z)');

figure()
plotPZ(NTF, 'b', 20);
title('NTF(z)');

figure()
plotPZ(STF, 'r', 20);
title('STF(z)');

