

#include <stdio.h>
#include <math.h>
#include <stdbool.h>
#include <time.h>

// SDL2/SDL2.h defines SDL_Init
#include <SDL2/SDL.h>


#include <cairo/cairo.h>

#include <libguile.h>


// fixed window for now 
#define SCREEN_WIDTH 640
#define SCREEN_HEIGHT 480
#define WINDOW_X 200
#define WINDOW_Y 200


/*

guile   C language
scheme  

#f	SCM_BOOL_F
#t	SCM_BOOL_T
()	SCM_EOL

 */

//The window we'll be rendering to
static SDL_Window* gWindow;
    
//The surface contained by the window
static SDL_Surface* gScreenSurface;

//The image we will load and show on the screen
//SDL_Surface* gHelloWorld = NULL;



bool sdl_init(){
  //Initialize SDL
  if( SDL_Init( SDL_INIT_VIDEO ) < 0 )
    {
      printf( "SDL could not initialize! SDL_Error: %s\n", SDL_GetError() );
      return false;
    }

  //Create window
  // | SDL_WINDOW_RESIZABLE  causes animation to stop as may have to go around houses to correct X - Y pixels
  gWindow = SDL_CreateWindow( "SDL Tutorial", WINDOW_X , WINDOW_Y , SCREEN_WIDTH, SCREEN_HEIGHT, SDL_WINDOW_SHOWN );
  if( gWindow == NULL )
    {
      printf( "Window could not be created! SDL_Error: %s\n", SDL_GetError() );
      return false;
    }
  

  //SDL_SetWindowFullscreen(gWindow, SDL_WINDOW_FULLSCREEN);
  //SDL_SetWindowFullscreen(gWindow, SDL_WINDOW_FULLSCREEN_DESKTOP);
  
  //Get window surface
  gScreenSurface = SDL_GetWindowSurface( gWindow );
  return true;
}



SCM sdl_init_wrapper(){
  bool res = sdl_init();
  if (res){
    return SCM_BOOL_T;
  }
  return SCM_BOOL_F;
}






SCM zero_wrapper (){
  return scm_from_int(0);
}

SCM one_wrapper (){
  return scm_from_int(1);
}

SCM two_wrapper (){
  return scm_from_int(2);
}

SCM three_wrapper (){
  return scm_from_int(3);
}


SCM falsey_wrapper (){
  return SCM_BOOL_F; 
}

SCM truthy_wrapper (){
  return SCM_BOOL_T; 
}

// eol = end of list (scheme '())
SCM eol_wrapper (){
  return SCM_EOL; 
}

SCM plus_one_wrapper (SCM x) {
  int result;
  result = scm_to_int(x) + 1;
  return scm_from_int(result);
}

SCM plus_two_wrapper (SCM x) {
  int result;
  result = scm_to_int(x) + 2;
  return scm_from_int(result);
}

SCM fixnum_add_wrapper (SCM x, SCM y) {
  int result;
  result = scm_to_int(x) + scm_to_int(y);
  return scm_from_int(result);
}


void silly_init () {
  // req = required number of args ?
  // opt = optional number of args ?
  // rst = rest number of args ?
  //SCM scm_c_define_gsubr (const char *name, int req, int opt, int rst, fcn)

  // zero argument procedures
  scm_c_define_gsubr ("falsey", 0, 0, 0, falsey_wrapper);
  scm_c_define_gsubr ("truthy", 0, 0, 0, truthy_wrapper);  
  scm_c_define_gsubr ("empty-list", 0, 0, 0, eol_wrapper);  
  scm_c_define_gsubr ("zero", 0, 0, 0, zero_wrapper);  
  scm_c_define_gsubr ("one", 0, 0, 0, one_wrapper);  
  scm_c_define_gsubr ("two", 0, 0, 0, two_wrapper);
  scm_c_define_gsubr ("three", 0, 0, 0, three_wrapper);  

  // one argument procedures
  scm_c_define_gsubr ("plus1", 1, 0, 0, plus_one_wrapper);
  scm_c_define_gsubr ("plus2", 1, 0, 0, plus_two_wrapper);

  // add two fixnum ints 
  scm_c_define_gsubr ("fixnum-add", 2, 0, 0, fixnum_add_wrapper);    

  // free choose name in 1st position , 0 args, 0 opt args, 0 rest args , C wrapper sdl_init_wrapper
  scm_c_define_gsubr ("sdl-init", 0, 0, 0, sdl_init_wrapper);

  
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

sdl-init
(use-modules (system foreign-library))

 */


static void inner_main (void *closure, int argc, char **argv){
  /* preparation */
  silly_init();
  /* enter the shell */
  scm_shell (argc, argv);
  /* after exit */
}

int main (int argc, char **argv){
  scm_boot_guile (argc, argv, inner_main, 0);
  return 0; /* never reached, see inner_main */
}
