
#include <math.h>
#include <SDL2/SDL.h>
#include <stdio.h>
#include <stddef.h>

#include <libguile.h>

void pixelformat2(SDL_Surface *ptr);
SDL_PixelFormat *pixelformat_wrapper(SDL_Surface *ptr);
void output_check();


SDL_PixelFormat *pixelformat_wrapper(SDL_Surface *ptr){
  if(ptr){
    return (SDL_PixelFormat *)ptr->format;
  }
  return 0;
}

void output_check(){
  printf("this is an output check!\n");
}


void pixelformat2(SDL_Surface *ptr){
  if(ptr){
    char *p = (char *)ptr->format;
    int i = 0 ;
    for (i =0 ; i < 8 ; i ++){
      printf("byte %d is %d\n" , i, *p);
      p ++;	
    }
  }
}





/*
s is scheme <pointer 0xADDRESS> object
we need c pointer  

SCM pixelformat_wrapper(SCM s){
  SDL_Surface *ptr = (SDL_Surface *)scm_to_pointer(s);
  //printf("pixelformat : ptr->format (%p)\n",ptr->format);
  return scm_from_pointer(ptr->format,NULL);
  //return pointer->scm(ptr->format);
}

void
init_pixelformat (void)
{
  scm_c_define_gsubr ("pixelformat", 1, 0, 0, pixelformat_wrapper);
}

SCM
j0_wrapper (SCM x)
{
  return scm_from_double (j0 (scm_to_double (x, "j0")));
}

void
init_math_bessel (void)
{
  scm_c_define_gsubr ("j0", 1, 0, 0, j0_wrapper);
}
*/

