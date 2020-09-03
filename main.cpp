#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include "ballistics.h"
#include <boost/tuple/tuple.hpp>

FILE *file;


double
myfun (double BC, struct Parameters *P)
{
//  double x=BC;
//  double y = (x - 1) * (x - 1) + 100;
  double MV = P->MV;
  int DragFunction = P->DragFunction;
  double Altitude = P->Altitude;
  double Barometer = P->Barometer;
  double Temperature = P->Temperature;
  double RelativeHumidity = P->RelativeHumidity;
  double scopeOffset = P->scopeOffset;
  double zeroRange = P->zeroRange;
  double *TriedDistance = P->TriedDistance;
  double *TriedElevation = P->TriedElevation;
  double TriedN = P->TriedN;

  double modifiedBC = AtmCorrect (BC, Altitude, Barometer, Temperature,
				  RelativeHumidity);

  double angle = ZeroAngle (DragFunction, modifiedBC, MV, scopeOffset,
			    zeroRange, 0.);
  double **solution = (double**) malloc (1);

  SolveAll (DragFunction, modifiedBC, MV, scopeOffset, 0, angle, 10, 90,
	    solution);
  double *data = *solution;

  double error = 0;
  for (int i = 0; i < TriedN; i++)
    {
      error += fabs (
	  GetMOA (data, TriedDistance[i]) / 3.438 - TriedElevation[i]);
    }


//    printf ("BC:%f error=%f\n", BC,error );

  fprintf (file, "%f   %f\n", BC, error);

//    for (int i = 0; i < 101; i = i + 5)
//      {
//        printf ("%f ", data[i * 10 + 0]);
//        printf ("%f ", data[i * 10 + 2] / 3.438);
//        printf ("%f ", data[i * 10 + 3]);
//        printf ("%f ", data[i * 10 + 5] / 3.438);
//        printf ("%f ", data[i * 10 + 6]);
//        printf ("\n");
//      }
  fflush (stdout);
  free (solution[0]);
  free (solution);
  return error;

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
  double TriedDistance[100] =
    {  50, 100,200,254 };
  double TriedElevation[100] =
    {   0, 1.9,6.8,9.9 };
  int TriedN = 4;

  struct Parameters P =
    { MV, DragFunction, Altitude, Barometer, Temperature, RelativeHumidity,
	scopeOffset, zeroRange, TriedDistance, TriedElevation, TriedN };

  file = fopen ("Data.txt", "w+");
  fprintf (file, "# sample 2-column data file\n");

  BC = Adam (&myfun, &P, 0.2, 300, 0.001);

  fclose (file);
  printf ("solutions=%f\n", BC);

  double modifiedBC = AtmCorrect (BC, Altitude, Barometer, Temperature,
				  RelativeHumidity);
  double angle = ZeroAngle (DragFunction, modifiedBC, 1070, 1.8017, 25, 0.);
  printf ("BC:%f \n", BC);
  printf ("the shooting angle is %f degree\n", angle);
  printf ("# Range elevationMil Time WindageMil Velocity \n");

  double **solution = (double**) malloc (1);
  SolveAll (DragFunction, modifiedBC, 1070, 1.8017, 0, angle, 10, 90, solution);
  double *data = *solution;

  for (int i = 0; i <= 300; i = i + 25)
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

