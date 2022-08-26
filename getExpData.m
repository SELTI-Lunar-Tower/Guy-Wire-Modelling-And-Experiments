% INSTRUCTIONS
% Input: Excel file name
% Output: Time, load cell tension, and stepper motor angle

function [time,tension,theta] = getExpData(csvName)

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
time = time(~isnan(time))';
tension = data(:,2)*0.00981; % convert grams to newtons
tension = tension(~isnan(tension))';
theta = data(:,3)*(pi/100); % convert motor steps to radians
theta = theta(~isnan(theta))';
disp(time)
end




