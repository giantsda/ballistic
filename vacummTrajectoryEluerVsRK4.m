
iterations=[1,10,100,1000,10000,100000,1000000];
for i=1:length(iterations)
    errors(i)=myfun(iterations(i),'Eluer');
end
loglog(iterations, errors,'*-');
hold on;
for i=1:length(iterations)
    errors(i)=myfun(iterations(i),'RK4');
end
loglog(iterations, errors,'*-');
xlabel('Number of iterations');
ylabel('error')
legend('Eluer','RK4');

function error=myfun(timeStep,method)
V0=1300;
pi=3.14159265358;
theta=1*pi/180;
Vx0=V0*cos(theta);
Vy0=V0*sin(theta);
t=0;
tEnd=1;
x=0;
y=0;
% timeStep=50000;
dt=tEnd/timeStep;

g=32.1740;% ft/s2
Vxs=zeros(timeStep,1);
Vys=zeros(timeStep,1);
Position=zeros(timeStep,2);

Vx=Vx0;
Vy=Vy0;

if (strcmp(method,'Eluer'))
    %% Eluer
    for i=1:timeStep
        %     Vx=Vx0;
        Vx=Vx-0;
        Vy=Vy-g*dt;
        dx=Vx0*dt;
        dy=Vy*dt;
        x=x+dx;
        y=y+dy;
        Vxs(i)=Vx;
        Vys(i)=Vy;
        Position(i,:)=[x y];
    end
end


if (strcmp(method,'RK4'))
    %% RK4
    for i=1:timeStep
        %     Vx=Vx-0;
        %     Vy=Vy-g*dt;
        % for x
        k1=dt*Vx;
        k2=dt*Vx;
        k3=dt*Vx;
        k4=dt*Vx;
        x=x+1/6*k1+1/3*k2+1/3*k3+1/6*k4;
        % for y
        k1=dt*Vy;
        k2=dt*(Vy-g*0.5*dt);
        k3=dt*(Vy-g*0.5*dt);
        k4=dt*(Vy-g*dt);
        y=y+1/6*k1+1/3*k2+1/3*k3+1/6*k4;
        Vy=Vy-g*dt;
        Vxs(i)=Vx;
        Vys(i)=Vy;
        Position(i,:)=[x y];
    end
end


% y
% V0*cos(theta)*1
shouldBeY=V0*sin(theta)*tEnd-0.5*g*tEnd*tEnd;
% plot(Vys);
error=abs(shouldBeY-y);
% plot(Position(:,1),Position(:,2));
% hold on;
end

