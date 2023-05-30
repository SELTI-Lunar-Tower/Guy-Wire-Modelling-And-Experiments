% Matlab Script to Rotate Principal Axes of Euler Angle Data
%
%           Version 1.0 (04/30/2023) H.C. & V.P.
%
clear; clc; close all

fileName = "step_400mstp-motor1-t0_0N-trial1"; % name of .mat data file to be corrected
correctionAngle = -61.58; % manually calculated avg of correction angles from CorrectionAngle.m

load(fileName) 

% plot the old data
pitchOld = data(2:end,8); 
rollOld = data(2:end,9);

% apply the principle axes rotation
pitchCorrected = rollOld*cosd(correctionAngle) - pitchOld*sind(correctionAngle);
rollCorrected = rollOld*sind(correctionAngle) + pitchOld*cosd(correctionAngle);

data(2:end,8) = pitchCorrected; 
data(2:end,9) = rollCorrected;

% save corrected data to a csv
csvTable = array2table(data);
csvTable.Properties.VariableNames(1:length(data(1,:))) = {'Time (s)',...
    'Setpoint (deg)','Motor Position (deg)','Tension 1 (N)',...
    'Tension 2 (N)','Tension 3 (N)','Heading (deg)','Pitch (deg)',...
    'Roll (deg)','Quaternion W','Quaternion X','Quaternion Y',...
    'Quaternion Z','Gravity X','Gravity Y','Gravity Z'};
writetable(csvTable,fileName+'-Corrected.csv')

% save workspace data
save(fileName+'-Corrected.mat',"data")

% recreate figure and save it
subplot(3,1,1); hold on
plot(data(:,1), data(:,2),'Color',[1 0 0]) 
plot(data(:,1), data(:,3),'Color',[0 0 1]) 
title('Stepper Data')
xlabel('Time (sec)'),ylabel('Position (Degrees)'), grid
legend('Setpoint (deg)','Motor Position (deg)');
subplot(3,1,2); hold on
plot(data(:,1), data(:,4),'Color',[1 0 0])
plot(data(:,1), data(:,5),'Color',[0 1 0])
plot(data(:,1), data(:,6),'Color',[0 0 1])
title('Tension Data')
xlabel('Time (sec)'),ylabel('Tension (N)'), grid
legend('Tension 1 (N)','Tension 2 (N)','Tension 3 (N)');
subplot(3,1,3); hold on
plot(data(:,1), data(:,8),'Color',[1 0 0])
plot(data(:,1), data(:,9),'Color',[0 0 1])
title('Euler Angle Data')
xlabel('Time (sec)'),ylabel('Euler Angles (Deg)'), grid
legend('Pitch (deg)','Roll (deg)');
saveas(gcf,fileName+'-Corrected')

disp("Saved new csv, mat data, and figure as renamed files.")
