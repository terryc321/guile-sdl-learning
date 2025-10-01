
/*
cairo with SDL
  
https://www.cairographics.org/SDL/

https://cgit.freedesktop.org/~joonas/cairosdl/tree/README


Technically there is only one common pixel format in common between
cairo and SDL: 32 bit pixels which do NOT use per pixel alpha.  Cairo
calls that format CAIRO_FORMAT_RGB24.  In SDL terms such surfaces are
created by:

	SDL_CreateRGBSurface (flags, width, height, 32,
			      CAIROSDL_RMASK, // 0x00FF0000
			      CAIROSDL_GMASK, // 0x0000FF00
			      CAIROSDL_BMASK, // 0x000000FF
			      0);

Using the cairosdl_surface_create(SDL_Surface*) function one can get a
cairo_surface_t* that can be used to get a cairo_t drawing context,
just as normal.  As a convenience, cairosdl_create(SDL_Surface*) will
make the cairo_surface_t and then bind it to a cairo_t drawing context.

If your SDL_Surface has this pixel format and does not need locking,
that's all you need to do.

keyboard see sdl although for version 1 still works with version 2 
https://www.libsdl.org/release/SDL-1.2.15/docs/html/sdlkey.html


SDL2 sdlkey definitions 
https://github.com/libsdl-org/SDL/blob/SDL2/include/SDL_keycode.h


*/

#include <stdio.h>
#include <math.h>
#include <stdbool.h>
#include <time.h>

#include <SDL2/SDL.h>

#include <cairo/cairo.h>


// 10,000 BALLS
#define NBALLS  1000
	  
/*
#define SCREEN_WIDTH 640
#define SCREEN_HEIGHT 480
#define WINDOW_X 200
#define WINDOW_Y 200
*/

/*
#define SCREEN_WIDTH 1024
#define SCREEN_HEIGHT 768
#define WINDOW_X 200
#define WINDOW_Y 200
*/


/*
#define SCREEN_WIDTH 1280
#define SCREEN_HEIGHT 720
#define WINDOW_X 200
#define WINDOW_Y 200
*/


#define SCREEN_WIDTH 1920
#define SCREEN_HEIGHT 1080
#define WINDOW_X 200
#define WINDOW_Y 200


struct BALL {
  double x;
  double y;
  double vx ;
  double vy ; 
};

struct BOX {
  int x;
  int y;
  int width;
  int height;
};

/* mouse position and three mouse button states */
struct MOUSE {
  int x ;
  int y ;
  int button1;
  int button2;
  int button3;
};


/* detect when key is pressed or released gets entered into a KEYS struct
 can then make movement based on these
 */
struct KEYS {
  int up;
  int down;
  int left;
  int right;
  int f1;
  int f2;
  int f3;
  int f4;
  int f5;
  int f6;
  int f7;
  int f8;
  int f9;
  int f10;
  int f11;
  int f12;
  int f13; //?? do we have f13 on keyboard ??
  int caps;

  int lshift;
  int rshift;

  int ralt;
  int lalt;
  int rctrl;
  int lctrl;

  /*
  int rmeta;
  int lmeta;
  int rsuper;
  int lsuper;
  */
  
};





//Starts up SDL and creates window
bool init();

//Loads media
bool loadMedia();

//Frees media and shuts down SDL
void close();

//The window we'll be rendering to
SDL_Window* gWindow = NULL;
    
//The surface contained by the window
SDL_Surface* gScreenSurface = NULL;

//The image we will load and show on the screen
SDL_Surface* gHelloWorld = NULL;








/*
  
https://dev.to/noah11012/using-sdl2-2d-accelerated-renderering-1kcb

accelerated 2d rendering

*/

