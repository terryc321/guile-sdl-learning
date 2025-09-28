
#include <stdio.h>
#include <math.h>
#include <SDL2/SDL.h>
#include <stdbool.h>

#define SCREEN_WIDTH 640
#define SCREEN_HEIGHT 480
#define WINDOW_X 200
#define WINDOW_Y 200

//Key press surfaces constants
enum KeyPressSurfaces
{
    KEY_PRESS_SURFACE_DEFAULT,
    KEY_PRESS_SURFACE_UP,
    KEY_PRESS_SURFACE_DOWN,
    KEY_PRESS_SURFACE_LEFT,
    KEY_PRESS_SURFACE_RIGHT,
    KEY_PRESS_SURFACE_TOTAL
};


//Starts up SDL and creates window
bool init();

//Loads media
bool loadMedia();

//Frees media and shuts down SDL
void close();

//Loads individual image
SDL_Surface* loadSurface( char* path );

//The images that correspond to a keypress
SDL_Surface* gKeyPressSurfaces[ KEY_PRESS_SURFACE_TOTAL ];

//The window we'll be rendering to
SDL_Window* gWindow = NULL;
    
//The surface contained by the window
SDL_Surface* gScreenSurface = NULL;

//The image we will load and show on the screen
SDL_Surface* gHelloWorld = NULL;


//Current displayed image
SDL_Surface* gCurrentSurface = NULL;

bool init()
{
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
      gWindow = SDL_CreateWindow( "SDL Tutorial", WINDOW_X , WINDOW_Y , SCREEN_WIDTH, SCREEN_HEIGHT,
				  SDL_WINDOW_SHOWN
				  | SDL_WINDOW_RESIZABLE
				  | SDL_WINDOW_ALLOW_HIGHDPI
				  );
      if( gWindow == NULL )
        {
	  printf( "Window could not be created! SDL_Error: %s\n", SDL_GetError() );
	  success = false;
        }
      else
        {
	  //Get window surface
	  gScreenSurface = SDL_GetWindowSurface( gWindow );
        }
    }

  return success;
}


SDL_Surface* loadSurface( const char* path )
{
    //Load image at specified path
    SDL_Surface* loadedSurface = SDL_LoadBMP( path );
    if( loadedSurface == NULL )
    {
        printf( "Unable to load image %s! SDL Error: %s\n", path, SDL_GetError() );
    }
    return loadedSurface;
}


bool loadMedia()
{
  //Loading success flag
  bool success = true;

  //Load default surface
    gKeyPressSurfaces[ KEY_PRESS_SURFACE_DEFAULT ] = loadSurface( "press.bmp" );
    if( gKeyPressSurfaces[ KEY_PRESS_SURFACE_DEFAULT ] == NULL )
    {
        printf( "Failed to load default image!\n" );
        success = false;
    }

    //Load up surface
    gKeyPressSurfaces[ KEY_PRESS_SURFACE_UP ] = loadSurface( "up.bmp" );
    if( gKeyPressSurfaces[ KEY_PRESS_SURFACE_UP ] == NULL )
    {
        printf( "Failed to load up image!\n" );
        success = false;
    }

    //Load down surface
    gKeyPressSurfaces[ KEY_PRESS_SURFACE_DOWN ] = loadSurface( "down.bmp" );
    if( gKeyPressSurfaces[ KEY_PRESS_SURFACE_DOWN ] == NULL )
    {
        printf( "Failed to load down image!\n" );
        success = false;
    }

    //Load left surface
    gKeyPressSurfaces[ KEY_PRESS_SURFACE_LEFT ] = loadSurface( "left.bmp" );
    if( gKeyPressSurfaces[ KEY_PRESS_SURFACE_LEFT ] == NULL )
    {
        printf( "Failed to load left image!\n" );
        success = false;
    }

    //Load right surface
    gKeyPressSurfaces[ KEY_PRESS_SURFACE_RIGHT ] = loadSurface( "right.bmp" );
    if( gKeyPressSurfaces[ KEY_PRESS_SURFACE_RIGHT ] == NULL )
    {
        printf( "Failed to load right image!\n" );
        success = false;
    }
    
    /*
  //Load splash image
  gHelloWorld = SDL_LoadBMP( "hello_world.bmp" );
  if( gHelloWorld == NULL )
    {
      printf( "Unable to load image %s! SDL Error: %s\n", "hello_world.bmp", SDL_GetError() );
      success = false;
    }
    */

  return success;
}


