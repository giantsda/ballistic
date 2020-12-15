load ('siacci.mat');
%% Input Parameters
Altitude = 4917;
Barometer = 24.97;
Temperature = 52.34;
RelativeHumidity = 31;

MV=1088.45;
zeroDistance=25;
pi=3.14159265358;
Vwind=10;
thetaWind=90*pi/180;
DragFunction="G1";
scopeOffSet=1.8017;
distance=300;
parameters.MV=MV;
parameters.zeroDistance=zeroDistance;
parameters.Vwind=Vwind;
parameters.thetaWind=thetaWind;
parameters.DragFunction=DragFunction;
parameters.scopeOffSet=scopeOffSet;
parameters.distance=distance;
parameters.siacci=siacci;
parameters.Altitude=Altitude;
parameters.Barometer=Barometer;
parameters.Temperature=Temperature;
parameters.RelativeHumidity=RelativeHumidity;
 
range=[50, 75, 100, 125, 150, 175, 200, 300 ];
DOPE=[0.177, 0.96, 2.0, 3.0, 4.3, 5.8, 7.2, 13.38];
[BC, w_s]=adm (300, range, DOPE,parameters);
[~, index]=min(w_s(:,2));
BC=min(w_s(index,1))

%% use adm to calculate BC
%% get shooting angle
modifiedBC=atmosphericCorrection (BC,   Altitude,   Barometer,  Temperature,   RelativeHumidity);
theta=getShootingAngle(siacci,MV,modifiedBC,zeroDistance,Vwind,thetaWind,"G1",scopeOffSet);
%% solve trajectory
Results=solveTrajectory(siacci,MV,modifiedBC,theta,Vwind,thetaWind,DragFunction,scopeOffSet,distance);
vq = interp1(Results(:,1),Results,[5:5:300]);
fprintf("%-10s%-10s%-10s%-10s%-10s%-10s%-10s%-10s%-10s\n","range","elevation","windage","Drop","Vx","Vy","Vz","V","t");
fprintf("%-10.2f%-10.2f%-10.2f%-10.2f%-10.2f%-10.2f%-10.2f%-10.2f%-10.3f\n",vq.');



function [w w_s]=adm (iteration, range, DOPE,parameters)
w_s=zeros(iteration,2);
learning_rate = 0.01;
beta1 = 0.9;
beta2 = 0.999;
alpha = learning_rate;
epsilon = 10e-8;
g = 0;
g2 = 0;
beta1t = beta1;
beta2t = beta2;
w = 0.2;
delta = 0.000001;
 
for i=1:iteration
    i
    error = getError (w, range, DOPE, parameters);
    grad = (getError (w + delta, range, DOPE,parameters) - error) / delta;
    g = beta1 * g + (1 - beta1) * grad;
    g2 = beta2 * g2 + (1 - beta2) * grad * grad;
    beta1t = beta1t * beta1;
    beta2t = beta2t * beta2;
    alphat = alpha * sqrt (1 - beta2t) / (1 - beta1t);
    w = w - alphat * g / (sqrt (g2) + epsilon);
    w_s(i,:)=[w error];
    plot(w_s(1:i,2),'*-');
    hold on;
    pause(0);
end
end


function sumError=getError(BC,range,DOPE,parameters)
MV=parameters.MV;
zeroDistance=parameters.zeroDistance;
Vwind=parameters.Vwind;
thetaWind=parameters.thetaWind;
DragFunction=parameters.DragFunction;
scopeOffSet=parameters.scopeOffSet;
distance=parameters.distance;
siacci=parameters.siacci;
Altitude=parameters.Altitude;
Barometer=parameters.Barometer;
Temperature=parameters.Temperature;
RelativeHumidity=parameters.RelativeHumidity;

modifiedBC=atmosphericCorrection (BC,   Altitude,   Barometer,  Temperature,   RelativeHumidity);
 
theta = getShootingAngle(siacci,MV,modifiedBC,zeroDistance,Vwind,thetaWind,DragFunction,scopeOffSet);
Results=solveTrajectory(siacci,MV,modifiedBC,theta,Vwind,thetaWind,DragFunction,scopeOffSet,distance);
vq = interp1(Results(:,1),Results(:,2),range);
sumError=sum(abs(vq-DOPE));
end