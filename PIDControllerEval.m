clear; clc; close all;
s = tf('s');

% GUY WIRE PROPERTIES (KELVIN-VOIGT SLS)
%Eguy = 112e9; % Kevlar® 49 Aramid Fiber elastic modulus [Pa]
%Eguy = 172e9; % Honeywell Spectra® 1000 Fiber elastic modulus [Pa]
Eguy = 117e9; % Honeywell Spectra® 900 Fiber elastic modulus [Pa]
Ee = Eguy; % instantaneous elastic response, no viscous effects [Pa]
Ev = 90e9; % elastic part of Kelvin element [Pa]
eta = 65e10; % Kelvin dashpot viscousity [kg/s]
A = pi*(1e-4)^2; % guy wire cross sectional area [m^2]
R = 0.9e-2; % spindle radius including wire [m]
L = 1.98; % approximate length [m]

% TENSION SPRING PROPERTIES
k_s = 301; % [N/m]

% BOOM AND OPPOSING SPRING STIFFNESSES
k_boom = 1012; % (Improve this estimate and generalize to all lengths!) [N/m]
k_eff = 1/(1/k_boom+1/k_s); 

% PLOT EXPERIMENT DATA WITH MODEL
plotRiggingData("kp1ki50kd0",8.5,1.5); 

% PLANT MODEL
G = A*R*Ee*k_eff*(eta*s+Ev)/(eta*(L*k_eff+A*Ee)*s+L*k_eff*(Ev+Ee)+A*Ev*Ee); % plant

% PID CONTROLLER
kp = 1;
ki = 20;
kd = 0;
D = kp + ki/s + kd*s;

% PLOT MODEL STEP RESPONSE WITH EXPERIMENT
% hold on; step(1.5*pi*feedback(G*D,1),'g') % step response of 1.5 revolutions
% legend("Tension [N]","Theta [-]","Plant Model")


