#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include "ballistics.h"

using namespace std;
int
main ()
{
  double angle = ZeroAngle (G1, 0.200, 1070, 1.8017, 25, 0.);

  // printf("the shooting angle is %f\n",angle);

  printf ("# Range elevationMil Time WindageMil Velocity \n");

  double **solution = (double**) malloc (20);
  // double ZeroAngle(int DragFunction, double DragCoefficient, double Vi, double SightHeight, double ZeroRange, double yIntercept){

// 	int SolveAll(int DragFunction, double DragCoefficient, double Vi, double SightHeight, \
// double ShootingAngle, double ZAngle, double WindSpeed, double WindAngle, double** Solution){
  SolveAll (G1, 0.2, 1070, 1.8017, 0, angle, 10, 90, solution);
  double *data = *solution;

  for (int i = 0; i < 586; i = i + 8)
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

