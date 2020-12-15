load ('siacci.mat')
%% Input Parameters
Altitude = 4917;
Barometer = 24.97;
Temperature = 52.34;
RelativeHumidity = 31;
  
BC=0.086033319420176;
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


modifiedBC=0.34466948931094837;
%% get shooting angle
theta=getShootingAngle(siacci,MV,modifiedBC,zeroDistance,Vwind,thetaWind,"G1",scopeOffSet);
%% solve trajectory
Results=solveTrajectory(siacci,MV,modifiedBC,theta,Vwind,thetaWind,DragFunction,scopeOffSet,distance);
vq = interp1(Results(:,1),Results,[5:5:300]); 
fprintf("%-10s%-10s%-10s%-10s%-10s%-10s%-10s%-10s%-10s\n","range","elevation","windage","Drop","Vx","Vy","Vz","V","t");
fprintf("%-10s%-10s%-10s%-10s%-10s%-10s%-10s%-10s%-10s\n","Yard","mrad","mrad","inch","fps","fps","fps","fps","second");
fprintf("%-10.5f%-10.1f%-10.1f%-10.2f%-10.2f%-10.2f%-10.2f%-10.2f%-10.3f\n",vq.');



plot(Results(:,1),Results(:,4));
legend('trajectory'); 

 