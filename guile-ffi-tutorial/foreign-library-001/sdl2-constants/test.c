
/*

clang -o test `pkg-config --cflags --libs sdl2` test.c  

to pull values of the C macros we can code something like this and manually pick out the values

 */

#include <SDL2/SDL.h>

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

  
  
  exit(0);    
}
