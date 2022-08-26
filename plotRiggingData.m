% INSTRUCTIONS
% Input: Excel file name, t0: csv time chosen to be t=0 of output, intervalLength: time interval length (tf in output)
% Output: Plot of of load cell tension and stepper motor angle with respect to time
% For a step input in motor angle, set t0=-1 to make t=0 of the output correspond to the time just after the step.
% To use all data points after t0, set intervalLength=-1.

function [] = plotRiggingData(csvName,t0,intervalLength)

% SPECIFY DESIRED TIME INTERVAL
[time0,tension0,theta0] = getExpData(csvName);

if t0 == -1
    [~,ind_i] = max(tension0); % useful for selecting time just after a step reponse
elseif t0>=0 && t0<time0(length(time0)) % if valid t_i is specified
    ind_i = find(time0>t0,1); % select initial time to be just after t_i
else
    disp("The initial time you entered is negative or exceeds the max time recorded in the csv")
    ind_i = 1;
end

if intervalLength == -1
    ind_f = length(time0); % include the last data point
elseif intervalLength>0 && intervalLength<=time0(length(time0)) && intervalLength>t0 % if valid t_f is specified
    ind_f = find(time0-time0(ind_i)>intervalLength,1); % choose time cap for last fitted point
else
    disp("The final time you entered is negative or exceeds the max time recorded in the csv")
    ind_f = length(time0);
end

time = time0(ind_i:ind_f)-time0(ind_i);
tension = tension0(ind_i:ind_f);
theta = theta0(ind_i:ind_f);

figure; plot(time,tension)
hold on; plot(time,theta)
xlabel("Time [s]")
legend("Tension [N]","Theta [-]")

end