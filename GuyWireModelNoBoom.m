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
plotRiggingData("GuyWireSysID-2022-08-10",-1,60); % t0 just after the step

% PLANT MODEL AND STEP RESPONSE
G = A*R*Ee*k_eff*(eta*s+Ev)/(eta*(L*k_eff+A*Ee)*s+L*k_eff*(Ev+Ee)+A*Ev*Ee); % plant
hold on; step(pi*G,60,'g') % step response of half a revolution
legend("Tension [N]","Theta [-]","Plant Model")

% ANALYTICAL TIME DOMAIN STEP RESPONSE
% a1 = (A*Ee^2*L*R*k_eff^2)/((L*k_eff + A*Ee)*(A*Ee*Ev + Ee*L*k_eff + Ev*L*k_eff));
% b1 = (A*Ee*Ev + Ee*L*k_eff + Ev*L*k_eff)/(eta*(L*k_eff + A*Ee));
% c = (A*Ee*Ev*R*k_eff)/(A*Ee*Ev + Ee*L*k_eff + Ev*L*k_eff);
% stepRes = @(amp,t) amp*(a1*exp(-b1*t)+c);
% time = 0:0.1:10;
% hold on; plot(time,stepRes(pi,time),'r')
% timeConstant = 1/b1;




