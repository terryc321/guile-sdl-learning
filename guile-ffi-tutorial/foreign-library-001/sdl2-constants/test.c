
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

  
  fprintf(stdout,"SDL_MOUSEMOTION event type is %d\n", SDL_MOUSEMOTION ); 

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

  /*  
;; keyboard 
typedef struct SDL_KeyboardEvent
{
    Uint32 type;        //< SDL_KEYDOWN or SDL_KEYUP 
    Uint32 timestamp;   //< In milliseconds, populated using SDL_GetTicks() 
    Uint32 windowID;    //< The window with keyboard focus, if any 
    Uint8 state;        //< SDL_PRESSED or SDL_RELEASED 
    Uint8 repeat;       //< Non-zero if this is a key repeat 
    Uint8 padding2;
    Uint8 padding3;
    SDL_Keysym keysym;  //< The key that was pressed or released 
} SDL_KeyboardEvent;
  */

  fprintf(stdout,"================= SDL_KeyboardEvent ============= \n");
  fprintf(stdout,"SDL_KeyboardEvent type : %zu\n" , offsetof(SDL_KeyboardEvent, type));
  fprintf(stdout,"SDL_KeyboardEvent timestamp : %zu\n" , offsetof(SDL_KeyboardEvent, timestamp));
  fprintf(stdout,"SDL_KeyboardEvent windowid : %zu\n" , offsetof(SDL_KeyboardEvent, windowID));
  fprintf(stdout,"SDL_KeyboardEvent state : %zu\n" , offsetof(SDL_KeyboardEvent, state));
  fprintf(stdout,"SDL_KeyboardEvent repeat : %zu\n" , offsetof(SDL_KeyboardEvent, repeat));
  fprintf(stdout,"SDL_KeyboardEvent padding2 : %zu\n" , offsetof(SDL_KeyboardEvent, padding2));
  fprintf(stdout,"SDL_KeyboardEvent padding3 : %zu\n" , offsetof(SDL_KeyboardEvent, padding3));
  fprintf(stdout,"SDL_KeyboardEvent keysym : %zu\n" , offsetof(SDL_KeyboardEvent, keysym));


  /*
typedef struct SDL_Keysym
{
    SDL_Scancode scancode;      //< SDL physical key code - see SDL_Scancode for details 
    SDL_Keycode sym;            //< SDL virtual key code - see SDL_Keycode for details 
    Uint16 mod;                 //< current key modifiers - see SDL_Keymod for details 
    Uint32 unused;
} SDL_Keysym;
  */
  fprintf(stdout,"================= SDL_Keysym ============= \n");
  fprintf(stdout,"SDL_Keysym has size in bytes of : %zu\n" , sizeof(SDL_Keysym));
  fprintf(stdout,"SDL_Keysym scancode : %zu\n" , offsetof(SDL_Keysym, scancode));
  fprintf(stdout,"SDL_Keysym sym : %zu\n" , offsetof(SDL_Keysym, sym));
  fprintf(stdout,"SDL_Keysym mod : %zu\n" , offsetof(SDL_Keysym, mod));
  fprintf(stdout,"SDL_Keysym unused : %zu\n" , offsetof(SDL_Keysym, unused));
  
  fprintf(stdout,"================= standard signed int sizes  ============= \n");
  fprintf(stdout,"int unspecified : %zu\n" , sizeof(int));
  fprintf(stdout,"int8_t : %zu\n" , sizeof(int8_t));
  fprintf(stdout,"int16_t : %zu\n" , sizeof(int16_t));
  fprintf(stdout,"int32_t : %zu\n" , sizeof(int32_t));
  fprintf(stdout,"int64_t : %zu\n" , sizeof(int64_t));
  fprintf(stdout,"================= standard unsigned int sizes  ============= \n");  
  fprintf(stdout,"uint8_t : %zu\n" , sizeof(uint8_t));
  fprintf(stdout,"uint16_t : %zu\n" , sizeof(uint16_t));
  fprintf(stdout,"uint32_t : %zu\n" , sizeof(uint32_t));
  fprintf(stdout,"uint64_t : %zu\n" , sizeof(uint64_t));
  
  fprintf(stdout,"================= SDL_Rect ============= \n");
  fprintf(stdout,"SDL_Rect has size in bytes of : %zu\n" , sizeof(SDL_Rect));
  fprintf(stdout,"SDL_Rect x : %zu\n" , offsetof(SDL_Rect, x));
  fprintf(stdout,"SDL_Rect y : %zu\n" , offsetof(SDL_Rect, y));
  fprintf(stdout,"SDL_Rect w: %zu\n" , offsetof(SDL_Rect,  w));
  fprintf(stdout,"SDL_Rect h : %zu\n" , offsetof(SDL_Rect, h));

  fprintf(stdout,"color blue : R G B : %d\n" , 255 );
  fprintf(stdout,"color green : R G B : %d\n" , 255 << 8);
  fprintf(stdout,"color reg : R G B : %d\n" , 255 << 16);

  