void close()
{
  //Deallocate surface
  if(gHelloWorld){
  SDL_FreeSurface( gHelloWorld );
  gHelloWorld = NULL;
  }

  int i;
  for (i = 0 ; i < KEY_PRESS_SURFACE_TOTAL ; i ++){
    SDL_FreeSurface(gKeyPressSurfaces[i]);
  }
  
  //Destroy window
  if(gWindow){
  SDL_DestroyWindow( gWindow );
  gWindow = NULL;
  }
  

  //Quit SDL subsystems
  SDL_Quit();
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
	  /* */
	  /* //Apply the image */
	  /* SDL_BlitSurface( gHelloWorld, NULL, gScreenSurface, NULL ); */
	  /* //Update the surface */
	  /* SDL_UpdateWindowSurface( gWindow ); */

	  //Main loop flag
	  bool quit = false;

	  //Event handler
	  SDL_Event e;

	  //Set default current surface
	  gCurrentSurface = gKeyPressSurfaces[ KEY_PRESS_SURFACE_DEFAULT ];
	  
	   //While application is running
            while( !quit )
            
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
			  /*
			    case SDLK_A:
			      //gCurrentSurface = gKeyPressSurfaces[ KEY_PRESS_SURFACE_UP ];
			      printf("key A\n");
                            break;
			    case SDLK_a:
			      //gCurrentSurface = gKeyPressSurfaces[ KEY_PRESS_SURFACE_UP ];
			      printf("key a\n");
                            break;
			  */
			  
			    case SDLK_ESCAPE:
			      gCurrentSurface = gKeyPressSurfaces[ KEY_PRESS_SURFACE_UP ];
			      printf("escape key pressed\n");
			      quit = true;
                            break;
                            case SDLK_UP:
			      gCurrentSurface = gKeyPressSurfaces[ KEY_PRESS_SURFACE_UP ];
			      printf("key up\n");
                            break;

                            case SDLK_DOWN:
			      gCurrentSurface = gKeyPressSurfaces[ KEY_PRESS_SURFACE_DOWN ];
			      printf("key down\n");
                            break;

                            case SDLK_LEFT:
			      gCurrentSurface = gKeyPressSurfaces[ KEY_PRESS_SURFACE_LEFT ];
			      printf("key left\n");
                            break;

                            case SDLK_RIGHT:
			      gCurrentSurface = gKeyPressSurfaces[ KEY_PRESS_SURFACE_RIGHT ];
			      printf("key right\n");
                            break;

                            default:
			      gCurrentSurface = gKeyPressSurfaces[ KEY_PRESS_SURFACE_DEFAULT ];
                            break;
                        }
                    }// keypress SDL_KEYDOWN
		    else if( e.type == SDL_KEYUP )
                    {
                        //Select surfaces based on key press
                        switch( e.key.keysym.sym )
                        {
			  
			    case SDLK_ESCAPE:
			      //gCurrentSurface = gKeyPressSurfaces[ KEY_PRESS_SURFACE_UP ];
			      printf("escape key up released\n");
                            break;
                            case SDLK_UP:
			      //gCurrentSurface = gKeyPressSurfaces[ KEY_PRESS_SURFACE_UP ];
			      printf("key up released\n");
                            break;

                            case SDLK_DOWN:
			      //gCurrentSurface = gKeyPressSurfaces[ KEY_PRESS_SURFACE_DOWN ];
			      printf("key down released\n");
                            break;

                            case SDLK_LEFT:
			      //gCurrentSurface = gKeyPressSurfaces[ KEY_PRESS_SURFACE_LEFT ];
			      printf("key left released\n");
                            break;

                            case SDLK_RIGHT:
			      //gCurrentSurface = gKeyPressSurfaces[ KEY_PRESS_SURFACE_RIGHT ];
			      printf("key right released\n");
                            break;

                            default:
			      //gCurrentSurface = gKeyPressSurfaces[ KEY_PRESS_SURFACE_DEFAULT ];
                            break;
                        }
                    }// keypress SDL_KEYUP
	            else if (e.type == SDL_WINDOWEVENT && e.window.event == SDL_WINDOWEVENT_RESIZED) {
		      SDL_Window* win = SDL_GetWindowFromID(e.window.windowID);
		      int wid , hgt ;
		      SDL_GL_GetDrawableSize(win, &wid,  &hgt);
		      printf("resizing to %d , %d.....\n",wid,hgt);
		      /*
		      if (win == (SDL_Window*)data) {
			printf("resizing.....\n");
			}*/
		      
		    }// SDL_WINDOW_RESIZE_EVENT

		    
	    //Apply the current image
	    //SDL_BlitSurface( gHelloWorld, NULL, gScreenSurface, NULL );
	    SDL_BlitSurface( gCurrentSurface, NULL, gScreenSurface, NULL );
	    //Update the surface
	    SDL_UpdateWindowSurface( gWindow );	      


		}//while SDL_PollEvent 
	    
	  
	      } // else media'loaded ok
    }//else init'ed
  //Free resources and close SDL
  close();
  return 0;
}


int main(int argc,char **argv){
  printf("hello world\n");
  run();
  return 0;
}


			      
