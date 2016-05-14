clear all; clc;
% integral
syms N x
N = 16;

% I1 = int(sin(N*x/2)^2, 0, pi)
% I2 = int(sin(N*x/2)^4, 0, pi)
% I3 = int( (sin(x/2)*sin(N*x/2))^2, 0, pi)
% I4 = int((sin(N*x/2)^2/sin(x/2))^2, 0, pi)
I5 = int((sin(N*x/2)^3/sin(x/2))^2, 0, pi)

%eval(I1),eval(I2),eval(I3),eval(I4),eval(I5)