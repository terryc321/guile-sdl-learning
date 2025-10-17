
/*

clang -o test `pkg-config --cflags --libs sdl2` test.c  

to pull values of the C macros we can code something like this and manually pick out the values

 */
#include <stdio.h>
#include <stddef.h> 

#include <SDL2/SDL.h>
#include <cairo/cairo.h>

int main(){

  printf("this program is to test the constants that hex->decimal converter on web was accurate\n");
  printf("also it also shows SDL2 C macro constants that get lost in compilation , do not survive to the shared library\n");
  
  
  printf("SDL_INIT_TIMER is 1 ? %d \n",SDL_INIT_TIMER == 1);
  printf("SDL_INIT_AUDIO is 16 ? %d\n",SDL_INIT_AUDIO == 16);
  printf("SDL_INIT_VIDEO is 32 ? %d\n",SDL_INIT_VIDEO == 32);
  printf("SDL_INIT_JOYSTICK is 512 ? %d\n",SDL_INIT_JOYSTICK == 512);
  printf("SDL_INIT_HAPTIC is 4096 ? %d\n",SDL_INIT_HAPTIC == 4096);
  printf("SDL_INIT_GAMECONTROLLER is 8192 ? %d\n",SDL_INIT_GAMECONTROLLER == 8192);
  printf("SDL_INIT_EVENTS is 16384 ? %d\n",SDL_INIT_EVENTS == 16384);
  printf("SDL_INIT_SENSOR is 32768 ? %d\n",SDL_INIT_SENSOR == 32768);
  printf("SDL_INIT_NOPARACHUTE is 1048576 ? %d\n",SDL_INIT_NOPARACHUTE == 1048576);
  printf("SDL_INIT_EVERYTHING is  ? %d\n",SDL_INIT_EVERYTHING == (SDL_INIT_TIMER | SDL_INIT_AUDIO | SDL_INIT_VIDEO | SDL_INIT_EVENTS | SDL_INIT_JOYSTICK | SDL_INIT_HAPTIC | SDL_INIT_GAMECONTROLLER | SDL_INIT_SENSOR));
  printf("SDL_INIT_EVERYTHING is %u\n",SDL_INIT_EVERYTHING);
  printf("SDL_INIT_EVERYTHING is 62001 ? %d\n",62001 == SDL_INIT_EVERYTHING);

  //int result = SDL_Init(62001); // should be a few seconds
  int result = SDL_Init(32);
  printf("the result was %d \n" , result);
  // all ok

  printf("CAIRO_FORMAT_RGB24 %d \n",CAIRO_FORMAT_RGB24 );

  size_t pixels_offset = offsetof(SDL_Surface, pixels);
  printf("SDL_Surface *p ; p->pixels offset is %zu\n",pixels_offset);
  // pixels offset is 32 bytes from start of p
 
  size_t format_offset = offsetof(SDL_Surface, format);
  printf("SDL_Surface *p ; p->format offset is %zu\n",format_offset);
  
 
  SDL_Surface *p = (SDL_Surface *)malloc(sizeof(SDL_Surface));
  if (!p){
    fprintf(stderr, "cannot allot SDL_Surface");
    exit(1);
  }
  int i = 0;
  char *q = (char *)p;
    
  fprintf(stdout,"address of p is %p\n", q);
  fprintf(stdout,"address of p->pixels is %p\n", q + 32);
  fprintf(stdout,"sanity check p->pixels == q + 32 : %d\n", ((char *)&(p->pixels)) == ((char*)(q + 32)));
  
  free((void*)p);
  p = 0;

  // size of SDL_Event
  // event types
  // event type IDs
  fprintf(stdout,"size of SDL_Event is %zu\n", sizeof(SDL_Event));
  fprintf(stdout,"size of SDL_Event is %lu\n", sizeof(SDL_Event));

  
  fprintf(stdout,"SDL_MOUSEMOTION event type is %lu\n", SDL_MOUSEMOTION );
  fprintf(stdout,"SDL_MOUSEMOTION event type is %lu\n", SDL_MOUSEMOTION );
  

  fprintf(stdout,"================= SDL_MOUSEMOTIONEVENT ============= \n");
  fprintf(stdout,"MOUSEMOTIONEVENT type : %zu\n" , offsetof(SDL_MouseMotionEvent, type));
  fprintf(stdout,"MOUSEMOTIONEVENT timestamp : %zu\n" , offsetof(SDL_MouseMotionEvent, timestamp));
  fprintf(stdout,"MOUSEMOTIONEVENT windowid : %zu\n" , offsetof(SDL_MouseMotionEvent, windowID));
  fprintf(stdout,"MOUSEMOTIONEVENT which : %zu\n" , offsetof(SDL_MouseMotionEvent, which));
  fprintf(stdout,"MOUSEMOTIONEVENT state : %zu\n" , offsetof(SDL_MouseMotionEvent, state));
  fprintf(stdout,"MOUSEMOTIONEVENT x : %zu\n" , offsetof(SDL_MouseMotionEvent, x));
  fprintf(stdout,"MOUSEMOTIONEVENT y : %zu\n" , offsetof(SDL_MouseMotionEvent, y));
  fprintf(stdout,"MOUSEMOTIONEVENT xrel : %zu\n" , offsetof(SDL_MouseMotionEvent, xrel));
  fprintf(stdout,"MOUSEMOTIONEVENT yrel : %zu\n" , offsetof(SDL_MouseMotionEvent, yrel));
  
  fprintf(stdout,"overall size of MOUSEMOTIONEVENT %zu\n" , sizeof(SDL_MouseMotionEvent));

  fprintf(stdout,"================= SDL_QUIT ============= \n");
  fprintf(stdout,"QUIT_EVENT type : %zu\n" , offsetof(SDL_QuitEvent, type));
  fprintf(stdout,"QUIT_EVENT timestamp : %zu\n" , offsetof(SDL_QuitEvent, timestamp));

  
  exit(0);    
}


