clear; clc; close all

fileName = "step_200mstp-motor1-t0_1N-PassiveResistance_1N-trial1-Corrected"; % name of .mat data file
load(fileName) 
i = 9.5 < data(2:end,1);
t = data(i); t = t - t(1);
dt = mean(diff(data(:,1)));
setpoint = data(2:end,2); 
setpoint = setpoint(i); %only include values after the step
pitch = data(2:end,8); 
pitch0 = mean(pitch((2.9>data(2:end,1)))); %find the IC
pitch = pitch(i)-pitch0; %only include values after the step and subtract the nonzero IC
pitchHighPass = highpass(pitch,0.4941,1/dt) + mean(pitch);

w_nat_real = sqrt(9.599); %rad

%SYSTEM PARAMETERS
a = 0.17; %m
b = 1.5;
c = sqrt(1.5^2-0.17^2); %m
T_pre = 1; %N
m_payload = 1; %kg
m_pipe = 0.76; %kg
EI_pipe = 10.5; %Nm^2
L_pipe = 1.5; %m
k_spring = 300; %N/m
r_spool = 0.004; %m

%CALCULATED PARAMETERS
k_c = 3/c*(T_pre+0.5*(a/c)^2*T_pre);
k = 3*EI_pipe/L_pipe^3;
m_eff = m_payload + 33/140*m_pipe;
w_nat_calc = sqrt((k+k_c)/m_eff);
damp_calc = 0.1056/(2*w_nat_calc);
b_calc = 2*damp_calc*w_nat_calc*m_eff;
g = r_spool*k_spring*(a/b)*(3/(2*L_pipe))/(k_c+k);

T = [1 1 1]; %Tension vector

x = [0 0 0 0]; %State vector

A = [-b_calc/m_eff 0 -(k+k_c)/m_eff 0;
    0 -b_calc/m_eff 0 -(k+k_c)/m_eff;
    1 0 0 0;
    0 1 0 0];

B = g*(k+k_c)*(-3/(2*L_pipe))*(a/b)*...
    [-1/m_eff 1/2/m_eff 1/2/m_eff;
    0 -sqrt(3)/2/m_eff sqrt(3)/2/m_eff;
    0 0 0;
    0 0 0];

C = [0 0 1 0;
    0 0 0 1];

D = zeros(2,3);

sys = ss(A,B,C,D);

% figure(1)
opt = stepDataOptions;
opt.StepAmplitude = 90; 
% step(sys,t(end),opt)

% hold on; plot(t, -pitchHighPass,'Color',[1 0 0]); title('Euler Angle Data'); xlabel('Time (sec)'),ylabel('Euler Angle (Deg)'), grid

%eig(A)

fpass = 0.4941;
damp = 0.017;
natf = fpass*(2*pi)/sqrt(1-damp^2);
gain = 0.015;
sys_SISO = tf(gain*natf^2,[1 2*damp*natf natf^2]);

% s = tf('s');
% D_SISO = (20*(1+0.12*s+(0.5*s)^2))/s;
% P = pole((D_SISO*sys_SISO)/(1+D_SISO*sys_SISO));

%P = [-3.1+2.9i -3.1-2.9i -3.1+2.9i -3.1-2.9i]; %too fast
P = [-0.14+0.123i -0.14-0.123i -0.14+0.123i -0.14-0.123i]; %handwritten analysis
K = place(A, B, P);
A_cl = A - B*K;
% eig(A_cl)
sys_cl = ss(A_cl,B,C,D);
Kdc = dcgain(sys_cl);
sys_cl_scaled = ss(A_cl,B/Kdc(1)/90,C,D);

[stepResponses,t_step] = step(sys_cl_scaled,90,opt);

figure(2); hold on
plot(t(t>3 & t<73)-3, -pitchHighPass(t>3 & t<73),'Color',[0 0 0],'LineWidth',1);
plot(t_step,stepResponses(:,1,1),'Color',[1 0 0],'LineWidth',2)
plot(t_step,stepResponses(:,2,1),'Color',[0 0 1],'LineWidth',2)
legend("Open Loop Pitch Response","Pitch Simulation","Roll Simulation")
% legend("Pitch Simulation","Roll Simulation")
xlabel("Time (sec)")
ylabel("Angle (Degrees)")
xlim([0,90])
set(gca,'fontsize', 13) 

figure(3); hold on
plot(t_step,stepResponses(:,1,2),'Color',[1 0 0],'LineWidth',2)
plot(t_step,stepResponses(:,2,2),'Color',[0 0 1],'LineWidth',2)
legend("Pitch Simulation","Roll Simulation")
xlabel("Time (sec)")
ylabel("Angle (Degrees)")
set(gca,'fontsize', 11) 

figure(4); hold on
plot(t_step,stepResponses(:,1,3),'Color',[1 0 0],'LineWidth',2)
plot(t_step,stepResponses(:,2,3),'Color',[0 0 1],'LineWidth',2)
legend("Pitch Simulation","Roll Simulation")
xlabel("Time (sec)")
ylabel("Angle (Degrees)")
set(gca,'fontsize', 11) 

%pole((sys_SISO*D_SISO)/(1+sys_SISO*D_SISO))

