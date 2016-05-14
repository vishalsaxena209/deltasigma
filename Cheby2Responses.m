%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Inverse Chebyshev Responses
% Vishal Saxena, BSU
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
clear all; clc; close all;

%% User params
L = 3;          % Modulator Order
OSR = 16;       % OSR
R = 60;
Wst = 1/OSR;

R = 60; Wst = 1/OSR;
[b,a] = cheby2(L,R,Wst,'high');
H1 = tf(b,a,[],'variable','z^-1');
H1 = zpk(H1);
NTF1 = H1/b(1);

R = 60; Wst = 1.1/OSR;
[b,a] = cheby2(L,R,Wst,'high');
H2 = tf(b,a,[],'variable','z^-1');
H2 = zpk(H2);
NTF2 = H2/b(1);

R = 60; Wst = 1.2/OSR;
[b,a] = cheby2(L,R,Wst,'high');
H3 = tf(b,a,[],'variable','z^-1');
H3 = zpk(H3);
NTF3 = H3/b(1);

R = 60; Wst = 1.3/OSR;
[b,a] = cheby2(L,R,Wst,'high');
H4 = tf(b,a,[],'variable','z^-1');
H4 = zpk(H4);
NTF4 = H4/b(1);

R = 60; Wst = 1.4/OSR;
[b,a] = cheby2(L,R,Wst,'high');
H5 = tf(b,a,[],'variable','z^-1');
H5 = zpk(H5);
NTF5 = H5/b(1);


%% Plot NTF Response
figure(1);
w = [linspace(0,0.75/OSR,100) linspace(0.75/OSR,1,100)]; % Normalized w
z = exp(i*w*pi);
plot(w,abs(evalTF(H1,z)), 'b', 'LineWidth', 2);
grid on; hold on;
plot(w,abs(evalTF(H2,z)), 'r', 'LineWidth', 2);
plot(w,abs(evalTF(H3,z)), 'm', 'LineWidth', 2);
plot(w,abs(evalTF(H4,z)), 'g', 'LineWidth', 2);
plot(w,abs(evalTF(H5,z)), 'y', 'LineWidth', 2);
xlabel('\omega / \pi'), ylabel('Magnitude');
legend('\omega_{3dB}=0.2', '\omega_{3dB}=0.3', '\omega_{3dB}=0.4',...
    '\omega_{3dB}=0.5', '\omega_{3dB}=0.6', 'Location', 'SouthEast');
title('H(z), Butterworth High-Pass Responses');

figure(2);
w = [linspace(0,0.75/OSR,100) linspace(0.75/OSR,1,100)]; % Normalized w
z = exp(i*w*pi);
plot(w,abs(evalTF(NTF1,z)), 'b', 'LineWidth', 2);
grid on; hold on;
plot(w,abs(evalTF(NTF2,z)), 'r', 'LineWidth', 2);
plot(w,abs(evalTF(NTF3,z)), 'm', 'LineWidth', 2);
plot(w,abs(evalTF(NTF4,z)), 'g', 'LineWidth', 2);
plot(w,abs(evalTF(NTF5,z)), 'y', 'LineWidth', 2);
xlabel('\omega / \pi'), ylabel('Magnitude');
legend('\omega_{3dB}=0.2', '\omega_{3dB}=0.3', '\omega_{3dB}=0.4',...
    '\omega_{3dB}=0.5', '\omega_{3dB}=0.6', 'Location', 'NorthWest');
title('NTF(z), Realizable Butterworth Response');

figure(3);
plotPZ(NTF2, 'r', 10);hold on;
plotPZ(NTF3, 'm', 10);
plotPZ(NTF4, 'g', 10);
plotPZ(NTF5, 'y', 10);
plotPZ(NTF1, 'b', 10); 
title('NTF(z) with Butterworth Response');