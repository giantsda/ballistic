V0=2800;
Cd=0.006;
pi=3.14159265358;
theta=0.2*pi/180;
Vx0=V0*cos(theta);
Vy0=V0*sin(theta);
t=0;
distance=600;
maxTimeStep=50000;
dt=1/V0/1;

g=32.1740;% ft/s2
Vxs=zeros(maxTimeStep,1);
Vys=zeros(maxTimeStep,1);
Position=zeros(maxTimeStep,2);

i=1;
x=0;
y=0;
Vx=Vx0;
Vy=Vy0;
%% Eluer
while(x<distance)
    V=sqrt(Vx^2+Vy^2);
    Vx=Vx-Cd*V*Vx*dt; %eqn 8.51-8.53 from<<Ballistics Theory and Design of Guns and Ammunition>> 
    Vy=Vy-Cd*V*Vy*dt-g*dt;
    x=x+Vx*dt;
    y=y+Vy*dt;
    Vxs(i)=Vx;
    Vys(i)=Vy;
    Position(i,:)=[x y];
    i=i+1;
end
plot(Position(1:i-1,1),Position(1:i-1,2));
hold on;