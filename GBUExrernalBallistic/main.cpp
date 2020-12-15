#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include "ballistics.h"

using namespace std;
double Altitude, Barometer, Temperature, RelativeHumidity, MV, ScopeOffset,
    zeroYard;
int sizeOfDope;
double
getError (double BC, double *range, double *DOPE);
double
adm (int interation, double *range, double *DOPE);

// double getError(double BC,int N,double* range, double* DOPE)
int
main ()
{
  Altitude = 4917;
  Barometer = 24.97;
  Temperature = 52.34;
  RelativeHumidity = 31;
  MV = 1088.45;
  ScopeOffset = 1.8017;
  zeroYard = 25;

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

  double BC = adm (500, range, DOPE);

  double modifiedBC = AtmCorrect (BC, Altitude, Barometer, Temperature,
				  RelativeHumidity);

  double angle = ZeroAngle (G1, modifiedBC, MV, ScopeOffset, zeroYard, 0.);
  printf ("the shooting angle is %f\n", angle);
  printf ("# Range elevationMil   WindageMil   \n");
  double **solution = (double**) malloc (1);
  SolveAll (G1, modifiedBC, MV, ScopeOffset, 0, angle, 10, 90, solution);
  double *data = *solution;
  for (int i = 0; i < 304; i = i + 1)
    {
      printf ("%f ", data[i * 10 + 0]);
      printf ("%f ", data[i * 10 + 1]);
      printf ("%f ", data[i * 10 + 2] / 3.438);
      printf ("%f ", data[i * 10 + 5] / 3.438);
      printf ("%f ", data[i * 10 + 3]);
      printf ("%f ", data[i * 10 + 6]);
      printf ("\n");
    }

  FILE *fid = fopen ("Results.txt", "w");
  for (int i = 0; i < 304; i = i + 1)
    {
      fprintf (fid, "%f ", data[i * 10 + 0]);
      fprintf (fid, "%f ", data[i * 10 + 1]);
      fprintf (fid, "%f ", data[i * 10 + 2] / 3.438);
      fprintf (fid, "%f ", data[i * 10 + 5] / 3.438);
      fprintf (fid, "%f ", data[i * 10 + 3]);
      fprintf (fid, "%f ", data[i * 10 + 6]);
      fprintf (fid, "\n");
    }

  fclose (fid);
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
  // error_s=[];
  // w_s=[];
  FILE *f1 = fopen ("errorTrack.txt", "w");
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
      fprintf (f1, "%d, %f, %f\n", i, w, error);
      // w_s=[w_s w];
      // error_s=[error_s error];
    }
  fclose (f1);
  printf ("The BC is %f\n", w);
  return w;
}

double
getError (double BC, double *range, double *DOPE)
{
  double modifiedBC = AtmCorrect (BC, Altitude, Barometer, Temperature,
				  RelativeHumidity);

  double angle = ZeroAngle (G1, modifiedBC, MV, ScopeOffset, zeroYard, 0.);
  double **solution = (double**) malloc (1);
  SolveAll (G1, modifiedBC, MV, ScopeOffset, 0, angle, 10, 90, solution);
  double *data = *solution;
  double sumError = 0.;
  double elevationMil;
  for (int i = 0; i < sizeOfDope; i++)
    {
      elevationMil = data[int (range[i]) * 10 + 2] / 3.438;
      sumError = sumError + abs (DOPE[i] - elevationMil);
    }
  return sumError;
}
