clc; clear; close all

sp = serialport("COM3",115200);

dataPlot = figure(1);
dataPlot.Name = 'Serial Data Plot';
ax = axes(dataPlot);
ax.Units = 'normalized';
ax.Position = [0.125 0.15 0.775 0.775];
button = uicontrol(dataPlot,'Style','pushbutton');
button.String = 'STOP';
button.BackgroundColor = [1 0 0];
button.ForegroundColor = [1 1 1];
button.FontWeight = 'bold';
button.UserData = 0;

xlabel('Time (sec)'), grid

h2 = animatedline ('Color',[0 1 0]); %Set Point
h3 = animatedline ('Color',[1 0 0]); %Tension 1
h4 = animatedline ('Color',[1 0.5 0]); %Tension 2
h5 = animatedline ('Color',[1 0 0.5]); %Tension 3
h6 = animatedline ('Color',[0 0 1]); %Euler Angle X
h7 = animatedline ('Color',[0.3 0.3 1]); %Euler Angle Y
h8 = animatedline ('Color',[0.9 0.3 0]); %Acceleration X
h9 = animatedline ('Color',[0.9 0.4 0.1]); %Acceleration Y

Labels = {'Set Point','Tension 1','Tension 2',...
    'Tension 3','Euler Angle X','Euler Angle Y','Acceleration X',...
    'Acceleration Y'};
legend(Labels);

while(button.UserData == 0)

    data_char{i} = readline(sp);
    
    if(~strcmp(data_char{i},''))
        data(i,:) = str2num(data_char{i});
    else
        break;
    end
    
    addpoints(h2, data(i,1), data(i,2));
    addpoints(h3, data(i,1), data(i,3));
    addpoints(h4, data(i,1), data(i,4));
    addpoints(h5, data(i,1), data(i,5));
    addpoints(h6, data(i,1), data(i,6));
    addpoints(h7, data(i,1), data(i,7));
    addpoints(h8, data(i,1), data(i,8));
    addpoints(h9, data(i,1), data(i,9));
    legend(Labels);

    drawnow limitrate
    
    i = i+1;
end

% figure(1)
% plot(data(:,1), data(:,2),'g', data(:,1), data(:,3),'b', data(:,1), data(:,4),'r')
% title('Serial Data')
% xlabel('Time (sec)'),ylabel('Values'), grid
% legend(Labels);

% dt = mean(diff(data(:,1)));
% disp(['Sampling period (sec) = ', num2str(dt)])
% disp(['Sampling frequency (Hz) = ', num2str(1/dt)])

% To disconnect the serial port object from the serial port
delete(s1);
clear s1;