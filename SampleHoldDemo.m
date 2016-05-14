
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Sample and Hold Demo
%  (c) Vishal Saxena
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; close all; clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% User defined parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fin = 3e6;      % 3MHz input sinusoid
Vp = 1;         % 1V amplitude
fs = 100e6;     % 100MHz sampling
Ts = 1/fs;      % Sampling Time   
T = Ts/2;       % S/H Pulse Width   
m = 10;         % Show sim for m sampling periods

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% My calcs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
F= fs*100;  % oversampling for discretization, 100 times of fs

delta_t = 1/F;   % dt   
max_t = 1e-6 - delta_t; % sim time = 1us
t = 0:delta_t:max_t;    % time vector

f_range = 1/delta_t;    % Frequency range    
delta_f = 1/max_t;      % df

startf = 0;
stopf = m*fs;   % Sim for 'm' sampling periods
startindex = floor(startf/delta_f)+1;   % Start freq index
stopindex = floor(stopf/delta_f)+1;     % Stop freq index

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generating Sample-and-Hold operation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Input signal
x = Vp*sin(2*pi*fin*t);

% Basic S/H pulse, h(t)
h = rectpuls(t, T*2);

% Repetition instances, matlab dependent parameter
d1 = 0:Ts:max_t;

% Sampling pulse stream, g(t)
g = pulstran(t,d1,h,F); 

% Repetition instances, matlab dependent parameter
d2 = [0:Ts:max_t; x(1:Ts/delta_t:max_t/delta_t)]';

% Generate sampled and held data stream, y(t)
y = pulstran(t,d2,h,F); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Time domain plots
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure;
plot(t, y);
hold;
plot(t, x, 'g');
grid on
title('S/H Output, y(t)');
xlabel('time (s)'), ylabel ('Volts');
legend('y(t)', 'g(t)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Frequency domain plots
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calculate the FFTs. I didnt bother about the proper scaling here.
% May need fixing

X = fft(x); % Vin(f)
H = fft(h); % P(f)
Y = fft(y); % Y(f)

X_dB = 20*log10(abs(X (startindex:stopindex)));
H_dB = 20*log10(abs(H (startindex:stopindex)));
Y_dB = 20*log10(abs(Y (startindex:stopindex)));

% Define display frequency range
f = [startf : delta_f: stopf];

figure;
plot(f,X_dB);
grid on
title('Input Signal Spectrum, X(f)');
xlabel('Hz'), ylabel ('dB');
legend('X(f)'); 
xlim([0 fs/2]);

figure;
plot(f,Y_dB);
hold;
plot(f,H_dB,'g');
grid on
title('S/H Output Spectrum, Y(f)');
xlabel('Hz'), ylabel ('dB');
legend('Y(f)','H(f)');
ylim([-100 100]);

%% EOF