bool init()
{
  // some random number init 
  srand((unsigned int)time(NULL));

  //Initialization flag
  bool success = true;

  //Initialize SDL
  if( SDL_Init( SDL_INIT_VIDEO ) < 0 )
    {
      printf( "SDL could not initialize! SDL_Error: %s\n", SDL_GetError() );
      success = false;
    }
  else
    {
      //Create window
      // | SDL_WINDOW_RESIZABLE  causes animation to stop as may have to go around houses to correct X - Y pixels
      gWindow = SDL_CreateWindow( "SDL Tutorial", WINDOW_X , WINDOW_Y , SCREEN_WIDTH, SCREEN_HEIGHT, SDL_WINDOW_SHOWN );
      if( gWindow == NULL )
        {
	  printf( "Window could not be created! SDL_Error: %s\n", SDL_GetError() );
	  success = false;
        }
      else
        {

	  //SDL_SetWindowFullscreen(gWindow, SDL_WINDOW_FULLSCREEN);
	  //SDL_SetWindowFullscreen(gWindow, SDL_WINDOW_FULLSCREEN_DESKTOP);
	  	  
	  //Get window surface
	  gScreenSurface = SDL_GetWindowSurface( gWindow );
        }
    }

  return success;
}


bool loadMedia()
{
  //Loading success flag
  bool success = true;

  /* saved hello world bitmap as 32 bit , in gimp file->export 32bit A8 R8 G8 B8 */
  //Load splash image
  gHelloWorld = SDL_LoadBMP( "hello_world2.bmp" );
  if( gHelloWorld == NULL )
    {
      printf( "Unable to load image %s! SDL Error: %s\n", "hello_world2.bmp", SDL_GetError() );
      success = false;
    }

  return success;
}


void close()
{
  //Deallocate surface
  SDL_FreeSurface( gHelloWorld );
  gHelloWorld = NULL;

  //Destroy window
  SDL_DestroyWindow( gWindow );
  gWindow = NULL;

  //Quit SDL subsystems
  SDL_Quit();
}

void moveBall(struct BALL *ball){
  // assume WINDOW_WIDTH WINDOW_HEIGHT 640 480
  int wid = SCREEN_WIDTH;
  int hgt = SCREEN_HEIGHT;
  ball->x = ball->x + ball->vx;
  ball->y = ball->y + ball->vy;

  if (ball->x > wid){
    ball->x = wid ;
    ball->vx = 0 - ball->vx ; 
  }
  if (ball->y > hgt){
    ball->y = hgt ;
    ball->vy = 0 - ball->vy ; 
  }
  if (ball->x < 0){
    ball->x = 0 ;
    ball->vx = 0 - ball->vx ; 
  }
  if (ball->y < 0){
    ball->y = 0 ;
    ball->vy = 0 - ball->vy ; 
  }
  
}



