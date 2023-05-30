clear; clc; close all

fileName = "step_200mstp-motor1-t0_1N-PassiveResistance_1N-trial1-Corrected"; % name of .mat data file
load(fileName) 
i = 5.5 < data(2:end,1);
t = data(i); t = t - t(1);
dt = mean(diff(data(:,1)));
setpoint = data(2:end,2); 
setpoint = setpoint(i); %only include values after the step
pitch = data(2:end,8); 
pitch0 = mean(pitch((2.9>data(2:end,1)))); %find the IC
pitch = pitch(i)-pitch0; %only include values after the step and subtract the nonzero IC

% % FFT for finding dominant frequency
% pitchM = pitch-mean(pitch);  
% Fv = linspace(0, 1, fix(length(t)/2)+1)*1/(dt*2);
% Iv = 1:numel(Fv);
% FFT = fft(pitchM)/length(t);
% [pks,locs] = findpeaks(abs(FFT(Iv))*2, 'MinPeakHeight',0.2);
% fpass = Fv(locs(Fv(locs)>0.3 & Fv(locs)<0.6)); % damped frequency in Hz
% figure(1); 
% plot(Fv, abs(FFT(Iv))*2)

fpass = 0.4941; %temporary
pitchHighPass = highpass(pitch,fpass,1/dt) + mean(pitch);

% figure(2); hold on
% plot(t, pitch,'Color',[1 0 0]) 
% plot(t, pitchHighPass,'Color',[0 0 1])

damp = 0.017;
natf = fpass*(2*pi)/sqrt(1-damp^2);
gain = 0.012;
sys = tf(gain*natf^2,[1 2*damp*natf natf^2]);
opt = stepDataOptions;
opt.InputOffset = 0;
opt.StepAmplitude = 90;
[step,t_step] = step(sys,t(end),opt);

figure(3); hold on
plot(t_step, step-mean(pitchHighPass)-mean(step),'Color',[0.5 0.5 1],'LineWidth',1.9)
plot(t, -pitchHighPass,'Color',[1 0 0],'LineWidth',0.8)
ylabel('Pitch (Degrees)')
xlabel('Time (sec)')
xlim([0 85])
legend("Simulation","Filtered Data")
set(gca,'fontsize', 12) 
f = gcf;
f.Position = [100 100 850 400];

% gain2 = 0.012;
% sys2 = tf(gain2*natf^2,[1 2*damp*natf natf^2]);
% opt2 = stepDataOptions;
% opt2.InputOffset = 0;
% opt2.StepAmplitude = 90;
% [step2,t_step2] = step(sys2,t(end),opt2);
% 
% figure(4); hold on
% plot(t, -pitchHighPass,'Color',[1 0 0])
% plot(t_step, step,'Color',[0.2 0.2 1])
% ylabel('Pitch (Degrees)')
% legend("Filtered Data","Simulation")
% set(gca,'fontsize', 12) 

% controlSystemDesigner(sys)
%sys