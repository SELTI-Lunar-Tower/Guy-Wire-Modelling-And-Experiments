% Matlab Script to Find Angle of Correction for IMU Coordinates
%
%           Version 1.0 (04/29/2023) H.C. & V.P.
%
clear; clc; close all

% load data from a motor 1 step response (oscillation expected to be mostly in pitch)
load("step_400mstp-motor1-t0_0N-trial3")
timeLims = [5,35]; %section of data used for correction

% find indices of section used for data correction
i = timeLims(1) < data(2:end,1) & timeLims(2) > data(2:end,1);
t = data(i);

% plot the current data
pitch = data(2:end,8); pitchSample = pitch(i); pitchSample = pitchSample - mean(pitchSample);
roll = data(2:end,9); rollSample = roll(i); rollSample = rollSample - mean(rollSample);
subplot(1,2,1); hold on
plot(t,pitchSample)
plot(t,rollSample)
xlabel("Time (s)"); ylabel("Angle (Degrees)")
legend("Pitch","Roll")

% find the correction angle
headingRatio = mean(pitchSample./rollSample);
correctionAngle = -atand(headingRatio);
disp("The correction angle is "+num2str(correctionAngle))

% apply the coordinate rotation and plot the corrected data
pitchNew = rollSample*cosd(correctionAngle) - pitchSample*sind(correctionAngle);
rollNew = rollSample*sind(correctionAngle) + pitchSample*cosd(correctionAngle);
subplot(1,2,2); hold on
plot(t,pitchNew)
plot(t,rollNew)
xlabel("Time (s)"); ylabel("Angle (Degrees)")
legend("Corrected Pitch","Corrected Roll")

%test = mean(sqrt(pitchSample.^2 + rollSample.^2) - sqrt(pitchNew.^2 + rollNew.^2));
