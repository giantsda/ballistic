function Results=solveTrajectory(siacci,MV,BC,theta,Vwind,thetaWind,DragFunction,scopeOffSet,distance)
V0=MV;

%% Initilize
pi=3.14159265358;
dt=1/V0/2;
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
    Results(i,:)=[xIntercept,elevation,windage,yIntercept,Vx,Vy,Vz,V,t];
    i=i+1;
end
Position(i:end,:)=[];
Results(i:end,:)=[];





