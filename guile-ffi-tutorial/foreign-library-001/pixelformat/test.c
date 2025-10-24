
#include <SDL2/SDL.h>
#include <SDL2/SDL_image.h>

#include <math.h>
#include <stdio.h>
#include <stddef.h>

#include <libguile.h>


void pixelformat2(SDL_Surface *ptr);
SDL_PixelFormat *pixelformat_wrapper(SDL_Surface *ptr);
void output_check();


int surface_width(SDL_Surface *s){
  return s->w;
}

int surface_height(SDL_Surface *s){
  return s->h;
}


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
try
 (applyStretchedImage surface 1024 768)
 => error
guile: symbol lookup error: ./pixelformat/pixelformat.so: undefined symbol: SDL_UpperBlitScaled


  
int SDL_UpperBlitScaled
    (SDL_Surface * src, const SDL_Rect * srcrect,
    SDL_Surface * dst, SDL_Rect * dstrect);

    
 */


SDL_Surface *applyStretchedImage(SDL_Surface *gScreenSurface, int screenWidth , int screenHeight){
  //Apply the image stretched
  SDL_Rect stretchRect;
  stretchRect.x = 0;
  stretchRect.y = 0;
  stretchRect.w = screenWidth;
  stretchRect.h = screenHeight;
  SDL_Surface* gStretchedSurface;
  // but this is equivalent to SDL_UpperBlitScaled gStretced NULL gScreen NULL
  // no point in defining rect 
  SDL_BlitScaled( gStretchedSurface, NULL, gScreenSurface, &stretchRect );
  return gStretchedSurface;
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

/*
SDL_Texture* loadTexture( char *path , SDL_Renderer *render)
{
    //The final texture
    SDL_Texture* newTexture = NULL;

    //Load image at specified path
    SDL_Surface* loadedSurface = IMG_Load( path );
    if( loadedSurface == NULL )
    {
        printf( "Unable to load image %s! SDL_image Error: %s\n", path, IMG_GetError() );
    }
    else
    {
        //Create texture from surface pixels
        newTexture = SDL_CreateTextureFromSurface( render, loadedSurface );
        if( newTexture == NULL )
        {
            printf( "Unable to create texture from %s! SDL Error: %s\n", path, SDL_GetError() );
        }

        //Get rid of old loaded surface
        SDL_FreeSurface( loadedSurface );
    }

    return newTexture;
}
*/

int size_int(){
  size_t sz = sizeof(int);
  //fprintf(stdout,"size of int is %zu\n",sz);
  return sz;  
}

void show_rect(SDL_Rect *r){
  fprintf(stdout,"rect has x,y,w,h of %d %d %d %d \n" , r->x ,r->y,r->w , r->h);
}


