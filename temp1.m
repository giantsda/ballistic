re=myfun(0.3)
 
x0 = [0.3];
options = optimset('PlotFcns',@optimplotfval);
x = fminsearch(@myfun,x0,options)


function re=myfun(BC)
load ('siacci.mat')
%% Input Parameters
% BC=0.25;
V0=1088.45;
distance=300;
pi=3.14159265358;
theta=0.174510*pi/180;
Vwind=10;
thetaWind=45*pi/180;
DragFunction="G1";
scopeOffSet=1.8017;
%% Initilize
dt=1/V0/0.5;
maxTimeStep=50000;
g=32.1740;% ft/s2
Vx=V0*cos(theta);
Vy=V0*sin(theta);
Vz=0;
Wx=Vwind*cos(thetaWind);
Wz=Vwind*sin(thetaWind);
Wy=0;
Vxs=zeros(maxTimeStep,1);
Vys=zeros(maxTimeStep,1);
Vzs=zeros(maxTimeStep,1);
Position=zeros(maxTimeStep,3);
Results=zeros(maxTimeStep,9);
i=1;
x=0;
y=-scopeOffSet/12;
z=0;
t=0;
%% Eluer
while(x/3<distance)
    V=sqrt(Vx^2+Vy^2+Vz^2);
    Cd=getDrag(V,DragFunction,siacci)/BC;
    Vx=Vx-(Cd*V*(Vx+Wx))*dt; %eqn 8.106-8.108 from<<Ballistics Theory and Design of Guns and Ammunition>>
    Vy=Vy-(Cd*V*(Vy+Wy)+g)*dt;
    Vz=Vz-Cd*V*(Vz-Wz)*dt;
    x=x+Vx*dt;
    y=y+Vy*dt;
    z=z+Vz*dt;
    Vxs(i)=Vx;
    Vys(i)=Vy;
    Vzs(i)=Vz;
    Position(i,:)=[x y z];
    
    t=t+dt;
    xIntercept=x/3;
    yIntercept=y*12;
    elevation=-RadtoMil (atan (y / x));
    windage=RadtoMil (atan (z / x));
    Results(i,:)=[t,xIntercept,yIntercept,elevation,windage,Vx,Vy,Vz,V];
    i=i+1;
    if Vx<0
        break;
    end
end
Position(i:end,:)=[];
Results(i:end,:)=[];
plot(Position(:,1),Position(:,2));
hold on;
re=abs(Results(end,6)-774.9);
end