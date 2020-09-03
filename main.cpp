#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include "ballistics.h"
#include "NR_chen.h"

void
myfun (int n, double *BC, double *out, struct Parameters *P)
{
  double MV = P->MV;
  int DragFunction = P->DragFunction;
  double Altitude = P->Altitude;
  double Barometer = P->Barometer;
  double Temperature = P->Temperature;
  double RelativeHumidity = P->RelativeHumidity;
  double scopeOffset = P->scopeOffset;
  double zeroRange = P->zeroRange;

  double modifiedBC = AtmCorrect (BC[0], Altitude, Barometer, Temperature,
				  RelativeHumidity);

  double angle = ZeroAngle (DragFunction, modifiedBC, MV, scopeOffset,
			    zeroRange, 0.);
  double **solution = (double**) malloc (1);

  SolveAll (DragFunction, modifiedBC, MV, scopeOffset, 0, angle, 10, 90,
	    solution);
  double *data = *solution;

  out[0] = (GetMOA (data, 25)) / 3.438   + (GetMOA (data, 50)) / 3.438
      + ((GetMOA (data, 100) / 3.438 - 1.9)) ;

  printf ("BC:%f \n", BC[0]);
  for (int i = 0; i < 101; i = i + 5)
    {
      printf ("%f ", data[i * 10 + 0]);
      printf ("%f ", data[i * 10 + 2] / 3.438);
      printf ("%f ", data[i * 10 + 3]);
      printf ("%f ", data[i * 10 + 5] / 3.438);
      printf ("%f ", data[i * 10 + 6]);
      printf ("\n");
    }

//  free (solution[0]);
//  free (solution);
}

using namespace std;

int
main ()
{
  double BC = 0.14;
  int DragFunction = G1;
  double Altitude = 5003;
  double Barometer = 29.53;
  double Temperature = 86;
  double RelativeHumidity = 25;
  double MV = 1070;
  double scopeOffset = 1.8017;
  double zeroRange = 25;
  struct Parameters P =
    { MV, DragFunction, Altitude, Barometer, Temperature, RelativeHumidity,
	scopeOffset, zeroRange };
  double x[] =
    { 0.2 };
  int fail = adm_chen (&myfun, x, 1e-5, 50, 1, 0.9, 30, &P);
  BC = x[0];
  double modifiedBC = AtmCorrect (BC, Altitude, Barometer, Temperature,
				  RelativeHumidity);
  double angle = ZeroAngle (DragFunction, modifiedBC, 1070, 1.8017, 25, 0.);
  printf ("BC:%f \n", BC);
  printf ("the shooting angle is %f degree\n", angle);

  printf ("# Range elevationMil Time WindageMil Velocity \n");

  double **solution = (double**) malloc (1);
  SolveAll (DragFunction, modifiedBC, 1070, 1.8017, 0, angle, 10, 90, solution);
  double *data = *solution;

  for (int i = 0; i < 300; i = i + 25)
    {
      printf ("%f ", data[i * 10 + 0]);
      printf ("%f ", data[i * 10 + 2] / 3.438);
      printf ("%f ", data[i * 10 + 3]);
      printf ("%f ", data[i * 10 + 5] / 3.438);
      printf ("%f ", data[i * 10 + 6]);
      printf ("\n");
    }
  return 0;
}

/*

 int
 main ()
 {
 double BC = 0.14;
 int DragFunction=G1;
 double Altitude=5003;
 double Barometer=29.53;
 double Temperature=86;
 double RelativeHumidity=25;

 double modifiedBC = AtmCorrect (BC, Altitude, Barometer,
 Temperature, RelativeHumidity);

 double angle = ZeroAngle (DragFunction, modifiedBC, 1070, 1.8017, 25, 0.);

 printf ("the shooting angle is %f degree\n", angle);

 printf ("# Range elevationMil Time WindageMil Velocity \n");

 double **solution = (double**) malloc (1);
 // double ZeroAngle(int DragFunction, double DragCoefficient, double Vi, double SightHeight, double ZeroRange, double yIntercept){

 // 	int SolveAll(int DragFunction, double DragCoefficient, double Vi, double SightHeight, \
// double ShootingAngle, double ZAngle, double WindSpeed, double WindAngle, double** Solution){
 SolveAll (DragFunction, modifiedBC, 1070, 1.8017, 0, angle, 10, 90, solution);
 double *data = *solution;

 for (int i = 0; i < 101; i = i + 5)
 {
 printf ("%f ", data[i * 10 + 0]);
 printf ("%f ", data[i * 10 + 2] / 3.438);
 printf ("%f ", data[i * 10 + 3]);
 printf ("%f ", data[i * 10 + 5] / 3.438);
 printf ("%f ", data[i * 10 + 6]);
 printf ("\n");
 }
 return 0;
 }



 */

