%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot transfer functions for the quantization noise being filtered by a
% Decimation filter.
% Vishal Saxena, BSU
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Creating NTF(z) = 1-z^-1
b = [1 -1]; a = 1;
NTF = dfilt.df2t(b,a);

% Sinc filter of length 8, H1
N = 8;
b1 = [1 0 0 0 0 0 0 -1]/N;
a1 = [1 -1];
H1=dfilt.df2t(b1,a1);

% Cascade of NTF followed by H1
Hcas=dfilt.cascade(NTF,H1);

% Plots
fvtool(NTF, H1, Hcas);
