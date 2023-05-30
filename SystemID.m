% MATLAB Script to Read and Plot Tinkerforge Data for System ID
%
%           Version 2.0 (04/08/2023) H.C. & V.P.
%
clear; clc; close all

expName = "step_200mstp-motor1-t0_0N-PassiveResistance_1N-trial3";
% define the input signal and set baseline tensions
signal = "step";
%signal = "chirp";
stepper_num = 1;
% tension_slack = 10; %tension of "slacked"/constant wires in grams
tension_0 = 0/9.8*1000; %baseline tension in grams
tension_margin = 2; % +/- margin for tension_0 in grams 
tension_max = 450; %grams

t_0 = 3; %time delay before signal (seconds)
if signal == "step"  
    amp = 200; %amplitude in microsteps (800 per rev)
elseif signal == "chirp"  
    amp = 200; %amplitude in microsteps (800 per rev)
    f0 = 0.01; %initial frequency (Hz)
    f1 = 1; %final frequency (Hz)
    t1 = 20; %duration (s)
    phi = 0; %SET SO THAT CHIRP IS A SINE SWEEP (COSINE BY DEFAULT)
else
end

import com.tinkerforge.IPConnection;
import com.tinkerforge.BrickletIMUV3;
import com.tinkerforge.BrickletLoadCellV2;
import com.tinkerforge.BrickletSilentStepperV2;

HOST = 'localhost';
PORT = 4223;
UIDimu = 'Zkd'; %IMU Bricklet 3.0
UIDlc1 = 'Ki6'; %Load Cell Bricklet 2.0
UIDlc2 = 'KiN'; %Load Cell Bricklet 2.0
UIDlc3 = 'KfN'; %Load Cell Bricklet 2.0
UIDss1 = "25GT"; %Silent Stepper Bricklet 2.0
UIDss2 = "21bk"; %Silent Stepper Bricklet 2.0
UIDss3 = "21df"; %Silent Stepper Bricklet 2.0

ipcon = IPConnection(); % Create IP connection
imu = handle(BrickletIMUV3(UIDimu, ipcon), 'CallbackProperties'); % Create device object
lc1 = handle(BrickletLoadCellV2(UIDlc1, ipcon), 'CallbackProperties'); % Create device object
lc2 = handle(BrickletLoadCellV2(UIDlc2, ipcon), 'CallbackProperties'); % Create device object
lc3 = handle(BrickletLoadCellV2(UIDlc3, ipcon), 'CallbackProperties'); % Create device object
ss1 = handle(BrickletSilentStepperV2(UIDss1, ipcon), 'CallbackProperties'); % Create device object
ss2 = handle(BrickletSilentStepperV2(UIDss2, ipcon), 'CallbackProperties'); % Create device object
ss3 = handle(BrickletSilentStepperV2(UIDss3, ipcon), 'CallbackProperties'); % Create device object
%define the tensioned wire
if stepper_num == 1
    ss_tensioned = ss1;
    ss_constant1 = ss2;
    ss_constant2 = ss3;
    lc_tensioned = lc1;
    lc_constant1 = lc2;
    lc_constant2 = lc3;
elseif stepper_num == 2
    ss_tensioned = ss2;
    ss_constant1 = ss3;
    ss_constant2 = ss1;
    lc_tensioned = lc2;
    lc_constant1 = lc3;
    lc_constant2 = lc1;
elseif stepper_num == 3
    ss_tensioned = ss3;
    ss_constant1 = ss1;
    ss_constant2 = ss2;
    lc_tensioned = lc3;
    lc_constant1 = lc1;
    lc_constant2 = lc2;
end

ipcon.connect(HOST, PORT); % Connect to brickd
% Don't use device before ipcon is connected

% modify data labels for the 3 signals here
Labels = {'Setpoint (deg)','Motor Position (deg)','Tension 1 (N)','Tension 2 (N)',...
    'Tension 3 (N)','Heading (deg)','Pitch (deg)','Roll (deg)'};

% create a STOP button on the figure window
hFig = figure(1);
hFig.Name = 'Serial Data Plot';
ax = axes(hFig);
ax.Units = 'normalized';
ax.Position = [0.125 0.15 0.775 0.775];
hButton = uicontrol(hFig,'Style','pushbutton');
hButton.String = 'STOP';
hButton.BackgroundColor = [1 0 0];
hButton.ForegroundColor = [1 1 1];
hButton.FontWeight = 'bold';
hButton.UserData = 0;

% here we define 3 data lines, add or substract lines if needed
h2 = animatedline('Color',[0 0 1]);
h3 = animatedline('Color',[0.1 0.1 1]);
h4 = animatedline('Color',[0 1 0]);
h5 = animatedline('Color',[0 0.7 0.2]);
h6 = animatedline('Color',[0.2 0.7 0]);
h7 = animatedline('Color',[0 0 0]);
h8 = animatedline('Color',[1 0 0]);
h9 = animatedline('Color',[0.7 0.4 0]);

