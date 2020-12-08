timeStep=10000;
V0=2800;
pi=3.14159265358;
theta=0.2*pi/180;
Vx0=V0*cos(theta);
Vy0=V0*sin(theta);
t=0;
distance=600;
% tEnd=600/Vx0;
x=0;
y=0;
% timeStep=50000;
dt=1/V0;

g=32.1740;% ft/s2
Vxs=zeros(timeStep,1);
Vys=zeros(timeStep,1);
Position=zeros(timeStep,2);

Vx=Vx0;
Vy=Vy0;

i=1;
%% RK4
while(x<distance)
    %     Vx=Vx-0;
    %     Vy=Vy-g*dt;
    % for x
    k1=dt*Vx;
    k2=dt*Vx;
    k3=dt*Vx;
    k4=dt*Vx;
    x=x+1/6*k1+1/3*k2+1/3*k3+1/6*k4;
    % for y
    k1=dt*Vy;
    k2=dt*(Vy-g*0.5*dt);
    k3=dt*(Vy-g*0.5*dt);
    k4=dt*(Vy-g*dt);
    y=y+1/6*k1+1/3*k2+1/3*k3+1/6*k4;
    Vy=Vy-g*dt;
    Vxs(i)=Vx;
    Vys(i)=Vy;
    Position(i,:)=[x y];
    i=i+1;
end
y
% V0*cos(theta)*1
% shouldBeY=V0*sin(theta)*tEnd-0.5*g*tEnd*tEnd;
% plot(Vys);
% error=abs(shouldBeY-y);
plot(Position(1:i-1,1),Position(1:i-1,2));
hold on;


