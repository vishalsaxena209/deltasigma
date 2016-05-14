%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Second-order CT DSM Design Example
% from Cherry's book, Pgs. 34-35
%
% Vishal Saxena, 2010.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; clear all;

% NTF(z) = (1-z^-1)^2
% L(z) = (-2*z + 1)/(z-1)^2

% Define DAC pulse
tdac = [0 0.5];

% Define DT state-space
[A,B,C,D] = tf2ss([0 -2 1], [1 -2 1]);
sysd = ss(A,B,C,D,1);   % State-space, Ts=1

% Convert to CT state-space
% sysc = d2c(sysd) produces a continuous-time model sysc that is equivalent
% to the discrete-time LTI model sysd using zero-order hold on the inputs.
sysc = d2c(sysd);

% Change to a generic rectangular DAC pulse shape
% Ac = sysc.a;
Ac = [1 -1; 1 -1.0001];  % Fix for singularity problem in ac
Bc = inv(expm(Ac*(1-tdac(1))) - expm(Ac*(1-tdac(2))))*(sysd.a - eye(2))*sysc.b;
sysc.b = Bc;
tf(sysc)