title('Streaming Serial Data <Press the STOP button to end>')
xlabel('Time (sec)'),ylabel('Values'), grid
legend(Labels);

% set load cell rates to 80Hz
lc_tensioned.setConfiguration(BrickletLoadCellV2.RATE_80HZ,0)
lc_constant1.setConfiguration(BrickletLoadCellV2.RATE_80HZ,0)
lc_constant2.setConfiguration(BrickletLoadCellV2.RATE_80HZ,0)

% configure and enable stepper
ss_tensioned.setStepConfiguration(BrickletSilentStepperV2.STEP_RESOLUTION_4, ...
                            true); % 1/4 microsteps (800 steps/rev)
ss_tensioned.setMotorCurrent(1200); %rated current is 1.2 A
ss_tensioned.setMinimumVoltage(4);
ss_tensioned.setSpeedRamping(8000, 8000); %(accel,decel) steps/s^2
ss_tensioned.setEnabled(true);
% ss_constant1.setStepConfiguration(BrickletSilentStepperV2.STEP_RESOLUTION_4, ...
%                             true); % 1/4 microsteps (800 steps/rev)
% ss_constant1.setMotorCurrent(1200); %rated current is 1.2 A
% ss_constant1.setMinimumVoltage(4);
% ss_constant1.setSpeedRamping(8000, 8000); %(accel,decel) steps/s^2
% ss_constant1.setEnabled(true);
% ss_constant2.setStepConfiguration(BrickletSilentStepperV2.STEP_RESOLUTION_4, ...
%                             true); % 1/4 microsteps (800 steps/rev)
% ss_constant2.setMotorCurrent(1200); %rated current is 1.2 A
% ss_constant2.setMinimumVoltage(4);
% ss_constant2.setSpeedRamping(8000, 8000); %(accel,decel) steps/s^2
% ss_constant2.setEnabled(true);

% max velocity for slackening/pretensioning
ss_tensioned.setMaxVelocity(40); %microsteps/s
% ss_constant1.setMaxVelocity(40); %microsteps/s
% ss_constant2.setMaxVelocity(40); %microsteps/s

% % slacken all guy wires 
% while(lc_constant1.getWeight()>slack_tension || lc_constant2.getWeight()>slack_tension...
%         || lc_tensioned.getWeight()>slack_tension)
%     tension_constant1 = lc_constant1.getWeight();
%     tension_constant2 = lc_constant2.getWeight();
%     tension_tensioned = lc_tensioned.getWeight();
%     if tension_constant1>slack_tension
%         ss_constant1.setSteps(-4)
%     end
%     if tension_constant2>slack_tension
%         ss_constant2.setSteps(-4)
%     end
%     if tension_tensioned>slack_tension
%         ss_tensioned.setSteps(-4)
%     end
%     pause(0.05) %steppers can only move up to 1/10 rev/s
%     if (tension_constant1 < lc_constant1.getWeight() || tension_constant2 < lc_constant2.getWeight()...
%             || tension_tensioned < lc_tensioned.getWeight())
%         disp("Warning: Tension is increasing. Reverse steppers or spooling direction.")
%         quit
%     end
% end
% pause(10) %pause 10 seconds so it can settle
% % set baseline tensions
% while(lc_constant1.getWeight()>slack_tension || lc_constant2.getWeight()>slack_tension...
%         || lc_tensioned.getWeight()~=baseline_tension)
%     tension_constant1 = lc_constant1.getWeight();
%     tension_constant2 = lc_constant2.getWeight();
%     tension_tensioned = lc_tensioned.getWeight();
%     if tension_constant1>slack_tension
%         ss_constant1.setSteps(-4)
%     end
%     if tension_constant2>slack_tension
%         ss_constant2.setSteps(-4)
%     end
%     if tension_tensioned>baseline_tension
%         ss_tensioned.setSteps(-4)
%     elseif tension_tensioned<baseline_tension
%         ss_tensioned.setSteps(4)
%     else
%     end
% end
% pause(3)

%replacement for above pretension/slacking code
%for 1 stepper, others are fully slackened
while(lc_tensioned.getWeight()<=tension_0-tension_margin || ...
        lc_tensioned.getWeight()>=tension_0+tension_margin)
    tension_tensioned = lc_tensioned.getWeight();
    if tension_tensioned>tension_0+tension_margin
        ss_tensioned.driveBackward()
        pause(0.01)
        if tension_max <= lc_tensioned.getWeight()
            ss_tensioned.stop()
            disp("Warning: Max tension reached.")
            return
        end
    elseif tension_tensioned<tension_0-tension_margin
        ss_tensioned.driveForward
        pause(0.01)
    else
        break
    end
