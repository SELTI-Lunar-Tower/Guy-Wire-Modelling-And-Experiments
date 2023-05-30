clear; clc; close all

fileName = "step_200mstp-motor1-t0_1N-PassiveResistance_1N-trial1-Corrected"; % name of .mat data file
load(fileName) 
i = 0 < data(2:end,1) & 70 > data(2:end,1);
t = data(i); t = t - t(1);
dt = mean(diff(data(:,1)));
setpoint = data(2:end,2); 
setpoint = setpoint(i); %only include values after the step
pitch = -data(2:end,8); pitch = pitch(i);

%Raw Data Fig
figure(1)
plot(t, pitch,'Color',[1 0 0])
xlabel("Time (sec)")
ylabel("Pitch (Degrees)")
set(gca,'fontsize', 12) 

% pitch0 = mean(pitch((2.9>data(2:end,1)))); %find the IC
% pitch = pitch(i)-pitch0; %only include values after the step and subtract the nonzero IC
% 
% % FFT for finding dominant frequency
% pitchM = pitch-mean(pitch);  
% Fv = linspace(0, 1, fix(length(t)/2)+1)*1/(dt*2);
% Iv = 1:numel(Fv);
% FFT = fft(pitchM)/length(t);
% [pks,locs] = findpeaks(abs(FFT(Iv))*2, 'MinPeakHeight',0.2);
% fpass = Fv(locs(Fv(locs)>0.3 & Fv(locs)<0.6)); % damped frequency in Hz
% figure(2); 
% plot(Fv, abs(FFT(Iv))*2)
% 
% pitchHighPass = highpass(pitch,fpass,1/dt) + mean(pitch);

