#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include "ballistics.h"

using namespace std;
double Altitude, Barometer, Temperature, RelativeHumidity, MV, scopeOffSet,
    zeroDistance, windV, windAngle, distance;
int sizeOfDope, DragFunction;
double **Results;
double **interpolatedResults;

double
getError (double BC, double *range, double *DOPE);
double
adm (int interation, double *range, double *DOPE);

// double getError(double BC,int N,double* range, double* DOPE)
int
main ()
{
  double plotInterval = 1;
  double plotStartRange = 5;
  Altitude = 4917;
  Barometer = 24.97;
  Temperature = 52.34;
  RelativeHumidity = 31;
  MV = 1088.45;
  scopeOffSet = 1.8017;
  zeroDistance = 25;
  DragFunction = G1;
  windV = 10;
  windAngle = 90;
  distance = 300;
  double BC = 0.086033319420176;
  double range[] =
    { 50, 75, 100, 125, 150, 175, 200, 300 };
  double DOPE[] =
    { 0.177, 0.96, 2.0, 3.0, 4.3, 5.8, 7.2, 13.38 };

  int N1 = sizeof(range) / sizeof(range[0]);
  int N2 = sizeof(DOPE) / sizeof(DOPE[0]);
  if (N1 != N2)
    {
      printf ("size of range does not equal to the size of DOPE!\n");
      return 1;
    }
  else
    {
      sizeOfDope = N1;
    }

  // initialization
  Results = Matcreate (9, __BCOMP_MAXRANGE__);
  interpolatedResults = Matcreate (__BCOMP_MAXRANGE__, 9);

  BC = adm (300, range, DOPE);

//   calculation
  double modifiedBC = AtmCorrect (BC, Altitude, Barometer, Temperature,
				  RelativeHumidity);
  double theta = getShootingAngle (MV, modifiedBC, zeroDistance, windV,
				   windAngle, G1, scopeOffSet);

  int N = solveTrajectory (MV, theta, modifiedBC, windV, windAngle,
			   DragFunction, scopeOffSet, distance, Results);

//  get Dope  Card
  int NDope = getDopeCard (plotStartRange, plotInterval, distance, Results,
			   interpolatedResults, N);

  printDppe (interpolatedResults, NDope);

  Matfree (Results);
  Matfree (interpolatedResults);

  return 0;
}

double
adm (int interation, double *range, double *DOPE)
{
  double learning_rate, beta1, beta2, alpha, epsilon, g, g2, beta1t, beta2t, w,
      delta, error, grad, alphat;
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
//  FILE *f1 = fopen ("errorTrack.txt", "w");
  for (int i = 0; i < interation; i++)
    {
      error = getError (w, range, DOPE);
      grad = (getError (w + delta, range, DOPE) - error) / delta;
      g = beta1 * g + (1 - beta1) * grad;
      g2 = beta2 * g2 + (1 - beta2) * grad * grad;
      beta1t = beta1t * beta1;
      beta2t = beta2t * beta2;
      alphat = alpha * sqrt (1 - beta2t) / (1 - beta1t);
      w = w - alphat * g / (sqrt (g2) + epsilon);
//      fprintf (f1, "%d, %f, %f\n", i, w, error);
    }
//  fclose (f1);
  printf ("The BC is %2.16f\n", w);
  return w;
}

double
getError (double BC, double *range, double *DOPE)
{
  double modifiedBC = AtmCorrect (BC, Altitude, Barometer, Temperature,
				  RelativeHumidity);

  double theta = getShootingAngle (MV, modifiedBC, zeroDistance, windV,
				   windAngle, G1, scopeOffSet);
  int N = solveTrajectory (MV, theta, modifiedBC, windV, windAngle,
			   DragFunction, scopeOffSet, distance, Results);

  int i, j, k;
  double sumError = 0.;
  double elevationMil;

  for (i = 0; i < sizeOfDope; i++)
    {
      j = 1;
      //compare xp[i] and Results[0][0] to Results[0][Nx-1];
      int klo = 0;
      int khi = N - 1;
      while (khi - klo > 1)
	{
	  k = (khi + klo) >> 1;
	  if (Results[0][k] > range[i])
	    khi = k;
	  else
	    klo = k;
	}
      // interpolate for 8 fields.
      elevationMil = Results[j][klo]
	  + (range[i] - Results[0][klo]) / (Results[0][khi] - Results[0][klo])
	      * (Results[j][khi] - Results[j][klo]);
      sumError = sumError + fabs (DOPE[i] - elevationMil);
    }

  return sumError;
}

