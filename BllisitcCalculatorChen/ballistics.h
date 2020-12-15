// GNU Ballistics Library
// Originally created by Derek Yates
// Now available free under the GNU GPL

#ifndef __lib_ballistics__
#define __lib_ballistics__
#define __BCOMP_MAXRANGE__ 50001
#define GRAVITY 32.1740000000
#define PI (3.1415926535897932)    

enum __DragFunctions
{
  G1 = 1, G2, G3, G4, G5, G6, G7, G8
};
#include <math.h>
#include <stdlib.h>

double**
Matcreate (int r, int c); // The elements in the rows are next to each other.

void
Matfree (double **A);

double
DegtoMOA (double deg); // Converts degrees to minutes of angle
double
DegtoRad (double deg); // Converts degrees to radians
double
MOAtoDeg (double moa); // Converts minutes of angle to degrees
double
MOAtoRad (double moa); // Converts minutes of angle to radians
double
RadtoDeg (double rad); // Converts radians to degrees
double
RadtoMOA (double rad); // Converts radiants to minutes of angle
double
RadtoMil (double rad); // convert rad to mrad

// A function to correct a "standard" Drag Coefficient for differing atmospheric conditions.
// Returns the corrected drag coefficient for supplied drag coefficient and atmospheric conditions.
double
AtmCorrect (double DragCoefficient, double Altitude, double Barometer,
	    double Temperature, double RelativeHumidity);
/* Arguments:
 DragCoefficient:  The coefficient of drag for a given projectile.
 Altitude:  The altitude above sea level in feet.  Standard altitude is 0 feet above sea level.
 Barometer:  The barometric pressure in inches of mercury (in Hg).
 This is not "absolute" pressure, it is the "standardized" pressure reported in the papers and news.
 Standard pressure is 29.53 in Hg.
 Temperature:  The temperature in Fahrenheit.  Standard temperature is 59 degrees.
 RelativeHumidity:  The relative humidity fraction.  Ranges from 0.00 to 1.00, with 0.50 being 50% relative humidity.
 Standard humidity is 78%

 Return Value:
 The function returns a ballistic coefficient, corrected for the supplied atmospheric conditions.
 */
double
getShootingAngle (double MV, double modifiedBC, double zeroDistance,
		  double windV, double windAngle, int DragFunction,
		  double scopeOffSet);

double
getDrag (double Velocity, int DragFunction);

int
solveTrajectory (double MV, double shootingAngle, double modifiedBC,
		 double windV, double windAngle, int DragFunction,
		 double scopeOffSet, double distance, double **Results);
int
getDopeCard (double plotStartRange, double plotInterval, double distance,
	     double **Results, double **interpolatedResults, int Nx);

void
printDppe (double **interpolatedResults, int NDope);

#endif

