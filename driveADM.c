/*
 * driveADM.c
 *
 *  Created on: Oct 6, 2018
 *      Author: chen
 */
#include "NR_chen.h"

void
myfun (int n, double* in, double* out)
{
  out[0] = in[0] * in[1] * in[2] - 12.;
  out[1] = in[1] * in[1] + in[0] * in[0] - 8.;
  out[2] = in[1] + in[0] + in[2] - 511.;
}

int
main ()
{
  double x[] =
    { 1, 2, 3 };
  int fail = adm_chen (&myfun, x, 1e-15, 3000, 3, 0.9,30);
  return 0;
}
