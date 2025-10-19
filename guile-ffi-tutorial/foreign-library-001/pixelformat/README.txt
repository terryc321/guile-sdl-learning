
make pixelformat->format pointer address avaialble on console when given an sdl_surface



#include <SDL2/SDL.h>
#include <stdio.h>
#include <stddef.h>

void show_pixelformat_format( SDL_Surface *ptr){
     printf("ptr->format%p\n",ptr->format);
}

> how to compile as a shared library ?


LTDL_LIBRARY=./format-offset/ guile
(use-modules (system foreign-library))
(load-shared-library "pixelformat")
(define pixel-format (foreign-library-pointer "pixelformat" "show_pixelformat_format"))

(load "test.scm")
(skooldaze2)


