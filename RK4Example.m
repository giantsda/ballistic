

myfun(10000,'Eluer');

iterations=[1,5,10,50,80,100,200,400,500,700];
y=[];
for i=1:length(iterations)
    y(i)=myfun(iterations(i),'Eluer');
end
loglog(iterations, abs(y-exp(0.5)),'*-');
hold on;
y=[];
for i=1:length(iterations)
    y(i)=myfun(iterations(i),'RK4');
end
loglog(iterations , abs(y-exp(0.5)),'*-');


function y=myfun(timeStep,method)
V0=1300;
pi=3.14159265358;
theta=1*pi/180;
Vx0=V0*cos(theta);
Vy0=V0*sin(theta);
t=0;
tEnd=1;
x=0;
y=1;
dt=tEnd/timeStep;
g=32.1740;% ft/s2
Position=zeros(timeStep,2);

t=0;
if (strcmp(method,'Eluer'))
    %% Eluer
    for i=1:timeStep
        %     Vx=Vx0;
        y=y+t*y*dt;
%         Vys(i)=Vy;
        Position(i,:)=[y];
        t=t+dt;
    end
end


if (strcmp(method,'RK4'))
    %% RK4
    for i=1:timeStep
 
        % for y
        k1=dt*y*t;
        k2=dt*(t+0.5*dt)*(y+0.5*k1);
        k3=dt*(t+0.5*dt)*(y+0.5*k2);
        k4=dt*(t+dt)*(y+k3);
        y=y+1/6*k1+1/3*k2+1/3*k3+1/6*k4;
        Position(i,:)=[x y];
        t=t+dt;
    end
end

shouldBeY=Vy0*tEnd-1/3*g*tEnd*tEnd*tEnd;
error=abs(exp(1.5)-y);
end

