clear; clc; close all
s=tf('s');

tfinal = 3; % final time for simulations

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

p.T = [1 1 1]; %Tension vector

p.x = [0 0 0 0]; %State vector

p.A = [-b_calc/m_eff      0       -(k+k_c)/m_eff      0;
         0         -b_calc/m_eff     0        -(k+k_c)/m_eff;
         1              0            0              0;
         0              1            0              0];

p.B = g*(k+k_c)*(-3/(2*L_pipe))*(a/b)*...
    [-1/m_eff        1/2/m_eff          1/2/m_eff;
        0       -sqrt(3)/2/m_eff  sqrt(3)/2/m_eff;
        0               0               0;
        0               0               0];

p.C = [0 0 1 0;
    0 0 0 1];

p.D = zeros(2,3);


p.A = [ -bm/Jm  0       kt/Jm   0   0 ;
        0       -bf/Jf  0       0   0 ;
        -kt/L   0       -R/L    0   0 ;
        1       0       0       0   0 ;
        0       1       0       0   0   ] ;
p.BV = [ 0  0  1/L  0  0 ]' ;
p.BF = [ p.rm/Jm  p.rf/Jf  0  0  0 ]' ;

[t,x] = ode45(@(t,x) deriv(t,x,p),[0 tfinal],p.x);
plot(t,x(:,5),'r'); axis('auto');



figure(3) ; clf ; hold off ;
plot(t,x(:,4));grid on;
xlabel('time, sec');ylabel('\theta, rad');
title('Motor Position With Backlash Model');

% reconstruct the voltage signal v, and show it
v = zeros(size(t));
for i = 1:length(t)
    v(i) = getU(rdot(i),r(i),x(i,:),p);
end

figure(4); clf ; hold off ;
plot(t,v);grid on;
xlabel('time, sec');title('Applied Voltage With Backlash Model');
ylabel('v, Volts');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function  dx = deriv(t, x, p)
   A = [0 1; -2 3]; B = [0;1]; K = [-1 -1]; 
   u = K*x
   dx = A*x + B*u;
end