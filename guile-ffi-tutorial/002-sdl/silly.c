#include <stdio.h>
#include <math.h>
#include <stdbool.h>
#include <time.h>

#include <SDL2/SDL.h>
#include <cairo/cairo.h>
#include <libguile.h>



/*

guile   C language
scheme  

#f	SCM_BOOL_F
#t	SCM_BOOL_T
()	SCM_EOL

 */

SCM silly_sdl_wrapper (SCM x)
{
  return SCM_BOOL_F; //scm_from_double (j0 (scm_to_double (x)));
}

void silly_init_sdl ()
{
  // req = required number of args ?
  // opt = optional number of args ?
  // rst = rest number of args ?
  //SCM scm_c_define_gsubr (const char *name, int req, int opt, int rst, fcn)
  scm_c_define_gsubr ("init_sdl", 0, 0, 0, silly_sdl_wrapper);
}





