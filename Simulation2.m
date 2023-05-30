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
r_spool = 0.004; %m

g = 0.05;

%CALCULATED PARAMETERS
k_c = 3/c*(T_pre+0.5*(a/c)^2*T_pre);
k = 3*EI_pipe/L_pipe^3;
m_eff = m_payload + 33/140*m_pipe;
w_nat_calc = sqrt((k+k_c)/m_eff);
damp_calc = 0.1487/(2*w_nat_calc);
b_calc = 2*damp_calc*w_nat_calc*m_eff;
k_spring = g*(2*pi/360)*(k+k_c)/(3/(2*L_pipe)*(a/b)*r_spool*(2*pi/360));

T = [1 1 1]; %Tension vector

x = [0 0 0 0]; %State vector

A = [-b_calc/m_eff 0 -(k+k_c)/m_eff 0;
    0 -b_calc/m_eff 0 -(k+k_c)/m_eff;
    1 0 0 0;
    0 1 0 0];

B = g*(k+k_c)*(-3/2*L_pipe)*(a/b)*... %mistake
    [-1/m_eff 1/2/m_eff 1/2/m_eff;
    0 -sqrt(3)/2/m_eff sqrt(3)/2/m_eff;
    0 0 0;
    0 0 0];

C = [0 0 1 0;
    0 0 0 1];

D = zeros(2,3);

sys = ss(A,B,C,D);

figure(1)
opt = stepDataOptions;
opt.StepAmplitude = 90; 
step(sys,t(end),opt)

% hold on; plot(t, -pitchHighPass,'Color',[1 0 0]); title('Euler Angle Data'); xlabel('Time (sec)'),ylabel('Euler Angle (Deg)'), grid

eig(A)
%P = [-0.135+0.138i -0.135-0.138i -0.135+0.138i -0.135-0.138i];
P = [-0.14+0.123i -0.14-0.123i -0.14+0.123i -0.14-0.123i];
K = place(A, B, P);
A_cl = A - B*K;
eig(A_cl)
sys_cl = ss(A_cl,B,C,D);
Kdc = dcgain(sys_cl);
sys_cl_scaled = ss(A_cl,B/Kdc(1)/90,C,D);

figure(2)
step(sys_cl_scaled,t(end),opt)



