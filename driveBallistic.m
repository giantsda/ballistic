load ('siacci.mat')
%% Input Parameters
BC=0.1512;
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
theta=getShootingAngle(siacci,MV,BC,zeroDistance,Vwind,thetaWind,"G1",scopeOffSet);
%% solve trajectory
Results=solveTrajectory(siacci,MV,BC,theta,Vwind,thetaWind,DragFunction,scopeOffSet,distance);

plot(Results(:,1),Results(:,4));
legend('trajectory'); 

 