end
ss_tensioned.stop()
ss_tensioned.setCurrentPosition(0) %position 0 is where the baseline tension is
disp("Baseline position set...")
pause(10) %pause for tower to settle slightly

% max velocity for the input
ss_tensioned.setMaxVelocity(16000); %microsteps/s
% ss_constant1.setMaxVelocity(16000); %microsteps/s
% ss_constant2.setMaxVelocity(16000); %microsteps/s

t_start = tic;
i = 1;
% get data from the serial object till the STOP button is pressed
while ( hButton.UserData == 0 )
    drawnow limitrate
    hButton.Callback = ['hButton.UserData = 1;','disp(''Stopping data collection...'')'];
    i = i+1;
    
    % set stepper to input signal
    t = toc(t_start);
    if signal == "chirp" && t >= t_0 && t <= t1+t0
        setpoint = chirp(t-t0,f0,t1,f1,'linear',phi); 
    elseif signal == "step" && t >= t_0
        setpoint = amp;
    else
        setpoint = 0;
    end
    ss_tensioned.setTargetPosition(setpoint)

    eulerAngle = imu.getOrientation();
    quaternion = imu.getQuaternion();
    gravity = imu.getGravityVector();
    acceleration = imu.getLinearAcceleration();
    tension1 = lc1.getWeight()*9.8/1000;
%     tension2 = lc2.getWeight()*9.8/1000;
%     tension3 = lc3.getWeight()*9.8/1000;
    
    data(i,1) = toc(t_start);
    data(i,2) = setpoint*360/800; %Degrees
    data(i,3) = ss_tensioned.getCurrentPosition()*360/800; %Degrees
    data(i,4) = tension1; %Newtons
%     data(i,5) = tension2;
%     data(i,6) = tension3;
    data(i,7) = eulerAngle.heading/16.0; %Degrees
    data(i,8) = eulerAngle.pitch/16.0;
    data(i,9) = eulerAngle.roll/16.0;
    %values below this comment are not plotted but are saved in the csv
    data(i,10) = quaternion.w/16383.0;
    data(i,11) = quaternion.x/16383.0;
    data(i,12) = quaternion.y/16383.0;
    data(i,13) = quaternion.z/16383.0;
    data(i,14) = gravity.x/100.0; %Meters/Seconds^2
    data(i,15) = gravity.y/100.0;
    data(i,16) = gravity.z/100.0;
    
    addpoints(h2, data(i,1), data(i,2));
    addpoints(h3, data(i,1), data(i,3));
    addpoints(h4, data(i,1), data(i,4));
    addpoints(h5, data(i,1), data(i,5));
    addpoints(h6, data(i,1), data(i,6));
    addpoints(h7, data(i,1), data(i,7));
    addpoints(h8, data(i,1), data(i,8));
    addpoints(h9, data(i,1), data(i,9));
    legend(Labels);
end
ss_tensioned.setMaxVelocity(160);
ss_tensioned.setTargetPosition(-200); %unspool 1/4 turn to slacken
pause(3)
ss_tensioned.setEnabled(false); %disable motor

% drawnow;
fprintf(['*** Done. A total of ',num2str(i-1), ' datasets collected ***\n']);
disp(' ');


% re-plot the data once the data collection is done to get all figure features
close(figure(1))
figure(2)
subplot(3,1,1); hold on
plot(data(:,1), data(:,2),'Color',[1 0 0]) 
plot(data(:,1), data(:,3),'Color',[0 0 1]) 
title('Stepper Data')
xlabel('Time (sec)'),ylabel('Position (Degrees)'), grid
legend(Labels(1:2));
subplot(3,1,2); hold on
plot(data(:,1), data(:,4),'Color',[1 0 0])
plot(data(:,1), data(:,5),'Color',[0 1 0])
plot(data(:,1), data(:,6),'Color',[0 0 1])
title('Tension Data')
xlabel('Time (sec)'),ylabel('Tension (N)'), grid
legend(Labels(3:5));
subplot(3,1,3); hold on
plot(data(:,1), data(:,8),'Color',[1 0 0])
plot(data(:,1), data(:,9),'Color',[0 0 1])
title('Euler Angle Data')
xlabel('Time (sec)'),ylabel('Euler Angles (Deg)'), grid
legend(Labels(7:8));

dt = mean(diff(data(:,1)));
disp(['Sampling period (sec) = ', num2str(dt)])
disp(['Sampling frequency (Hz) = ', num2str(1/dt)])

% % save data to a csv
csvTable = array2table(data);
csvTable.Properties.VariableNames(1:length(data(1,:))) = ['Time (s)',Labels,...
    'Quaternion W','Quaternion X','Quaternion Y','Quaternion Z',...
    'Gravity X','Gravity Y','Gravity Z'];
writetable(csvTable,expName+'.csv')
% save workspace and figure
save(expName+'.mat',"data")
saveas(gcf,expName)
disp("Saved.")

% Disconnect
ipcon.disconnect();