int run(){
  //Start up SDL and create window
  if( !init() )
    {
      printf( "Failed to initialize!\n" );
    }
  else
    {
      //Load media
      if( !loadMedia() )
        {
	  printf( "Failed to load media!\n" );
        }
      else
        {

	  /*
	  //Apply the image
	  SDL_BlitSurface( gHelloWorld, NULL, gScreenSurface, NULL );
	  
	  //Update the surface
	  SDL_UpdateWindowSurface( gWindow );
	  */

	  /* lets have a mouse item - lets zero everything out ! */
	  struct MOUSE mouse;
	  mouse.x = 0;
	  mouse.y = 0;
	  mouse.button1 = 0;
	  mouse.button2 = 0;
	  mouse.button3 = 0;


	  
	  
	  int flags = 0; // flags unused should be set to 0 ??
	  int width = SCREEN_WIDTH; // 640 pixels wide
	  int height = SCREEN_HEIGHT; // 480 pixels high
	  int depth = 32; // 32 bits - cairo only understands 32 bits
	  SDL_Surface *sdlsurf = SDL_CreateRGBSurface (
						       flags, width, height, depth,
						       0x00FF0000, /* Rmask */
						       0x0000FF00, /* Gmask */
						       0x000000FF, /* Bmask */
						       0); /* Amask */

	  /* ... make sure sdlsurf is locked or doesn't need locking ... */

	  // can we draw on hello world bitmap we loaded in before ?
	  //sdlsurf = gHelloWorld;
	  printf("helloworld bitmap w:%d h:%d pitch:%d\n",sdlsurf->w , sdlsurf->h , sdlsurf->pitch);
	  
	  cairo_surface_t *cairosurf = cairo_image_surface_create_for_data (
									    (unsigned char*)sdlsurf->pixels,
									    CAIRO_FORMAT_RGB24,
									    sdlsurf->w,
									    sdlsurf->h,
									    sdlsurf->pitch);
	  
	  /* ... normal cairo calls onto cairosurf ... */
	  cairo_t *cr;
	  cr = cairo_create (cairosurf);


	  /* set font size */
	  cairo_set_font_size(cr , (double) 20.0);
	  

	  
	  
	  /* moveable box on screen to respond to up down left right arrows */
	  struct BOX box;
	  box.x = 100;
	  box.y = 100;
	  box.width = 100;
	  box.height = 100;
	  

	  struct BALL *balls= (struct BALL *)malloc(sizeof(struct BALL) * NBALLS);
	  if (!balls){
	    fprintf(stderr,"we did not get %d balls created\n",NBALLS);
	    exit(2);
	  }
	  for (int i = 0; i < NBALLS; i++){
	    balls[i].x = ((float)rand()/(float)(RAND_MAX)) * (float)SCREEN_WIDTH;
	    balls[i].y = ((float)rand()/(float)(RAND_MAX)) * (float)SCREEN_HEIGHT;
	    balls[i].vx = ((float)rand()/(float)(RAND_MAX)) * (float)0.1;
	    balls[i].vy = ((float)rand()/(float)(RAND_MAX)) * (float)0.1;
	  }
	  
	   //Main loop flag
	  bool quit = false;

	  //Event handler
	  SDL_Event e;

	  // how do we clear a struct 
	  struct KEYS keys;
	  keys.up = 0; // arrow keys
	  keys.down = 0;
	  keys.left = 0;
	  keys.right = 0;
	  keys.f1 = 0; // fn keys
	  keys.f2 = 0;
	  keys.f3 = 0;
	  keys.f4 = 0;
	  keys.f5 = 0;
	  keys.f6 = 0;
	  keys.f7 = 0;
	  keys.f8 = 0;
	  keys.f9 = 0;
	  keys.f10 = 0;
	  keys.f11 = 0;
	  keys.f12 = 0;
	  keys.f13 = 0;
	  keys.caps = 0; // caps lock key
	  keys.lshift = 0; // left right shift keys
	  keys.rshift = 0;
	  
	  keys.lalt = 0; // left right alt keys
	  keys.ralt = 0;
	  keys.lctrl = 0; // left right control keys
	  keys.rctrl = 0;

	  /*
	  keys.rmeta = 0;
	  keys.lmeta = 0;
	  keys.rsuper = 0;
	  keys.lsuper = 0;
	  */
	  
	  
	  
	   //While application is running
	  while( !quit ){
            
                //Handle events on queue
                while( SDL_PollEvent( &e ) != 0 )
                {
                    //User requests quit
                    if( e.type == SDL_QUIT )
                    {
                        quit = true;
                    } // QUIT event
		     //User presses a key
                    else if( e.type == SDL_KEYDOWN )
                    {
                        //Select surfaces based on key press
                        switch( e.key.keysym.sym )
                        {
			  case SDLK_ESCAPE:
			    //printf("escape key pressed\n");
			      quit = true;
                            break;
			case SDLK_CAPSLOCK:
			  keys.caps = 1;
			  printf("caps key pressed\n");
			  break;
			case SDLK_LSHIFT:
			  keys.lshift = 1;
			  printf("left shift key pressed\n");
			  break;
			case SDLK_RSHIFT:
			  keys.rshift = 1;
			  printf("right shift key pressed\n");
			  break;

			case SDLK_LALT:
			  keys.lalt = 1;
			  printf("left alt key pressed\n");
			  break;
			case SDLK_RALT:
			  keys.ralt = 1;
			  printf("right alt key pressed\n");
			  break;
			case SDLK_LCTRL:
			  keys.lctrl = 1;
			  printf("left control key pressed\n");
			  break;
			case SDLK_RCTRL:
			  keys.rctrl = 1;
			  printf("right control key pressed\n");
			  break;

			  /*
			case SDLK_LMETA:
			  keys.lmeta = 1;
			  printf("left meta key pressed\n");
			  break;
			case SDLK_RMETA:
			  keys.rmeta = 1;
			  printf("right meta key pressed\n");
			  break;

			case SDLK_LSUPER:
			  keys.lsuper = 1;
			  printf("left super key pressed\n");
			  break;
			case SDLK_RSUPER:
			  keys.rsuper = 1;
			  printf("right super key pressed\n");
			  break;
			  */
			  
			  
			 case SDLK_F1:			      
			      keys.f1 = 1;			      
                            break;
			    case SDLK_F2:			      
			      keys.f2 = 1;			      
                            break;
			    case SDLK_F3:			      
			      keys.f3 = 1;			      
                            break;
			    case SDLK_F4:			      
			      keys.f4 = 1;			      
                            break;
			    case SDLK_F5:			      
			      keys.f5 = 1;			      
                            break;
			    case SDLK_F6:			      
			      keys.f6 = 1;			      
                            break;
			    case SDLK_F7:			      
			      keys.f7 = 1;			      
                            break;
			    case SDLK_F8:			      
			      keys.f8 = 1;			      
                            break;
			    case SDLK_F9:			      
			      keys.f9 = 1;			      
                            break;
			    case SDLK_F10:			      
			      keys.f10 = 1;			      
                            break;
			    case SDLK_F11:			      
			      keys.f11 = 1;			      
                            break;
			    case SDLK_F12:			      
			      keys.f12 = 1;			      
                            break;
			    
			    
			    

                            case SDLK_UP:
			      //printf("key up\n");
			      keys.up = 1;
			      
                            break;

                            case SDLK_DOWN:
			      //printf("key down\n");
			      keys.down = 1;

                            break;

                            case SDLK_LEFT:
			      //printf("key left\n");
			      keys.left = 1;
                            break;

                            case SDLK_RIGHT:
			      //printf("key right\n");
			      keys.right = 1;
                            break;

                            default:
			      // nop 
                            break;
                        }
                    }// keypress SDL_KEYDOWN
		    else if( e.type == SDL_KEYUP )
                    {
                        //Select surfaces based on key press
                        switch( e.key.keysym.sym )
                        {
			  
			    case SDLK_ESCAPE:
			      //printf("escape key up released\n");
                            break;
			case SDLK_LSHIFT:
			  keys.lshift = 0;
			  break;
			case SDLK_RSHIFT:
			  keys.rshift = 0;
			  break;
			case SDLK_CAPSLOCK:
			  keys.caps = 0;
			  break;
			case SDLK_LALT:
			  keys.lalt = 0;
			  break;
			case SDLK_RALT:
			  keys.ralt = 0;
			  break;
			case SDLK_LCTRL:
			  keys.lctrl = 0;
			  break;
			case SDLK_RCTRL:
			  keys.rctrl = 0;
			  break;

			  /*
			case SDLK_LMETA:
			  keys.lmeta = 0;
			  break;
			case SDLK_RMETA:
			  keys.rmeta = 0;
			  break;

			case SDLK_LSUPER:
			  keys.lsuper = 0;
			  break;
			case SDLK_RSUPER:
			  keys.rsuper = 0;
			  break;
			  */
			  
			  
			    case SDLK_F1:			      
			      keys.f1 = 0;			      
                            break;
                            case SDLK_F2:			      
			      keys.f2 = 0;			      
                            break;
			    case SDLK_F3:			      
			      keys.f3 = 0;			      
                            break;
			    case SDLK_F4:			      
			      keys.f4 = 0;			      
                            break;
			    case SDLK_F5:			      
			      keys.f5 = 0;			      
                            break;
			    case SDLK_F6:			      
			      keys.f6 = 0;			      
                            break;
			    case SDLK_F7:			      
			      keys.f7 = 0;			      
                            break;
			    case SDLK_F8:			      
			      keys.f8 = 0;			      
                            break;
			    case SDLK_F9:			      
			      keys.f9 = 0;			      
                            break;
			    case SDLK_F10:			      
			      keys.f10 = 0;			      
                            break;
			    case SDLK_F11:			      
			      keys.f11 = 0;			      
                            break;
			    case SDLK_F12:			      
			      keys.f12 = 0;			      
                            break;
			    case SDLK_UP:
			      keys.up = 0;
                            break;

                            case SDLK_DOWN:
			      //printf("key down released\n");
			      keys.down = 0;
                            break;

                            case SDLK_LEFT:
			      //printf("key left released\n");
			      keys.left = 0;
                            break;

                            case SDLK_RIGHT:
			      //printf("key right released\n");
			      keys.right = 0;
                            break;

                            default:
			      // nop
                            break;
                        }
                    }// keypress SDL_KEYUP
	            else if (e.type == SDL_WINDOWEVENT && e.window.event == SDL_WINDOWEVENT_RESIZED) {
		      // resize event
		      SDL_Window* win = SDL_GetWindowFromID(e.window.windowID);
		      int wid , hgt ;
		      SDL_GL_GetDrawableSize(win, &wid,  &hgt);
		      printf("resizing to %d , %d.....\n",wid,hgt);

		      // resizing the window causes black window to occur 
		      // blit the result
		      SDL_BlitSurface( sdlsurf , NULL, gScreenSurface, NULL );
		      //Update the surface
		      SDL_UpdateWindowSurface( gWindow );
	  
		      /*
		      if (win == (SDL_Window*)data) {
			printf("resizing.....\n");
			}*/
		      
		    }// SDL_WINDOW_RESIZE_EVENT
		    else if( e.type == SDL_MOUSEMOTION ){
		      //Get mouse position
		      SDL_GetMouseState( &(mouse.x), &(mouse.y) );

		    }
		    else if (e.type == SDL_MOUSEBUTTONDOWN){
		      int button_index = e.button.button;
		      if (button_index == 1) {
			mouse.button1 = 1;
		      } else if (button_index == 2) {
			mouse.button2 = 1;
		      } else if (button_index == 3) {
			mouse.button3 = 1;		
		      }
		      printf("mouse button down : %d %d %d \n",mouse.button1, mouse.button2 , mouse.button3);
		    } 
		    else if (e.type == SDL_MOUSEBUTTONUP ){
		      int button_index = e.button.button;
		      if (button_index == 1) {
			mouse.button1 = 0;
		      } else if (button_index == 2) {
			mouse.button2 = 0;
		      } else if (button_index == 3) {
			mouse.button3 = 0;		
		      }
		      printf("mouse buttons released : %d %d %d \n",mouse.button1, mouse.button2 , mouse.button3);
		    }
    
    		}//while SDL_PollEvent 


		// Fill the window with a white rectangle
	SDL_FillRect( sdlsurf, NULL, SDL_MapRGB( sdlsurf->format, 255, 255, 255 ) );

	
	
	/*
		// filled rectangle
	  cairo_set_source_rgb (cr, 0, 0, 0);
	  cairo_rectangle (cr, 0 , 0, SCREEN_WIDTH, SCREEN_HEIGHT);
	  cairo_fill (cr);
	*/
	
		
		    
	  cairo_set_line_width (cr, 0.1);
	  cairo_set_source_rgb (cr, 0, 0, 0);
	  cairo_rectangle (cr, 0.25, 0.25, 0.5, 0.5);
	  cairo_stroke (cr);

	  
	  // fill screen with black - a very tiny portion of screen -- a dot !
	  cairo_set_source_rgb (cr, 0, 0, 0);
	  cairo_rectangle (cr, 0.25, 0.25, 0.5, 0.5);
	  cairo_fill (cr);


	  // line from top left to mouse.x mouse.y -- so we can tell where mouse is
	  /*
	  cairo_set_source_rgb (cr, 0, 0, 0);
	  cairo_set_line_width (cr, 1);
	  cairo_move_to (cr, 0, 0);
	  cairo_line_to (cr, mouse.x, mouse.y);
	  cairo_stroke (cr);
	  */
	  {
	    // draw a circle where mouse 'is'
	    double angle1 = 0.0;
	    double angle2 = 2.0 * M_PI;
	    double radius = 20.0 ;
	    double x = mouse.x;
	    double y = mouse.y;
	    cairo_set_source_rgb (cr, 255, 0, 0);
	    cairo_arc (cr, x, y, radius, angle1, angle2);
	    cairo_fill (cr);	    
	  }

	  
	  // have some text on screen 
	  cairo_set_source_rgb (cr, 0, 0, 0);
	  cairo_move_to (cr, 100, 50);
	  char message[100];
	  sprintf(message, "mouse position %d %d",mouse.x ,mouse.y);
	  cairo_show_text(cr , message );
	  
	  

	  // hollow rectangle
	  cairo_set_line_width (cr, 3);
	  cairo_set_source_rgb (cr, 0, 255, 0);
	  cairo_rectangle (cr, 100, 100, 300, 300);
	  cairo_stroke (cr);

	  // 
	  cairo_set_source_rgb (cr, 255, 255, 0);
	  cairo_rectangle (cr, 0, 0, 200, 200);
	  cairo_stroke (cr);

	  
	  // filled rectangle
	  if (keys.f1){
	    cairo_set_source_rgb (cr, 255, 0, 0);
	    cairo_rectangle (cr, 200 , 200, 200, 200);
	    cairo_fill (cr);
	  }
	  
	  // draw ball
	  for (int i = 0; i < NBALLS; i++){
	    cairo_set_line_width (cr, 1);
	    cairo_set_source_rgb (cr, 0, 0, 255);
	    cairo_rectangle (cr, (int)(balls[i].x) , (int)(balls[i].y), 5, 5);
	    cairo_fill (cr);
	    moveBall(&(balls[i]));
	  }

	  
	  
	  // move box - side to side are mutually destructive 
	  if (keys.right && keys.left){	   
	  }
	  else if (keys.right){
	    box.x = box.x + 5;
	    if (box.x > (SCREEN_WIDTH - box.width)){
	      box.x = (SCREEN_WIDTH - box.width);
	    }
	  }
	  else if (keys.left){
	    box.x = box.x - 5;
	    if (box.x < 0){
	      box.x = 0;
	    }
	  }

	  // move box - up down are mutually destructive
	  if (keys.up && keys.down){	   
	  }
	  else if (keys.up){
	    box.y = box.y - 5;
	    if (box.y < 0){
	      box.y = 0;
	    }
	  }
	  else if (keys.down){
	    box.y = box.y + 5;
	    if (box.y > (SCREEN_HEIGHT - box.height)){
	      box.y = SCREEN_HEIGHT - box.height;
	    }
	  }
	  
	  // draw box
	  cairo_set_line_width (cr, 1);
	  cairo_set_source_rgb (cr, 0, 0, 0);
	  cairo_rectangle (cr, (int)(box.x) , (int)(box.y), 100, 100);
	  cairo_fill (cr);
	  
	  
	  
	  SDL_BlitSurface( sdlsurf , NULL, gScreenSurface, NULL );
	  //Update the surface
	  SDL_UpdateWindowSurface( gWindow );
	  

	  /*
	    //Apply the current image
	    //SDL_BlitSurface( gHelloWorld, NULL, gScreenSurface, NULL );
	    SDL_BlitSurface( gCurrentSurface, NULL, gScreenSurface, NULL );
	    //Update the surface
	    SDL_UpdateWindowSurface( gWindow );	      
	  */

	    
	  }// while !quit	  
	  
        }// loaded media ok
    }
  //Free resources and close SDL
  close();
  return 0;
}


int main(int argc,char **argv){
  printf("hello world\n");
  run();
  return 0;
}


			      
