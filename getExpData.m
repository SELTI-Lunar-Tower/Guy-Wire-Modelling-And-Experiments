% INSTRUCTIONS
% Input: Excel file name, t0: csv time chosen to be t=0 of output, intervalLength: time interval length (tf in output)
% Output: Time, load cell tension, and stepper motor angle
% For a step input in motor angle, set t0=-1 to make t=0 of the output correspond to the time just after the step.
% To use all data points after t0, set intervalLength=-1.

function [time0,tension0,theta0] = getExpData(csvName,t0,intervalLength)

% IMPORT DATA AND CONVERT UNITS
varTypes = {'double','double','double'};
opts = delimitedTextImportOptions('NumVariables',3,... % import options
    'VariableTypes',varTypes,...
    'ExtraColumnsRule','ignore',...
    'DataLines',2,...
    'EmptyLineRule','read',...
    'PreserveVariableNames',true);
currentfile = mfilename("fullpath");
[filepath,~,~] = fileparts(currentfile);
filename = fullfile(filepath,csvName); % update csv file name for new data
data = table2array(readtable(filename,opts));
time = data(:,1);
tension = data(:,2)*0.00981; % convert grams to newtons
theta = data(:,3)*(pi/100); % convert motor steps to radians

% SPECIFY DESIRED TIME INTERVAL 

if t0 == -1
    [~,ind_i] = max(tension); % useful for selecting time just after a step reponse 
elseif t0>=0 && t0<time(length(time)) % if valid t_i is specified
    ind_i = find(time>t0,1); % select initial time to be just after t_i
else
    disp("The initial time you entered is negative or exceeds the max time recorded in the csv")
    ind_i = 1;
end

if intervalLength == -1
    ind_f = length(time); % include the last data point
elseif intervalLength>0 && intervalLength<=time(length(time)) && intervalLength>t0 % if valid t_f is specified
    ind_f = find(time-time(ind_i)>intervalLength,1); % choose time cap for last fitted point
else
    disp("The final time you entered is negative or exceeds the max time recorded in the csv")
    ind_f = length(time);
end
time0 = time(ind_i:ind_f)-time(ind_i);
tension0 = tension(ind_i:ind_f);
theta0 = theta(ind_i:ind_f);

end




