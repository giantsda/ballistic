load ('siacci.mat')
%% Input Parameters
Altitude = 4917;
Barometer = 24.97;
Temperature = 52.34;
RelativeHumidity = 31;
  
BC=0.1512;
modifiedBC=atmosphericCorrection (BC,   Altitude,   Barometer,  Temperature,   RelativeHumidity);

MV=1088.45;
zeroDistance=25;
distance=300;
pi=3.14159265358;
theta=0.174510*pi/180;
Vwind=10;
thetaWind=90*pi/180;
DragFunction="G1";
scopeOffSet=1.8017;
distance=300;
%% get shooting angle
theta=getShootingAngle(siacci,MV,modifiedBC,zeroDistance,Vwind,thetaWind,"G1",scopeOffSet);
%% solve trajectory
Results=solveTrajectory(siacci,MV,modifiedBC,theta,Vwind,thetaWind,DragFunction,scopeOffSet,distance);
plot(Results(:,1),Results(:,4));
legend('trajectory'); 

 