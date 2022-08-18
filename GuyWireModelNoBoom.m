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
ks = 240; % spring constant of tension spring measured to be 301 [N/m]

% PLANT MODEL, STEP RESPONSE, IV and FV
G = A*R*Ee*ks*(eta*s+Ev)/(eta*(L*ks+A*Ee)*s+L*ks*(Ev+Ee)+A*Ev*Ee); % plant
figure(); step(pi*G,10)
% IV = pi*A*R*Ee*ks/(L*ks+A*Ee);
% FV = pi*(A*R*Ee*Ev*ks)/(L*ks*(Ee+Ev)+A*Ev*Ee);

% COMPARE EXPERIMENT DATA WITH MODEL
[time,tension,theta] = getExpData("GuyWireSysID-2022-08-10",-1,10); % t0 just after the step
hold on; plot(time,tension,'.g')

% ANALYTICAL TIME DOMAIN STEP RESPONSE
% a1 = (A*Ee^2*L*R*ks^2)/((L*ks + A*Ee)*(A*Ee*Ev + Ee*L*ks + Ev*L*ks));
% b1 = (A*Ee*Ev + Ee*L*ks + Ev*L*ks)/(eta*(L*ks + A*Ee));
% c = (A*Ee*Ev*R*ks)/(A*Ee*Ev + Ee*L*ks + Ev*L*ks);
% stepRes = @(amp,t) amp*(a1*exp(-b1*t)+c);
% time = 0:0.1:10;
% hold on; plot(time,stepRes(pi,time),'r')




