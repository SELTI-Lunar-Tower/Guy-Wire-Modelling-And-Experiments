%% Spreader Configuration Comparison (Analytical Analysis)
%The purpose of these calculations is to predict which rigging system
%configaturation will be most successful. The best configuration (predicted
%analytically and verified empirically) will be used in the tower version
%for which a rigging control system will be designed. Because the shape of
%the boom changes as it bends (asymmetric, meaning each guy wire has
%different dynamics), this analysis simplifies/generalizes each scenario by
%assuming that the boom is static, rigid, and remains in a straight, upright
%position. Also, because this is not a buckling analysis, the weight of the 
%boom and the payload are not considered. 
%Despite these assumptions, results should still indicate which
%configuration can control the boom's position most effectively. It is
%advantageous to have the ability to deliver a large horizontal force while
%minimizing vertical/axial forces that may cause buckling. 
clear; clc;

%Here "spreaders" refers to the boom attachment. Note that NCSU's study 
%refers to the base rigging system arms as "spreaders," which are simply
%called "rigging arms" here. The parameters L and S are consistent with
%NCSU's paper while others are only defined here (NCSU has not yet
%considered configurations with spreaders).
L = 11; %Tower height [m]
S = 0.5; %Horizonal distance between the tip of the rigging arms to where the guy wires connect to the boom [m]
d = 0.05; %Diameter defined by where the guy wires (springs) attach to the boom [m]
l = 0.44; %Length of one spreader arm from pulley to where guy wires connect [m]
h = 0.04; %Vertical distance between a spreader pulley and where the guy wire connects to the boom
theta = atan(S/L); %Angle between a guy wire and the boom without spreaders [rad]
alpha = atan(l/h); %Angle between a guy wire and the boom above spreaders [rad]
beta = atan((S-l)/(L-h)); %Angle between a guy wire and the boom below spreaders [rad]

T = 1; %Arbitrary guy wire tension [N]
%Note that NCSU's study refers to z as the horizontal coordinate and x as
%the vertical coordinate in their analysis. The coordinates are swapped
%here as this is our convention.

%Configuration A: No Spreaders
Fx_A = T*sin(theta); %Horizontal force exterted on the boom by a single guy wire in config A
Fz_A = -T*cos(theta); %Vertical force exterted on the boom by a single guy wire in config A
My_A = -(d/2)*T*cos(theta); %Moment exerted by a guy wire in config A

%Configuration B: Spreaders with pulleys, guy wires attached to the boom
Fx_B = T*sin(beta); %Horizontal force exterted on the boom by a single guy wire in config B
Fz_B = T*(2*cos(alpha)-cos(beta)); %Vertical force exterted on the boom by a single guy wire in config B
My_B = -h*T*sin(alpha)+l*T*(cos(alpha)-cos(beta)); %Moment exerted by a guy wire in config B

%Configuration C: Spreaders with guy wires attached to the ends
Fx_C = T*sin(beta); %Horizontal force exterted on the boom by a single guy wire in config C
Fz_C = -T*cos(beta); %Vertical force exterted on the boom by a single guy wire in config C
My_C = -l*T*cos(beta); %Moment exerted by a guy wire in config C

%Display Results (Direct comparisons for a given tension)
configLabels = ["A","B","C"];
disp("For a given tension...")
[Fx_max,Fx_ind] = max([Fx_A,Fx_B,Fx_C]);
disp("Configuration "+configLabels(Fx_ind)+" exerts the greatest horizontal force.")
[Fz_min,Fz_ind] = min(abs([Fz_A,Fz_B,Fz_C]));
disp("Configuration "+configLabels(Fz_ind)+" exerts the least axial force.")
[My_min,My_min_ind] = min(abs([My_A,My_B,My_C]));
[My_max,My_max_ind] = max(abs([My_A,My_B,My_C]));
disp("Configuration "+configLabels(My_min_ind)+" exerts the least moment, and configuration "+configLabels(My_max_ind)+" exerts the greatest moment.")

% %Comparing Configurations A and B for a given axial force 
% T_A = 1; %Arbitrary tension set for configuration A
% Fz = -T_A*cos(theta); %Axial force (set to be the same in both scenarios)
% T_B = Fz / (2*cos(alpha)-cos(beta)); %Solving for the corresponding tension for configuration B
% Fx_A_constT = T_A*sin(theta);
% Fx_B_constT = T_B*sin(beta);






