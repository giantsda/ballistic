load ('siacci.mat')
%% Input Parameters
BC= 0.1512;
V0=1088.45;
distance=300;
pi=3.14159265358;
theta=0.174510*pi/180;
Vwind=10;
thetaWind=90*pi/180;
DragFunction="G1";
scopeOffSet=1.8017;
%% Initilize
dt=1/V0/0.05;
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
% plot(Position(:,1),Position(:,2));
plot(Results(:,2),Results(:,3));

hold on;
% plot(a(:,1),a(:,2));

i=1;
t=0;
x=0;
y=-scopeOffSet/12;
z=0;
Vx=V0*cos(theta);
Vy=V0*sin(theta);
Vz=0;
Wx=Vwind*cos(thetaWind);
Wz=Vwind*sin(thetaWind);
Wy=0;
%% RK4
 
while(x/3<distance)
    V=sqrt(Vx^2+Vy^2+Vz^2);
    Cd=getDrag(V,DragFunction,siacci)/BC;
    % for Vx
    k1=dt*-(Cd*V*(Vx+Wx));
    k2=dt*-(Cd*V*(Vx+0.5*k1+Wx));
    k3=dt*-(Cd*V*(Vx+0.5*k2+Wx));
    k4=dt*-(Cd*V*(Vx+k3+Wx));
    Vx=Vx+1/6*k1+1/3*k2+1/3*k3+1/6*k4;
    % for Vy
    k1=dt*-(Cd*V*(Vy+Wy)+g);
    k2=dt*-(Cd*V*(Vy+0.5*k1+Wy)+g);
    k3=dt*-(Cd*V*(Vy+0.5*k2+Wy)+g);
    k4=dt*-(Cd*V*(Vy+k3+Wy)+g);
    Vy=Vy+1/6*k1+1/3*k2+1/3*k3+1/6*k4;
    % for Vz
    k1=dt*-Cd*V*(Vz-Wz);
    k2=dt*-Cd*V*(Vz+0.5*k1-Wz);
    k3=dt*-Cd*V*(Vz+0.5*k2-Wz);
    k4=dt*-Cd*V*(Vz+k3-Wz);
    Vz=Vz+1/6*k1+1/3*k2+1/3*k3+1/6*k4;
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
end
Position(i:end,:)=[];
Results(i:end,:)=[];
plot(Results(:,2),Results(:,3));
  
legend('Eluer','RK4');



