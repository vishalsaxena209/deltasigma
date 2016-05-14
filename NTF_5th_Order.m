%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Fifth Order NTF Synthesis
% Vishal Saxena, BSU
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
clear all; clc; close all;

%% User params
order = 5;  % Order of the NTF
OSR = 32;   % OSR
nLev = 16;  % Number of quantizer levels
% 16 levels good for stability and low opamp slew rate.
OBG  = 3;
% Out of band gain of 3 -> slightly aggressive but ok.
opt = 1;    % Optimize NTF zeros for opt=1

%% Synthesize NTF
NTF = synthesizeNTF(order, OSR, opt, OBG, 0);

% Plot NTF Response
figure();
w = [linspace(0,0.75/OSR,100) linspace(0.75/OSR,1,100)]; % Normalized w
z = exp(i*w*pi);
plot(w,abs(evalTF(NTF,z)), 'b', 'LineWidth', 2);
grid on; hold on;
legend('NTF(z)');
xlabel('\omega / \pi'), ylabel('Magnitude');

%break;

%% Find MSA using Risbo's method

u = 0:(nLev-1)/1e6:(nLev-1); % Slow ramp input
% Use random initial states, randn(order,1)
[v,xn,xmax,y] = simulateDSM(u,NTF,nLev, randn(order,1)); % Simulate DSM

% Estimate MSA using an arbitrary threshold on y
inst_index = min(find(y>150)); % instability index
MSA = (0.9/(nLev-1))*u(inst_index);  % 90% of the input where y blows up

%% Simulate in time-domain with an input with MSA
Nfft = 2^13;
tone_bin = max(primes(floor(Nfft/(4*OSR))));    % Input tone at fs/(4*OSR)
t = [0:Nfft-1];

u1 = 1.0*MSA*(nLev-1)*sin(2*pi*tone_bin/Nfft*t); % Amplitude = MSA 
% Increase the input amplitude to observe the effects of 
% modulator instability

[v1,xn1,xmax1,y1] = simulateDSM(u1,NTF,nLev, randn(order,1)); % Simulate DSM

figure()
subplot(2,1,1)
n=1:800;
plot(t(n), u1(n), 'r');
hold on; grid on;
stairs(t(n), v1(n), 'b');
legend('u','v');
title('DSM time-domain Simulation');

subplot(2,1,2)
stairs(t(n), xn1(1,n), 'g');
hold on; grid on;
stairs(t(n), xn1(2,n), 'b');
stairs(t(n), y1(n), 'r');
legend('x1','x2','y=x3');
title('Loop-filter States');

%break;

%% Plot the Spectrum
% spec = fft(v1)/(Nfft*(nLev-1)/4); % Rect window for demo purpose
spec = fft(v1.*ds_hann(Nfft))/(Nfft*(nLev-1)/4);
snr = calculateSNR(spec(1:ceil(Nfft/(2*OSR))+1), tone_bin);
Neff = (snr-1.76)/6.02;

w = linspace(0, 1, Nfft/2+1); % angular frequency axis

figure()
plot(w, dbv(spec(1:Nfft/2+1)), 'b')
hold on; grid on;
text_handle = text(0.6,-160, ...
    sprintf('SNDR = %4.1f dB \nENOB = %2.2f bits \n@OSR = %2.0f',snr,Neff,OSR),...
    'FontWeight','bold','EdgeColor','red','LineWidth',3,'BackgroundColor',[1 1 1],'Margin',10);
xlabel('\omega / \pi'), ylabel('dBFS'); 
title ('Modulator Output Spectrum'); 

%% EOF

