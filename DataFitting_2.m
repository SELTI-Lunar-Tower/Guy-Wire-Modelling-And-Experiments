clear; clc; close all

% fileName = "step_200mstp-motor1-t0_1N-PassiveResistance_1N-trial1-Corrected"; % name of .mat data file
fileName = "step_400mstp-motor1-t0_1N-trial1-Corrected"; % name of .mat data file
load(fileName) 
i = 3.5 < data(2:end,1);
t = data(i); t = t - t(1);
dt = mean(diff(data(:,1)));
setpoint = data(2:end,2); 
setpoint = setpoint(i); %only include values after the step
pitch = data(2:end,8); 
pitch0 = mean(pitch((2.9>data(2:end,1)))); %find the IC
pitch = pitch(i)-pitch0; %only include values after the step and subtract the nonzero IC

% FFT for finding dominant frequency
% pitchM = pitch-mean(pitch);  
pitchM = detrend(pitch);  
Fv = linspace(0, 1, fix(length(t)/2)+1)*1/(dt*2);
Iv = 1:numel(Fv);
FFT = fft(pitchM)/length(t);
[pks,locs] = findpeaks(abs(FFT(Iv))*2, 'MinPeakHeight',0.2);
fpass = Fv(locs(Fv(locs)>0.3 & Fv(locs)<0.6)); % damped frequency in Hz
%figure(1); 
%plot(Fv, abs(FFT(Iv))*2)

pitchHighPass = highpass(pitch,fpass,1/dt) + mean(pitch);

% figure(2); hold on
% plot(t, pitch,'Color',[1 0 0]) 
% plot(t, pitchHighPass,'Color',[0 0 1])

zeta = 0.015;   %damping ratio
omega_n = 3.005;   % natural frequency rad/s
Kdc = -4.3;
sys = tf([Kdc*omega_n^2],[1 2*zeta*omega_n omega_n^2])
opt = stepDataOptions;
opt.InputOffset = 0;
opt.StepAmplitude = 1;
[Y, T] = step(sys,t(end),opt);

set(0, 'DefaultTextInterpreter', 'none')
set(0, 'DefaultLegendInterpreter', 'none')
set(0, 'DefaultAxesTickLabelInterpreter', 'none')

figure(3)
plot(t, pitchHighPass, T, Y)
title(['Pitch Angle Comparison '], fileName)
xlabel('Time (sec)'),ylabel('Euler Angles (Deg)'), grid
legend('Actual corrected','Simulated');

