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

SCM zero_wrapper ()
{
  return scm_from_int(0);
}

SCM one_wrapper ()
{
  return scm_from_int(1);
}

SCM two_wrapper ()
{
  return scm_from_int(2);
}

SCM three_wrapper ()
{
  return scm_from_int(3);
}


SCM falsey_wrapper ()
{
  return SCM_BOOL_F; 
}

SCM truthy_wrapper ()
{
  return SCM_BOOL_T; 
}

// eol = end of list (scheme '())
SCM eol_wrapper ()
{
  return SCM_EOL; 
}


void silly_init ()
{
  // req = required number of args ?
  // opt = optional number of args ?
  // rst = rest number of args ?
  //SCM scm_c_define_gsubr (const char *name, int req, int opt, int rst, fcn)
  scm_c_define_gsubr ("falsey", 0, 0, 0, falsey_wrapper);
  scm_c_define_gsubr ("truthy", 0, 0, 0, truthy_wrapper);  
  scm_c_define_gsubr ("empty-list", 0, 0, 0, eol_wrapper);  
  scm_c_define_gsubr ("zero", 0, 0, 0, zero_wrapper);  
  scm_c_define_gsubr ("one", 0, 0, 0, one_wrapper);  
  scm_c_define_gsubr ("two", 0, 0, 0, two_wrapper);
  scm_c_define_gsubr ("three", 0, 0, 0, three_wrapper);  

}

/*
LTDL_LIBRARY_PATH=./ guile
(load-extension "libguile-sdl" "silly_init")
falsey
truthy 
(falsey) => #f
(truthy) => #t
(empty-list) => ()
(zero) => 0
(one) => 1
(two) => 2
(three) => 3
 */