/*   typedef struct SDL_Surface */
/* { */
/*     Uint32 flags;               /\**< Read-only *\/ */
/*     SDL_PixelFormat *format;    /\**< Read-only *\/ */
/*     int w, h;                   /\**< Read-only *\/ */
/*     int pitch;                  /\**< Read-only *\/ */
/*     void *pixels;               /\**< Read-write *\/ */

/*     /\** Application data associated with the surface *\/ */
/*     void *userdata;             /\**< Read-write *\/ */

/*     /\** information needed for surfaces requiring locks *\/ */
/*     int locked;                 /\**< Read-only *\/ */

/*     /\** list of BlitMap that hold a reference to this surface *\/ */
/*     void *list_blitmap;         /\**< Private *\/ */

/*     /\** clipping information *\/ */
/*     SDL_Rect clip_rect;         /\**< Read-only *\/ */

/*     /\** info for fast blit mapping to other surfaces *\/ */
/*     SDL_BlitMap *map;           /\**< Private *\/ */

/*     /\** Reference count -- used when freeing surface *\/ */
/*     int refcount;               /\**< Read-mostly *\/ */
/* } SDL_Surface; */

  SDL_Surface sdl_surface;
  fprintf(stdout,"================= SDL_Surface ============= \n");
  fprintf(stdout,"SDL_Surface has size in bytes of : %zu\n" , sizeof(SDL_Surface));
  fprintf(stdout,"SDL_Surface flags : offset %zu : size %zu\n" , offsetof(SDL_Surface, flags),sizeof(sdl_surface.flags));
  fprintf(stdout,"SDL_Surface format : offset %zu : size %zu\n" , offsetof(SDL_Surface, format),sizeof(sdl_surface.format));
  fprintf(stdout,"SDL_Surface w: offset %zu : size %zu\n" , offsetof(SDL_Surface,  w),sizeof(sdl_surface.w));
  fprintf(stdout,"SDL_Surface h : offset %zu : size %zu\n" , offsetof(SDL_Surface, h),sizeof(sdl_surface.h));
  fprintf(stdout,"SDL_Surface pitch :  offset %zu : size %zu\n" , offsetof(SDL_Surface, pitch),sizeof(sdl_surface.pitch));
  fprintf(stdout,"SDL_Surface pixels : offset %zu : size %zu\n" , offsetof(SDL_Surface, pixels),sizeof(sdl_surface.pixels));
  fprintf(stdout,"SDL_Surface userdata: offset %zu : size %zu\n" , offsetof(SDL_Surface,  userdata),sizeof(sdl_surface.userdata));
  fprintf(stdout,"SDL_Surface locked : offset %zu : size %zu\n" , offsetof(SDL_Surface, locked),sizeof(sdl_surface.locked));
  fprintf(stdout,"SDL_Surface list_blitmap : offset %zu : size %zu\n" , offsetof(SDL_Surface, list_blitmap),sizeof(sdl_surface.list_blitmap));
  fprintf(stdout,"SDL_Surface clip_rect : offset %zu : size %zu\n" , offsetof(SDL_Surface, clip_rect),sizeof(sdl_surface.clip_rect));
  fprintf(stdout,"SDL_Surface map : offset  %zu : size %zu\n" , offsetof(SDL_Surface, map),sizeof(sdl_surface.map));
  fprintf(stdout,"SDL_Surface refcount : offset %zu : size %zu\n" , offsetof(SDL_Surface, refcount),sizeof(sdl_surface.refcount));
  
  
  
  
  exit(0);    
}


