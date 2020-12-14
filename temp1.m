Cd=getDrag(1100,"G7",siacci)
plot(1100,Cd,'o')

function Cd=getDrag(Velocity,DragFunction,siacci)
switch DragFunction
    case "G1"
        data=siacci.G1DragCurveData;
    case "G2"
        data=siacci.G2DragCurveData;
    case "G5"
        data=siacci.G5DragCurveData;
    case "G6"
        data=siacci.G6DragCurveData;
    case "G7"
        data=siacci.G7DragCurveData;
    case "G8"
        data=siacci.G8DragCurveData;
    case "Sphere"
        data=siacci.SphereDragCurveData;
end

x=data(:,1); % velocity
y=data(:,2); % Cd
X=data(:,3); % 2rd derivative
 
% plot(x,y,'*');
% hold on;
klo=1;
khi=length(x);
while ((khi-klo)>1)
    k=floor((khi+klo)/2);
    if (x(k)>Velocity)
        khi=k;
    else
        klo=k;
    end
end
h=x(khi)-x(klo);
if (h==0)
    error('spline_chen: Bad x input. x(%d)=x(%d)=%f',khi,klo,x(khi));
end
a=(x(khi)-Velocity)/h;
b=(Velocity-x(klo))/h;
Cd=a*y(klo)+b*y(khi)+((a*a*a-a)*X(klo)+(b*b*b-b)*X(khi))*h*h/6;
end