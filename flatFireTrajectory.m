V0=2800;
Cd=0.006;
pi=3.14159265358;
theta=0.2*pi/180;
Vx0=V0*cos(theta);
Vy0=V0*sin(theta);
t=0;
distance=600;
timeStep=50000;
dt=1/V0*10;

g=32.1740;% ft/s2
Vxs=zeros(timeStep,1);
Vys=zeros(timeStep,1);
Position=zeros(timeStep,2);

i=1;
x=0;
y=0;
Vx=Vx0;
Vy=Vy0;
%% Eluer
while(x<distance)
    Vx=Vx-Cd*Vx*Vx*dt; %eqn 8.51-8.53 from<<Ballistics Theory and Design of Guns and Ammunition>> 
    Vy=Vy-Cd*Vx*Vy*dt-g*dt;
    x=x+Vx*dt;
    y=y+Vy*dt;
    Vxs(i)=Vx;
    Vys(i)=Vy;
    Position(i,:)=[x y];
    i=i+1;
end
plot(Position(1:i-1,1),Position(1:i-1,2));
hold on;

i=1;
x=0;
y=0;
Vx=Vx0;
Vy=Vy0;
%% RK4
while(x<distance)
    % for Vx
    k1=dt*-Cd*Vx^2;
    k2=dt*-Cd*(Vx+0.5*k1)^2;
    k3=dt*-Cd*(Vx+0.5*k2)^2;
    k4=dt*-Cd*(Vx+k3)^2;
    Vx=Vx+1/6*k1+1/3*k2+1/3*k3+1/6*k4;
    % for Vy
    k1=dt*(-Cd*Vx*Vy-g);
    k2=dt*(-Cd*Vx*(Vy+0.5*k1)-g);
    k3=dt*(-Cd*Vx*(Vy+0.5*k2)-g);
    k4=dt*(-Cd*Vx*(Vy+k3)-g);
    Vy=Vy+1/6*k1+1/3*k2+1/3*k3+1/6*k4;
    x=x+Vx*dt;
    y=y+Vy*dt;
    Vxs(i)=Vx;
    Vys(i)=Vy;
    Position(i,:)=[x y];
    i=i+1;
end
plot(Position(1:i-1,1),Position(1:i-1,2));
 
x=linspace(0,600,1000);
y=0+x*tan(theta)-g/Vx0^2*1/4/Cd^2*(exp(2*Cd.*x)); % eqn 8.69 from<<Ballistics Theory and Design of Guns and Ammunition>>
%note there should be -x term, but it agress with numerical resutls better without this term.
plot(x,y)
legend('Eluer','RK4','analytical');



