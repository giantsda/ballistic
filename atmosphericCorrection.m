% DragCoefficient=1;
% Altitude = 4917;
% Barometer = 24.97;
% Temperature = 52.34;
% RelativeHumidity = 31;
% Dc=AtmCorrect (  DragCoefficient,   Altitude,   Barometer,  Temperature,   RelativeHumidity)

function  modifiedBC=atmosphericCorrection (  DragCoefficient,   Altitude,   Barometer,  Temperature,   RelativeHumidity)
FA = calcFA (Altitude);
FT = calcFT (Temperature, Altitude);
FR = calcFR (Temperature, Barometer, RelativeHumidity);
FP = calcFP (Barometer);
CD = (FA * (1 + FT - FP) * FR);
modifiedBC= DragCoefficient * CD;
end

function FRH=calcFR (  Temperature,   Pressure,   RelativeHumidity)
VPw = 4e-6 *  Temperature^3 - 0.0004 * Temperature^2+ 0.0234 * Temperature - 0.2517;
FRH = 0.995* (Pressure / (Pressure - (0.3783) * (RelativeHumidity) * VPw));

end

function FP=calcFP (  Pressure)
Pstd = 29.53; % in-hg
FP = 0;
FP = (Pressure - Pstd) / (Pstd);
end

function FT=calcFT (  Temperature,   Altitude)
Tstd = -0.0036 * Altitude + 59;
FT = (Temperature - Tstd) / (459.6 + Tstd);
end

function FA=calcFA (  Altitude)
fa = 0;
fa = -4e-15*Altitude^ 3 + 4e-10 *Altitude^2 - 3e-5 * Altitude+ 1;
FA=(1 / fa);
end

