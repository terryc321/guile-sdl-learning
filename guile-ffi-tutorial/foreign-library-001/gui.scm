
;; can we alter LTDL_LIBRARY_PATH to point to current directory and also ./pixelformat directory ?

(load "pixelformat/pixelformat.scm")
;;(load "pixelformat.scm")

#|

guile sdl2 ffi file 

LTDL_LIBRARY_PATH=./:./pixelformat/ guile

file:///usr/share/doc/guile-3.0.10/ref/Foreign-Pointers.html
(use-modules (system foreign))
%null-pointer

file:///usr/share/doc/guile-3.0.10/ref/Foreign-Libraries.html
(use-modules (system foreign-library))


template for foreign function calls
all pointers are a single quoted asterisk '*
unsigned uint8 unit16 unit32 uint64  << check !
signed sint8 sint16 sint32 sint64    >> check !

(define sdl-XXXX
  (foreign-library-function "libSDL2" "SDL_XXXXX"
			    #:return-type '*
                            #:arg-types (list '* '* uint32)))


sdl foreign libraries found in directory { /usr/lib/x86_64-linux-gnu/ }

libSDL-1.2.so.0
libSDL-1.2.so.1.2.68
libSDL2-2.0.so
libSDL2-2.0.so.0
libSDL2-2.0.so.0.3000.0
libSDL2.a
libSDL2_image-2.0.so.0             <----- this is NOT sdl2 image library for development
          need to sudo apt install libsdl2-image-dev
then will see
libSDL2_image.so        <----- this is correct SDL2 image library
  sudo apt install libsdl2-image-dev 

libSDL2_image-2.0.so.0.800.2
libSDL2main.a
libSDL2_mixer-2.0.so
libSDL2_mixer-2.0.so.0
libSDL2_mixer-2.0.so.0.800.0
libSDL2_mixer.a
libSDL2_mixer.so                     <----- sdl2 sound shared library
libSDL2.so                           <--------- SDL2 shared library
libSDL2_test.a
libSDL2_ttf-2.0.so                   
libSDL2_ttf-2.0.so.0
libSDL2_ttf-2.0.so.0.2200.0
libSDL2_ttf.a
libSDL2_ttf.so                      <----- sdl2 true type font shared library


suppose we have to convert this expression in C to guile scheme ffi code 

gScreenSurface->format

question 1 . what is the structure ? here it is an SDL_Surface

typedef struct SDL_Surface
{
    Uint32 flags;               /**< Read-only */
    SDL_PixelFormat *format;    /**< Read-only */  <<<<<<<<< here is the format member
    int w, h;                   /**< Read-only */
    int pitch;                  /**< Read-only */
    void *pixels;               /**< Read-write */

    /** Application data associated with the surface */
    void *userdata;             /**< Read-write */

    /** information needed for surfaces requiring locks */
    int locked;                 /**< Read-only */

    /** list of BlitMap that hold a reference to this surface */
    void *list_blitmap;         /**< Private */

    /** clipping information */
    SDL_Rect clip_rect;         /**< Read-only */

    /** info for fast blit mapping to other surfaces */
    SDL_BlitMap *map;           /**< Private */

    /** Reference count -- used when freeing surface */
    int refcount;               /**< Read-mostly */
} SDL_Surface;


question 2 . what is the offset of the format structure member in bytes from structure start ?

we can write a C file to tell us this directly rather than guess

#include <stdio.h>
#include <stddef.h> 
#include <SDL2/SDL.h>
#include <cairo/cairo.h>

int main(){

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

}

offsets and sizes are all in bytes for complete consistency across all types 

================= SDL_Surface ============= 
SDL_Surface has size in bytes of : 96
SDL_Surface flags : offset 0 : size 4
SDL_Surface format : offset 8 : size 8          <<<<<<<< here is our format member at offset 8 with size 8 bytes
SDL_Surface w: offset 16 : size 4
SDL_Surface h : offset 20 : size 4
SDL_Surface pitch :  offset 24 : size 4
SDL_Surface pixels : offset 32 : size 8
SDL_Surface userdata: offset 40 : size 8
SDL_Surface locked : offset 48 : size 4
SDL_Surface list_blitmap : offset 56 : size 8
SDL_Surface clip_rect : offset 64 : size 16
SDL_Surface map : offset  80 : size 8
SDL_Surface refcount : offset 88 : size 4


question 3 : how do we fully code this up in guile scheme ?

SDL_PixelFormat *format;  

we simply need to convert byte offset 8 of pointer to another pointer

(define gScreenSurface->format (make-pointer (+ (pointer-address gSurface) 8)))
this will not work as pointer value is actually encoded in the surface structure itself
take 8 bytes from pointer address (+ (pointer-address gSurface) 8) to  (+ (pointer-address gSurface) 16)
then form pointer from this




> guile
(load "test.scm")
(skooldaze2)
- mouse x,y
- keyboard io
- sdl-fillrect coloured squares


< building guile scheme from github repository > 

git clone -b 'v2.0' --single-branch --depth 1 https://github.com/git/git.git
git clone --branch 'main' --single-branch --depth 1 https://cgit.git.savannah.gnu.org/cgit/guile.git
git clone --branch 'main' --single-branch --depth 1 https://git.savannah.gnu.org/git/guile.git

single byte does not have an endianness
our computer is little endianness

no scheme procedure bytevector-u8-native-ref just bytevector-u8-ref only for reason no endianness therefore no native
required as both big little endianness will give same result


6.6.12.3 Interpreting Bytevector Contents as Integers
The contents of a bytevector can be interpreted as a sequence of integers of any given size, sign, and endianness.

(let ((bv (make-bytevector 4)))
  (bytevector-u8-set! bv 0 #x12)
  (bytevector-u8-set! bv 1 #x34)
  (bytevector-u8-set! bv 2 #x56)
  (bytevector-u8-set! bv 3 #x78)

  (map (lambda (number)
         (number->string number 16))
       (list (bytevector-u8-ref bv 0)
             (bytevector-u16-ref bv 0 (endianness big))
             (bytevector-u32-ref bv 0 (endianness little)))))

⇒ ("12" "1234" "78563412")
The most generic procedures to interpret bytevector contents as integers are described below.

Scheme Procedure: bytevector-uint-ref bv index endianness size
C Function: scm_bytevector_uint_ref (bv, index, endianness, size)
Return the size-byte long unsigned integer at index index in bv, decoded according to endianness.

Scheme Procedure: bytevector-sint-ref bv index endianness size
C Function: scm_bytevector_sint_ref (bv, index, endianness, size)
Return the size-byte long signed integer at index index in bv, decoded according to endianness.

Scheme Procedure: bytevector-uint-set! bv index value endianness size
C Function: scm_bytevector_uint_set_x (bv, index, value, endianness, size)
Set the size-byte long unsigned integer at index to value, encoded according to endianness.

Scheme Procedure: bytevector-sint-set! bv index value endianness size
C Function: scm_bytevector_sint_set_x (bv, index, value, endianness, size)
Set the size-byte long signed integer at index to value, encoded according to endianness.

The following procedures are similar to the ones above, but specialized to a given integer size:

Scheme Procedure: bytevector-u8-ref bv index
Scheme Procedure: bytevector-s8-ref bv index
Scheme Procedure: bytevector-u16-ref bv index endianness
Scheme Procedure: bytevector-s16-ref bv index endianness
Scheme Procedure: bytevector-u32-ref bv index endianness
Scheme Procedure: bytevector-s32-ref bv index endianness
Scheme Procedure: bytevector-u64-ref bv index endianness
Scheme Procedure: bytevector-s64-ref bv index endianness
C Function: scm_bytevector_u8_ref (bv, index)
C Function: scm_bytevector_s8_ref (bv, index)
C Function: scm_bytevector_u16_ref (bv, index, endianness)
C Function: scm_bytevector_s16_ref (bv, index, endianness)
C Function: scm_bytevector_u32_ref (bv, index, endianness)
C Function: scm_bytevector_s32_ref (bv, index, endianness)
C Function: scm_bytevector_u64_ref (bv, index, endianness)
C Function: scm_bytevector_s64_ref (bv, index, endianness)
Return the unsigned n-bit (signed) integer (where n is 8, 16, 32 or 64) from bv at index, decoded according to endianness.

Scheme Procedure: bytevector-u8-set! bv index value
Scheme Procedure: bytevector-s8-set! bv index value
Scheme Procedure: bytevector-u16-set! bv index value endianness
Scheme Procedure: bytevector-s16-set! bv index value endianness
Scheme Procedure: bytevector-u32-set! bv index value endianness
Scheme Procedure: bytevector-s32-set! bv index value endianness
Scheme Procedure: bytevector-u64-set! bv index value endianness
Scheme Procedure: bytevector-s64-set! bv index value endianness
C Function: scm_bytevector_u8_set_x (bv, index, value)
C Function: scm_bytevector_s8_set_x (bv, index, value)
C Function: scm_bytevector_u16_set_x (bv, index, value, endianness)
C Function: scm_bytevector_s16_set_x (bv, index, value, endianness)
C Function: scm_bytevector_u32_set_x (bv, index, value, endianness)
C Function: scm_bytevector_s32_set_x (bv, index, value, endianness)
C Function: scm_bytevector_u64_set_x (bv, index, value, endianness)
C Function: scm_bytevector_s64_set_x (bv, index, value, endianness)
Store value as an n-bit (signed) integer (where n is 8, 16, 32 or 64) in bv at index, encoded according to endianness.

Finally, a variant specialized for the host’s endianness is available for each of these functions (with the exception of the u8 and s8 accessors, as endianness is about byte order and there is only 1 byte):

Scheme Procedure: bytevector-u16-native-ref bv index
Scheme Procedure: bytevector-s16-native-ref bv index
Scheme Procedure: bytevector-u32-native-ref bv index
Scheme Procedure: bytevector-s32-native-ref bv index
Scheme Procedure: bytevector-u64-native-ref bv index
Scheme Procedure: bytevector-s64-native-ref bv index
C Function: scm_bytevector_u16_native_ref (bv, index)
C Function: scm_bytevector_s16_native_ref (bv, index)
C Function: scm_bytevector_u32_native_ref (bv, index)
C Function: scm_bytevector_s32_native_ref (bv, index)
C Function: scm_bytevector_u64_native_ref (bv, index)
C Function: scm_bytevector_s64_native_ref (bv, index)
Return the unsigned n-bit (signed) integer (where n is 8, 16, 32 or 64) from bv at index, decoded according to the host’s native endianness.

Scheme Procedure: bytevector-u16-native-set! bv index value
Scheme Procedure: bytevector-s16-native-set! bv index value
Scheme Procedure: bytevector-u32-native-set! bv index value
Scheme Procedure: bytevector-s32-native-set! bv index value
Scheme Procedure: bytevector-u64-native-set! bv index value
Scheme Procedure: bytevector-s64-native-set! bv index value ¶
C Function: scm_bytevector_u16_native_set_x (bv, index, value)
C Function: scm_bytevector_s16_native_set_x (bv, index, value)
C Function: scm_bytevector_u32_native_set_x (bv, index, value)
C Function: scm_bytevector_s32_native_set_x (bv, index, value)
C Function: scm_bytevector_u64_native_set_x (bv, index, value)
C Function: scm_bytevector_s64_native_set_x (bv, index, value)
Store value as an n-bit (signed) integer (where n is 8, 16, 32 or 64) in bv at index, encoded according to the host’s native endianness.



From Scheme’s perspective, foreign pointers are shards of chaos. The user can create a foreign pointer for any address, and do with it what they will. The only thing that lends a sense of order to the whole is a shared hallucination that certain storage locations have certain types. When making Scheme wrappers for foreign interfaces, we hide the madness by explicitly representing the the data types of parameters and fields.

These “foreign type values” may be constructed using the constants and procedures from the (system foreign) module, which may be loaded like this:

(use-modules (system foreign))
(system foreign) exports a number of values expressing the basic C types.

Scheme Variable: int8
Scheme Variable: uint8
Scheme Variable: uint16
Scheme Variable: int16
Scheme Variable: uint32
Scheme Variable: int32
Scheme Variable: uint64
Scheme Variable: int64
Scheme Variable: float
Scheme Variable: double
Scheme Variable: complex-double
Scheme Variable: complex-float
These values represent the C numeric types of the specified sizes and signednesses. complex-float and complex-double stand for C99 float _Complex and double _Complex respectively.

In addition there are some convenience bindings for indicating types of platform-dependent size.

Scheme Variable: int
Scheme Variable: unsigned-int
Scheme Variable: long
Scheme Variable: unsigned-long
Scheme Variable: short
Scheme Variable: unsigned-short
Scheme Variable: size_t
Scheme Variable: ssize_t
Scheme Variable: ptrdiff_t
Scheme Variable: intptr_t
Scheme Variable: uintptr_t
Values exported by the (system foreign) module, representing C numeric types. For example, long may be equal? to int64 on a 64-bit platform.

Scheme Variable: void
The void type. It can be used as the first argument to pointer->procedure to wrap a C function that returns nothing.

In addition, the symbol * is used by convention to denote pointer types. Procedures detailed in the following sections, such as pointer->procedure, accept it as a type descriptor.

|#

;; 6.19.5 Foreign Functions - guile manual
(use-modules (system foreign))
(use-modules (system foreign-library))

;; byte vectors for foreign structure creation ?
(use-modules (rnrs bytevectors))

;; this may or may not be a correct definition of null 
(define *null* (make-pointer 0))


;; from /usr/include/SDL2/SDL.h
;; although C macro 0x0000u  the u means unsigned ??
;;
;; #define SDL_INIT_TIMER          0x00000001u
;; #define SDL_INIT_AUDIO          0x00000010u
;; #define SDL_INIT_VIDEO          0x00000020u  /**< SDL_INIT_VIDEO implies SDL_INIT_EVENTS */
;; #define SDL_INIT_JOYSTICK       0x00000200u  /**< SDL_INIT_JOYSTICK implies SDL_INIT_EVENTS */
;; #define SDL_INIT_HAPTIC         0x00001000u
;; #define SDL_INIT_GAMECONTROLLER 0x00002000u  /**< SDL_INIT_GAMECONTROLLER implies SDL_INIT_JOYSTICK */
;; #define SDL_INIT_EVENTS         0x00004000u
;; #define SDL_INIT_SENSOR         0x00008000u
;; #define SDL_INIT_NOPARACHUTE    0x00100000u  /**< compatibility; this flag is ignored. */
;; #define SDL_INIT_EVERYTHING ( \
;;                 SDL_INIT_TIMER | SDL_INIT_AUDIO | SDL_INIT_VIDEO | SDL_INIT_EVENTS | \
;;                 SDL_INIT_JOYSTICK | SDL_INIT_HAPTIC | SDL_INIT_GAMECONTROLLER | SDL_INIT_SENSOR \
;;             )
(define *constant-sdl-init-timer*             #x00000001)
(define *constant-sdl-init-audio*             #x00000010)
(define *constant-sdl-init-video*             #x00000020)
(define *constant-sdl-init-joystick*          #x00000200)
(define *constant-sdl-init-haptic*            #x00001000)
(define *constant-sdl-init-gamecontroller*    #x00002000)
(define *constant-sdl-init-events*            #x00004000)
(define *constant-sdl-init-sensor*            #x00008000)
(define *constant-sdl-init-parachute*         #x00100000)
;; C logical or | is guile logior logical inclusive or
(define *constant-sdl-init-everything*   (logior *constant-sdl-init-timer*
						 *constant-sdl-init-audio*
						 *constant-sdl-init-video*
						 *constant-sdl-init-events*
						 *constant-sdl-init-joystick*
						 *constant-sdl-init-haptic*
						 *constant-sdl-init-gamecontroller*
						 *constant-sdl-init-sensor*))




;; SDL_Init()

;; look for libSDL2.so 
(define sdl-init
  (foreign-library-function "libSDL2" "SDL_Init"
                            #:return-type int
                            #:arg-types (list int)))

(define (test-sdl-init)
  (sdl-init *constant-sdl-init-everything*))

;; gWindow = SDL_CreateWindow( "SDL Tutorial", WINDOW_X , WINDOW_Y , SCREEN_WIDTH, SCREEN_HEIGHT, SDL_WINDOW_SHOWN );


;; how convert a scheme string to c string ??
;; ;;
;; typedef enum
;; {
;;     SDL_WINDOW_FULLSCREEN = 0x00000001,         /**< fullscreen window */
;;     SDL_WINDOW_OPENGL = 0x00000002,             /**< window usable with OpenGL context */
;;     SDL_WINDOW_SHOWN = 0x00000004,              /**< window is visible */
;;     SDL_WINDOW_HIDDEN = 0x00000008,             /**< window is not visible */
;;     SDL_WINDOW_BORDERLESS = 0x00000010,         /**< no window decoration */
;;     SDL_WINDOW_RESIZABLE = 0x00000020,          /**< window can be resized */
;;     SDL_WINDOW_MINIMIZED = 0x00000040,          /**< window is minimized */
;;     SDL_WINDOW_MAXIMIZED = 0x00000080,          /**< window is maximized */
;;     SDL_WINDOW_MOUSE_GRABBED = 0x00000100,      /**< window has grabbed mouse input */
;;     SDL_WINDOW_INPUT_FOCUS = 0x00000200,        /**< window has input focus */
;;     SDL_WINDOW_MOUSE_FOCUS = 0x00000400,        /**< window has mouse focus */
;;     SDL_WINDOW_FULLSCREEN_DESKTOP = ( SDL_WINDOW_FULLSCREEN | 0x00001000 ),
;;     SDL_WINDOW_FOREIGN = 0x00000800,            /**< window not created by SDL */
;;     SDL_WINDOW_ALLOW_HIGHDPI = 0x00002000,      /**< window should be created in high-DPI mode if supported.
;;                                                      On macOS NSHighResolutionCapable must be set true in the
;;                                                      application's Info.plist for this to have any effect. */
;;     SDL_WINDOW_MOUSE_CAPTURE    = 0x00004000,   /**< window has mouse captured (unrelated to MOUSE_GRABBED) */
;;     SDL_WINDOW_ALWAYS_ON_TOP    = 0x00008000,   /**< window should always be above others */
;;     SDL_WINDOW_SKIP_TASKBAR     = 0x00010000,   /**< window should not be added to the taskbar */
;;     SDL_WINDOW_UTILITY          = 0x00020000,   /**< window should be treated as a utility window */
;;     SDL_WINDOW_TOOLTIP          = 0x00040000,   /**< window should be treated as a tooltip */
;;     SDL_WINDOW_POPUP_MENU       = 0x00080000,   /**< window should be treated as a popup menu */
;;     SDL_WINDOW_KEYBOARD_GRABBED = 0x00100000,   /**< window has grabbed keyboard input */
;;     SDL_WINDOW_VULKAN           = 0x10000000,   /**< window usable for Vulkan surface */
;;     SDL_WINDOW_METAL            = 0x20000000,   /**< window usable for Metal view */

;;     SDL_WINDOW_INPUT_GRABBED = SDL_WINDOW_MOUSE_GRABBED /**< equivalent to SDL_WINDOW_MOUSE_GRABBED for compatibility */
;; } SDL_WindowFlags;

;; guile #x10 means HEX of 10 -- equivalent of decimal 16
(define *constant-sdl-window-fullscreen* #x00000001)
(define *constant-sdl-window-opengl* #x00000002)
(define *constant-sdl-window-shown* #x00000004)
(define *constant-sdl-window-hidden* #x00000008)
(define *constant-sdl-window-borderless* #x00000010)
(define *constant-sdl-window-resizeable* #x00000020)
(define *constant-sdl-window-minimized* #x00000040)
(define *constant-sdl-window-maximized* #x00000080)
(define *constant-sdl-window-mouse-grabbed* #x000000100)
(define *constant-sdl-window-input-focus* #x000000200)
(define *constant-sdl-window-mouse-focus* #x000000400)
;; bitwise OR -- in guile called logical inclusive or (logior
(define *constant-sdl-window-fullscreen-desktop* (logior *constant-sdl-window-fullscreen* #x0001000))
(define *constant-sdl-window-foreign* #x000000800)
(define *constant-sdl-window-allow-highdpi* #x0000002000)
(define *constant-sdl-window-mouse-capture* #x0000004000)
(define *constant-sdl-window-always-on-top* #x0000008000)
(define *constant-sdl-window-skip-taskbar* #x00000010000)
(define *constant-sdl-window-utility* #x00000020000)
(define *constant-sdl-window-tooltip* #x00000040000)
(define *constant-sdl-window-popup-menu* #x00000080000)
(define *constant-sdl-window-keyboard-grabbed* #x00100000)
(define *constant-sdl-window-vulkan* #x10000000)
(define *constant-sdl-window-metal*  #x20000000)

;; how represent a char* in guile ffi ??
;; #:return-type '*  means a pointer   :: a quoted star symbol '*  , not scheme * multiply symbol
;; #:arg-types (list 
(define sdl-create-window 
  (foreign-library-function "libSDL2" "SDL_CreateWindow"
                            #:return-type '*
                            #:arg-types (list '* int int int int int)))


;; guile string -> char* use : string->pointer :
;; example
;; (string->pointer "my window")
;; will return an appropriate ? null terminated ? char* ?? for the guile string "my window"

;; convenience middle of my screen 1920 x 1080 default resolution
(define (create-window title width height)
  (let ((x (floor (/ (- 1920 width) 2)))
	(y (floor (/ (- 1080 height) 2)))
	(flags (logior ;;*constant-sdl-window-fullscreen-desktop*
		        *constant-sdl-window-resizeable*
		        *constant-sdl-window-allow-highdpi*
			*constant-sdl-window-always-on-top*
			;;*constant-sdl-window-fullscreen*
		       ;;*constant-sdl-window-borderless*
		       *constant-sdl-window-shown*)))
    (sdl-create-window (string->pointer title) x y width height flags)))



;; gScreenSurface = SDL_GetWindowSurface( gWindow );
(define sdl-get-window-surface 
  (foreign-library-function "libSDL2" "SDL_GetWindowSurface"
                            #:return-type '*
                            #:arg-types (list '* )))


(define sdl-quit
  (foreign-library-function "libSDL2" "SDL_Quit"
                            #:return-type void
                            #:arg-types '()))


;; void SDL_FreeSurface(SDL_Surface * surface)
(define sdl-free-surface
  (foreign-library-function "libSDL2" "SDL_FreeSurface"
                            #:return-type void
                            #:arg-types (list '*)))



;;SDL_Surface* SDL_LoadBMP_RW(SDL_RWops * src, int freesrc);
(define sdl-load-bmp-rw
  (foreign-library-function "libSDL2" "SDL_LoadBMP_RW"
                            #:return-type '*
                            #:arg-types (list '* int)))


;; SDL_RWops* SDL_RWFromFile(const char *file, const char *mode);
(define sdl-rw-from-file
  ;; " guile ffi need string->pointer "
  (foreign-library-function "libSDL2" "SDL_RWFromFile"
                            #:return-type '*
                            #:arg-types (list '* '*)))


;; #define SDL_LoadBMP(file)   SDL_LoadBMP_RW(SDL_RWFromFile(file, "rb"), 1)
(define (sdl-load-bmp filename)
  "SDL_LoadBMP is a macro in C land
 becomes two required routines
 SDL_RWFromFile(file, \"rb\")
 SDL_LoadBMP_RW
 "
  (sdl-load-bmp-rw (sdl-rw-from-file (string->pointer filename) (string->pointer "rb")) 1))


;; int SDL_ShowCursor(int toggle);
(define sdl-show-cursor
  (foreign-library-function "libSDL2" "SDL_ShowCursor"
                            #:return-type int
                            #:arg-types (list int)))




#|
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
|#

(define (load-texture path render)
  (define loaded-surface (%img-load (string->pointer path)))
  (cond
   ((equal? loaded-surface %null-pointer)
    (format #t "unable to load image ~a ~%" path)
    %null-pointer)
   (#t (let ((new-texture (sdl-create-texture-from-surface render loaded-surface)))
	 (cond
	  ((equal? new-texture %null-pointer)
	   (format #t "unable to create texture from image ~a ~%" path)
	   %null-pointer)
	  (#t (sdl-free-surface loaded-surface)
	      new-texture))))))


(define img-quit
  (foreign-library-function "libSDL2_image" "IMG_Quit"
                            #:return-type void
                            #:arg-types (list )))



  


;; nm -D /usr/lib/x86_64-linux-gnu/libSDL2.so | grep SDL_LoadBMP
;; 000000000004c620 T SDL_LoadBMP_RW
;;
;; C macros strikes again - no such thing in shared library 
;; In procedure dlsym: Error resolving "SDL_LoadBMP": "/usr/lib/x86_64-linux-gnu/libSDL2.so: undefined symbol: SDL_LoadBMP"
;;  #define SDL_LoadBMP(file)   SDL_LoadBMP_RW(SDL_RWFromFile(file, "rb"), 1)
;;


;; usage
;;SDL_DestroyWindow( gWindow );
(define sdl-destroy-window
  (foreign-library-function "libSDL2" "SDL_DestroyWindow"
                            #:return-type void
                            #:arg-types (list '* )))


;;SDL_Texture * SDL_CreateTextureFromSurface(SDL_Renderer * renderer, SDL_Surface * surface);
(define sdl-create-texture-from-surface
  (foreign-library-function "libSDL2" "SDL_CreateTextureFromSurface"
                            #:return-type '*
                            #:arg-types (list '* '*)))


;;void SDL_DestroyTexture(SDL_Texture * texture);
(define sdl-destroy-texture
  (foreign-library-function "libSDL2" "SDL_DestroyTexture"
                            #:return-type void
                            #:arg-types (list '*)))



;;SDL_DestroyRenderer
;;void SDL_DestroyRenderer(SDL_Renderer * renderer);
(define sdl-destroy-renderer
  (foreign-library-function "libSDL2" "SDL_DestroyRenderer"
                            #:return-type void
                            #:arg-types (list '*)))






;; usage
;; int flags = 0; // flags unused should be set to 0 ??
;; 	  int width = SCREEN_WIDTH; // 640 pixels wide
;; 	  int height = SCREEN_HEIGHT; // 480 pixels high
;; 	  int depth = 32; // 32 bits - cairo only understands 32 bits
;; 	  SDL_Surface *sdlsurf = SDL_CreateRGBSurface (
;; 						       flags, width, height, depth,
;; 						       0x00FF0000, /* Rmask */
;; 						       0x0000FF00, /* Gmask */
;; 						       0x000000FF, /* Bmask */
;; 						       0); /* Amask */
(define sdl-create-rgb-surface 
  (foreign-library-function "libSDL2" "SDL_CreateRGBSurface"
                            #:return-type '*
                            #:arg-types (list int int int int int int int int )))

;; convenience function
(define (create-rgb-surface width height)
  (let ((flags 0) ;;unused
	(depth 32) ;; only depth SDL and CAIRO agree on
	(rmask #x00FF0000) ;; red mask
	(gmask #x0000FF00) ;; green mask
	(bmask #x000000FF) ;; blue mask
	(amask #x0)) ;; alpha mask - unused	
    (sdl-create-rgb-surface flags width height depth rmask gmask bmask amask)))



;; guile (use-modules (system foreign)) exposes typical C types uint8 uint32 etc..
;; assuming NULL is just 0
;; Uint32 SDL_MapRGB(const SDL_PixelFormat * format,  Uint8 r, Uint8 g, Uint8 b);
(define sdl-map-rgb
  (foreign-library-function "libSDL2" "SDL_MapRGB"
                            #:return-type uint32
                            #:arg-types (list '* uint8 uint8 uint8)))


;; int SDL_FillRect (SDL_Surface * dst, const SDL_Rect * rect, Uint32 color);
;; returns 0 on success
(define sdl-fill-rect
  (foreign-library-function "libSDL2" "SDL_FillRect"
			    #:return-type int
                            #:arg-types (list '* '* uint32)))


;; int SDL_UpdateWindowSurface(SDL_Window * window);
(define sdl-update-window-surface
  (foreign-library-function "libSDL2" "SDL_UpdateWindowSurface"
			    #:return-type int
                            #:arg-types (list '*)))


#|
https://lazyfoo.net/tutorials/SDL/05_optimized_surface_loading_and_soft_stretching/index.php

SDL_Surface* SDL_ConvertSurface
(SDL_Surface * src, const SDL_PixelFormat * fmt, Uint32 flags;)
|#
(define sdl-convert-surface
  (foreign-library-function "libSDL2" "SDL_ConvertSurface"
			    #:return-type '*
                            #:arg-types (list '* '* uint32)))






;; ======================== cairo stuff ========================================

#|
cairo_surface_t *cairosurf = cairo_image_surface_create_for_data (
									    (unsigned char*)sdlsurf->pixels,
									    CAIRO_FORMAT_RGB24,
									    sdlsurf->w,
									    sdlsurf->h,
									    sdlsurf->pitch);
	  

#define SDL_BlitSurface SDL_UpperBlit
int SDL_UpperBlit
    (SDL_Surface * src, const SDL_Rect * srcrect,
     SDL_Surface * dst, SDL_Rect * dstrect);

|#
(define sdl-blit-surface 
  (foreign-library-function "libSDL2" "SDL_UpperBlit"
			    #:return-type int
                            #:arg-types (list '* '* '* '*)))


;; render-clear
;; int SDL_RenderClear(SDL_Renderer * renderer);
(define sdl-render-clear
  (foreign-library-function "libSDL2" "SDL_RenderClear"
			    #:return-type int
                            #:arg-types (list '*)))

;; int SDL_RenderCopy(SDL_Renderer * renderer,
;;                    SDL_Texture * texture,
;;                    const SDL_Rect * srcrect,
;;                    const SDL_Rect * dstrect);
(define sdl-render-copy
  (foreign-library-function "libSDL2" "SDL_RenderCopy"
			    #:return-type int
                            #:arg-types (list '* '* '* '*)))

;; void SDL_RenderPresent(SDL_Renderer * renderer);
(define sdl-render-present
  (foreign-library-function "libSDL2" "SDL_RenderPresent"
			    #:return-type int
                            #:arg-types (list '*)))


;; int SDL_RenderDrawLine(SDL_Renderer * renderer,
;;                        int x1, int y1, int x2, int y2);
(define sdl-render-draw-line
  (foreign-library-function "libSDL2" "SDL_RenderDrawLine"
			    #:return-type int
                            #:arg-types (list '* int int int int)))

;; int SDL_RenderDrawRect(SDL_Renderer * renderer,   const SDL_Rect * rect);
(define sdl-render-draw-rect
  (foreign-library-function "libSDL2" "SDL_RenderDrawRect"
			    #:return-type int
                            #:arg-types (list '* '*)))

;; int SDL_RenderFillRect(SDL_Renderer * renderer,
;;                        const SDL_Rect * rect);
(define sdl-render-fill-rect
  (foreign-library-function "libSDL2" "SDL_RenderFillRect"
			    #:return-type int
                            #:arg-types (list '* '*)))


;; int SDL_RenderDrawPoint(SDL_Renderer * renderer,
;;                         int x, int y);
(define sdl-render-draw-point
  (foreign-library-function "libSDL2" "SDL_RenderDrawPoint"
			    #:return-type int
                            #:arg-types (list '* int int)))


;; int TTF_Init(void);
(define ttf-init
  (foreign-library-function "libSDL2_ttf" "TTF_Init"
			    #:return-type int
                            #:arg-types (list)))

;; void TTF_Quit(void);
(define ttf-quit
  (foreign-library-function "libSDL2_ttf" "TTF_Quit"
			    #:return-type void
                            #:arg-types (list)))

;; SDL_Surface * TTF_RenderText_Solid(TTF_Font *font,   const char *text, SDL_Color fg);
;; what do if structure was just as a parameter , not a pointer , how cope if structure bigger than 64bit ?
(define ttf-render-text-solid
  (foreign-library-function "libSDL2_ttf" "TTF_RenderText_Solid"
			    #:return-type '*
                            #:arg-types (list '* '* uint32)))


;; gFont = TTF_OpenFont( "16_true_type_fonts/lazy.ttf", 28 );
;; TTF_Font * TTF_OpenFont(const char *file, int ptsize);
(define ttf-open-font
  (foreign-library-function "libSDL2_ttf" "TTF_OpenFont"
			    #:return-type '*
                            #:arg-types (list '* int)))

;; void TTF_CloseFont(TTF_Font *font);
(define ttf-close-font
  (foreign-library-function "libSDL2_ttf" "TTF_CloseFont"
			    #:return-type void
                            #:arg-types (list '*)))






(define *constant-cairo-format-rgb24* 1)

(define cairo-image-surface-create-for-data
  (foreign-library-function "libcairo" "cairo_image_surface_create_for_data"
                            #:return-type '*
                            #:arg-types (list '* int int int int)))


(define cairo-rectangle
  (foreign-library-function "libcairo" "cairo_rectangle"
                            #:return-type void
                            #:arg-types (list '* int int int int)))

(define cairo-set-source-rgb
  (foreign-library-function "libcairo" "cairo_set_source_rgb"
                            #:return-type void
                            #:arg-types (list '* double double double)))




;;
;; cairo_t *cairo_create( cairo_surface_t *)
;; cairo_t is cairo context
;; cairo_surface_t is a surface compatible with cairo 24 bit 
(define cairo-create
  (foreign-library-function "libcairo" "cairo_create"
                            #:return-type '*
                            #:arg-types (list '*)))


(define cairo-fill
  (foreign-library-function "libcairo" "cairo_fill"
                            #:return-type void
                            #:arg-types (list '*)))


;;void cairo_surface_flush (cairo_surface_t *surface);
(define cairo-surface-flush
  (foreign-library-function "libcairo" "cairo_surface_flush"
                            #:return-type void
                            #:arg-types (list '*)))



;; --- put an image on the screen
;; wait 5 seconds then cleanup
(define (skooldaze)
  (let ((width 640)(height 480))
    (sdl-init *constant-sdl-init-video*)
    (define window (create-window "hello world" width height))
    (define surface (sdl-get-window-surface window))
    (define hello-bitmap (sdl-load-bmp "hello.bmp"))
    ;; apply image
    (sdl-blit-surface hello-bitmap *null* surface *null*)
    ;; update surface
    (sdl-update-window-surface window) 
    ;; wait
    (sleep 5)
    ;; cleanup
    (sdl-free-surface hello-bitmap)
    (sdl-destroy-window window)
    (sdl-quit)))


;; int SDL_PollEvent(SDL_Event * event);
(define sdl-poll-event
  (foreign-library-function "libSDL2" "SDL_PollEvent"
			    #:return-type int
                            #:arg-types (list '*)))

#|
typedef union SDL_Event
{
    Uint32 type;                            /**< Event type, shared with all events */
    SDL_CommonEvent common;                 /**< Common event data */
    SDL_DisplayEvent display;               /**< Display event data */
    SDL_WindowEvent window;                 /**< Window event data */
    SDL_KeyboardEvent key;                  /**< Keyboard event data */
    SDL_TextEditingEvent edit;              /**< Text editing event data */
    SDL_TextEditingExtEvent editExt;        /**< Extended text editing event data */
    SDL_TextInputEvent text;                /**< Text input event data */
    SDL_MouseMotionEvent motion;            /**< Mouse motion event data */
    SDL_MouseButtonEvent button;            /**< Mouse button event data */
    SDL_MouseWheelEvent wheel;              /**< Mouse wheel event data */
    SDL_JoyAxisEvent jaxis;                 /**< Joystick axis event data */
    SDL_JoyBallEvent jball;                 /**< Joystick ball event data */
    SDL_JoyHatEvent jhat;                   /**< Joystick hat event data */
    SDL_JoyButtonEvent jbutton;             /**< Joystick button event data */
    SDL_JoyDeviceEvent jdevice;             /**< Joystick device change event data */
    SDL_JoyBatteryEvent jbattery;           /**< Joystick battery event data */
    SDL_ControllerAxisEvent caxis;          /**< Game Controller axis event data */
    SDL_ControllerButtonEvent cbutton;      /**< Game Controller button event data */
    SDL_ControllerDeviceEvent cdevice;      /**< Game Controller device event data */
    SDL_ControllerTouchpadEvent ctouchpad;  /**< Game Controller touchpad event data */
    SDL_ControllerSensorEvent csensor;      /**< Game Controller sensor event data */
    SDL_AudioDeviceEvent adevice;           /**< Audio device event data */
    SDL_SensorEvent sensor;                 /**< Sensor event data */
    SDL_QuitEvent quit;                     /**< Quit request event data */
    SDL_UserEvent user;                     /**< Custom event data */
    SDL_SysWMEvent syswm;                   /**< System dependent window event data */
    SDL_TouchFingerEvent tfinger;           /**< Touch finger event data */
    SDL_MultiGestureEvent mgesture;         /**< Gesture event data */
    SDL_DollarGestureEvent dgesture;        /**< Gesture event data */
    SDL_DropEvent drop;                     /**< Drag and drop event data */

    /* This is necessary for ABI compatibility between Visual C++ and GCC.
       Visual C++ will respect the push pack pragma and use 52 bytes (size of
       SDL_TextEditingEvent, the largest structure for 32-bit and 64-bit
       architectures) for this union, and GCC will use the alignment of the
       largest datatype within the union, which is 8 bytes on 64-bit
       architectures.

       So... we'll add padding to force the size to be 56 bytes for both.

       On architectures where pointers are 16 bytes, this needs rounding up to
       the next multiple of 16, 64, and on architectures where pointers are
       even larger the size of SDL_UserEvent will dominate as being 3 pointers.
    */
    Uint8 padding[sizeof(void *) <= 8 ? 56 : sizeof(void *) == 16 ? 64 : 3 * sizeof(void *)];
} SDL_Event;

how do i make a foreign struct ?
https://www.gnu.org/software/guile/manual/html_node/Foreign-Structs.html

typedef enum SDL_EventType
{
    SDL_FIRSTEVENT     = 0,     /**< Unused (do not remove) */

    /* Application events */
    SDL_QUIT           = 0x100, /**< User-requested quit  remember {{ guile scheme #x100 is same as 0x100 C language }} */

    /* These application events have special meaning on iOS, see README-ios.md for details */
    SDL_APP_TERMINATING,        /**< The application is being terminated by the OS
                                     Called on iOS in applicationWillTerminate()
                                     Called on Android in onDestroy()
                                */
    SDL_APP_LOWMEMORY,          /**< The application is low on memory, free memory if possible.
                                     Called on iOS in applicationDidReceiveMemoryWarning()
                                     Called on Android in onLowMemory()
                                */
    SDL_APP_WILLENTERBACKGROUND, /**< The application is about to enter the background
                                     Called on iOS in applicationWillResignActive()
                                     Called on Android in onPause()
                                */
    SDL_APP_DIDENTERBACKGROUND, /**< The application did enter the background and may not get CPU for some time
                                     Called on iOS in applicationDidEnterBackground()
                                     Called on Android in onPause()
                                */
    SDL_APP_WILLENTERFOREGROUND, /**< The application is about to enter the foreground
                                     Called on iOS in applicationWillEnterForeground()
                                     Called on Android in onResume()
                                */
    SDL_APP_DIDENTERFOREGROUND, /**< The application is now interactive
                                     Called on iOS in applicationDidBecomeActive()
                                     Called on Android in onResume()
                                */

    SDL_LOCALECHANGED,  /**< The user's locale preferences have changed. */

    /* Display events */
    SDL_DISPLAYEVENT   = 0x150,  /**< Display state change */

    /* Window events */
    SDL_WINDOWEVENT    = 0x200, /**< Window state change */
    SDL_SYSWMEVENT,             /**< System specific event */

    /* Keyboard events */
    SDL_KEYDOWN        = 0x300, /**< Key pressed */
    SDL_KEYUP,                  /**< Key released */
    SDL_TEXTEDITING,            /**< Keyboard text editing (composition) */
    SDL_TEXTINPUT,              /**< Keyboard text input */
    SDL_KEYMAPCHANGED,          /**< Keymap changed due to a system event such as an
                                     input language or keyboard layout change.
                                */
    SDL_TEXTEDITING_EXT,       /**< Extended keyboard text editing (composition) */

    /* Mouse events */
    SDL_MOUSEMOTION    = 0x400, /**< Mouse moved */
    SDL_MOUSEBUTTONDOWN,        /**< Mouse button pressed */
    SDL_MOUSEBUTTONUP,          /**< Mouse button released */
    SDL_MOUSEWHEEL,             /**< Mouse wheel motion */

    /* Joystick events */
    SDL_JOYAXISMOTION  = 0x600, /**< Joystick axis motion */
    SDL_JOYBALLMOTION,          /**< Joystick trackball motion */
    SDL_JOYHATMOTION,           /**< Joystick hat position change */
    SDL_JOYBUTTONDOWN,          /**< Joystick button pressed */
    SDL_JOYBUTTONUP,            /**< Joystick button released */
    SDL_JOYDEVICEADDED,         /**< A new joystick has been inserted into the system */
    SDL_JOYDEVICEREMOVED,       /**< An opened joystick has been removed */
    SDL_JOYBATTERYUPDATED,      /**< Joystick battery level change */

    /* Game controller events */
    SDL_CONTROLLERAXISMOTION  = 0x650, /**< Game controller axis motion */
    SDL_CONTROLLERBUTTONDOWN,          /**< Game controller button pressed */
    SDL_CONTROLLERBUTTONUP,            /**< Game controller button released */
    SDL_CONTROLLERDEVICEADDED,         /**< A new Game controller has been inserted into the system */
    SDL_CONTROLLERDEVICEREMOVED,       /**< An opened Game controller has been removed */
    SDL_CONTROLLERDEVICEREMAPPED,      /**< The controller mapping was updated */
    SDL_CONTROLLERTOUCHPADDOWN,        /**< Game controller touchpad was touched */
    SDL_CONTROLLERTOUCHPADMOTION,      /**< Game controller touchpad finger was moved */
    SDL_CONTROLLERTOUCHPADUP,          /**< Game controller touchpad finger was lifted */
    SDL_CONTROLLERSENSORUPDATE,        /**< Game controller sensor was updated */
    SDL_CONTROLLERUPDATECOMPLETE_RESERVED_FOR_SDL3,
    SDL_CONTROLLERSTEAMHANDLEUPDATED,  /**< Game controller Steam handle has changed */

    /* Touch events */
    SDL_FINGERDOWN      = 0x700,
    SDL_FINGERUP,
    SDL_FINGERMOTION,

    /* Gesture events */
    SDL_DOLLARGESTURE   = 0x800,
    SDL_DOLLARRECORD,
    SDL_MULTIGESTURE,

    /* Clipboard events */
    SDL_CLIPBOARDUPDATE = 0x900, /**< The clipboard or primary selection changed */

    /* Drag and drop events */
    SDL_DROPFILE        = 0x1000, /**< The system requests a file open */
    SDL_DROPTEXT,                 /**< text/plain drag-and-drop event */
    SDL_DROPBEGIN,                /**< A new set of drops is beginning (NULL filename) */
    SDL_DROPCOMPLETE,             /**< Current set of drops is now complete (NULL filename) */

    /* Audio hotplug events */
    SDL_AUDIODEVICEADDED = 0x1100, /**< A new audio device is available */
    SDL_AUDIODEVICEREMOVED,        /**< An audio device has been removed. */

    /* Sensor events */
    SDL_SENSORUPDATE = 0x1200,     /**< A sensor was updated */

    /* Render events */
    SDL_RENDER_TARGETS_RESET = 0x2000, /**< The render targets have been reset and their contents need to be updated */
    SDL_RENDER_DEVICE_RESET, /**< The device has been reset and all textures need to be recreated */

    /* Internal events */
    SDL_POLLSENTINEL = 0x7F00, /**< Signals the end of an event poll cycle */

    /** Events SDL_USEREVENT through SDL_LASTEVENT are for your use,
     *  and should be allocated with SDL_RegisterEvents()
     */
    SDL_USEREVENT    = 0x8000,

    /**
     *  This last event is only for bounding internal arrays
     */
    SDL_LASTEVENT    = 0xFFFF
} SDL_EventType;

typedef struct SDL_MouseMotionEvent
{
    Uint32 type;        /**< SDL_MOUSEMOTION */
    Uint32 timestamp;   /**< In milliseconds, populated using SDL_GetTicks() */
    Uint32 windowID;    /**< The window with mouse focus, if any */
    Uint32 which;       /**< The mouse instance id, or SDL_TOUCH_MOUSEID */
    Uint32 state;       /**< The current button state */
    Sint32 x;           /**< X coordinate, relative to window */
    Sint32 y;           /**< Y coordinate, relative to window */
    Sint32 xrel;        /**< The relative motion in the X direction */
    Sint32 yrel;        /**< The relative motion in the Y direction */
} SDL_MouseMotionEvent;

offsets into SDL_MouseMotionEvent using C language offsetof from #include<stddef.h>  printed as %zu
example
  fprintf(stdout, "MouseMotionEvent . type : %zu \n" , offsetof("SDL_MouseMotionEvent","type"));

guile scheme equivalents - mainly for most lisp languages

bytevector-u32-ref is unsigned 32 bit reference to foreign struct _ at byte offset _ with endianness _
bytevector-s32-ref is signed 32 bit reference to foreign struct _ at byte offset _ with endianness _
 

MOUSEMOTIONEVENT type : 0           bytevector-u32-ref event 0 (endianness little))
MOUSEMOTIONEVENT timestamp : 4      bytevector-u32-ref event 4 (endianness little))
MOUSEMOTIONEVENT windowid : 8       bytevector-u32-ref event 8 (endianness little))
MOUSEMOTIONEVENT which : 12         bytevector-u32-ref event 12 (endianness little))
MOUSEMOTIONEVENT state : 16         bytevector-u32-ref event 16 (endianness little))

MOUSEMOTIONEVENT x : 20             bytevector-s32-ref event 20 (endianness little))
MOUSEMOTIONEVENT y : 24             bytevector-s32-ref event 24 (endianness little))
MOUSEMOTIONEVENT xrel : 28          bytevector-s32-ref event 28 (endianness little))
MOUSEMOTIONEVENT yrel : 32          bytevector-s32-ref event 32 (endianness little))

(let ((type (bytevector-u32-ref event 0 (endianness little)))
      (timestamp (bytevector-u32-ref event 4 (endianness little)))
      (windowid (bytevector-u32-ref event 8 (endianness little)))
      (state (bytevector-u32-ref event 12 (endianness little)))
      (x (bytevector-s32-ref event 20 (endianness little)))
      (y (bytevector-s32-ref event 24 (endianness little)))
      (xrel (bytevector-s32-ref event 28 (endianness little)))
      (yrel (bytevector-s32-ref event 32 (endianness little))))
  ...)


;; keyboard 
typedef struct SDL_KeyboardEvent
{
    Uint32 type;        /**< SDL_KEYDOWN or SDL_KEYUP */
    Uint32 timestamp;   /**< In milliseconds, populated using SDL_GetTicks() */
    Uint32 windowID;    /**< The window with keyboard focus, if any */
    Uint8 state;        /**< SDL_PRESSED or SDL_RELEASED */
    Uint8 repeat;       /**< Non-zero if this is a key repeat */
    Uint8 padding2;
    Uint8 padding3;
    SDL_Keysym keysym;  /**< The key that was pressed or released */
} SDL_KeyboardEvent;

================= SDL_KeyboardEvent ============= 
SDL_KeyboardEvent type : 0          bytevector-u32-ref event 0 (endianness little))
SDL_KeyboardEvent timestamp : 4     bytevector-u32-ref event 4 (endianness little))
SDL_KeyboardEvent windowid : 8      bytevector-u32-ref event 8 (endianness little))
SDL_KeyboardEvent state : 12        bytevector-u8-ref event 12 (endianness little))
SDL_KeyboardEvent repeat : 13       bytevector-u8-ref event 13 (endianness little))
SDL_KeyboardEvent padding2 : 14     bytevector-u8-ref event 14 (endianness little))
SDL_KeyboardEvent padding3 : 15     bytevector-u8-ref event 15 (endianness little))
SDL_KeyboardEvent keysym : 16       bytevector-???-ref event 16 (endianness little))   this is a structure

keysym structure starts at offset 16
<SDL_Keysym>
- scancode is an enum or unsigned 32 int   uint32 at offset 0  + global offset 16 = offset 16
- sym   signed int 32                      int32  at offset 4  + global offset 16 = offset 20
- mod                                      uint16 at offset 8  + global offset 16 = offset 24
- unsused                                  ? at offset 12  + global offset 16 = offset 


unsigned int in guile scheme u
signed int in guile scheme s


(let ((type (bytevector-u32-ref event 0 (endianness little)))
      (timestamp (bytevector-u32-ref event 4 (endianness little)))
      (windowid (bytevector-u32-ref event 8 (endianness little)))
      (state (bytevector-u8-ref event 12 (endianness little)))
      (repeat (bytevector-u8-ref event 13 (endianness little)))
      (padding2 (bytevector-u8-ref event 13 (endianness little)))
      (padding3 (bytevector-u8-ref event 14 (endianness little)))
      (keysym-scancode (bytevector-u32-ref event 16 (endianness little)))
      (keysym-sym (bytevector-s32-ref event 20 (endianness little)))
      (keysym-mod (bytevector-u16-ref event 24 (endianness little)))
      ...)



typedef struct SDL_Keysym
{
    SDL_Scancode scancode;      /**< SDL physical key code - see SDL_Scancode for details */
    SDL_Keycode sym;            /**< SDL virtual key code - see SDL_Keycode for details */
    Uint16 mod;                 /**< current key modifiers - see SDL_Keymod for details */
    Uint32 unused;
} SDL_Keysym;

================= SDL_Keysym 16 bytes offsets ============= 
SDL_Keysym scancode : 0   
SDL_Keysym sym : 4
SDL_Keysym mod : 8
SDL_Keysym unused : 12

================= standard signed int sizes  ============= 
int8_t : 1
int16_t : 2
int32_t : 4
int64_t : 8
================= standard unsigned int sizes  ============= 
uint8_t : 1
uint16_t : 2
uint32_t : 4
uint64_t : 8
  
enum is unsigned 32 bit int  u32
  
  
typedef enum SDL_Scancode
{
    SDL_SCANCODE_UNKNOWN = 0,

    /**
     *  \name Usage page 0x07
     *
     *  These values are from usage page 0x07 (USB keyboard page).
     */
    /* @{ */

    SDL_SCANCODE_A = 4,
    SDL_SCANCODE_B = 5,
    SDL_SCANCODE_C = 6,
    SDL_SCANCODE_D = 7,
    SDL_SCANCODE_E = 8,
    SDL_SCANCODE_F = 9,
    SDL_SCANCODE_G = 10,
    SDL_SCANCODE_H = 11,
    SDL_SCANCODE_I = 12,
    SDL_SCANCODE_J = 13,
    SDL_SCANCODE_K = 14,
    SDL_SCANCODE_L = 15,
    SDL_SCANCODE_M = 16,
    SDL_SCANCODE_N = 17,
    SDL_SCANCODE_O = 18,
    SDL_SCANCODE_P = 19,
    SDL_SCANCODE_Q = 20,
    SDL_SCANCODE_R = 21,
    SDL_SCANCODE_S = 22,
    SDL_SCANCODE_T = 23,
    SDL_SCANCODE_U = 24,
    SDL_SCANCODE_V = 25,
    SDL_SCANCODE_W = 26,
    SDL_SCANCODE_X = 27,
    SDL_SCANCODE_Y = 28,
    SDL_SCANCODE_Z = 29,

    SDL_SCANCODE_1 = 30,
    SDL_SCANCODE_2 = 31,
    SDL_SCANCODE_3 = 32,
    SDL_SCANCODE_4 = 33,
    SDL_SCANCODE_5 = 34,
    SDL_SCANCODE_6 = 35,
    SDL_SCANCODE_7 = 36,
    SDL_SCANCODE_8 = 37,
    SDL_SCANCODE_9 = 38,
    SDL_SCANCODE_0 = 39,

    SDL_SCANCODE_RETURN = 40,
    SDL_SCANCODE_ESCAPE = 41,
    SDL_SCANCODE_BACKSPACE = 42,
    SDL_SCANCODE_TAB = 43,
    SDL_SCANCODE_SPACE = 44,

    SDL_SCANCODE_MINUS = 45,
    SDL_SCANCODE_EQUALS = 46,
    SDL_SCANCODE_LEFTBRACKET = 47,
    SDL_SCANCODE_RIGHTBRACKET = 48,
    SDL_SCANCODE_BACKSLASH = 49, /**< Located at the lower left of the return
                                  *   key on ISO keyboards and at the right end
                                  *   of the QWERTY row on ANSI keyboards.
                                  *   Produces REVERSE SOLIDUS (backslash) and
                                  *   VERTICAL LINE in a US layout, REVERSE
                                  *   SOLIDUS and VERTICAL LINE in a UK Mac
                                  *   layout, NUMBER SIGN and TILDE in a UK
                                  *   Windows layout, DOLLAR SIGN and POUND SIGN
                                  *   in a Swiss German layout, NUMBER SIGN and
                                  *   APOSTROPHE in a German layout, GRAVE
                                  *   ACCENT and POUND SIGN in a French Mac
                                  *   layout, and ASTERISK and MICRO SIGN in a
                                  *   French Windows layout.
                                  */
    SDL_SCANCODE_NONUSHASH = 50, /**< ISO USB keyboards actually use this code
                                  *   instead of 49 for the same key, but all
                                  *   OSes I've seen treat the two codes
                                  *   identically. So, as an implementor, unless
                                  *   your keyboard generates both of those
                                  *   codes and your OS treats them differently,
                                  *   you should generate SDL_SCANCODE_BACKSLASH
                                  *   instead of this code. As a user, you
                                  *   should not rely on this code because SDL
                                  *   will never generate it with most (all?)
                                  *   keyboards.
                                  */
    SDL_SCANCODE_SEMICOLON = 51,
    SDL_SCANCODE_APOSTROPHE = 52,
    SDL_SCANCODE_GRAVE = 53, /**< Located in the top left corner (on both ANSI
                              *   and ISO keyboards). Produces GRAVE ACCENT and
                              *   TILDE in a US Windows layout and in US and UK
                              *   Mac layouts on ANSI keyboards, GRAVE ACCENT
                              *   and NOT SIGN in a UK Windows layout, SECTION
                              *   SIGN and PLUS-MINUS SIGN in US and UK Mac
                              *   layouts on ISO keyboards, SECTION SIGN and
                              *   DEGREE SIGN in a Swiss German layout (Mac:
                              *   only on ISO keyboards), CIRCUMFLEX ACCENT and
                              *   DEGREE SIGN in a German layout (Mac: only on
                              *   ISO keyboards), SUPERSCRIPT TWO and TILDE in a
                              *   French Windows layout, COMMERCIAL AT and
                              *   NUMBER SIGN in a French Mac layout on ISO
                              *   keyboards, and LESS-THAN SIGN and GREATER-THAN
                              *   SIGN in a Swiss German, German, or French Mac
                              *   layout on ANSI keyboards.
                              */
    SDL_SCANCODE_COMMA = 54,
    SDL_SCANCODE_PERIOD = 55,
    SDL_SCANCODE_SLASH = 56,

    SDL_SCANCODE_CAPSLOCK = 57,

    SDL_SCANCODE_F1 = 58,
    SDL_SCANCODE_F2 = 59,
    SDL_SCANCODE_F3 = 60,
    SDL_SCANCODE_F4 = 61,
    SDL_SCANCODE_F5 = 62,
    SDL_SCANCODE_F6 = 63,
    SDL_SCANCODE_F7 = 64,
    SDL_SCANCODE_F8 = 65,
    SDL_SCANCODE_F9 = 66,
    SDL_SCANCODE_F10 = 67,
    SDL_SCANCODE_F11 = 68,
    SDL_SCANCODE_F12 = 69,

    SDL_SCANCODE_PRINTSCREEN = 70,
    SDL_SCANCODE_SCROLLLOCK = 71,
    SDL_SCANCODE_PAUSE = 72,
    SDL_SCANCODE_INSERT = 73, /**< insert on PC, help on some Mac keyboards (but
                                   does send code 73, not 117) */
    SDL_SCANCODE_HOME = 74,
    SDL_SCANCODE_PAGEUP = 75,
    SDL_SCANCODE_DELETE = 76,
    SDL_SCANCODE_END = 77,
    SDL_SCANCODE_PAGEDOWN = 78,
    SDL_SCANCODE_RIGHT = 79,
    SDL_SCANCODE_LEFT = 80,
    SDL_SCANCODE_DOWN = 81,
    SDL_SCANCODE_UP = 82,

    SDL_SCANCODE_NUMLOCKCLEAR = 83, /**< num lock on PC, clear on Mac keyboards
                                     */
    SDL_SCANCODE_KP_DIVIDE = 84,
    SDL_SCANCODE_KP_MULTIPLY = 85,
    SDL_SCANCODE_KP_MINUS = 86,
    SDL_SCANCODE_KP_PLUS = 87,
    SDL_SCANCODE_KP_ENTER = 88,
    SDL_SCANCODE_KP_1 = 89,
    SDL_SCANCODE_KP_2 = 90,
    SDL_SCANCODE_KP_3 = 91,
    SDL_SCANCODE_KP_4 = 92,
    SDL_SCANCODE_KP_5 = 93,
    SDL_SCANCODE_KP_6 = 94,
    SDL_SCANCODE_KP_7 = 95,
    SDL_SCANCODE_KP_8 = 96,
    SDL_SCANCODE_KP_9 = 97,
    SDL_SCANCODE_KP_0 = 98,
    SDL_SCANCODE_KP_PERIOD = 99,

    SDL_SCANCODE_NONUSBACKSLASH = 100, /**< This is the additional key that ISO
                                        *   keyboards have over ANSI ones,
                                        *   located between left shift and Y.
                                        *   Produces GRAVE ACCENT and TILDE in a
                                        *   US or UK Mac layout, REVERSE SOLIDUS
                                        *   (backslash) and VERTICAL LINE in a
                                        *   US or UK Windows layout, and
                                        *   LESS-THAN SIGN and GREATER-THAN SIGN
                                        *   in a Swiss German, German, or French
                                        *   layout. */
    SDL_SCANCODE_APPLICATION = 101, /**< windows contextual menu, compose */
    SDL_SCANCODE_POWER = 102, /**< The USB document says this is a status flag,
                               *   not a physical key - but some Mac keyboards
                               *   do have a power key. */
    SDL_SCANCODE_KP_EQUALS = 103,
    SDL_SCANCODE_F13 = 104,
    SDL_SCANCODE_F14 = 105,
    SDL_SCANCODE_F15 = 106,
    SDL_SCANCODE_F16 = 107,
    SDL_SCANCODE_F17 = 108,
    SDL_SCANCODE_F18 = 109,
    SDL_SCANCODE_F19 = 110,
    SDL_SCANCODE_F20 = 111,
    SDL_SCANCODE_F21 = 112,
    SDL_SCANCODE_F22 = 113,
    SDL_SCANCODE_F23 = 114,
    SDL_SCANCODE_F24 = 115,
    SDL_SCANCODE_EXECUTE = 116,
    SDL_SCANCODE_HELP = 117,    /**< AL Integrated Help Center */
    SDL_SCANCODE_MENU = 118,    /**< Menu (show menu) */
    SDL_SCANCODE_SELECT = 119,
    SDL_SCANCODE_STOP = 120,    /**< AC Stop */
    SDL_SCANCODE_AGAIN = 121,   /**< AC Redo/Repeat */
    SDL_SCANCODE_UNDO = 122,    /**< AC Undo */
    SDL_SCANCODE_CUT = 123,     /**< AC Cut */
    SDL_SCANCODE_COPY = 124,    /**< AC Copy */
    SDL_SCANCODE_PASTE = 125,   /**< AC Paste */
    SDL_SCANCODE_FIND = 126,    /**< AC Find */
    SDL_SCANCODE_MUTE = 127,
    SDL_SCANCODE_VOLUMEUP = 128,
    SDL_SCANCODE_VOLUMEDOWN = 129,
/* not sure whether there's a reason to enable these */
/*     SDL_SCANCODE_LOCKINGCAPSLOCK = 130,  */
/*     SDL_SCANCODE_LOCKINGNUMLOCK = 131, */
/*     SDL_SCANCODE_LOCKINGSCROLLLOCK = 132, */
    SDL_SCANCODE_KP_COMMA = 133,
    SDL_SCANCODE_KP_EQUALSAS400 = 134,

    SDL_SCANCODE_INTERNATIONAL1 = 135, /**< used on Asian keyboards, see
                                            footnotes in USB doc */
    SDL_SCANCODE_INTERNATIONAL2 = 136,
    SDL_SCANCODE_INTERNATIONAL3 = 137, /**< Yen */
    SDL_SCANCODE_INTERNATIONAL4 = 138,
    SDL_SCANCODE_INTERNATIONAL5 = 139,
    SDL_SCANCODE_INTERNATIONAL6 = 140,
    SDL_SCANCODE_INTERNATIONAL7 = 141,
    SDL_SCANCODE_INTERNATIONAL8 = 142,
    SDL_SCANCODE_INTERNATIONAL9 = 143,
    SDL_SCANCODE_LANG1 = 144, /**< Hangul/English toggle */
    SDL_SCANCODE_LANG2 = 145, /**< Hanja conversion */
    SDL_SCANCODE_LANG3 = 146, /**< Katakana */
    SDL_SCANCODE_LANG4 = 147, /**< Hiragana */
    SDL_SCANCODE_LANG5 = 148, /**< Zenkaku/Hankaku */
    SDL_SCANCODE_LANG6 = 149, /**< reserved */
    SDL_SCANCODE_LANG7 = 150, /**< reserved */
    SDL_SCANCODE_LANG8 = 151, /**< reserved */
    SDL_SCANCODE_LANG9 = 152, /**< reserved */

    SDL_SCANCODE_ALTERASE = 153,    /**< Erase-Eaze */
    SDL_SCANCODE_SYSREQ = 154,
    SDL_SCANCODE_CANCEL = 155,      /**< AC Cancel */
    SDL_SCANCODE_CLEAR = 156,
    SDL_SCANCODE_PRIOR = 157,
    SDL_SCANCODE_RETURN2 = 158,
    SDL_SCANCODE_SEPARATOR = 159,
    SDL_SCANCODE_OUT = 160,
    SDL_SCANCODE_OPER = 161,
    SDL_SCANCODE_CLEARAGAIN = 162,
    SDL_SCANCODE_CRSEL = 163,
    SDL_SCANCODE_EXSEL = 164,

    SDL_SCANCODE_KP_00 = 176,
    SDL_SCANCODE_KP_000 = 177,
    SDL_SCANCODE_THOUSANDSSEPARATOR = 178,
    SDL_SCANCODE_DECIMALSEPARATOR = 179,
    SDL_SCANCODE_CURRENCYUNIT = 180,
    SDL_SCANCODE_CURRENCYSUBUNIT = 181,
    SDL_SCANCODE_KP_LEFTPAREN = 182,
    SDL_SCANCODE_KP_RIGHTPAREN = 183,
    SDL_SCANCODE_KP_LEFTBRACE = 184,
    SDL_SCANCODE_KP_RIGHTBRACE = 185,
    SDL_SCANCODE_KP_TAB = 186,
    SDL_SCANCODE_KP_BACKSPACE = 187,
    SDL_SCANCODE_KP_A = 188,
    SDL_SCANCODE_KP_B = 189,
    SDL_SCANCODE_KP_C = 190,
    SDL_SCANCODE_KP_D = 191,
    SDL_SCANCODE_KP_E = 192,
    SDL_SCANCODE_KP_F = 193,
    SDL_SCANCODE_KP_XOR = 194,
    SDL_SCANCODE_KP_POWER = 195,
    SDL_SCANCODE_KP_PERCENT = 196,
    SDL_SCANCODE_KP_LESS = 197,
    SDL_SCANCODE_KP_GREATER = 198,
    SDL_SCANCODE_KP_AMPERSAND = 199,
    SDL_SCANCODE_KP_DBLAMPERSAND = 200,
    SDL_SCANCODE_KP_VERTICALBAR = 201,
    SDL_SCANCODE_KP_DBLVERTICALBAR = 202,
    SDL_SCANCODE_KP_COLON = 203,
    SDL_SCANCODE_KP_HASH = 204,
    SDL_SCANCODE_KP_SPACE = 205,
    SDL_SCANCODE_KP_AT = 206,
    SDL_SCANCODE_KP_EXCLAM = 207,
    SDL_SCANCODE_KP_MEMSTORE = 208,
    SDL_SCANCODE_KP_MEMRECALL = 209,
    SDL_SCANCODE_KP_MEMCLEAR = 210,
    SDL_SCANCODE_KP_MEMADD = 211,
    SDL_SCANCODE_KP_MEMSUBTRACT = 212,
    SDL_SCANCODE_KP_MEMMULTIPLY = 213,
    SDL_SCANCODE_KP_MEMDIVIDE = 214,
    SDL_SCANCODE_KP_PLUSMINUS = 215,
    SDL_SCANCODE_KP_CLEAR = 216,
    SDL_SCANCODE_KP_CLEARENTRY = 217,
    SDL_SCANCODE_KP_BINARY = 218,
    SDL_SCANCODE_KP_OCTAL = 219,
    SDL_SCANCODE_KP_DECIMAL = 220,
    SDL_SCANCODE_KP_HEXADECIMAL = 221,

    SDL_SCANCODE_LCTRL = 224,
    SDL_SCANCODE_LSHIFT = 225,
    SDL_SCANCODE_LALT = 226, /**< alt, option */
    SDL_SCANCODE_LGUI = 227, /**< windows, command (apple), meta */
    SDL_SCANCODE_RCTRL = 228,
    SDL_SCANCODE_RSHIFT = 229,
    SDL_SCANCODE_RALT = 230, /**< alt gr, option */
    SDL_SCANCODE_RGUI = 231, /**< windows, command (apple), meta */

    SDL_SCANCODE_MODE = 257,    /**< I'm not sure if this is really not covered
                                 *   by any of the above, but since there's a
                                 *   special KMOD_MODE for it I'm adding it here
                                 */

    /* @} *//* Usage page 0x07 */

    /**
     *  \name Usage page 0x0C
     *
     *  These values are mapped from usage page 0x0C (USB consumer page).
     *  See https://usb.org/sites/default/files/hut1_2.pdf
     *
     *  There are way more keys in the spec than we can represent in the
     *  current scancode range, so pick the ones that commonly come up in
     *  real world usage.
     */
    /* @{ */

    SDL_SCANCODE_AUDIONEXT = 258,
    SDL_SCANCODE_AUDIOPREV = 259,
    SDL_SCANCODE_AUDIOSTOP = 260,
    SDL_SCANCODE_AUDIOPLAY = 261,
    SDL_SCANCODE_AUDIOMUTE = 262,
    SDL_SCANCODE_MEDIASELECT = 263,
    SDL_SCANCODE_WWW = 264,             /**< AL Internet Browser */
    SDL_SCANCODE_MAIL = 265,
    SDL_SCANCODE_CALCULATOR = 266,      /**< AL Calculator */
    SDL_SCANCODE_COMPUTER = 267,
    SDL_SCANCODE_AC_SEARCH = 268,       /**< AC Search */
    SDL_SCANCODE_AC_HOME = 269,         /**< AC Home */
    SDL_SCANCODE_AC_BACK = 270,         /**< AC Back */
    SDL_SCANCODE_AC_FORWARD = 271,      /**< AC Forward */
    SDL_SCANCODE_AC_STOP = 272,         /**< AC Stop */
    SDL_SCANCODE_AC_REFRESH = 273,      /**< AC Refresh */
    SDL_SCANCODE_AC_BOOKMARKS = 274,    /**< AC Bookmarks */

    /* @} *//* Usage page 0x0C */

    /**
     *  \name Walther keys
     *
     *  These are values that Christian Walther added (for mac keyboard?).
     */
    /* @{ */

    SDL_SCANCODE_BRIGHTNESSDOWN = 275,
    SDL_SCANCODE_BRIGHTNESSUP = 276,
    SDL_SCANCODE_DISPLAYSWITCH = 277, /**< display mirroring/dual display
                                           switch, video mode switch */
    SDL_SCANCODE_KBDILLUMTOGGLE = 278,
    SDL_SCANCODE_KBDILLUMDOWN = 279,
    SDL_SCANCODE_KBDILLUMUP = 280,
    SDL_SCANCODE_EJECT = 281,
    SDL_SCANCODE_SLEEP = 282,           /**< SC System Sleep */

    SDL_SCANCODE_APP1 = 283,
    SDL_SCANCODE_APP2 = 284,

    /* @} *//* Walther keys */

    /**
     *  \name Usage page 0x0C (additional media keys)
     *
     *  These values are mapped from usage page 0x0C (USB consumer page).
     */
    /* @{ */

    SDL_SCANCODE_AUDIOREWIND = 285,
    SDL_SCANCODE_AUDIOFASTFORWARD = 286,

    /* @} *//* Usage page 0x0C (additional media keys) */

    /**
     *  \name Mobile keys
     *
     *  These are values that are often used on mobile phones.
     */
    /* @{ */

    SDL_SCANCODE_SOFTLEFT = 287, /**< Usually situated below the display on phones and
                                      used as a multi-function feature key for selecting
                                      a software defined function shown on the bottom left
                                      of the display. */
    SDL_SCANCODE_SOFTRIGHT = 288, /**< Usually situated below the display on phones and
                                       used as a multi-function feature key for selecting
                                       a software defined function shown on the bottom right
                                       of the display. */
    SDL_SCANCODE_CALL = 289, /**< Used for accepting phone calls. */
    SDL_SCANCODE_ENDCALL = 290, /**< Used for rejecting phone calls. */

    /* @} *//* Mobile keys */

    /* Add any other keys here. */

    SDL_NUM_SCANCODES = 512 /**< not a key, just marks the number of scancodes
                                 for array bounds */
} SDL_Scancode;




typedef Sint32 SDL_Keycode;

#define SDLK_SCANCODE_MASK (1<<30)
#define SDL_SCANCODE_TO_KEYCODE(X)  (X | SDLK_SCANCODE_MASK)


typedef enum
{
    SDLK_UNKNOWN = 0,

    SDLK_RETURN = '\r',
    SDLK_ESCAPE = '\x1B',
    SDLK_BACKSPACE = '\b',
    SDLK_TAB = '\t',
    SDLK_SPACE = ' ',
    SDLK_EXCLAIM = '!',
    SDLK_QUOTEDBL = '"',
    SDLK_HASH = '#',
    SDLK_PERCENT = '%',
    SDLK_DOLLAR = '$',
    SDLK_AMPERSAND = '&',
    SDLK_QUOTE = '\'',
    SDLK_LEFTPAREN = '(',
    SDLK_RIGHTPAREN = ')',
    SDLK_ASTERISK = '*',
    SDLK_PLUS = '+',
    SDLK_COMMA = ',',
    SDLK_MINUS = '-',
    SDLK_PERIOD = '.',
    SDLK_SLASH = '/',
    SDLK_0 = '0',
    SDLK_1 = '1',
    SDLK_2 = '2',
    SDLK_3 = '3',
    SDLK_4 = '4',
    SDLK_5 = '5',
    SDLK_6 = '6',
    SDLK_7 = '7',
    SDLK_8 = '8',
    SDLK_9 = '9',
    SDLK_COLON = ':',
    SDLK_SEMICOLON = ';',
    SDLK_LESS = '<',
    SDLK_EQUALS = '=',
    SDLK_GREATER = '>',
    SDLK_QUESTION = '?',
    SDLK_AT = '@',

    /*
       Skip uppercase letters
     */

    SDLK_LEFTBRACKET = '[',
    SDLK_BACKSLASH = '\\',
    SDLK_RIGHTBRACKET = ']',
    SDLK_CARET = '^',
    SDLK_UNDERSCORE = '_',
    SDLK_BACKQUOTE = '`',
    SDLK_a = 'a',
    SDLK_b = 'b',
    SDLK_c = 'c',
    SDLK_d = 'd',
    SDLK_e = 'e',
    SDLK_f = 'f',
    SDLK_g = 'g',
    SDLK_h = 'h',
    SDLK_i = 'i',
    SDLK_j = 'j',
    SDLK_k = 'k',
    SDLK_l = 'l',
    SDLK_m = 'm',
    SDLK_n = 'n',
    SDLK_o = 'o',
    SDLK_p = 'p',
    SDLK_q = 'q',
    SDLK_r = 'r',
    SDLK_s = 's',
    SDLK_t = 't',
    SDLK_u = 'u',
    SDLK_v = 'v',
    SDLK_w = 'w',
    SDLK_x = 'x',
    SDLK_y = 'y',
    SDLK_z = 'z',

    SDLK_CAPSLOCK = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_CAPSLOCK),

    SDLK_F1 = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F1),
    SDLK_F2 = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F2),
    SDLK_F3 = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F3),
    SDLK_F4 = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F4),
    SDLK_F5 = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F5),
    SDLK_F6 = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F6),
    SDLK_F7 = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F7),
    SDLK_F8 = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F8),
    SDLK_F9 = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F9),
    SDLK_F10 = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F10),
    SDLK_F11 = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F11),
    SDLK_F12 = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F12),

    SDLK_PRINTSCREEN = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_PRINTSCREEN),
    SDLK_SCROLLLOCK = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_SCROLLLOCK),
    SDLK_PAUSE = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_PAUSE),
    SDLK_INSERT = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_INSERT),
    SDLK_HOME = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_HOME),
    SDLK_PAGEUP = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_PAGEUP),
    SDLK_DELETE = '\x7F',
    SDLK_END = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_END),
    SDLK_PAGEDOWN = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_PAGEDOWN),
    SDLK_RIGHT = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_RIGHT),
    SDLK_LEFT = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_LEFT),
    SDLK_DOWN = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_DOWN),
    SDLK_UP = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_UP),

    SDLK_NUMLOCKCLEAR = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_NUMLOCKCLEAR),
    SDLK_KP_DIVIDE = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_DIVIDE),
    SDLK_KP_MULTIPLY = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_MULTIPLY),
    SDLK_KP_MINUS = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_MINUS),
    SDLK_KP_PLUS = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_PLUS),
    SDLK_KP_ENTER = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_ENTER),
    SDLK_KP_1 = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_1),
    SDLK_KP_2 = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_2),
    SDLK_KP_3 = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_3),
    SDLK_KP_4 = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_4),
    SDLK_KP_5 = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_5),
    SDLK_KP_6 = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_6),
    SDLK_KP_7 = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_7),
    SDLK_KP_8 = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_8),
    SDLK_KP_9 = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_9),
    SDLK_KP_0 = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_0),
    SDLK_KP_PERIOD = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_PERIOD),

    SDLK_APPLICATION = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_APPLICATION),
    SDLK_POWER = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_POWER),
    SDLK_KP_EQUALS = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_EQUALS),
    SDLK_F13 = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F13),
    SDLK_F14 = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F14),
    SDLK_F15 = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F15),
    SDLK_F16 = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F16),
    SDLK_F17 = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F17),
    SDLK_F18 = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F18),
    SDLK_F19 = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F19),
    SDLK_F20 = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F20),
    SDLK_F21 = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F21),
    SDLK_F22 = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F22),
    SDLK_F23 = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F23),
    SDLK_F24 = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_F24),
    SDLK_EXECUTE = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_EXECUTE),
    SDLK_HELP = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_HELP),
    SDLK_MENU = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_MENU),
    SDLK_SELECT = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_SELECT),
    SDLK_STOP = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_STOP),
    SDLK_AGAIN = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_AGAIN),
    SDLK_UNDO = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_UNDO),
    SDLK_CUT = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_CUT),
    SDLK_COPY = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_COPY),
    SDLK_PASTE = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_PASTE),
    SDLK_FIND = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_FIND),
    SDLK_MUTE = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_MUTE),
    SDLK_VOLUMEUP = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_VOLUMEUP),
    SDLK_VOLUMEDOWN = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_VOLUMEDOWN),
    SDLK_KP_COMMA = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_COMMA),
    SDLK_KP_EQUALSAS400 =
        SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_EQUALSAS400),

    SDLK_ALTERASE = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_ALTERASE),
    SDLK_SYSREQ = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_SYSREQ),
    SDLK_CANCEL = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_CANCEL),
    SDLK_CLEAR = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_CLEAR),
    SDLK_PRIOR = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_PRIOR),
    SDLK_RETURN2 = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_RETURN2),
    SDLK_SEPARATOR = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_SEPARATOR),
    SDLK_OUT = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_OUT),
    SDLK_OPER = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_OPER),
    SDLK_CLEARAGAIN = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_CLEARAGAIN),
    SDLK_CRSEL = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_CRSEL),
    SDLK_EXSEL = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_EXSEL),

    SDLK_KP_00 = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_00),
    SDLK_KP_000 = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_000),
    SDLK_THOUSANDSSEPARATOR =
        SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_THOUSANDSSEPARATOR),
    SDLK_DECIMALSEPARATOR =
        SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_DECIMALSEPARATOR),
    SDLK_CURRENCYUNIT = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_CURRENCYUNIT),
    SDLK_CURRENCYSUBUNIT =
        SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_CURRENCYSUBUNIT),
    SDLK_KP_LEFTPAREN = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_LEFTPAREN),
    SDLK_KP_RIGHTPAREN = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_RIGHTPAREN),
    SDLK_KP_LEFTBRACE = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_LEFTBRACE),
    SDLK_KP_RIGHTBRACE = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_RIGHTBRACE),
    SDLK_KP_TAB = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_TAB),
    SDLK_KP_BACKSPACE = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_BACKSPACE),
    SDLK_KP_A = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_A),
    SDLK_KP_B = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_B),
    SDLK_KP_C = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_C),
    SDLK_KP_D = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_D),
    SDLK_KP_E = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_E),
    SDLK_KP_F = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_F),
    SDLK_KP_XOR = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_XOR),
    SDLK_KP_POWER = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_POWER),
    SDLK_KP_PERCENT = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_PERCENT),
    SDLK_KP_LESS = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_LESS),
    SDLK_KP_GREATER = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_GREATER),
    SDLK_KP_AMPERSAND = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_AMPERSAND),
    SDLK_KP_DBLAMPERSAND =
        SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_DBLAMPERSAND),
    SDLK_KP_VERTICALBAR =
        SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_VERTICALBAR),
    SDLK_KP_DBLVERTICALBAR =
        SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_DBLVERTICALBAR),
    SDLK_KP_COLON = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_COLON),
    SDLK_KP_HASH = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_HASH),
    SDLK_KP_SPACE = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_SPACE),
    SDLK_KP_AT = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_AT),
    SDLK_KP_EXCLAM = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_EXCLAM),
    SDLK_KP_MEMSTORE = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_MEMSTORE),
    SDLK_KP_MEMRECALL = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_MEMRECALL),
    SDLK_KP_MEMCLEAR = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_MEMCLEAR),
    SDLK_KP_MEMADD = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_MEMADD),
    SDLK_KP_MEMSUBTRACT =
        SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_MEMSUBTRACT),
    SDLK_KP_MEMMULTIPLY =
        SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_MEMMULTIPLY),
    SDLK_KP_MEMDIVIDE = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_MEMDIVIDE),
    SDLK_KP_PLUSMINUS = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_PLUSMINUS),
    SDLK_KP_CLEAR = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_CLEAR),
    SDLK_KP_CLEARENTRY = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_CLEARENTRY),
    SDLK_KP_BINARY = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_BINARY),
    SDLK_KP_OCTAL = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_OCTAL),
    SDLK_KP_DECIMAL = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_DECIMAL),
    SDLK_KP_HEXADECIMAL =
        SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KP_HEXADECIMAL),

    SDLK_LCTRL = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_LCTRL),
    SDLK_LSHIFT = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_LSHIFT),
    SDLK_LALT = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_LALT),
    SDLK_LGUI = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_LGUI),
    SDLK_RCTRL = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_RCTRL),
    SDLK_RSHIFT = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_RSHIFT),
    SDLK_RALT = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_RALT),
    SDLK_RGUI = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_RGUI),

    SDLK_MODE = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_MODE),

    SDLK_AUDIONEXT = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_AUDIONEXT),
    SDLK_AUDIOPREV = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_AUDIOPREV),
    SDLK_AUDIOSTOP = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_AUDIOSTOP),
    SDLK_AUDIOPLAY = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_AUDIOPLAY),
    SDLK_AUDIOMUTE = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_AUDIOMUTE),
    SDLK_MEDIASELECT = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_MEDIASELECT),
    SDLK_WWW = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_WWW),
    SDLK_MAIL = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_MAIL),
    SDLK_CALCULATOR = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_CALCULATOR),
    SDLK_COMPUTER = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_COMPUTER),
    SDLK_AC_SEARCH = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_AC_SEARCH),
    SDLK_AC_HOME = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_AC_HOME),
    SDLK_AC_BACK = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_AC_BACK),
    SDLK_AC_FORWARD = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_AC_FORWARD),
    SDLK_AC_STOP = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_AC_STOP),
    SDLK_AC_REFRESH = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_AC_REFRESH),
    SDLK_AC_BOOKMARKS = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_AC_BOOKMARKS),

    SDLK_BRIGHTNESSDOWN =
        SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_BRIGHTNESSDOWN),
    SDLK_BRIGHTNESSUP = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_BRIGHTNESSUP),
    SDLK_DISPLAYSWITCH = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_DISPLAYSWITCH),
    SDLK_KBDILLUMTOGGLE =
        SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KBDILLUMTOGGLE),
    SDLK_KBDILLUMDOWN = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KBDILLUMDOWN),
    SDLK_KBDILLUMUP = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_KBDILLUMUP),
    SDLK_EJECT = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_EJECT),
    SDLK_SLEEP = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_SLEEP),
    SDLK_APP1 = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_APP1),
    SDLK_APP2 = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_APP2),

    SDLK_AUDIOREWIND = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_AUDIOREWIND),
    SDLK_AUDIOFASTFORWARD = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_AUDIOFASTFORWARD),

    SDLK_SOFTLEFT = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_SOFTLEFT),
    SDLK_SOFTRIGHT = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_SOFTRIGHT),
    SDLK_CALL = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_CALL),
    SDLK_ENDCALL = SDL_SCANCODE_TO_KEYCODE(SDL_SCANCODE_ENDCALL)
} SDL_KeyCode;

/**
 * \brief Enumeration of valid key mods (possibly OR'd together).
 */
typedef enum
{
    KMOD_NONE = 0x0000,
    KMOD_LSHIFT = 0x0001,
    KMOD_RSHIFT = 0x0002,
    KMOD_LCTRL = 0x0040,
    KMOD_RCTRL = 0x0080,
    KMOD_LALT = 0x0100,
    KMOD_RALT = 0x0200,
    KMOD_LGUI = 0x0400,
    KMOD_RGUI = 0x0800,
    KMOD_NUM = 0x1000,
    KMOD_CAPS = 0x2000,
    KMOD_MODE = 0x4000,
    KMOD_SCROLL = 0x8000,

    KMOD_CTRL = KMOD_LCTRL | KMOD_RCTRL,
    KMOD_SHIFT = KMOD_LSHIFT | KMOD_RSHIFT,
    KMOD_ALT = KMOD_LALT | KMOD_RALT,
    KMOD_GUI = KMOD_LGUI | KMOD_RGUI,

    KMOD_RESERVED = KMOD_SCROLL /* This is for source-level compatibility with SDL 2.0.0. */
} SDL_Keymod;



|#


(define *constant-sdl-quit* #x100)
(define *constant-sdl-keydown* #x300)
(define *constant-sdl-keyup* #x301)
(define *constant-sdl-mousemotion* #x400)

(define *constant-sdl-scancode-unknown* 0) 
(define *constant-sdl-scancode-a* 4) 
(define *constant-sdl-scancode-b* 5) 
(define *constant-sdl-scancode-c* 6) 
(define *constant-sdl-scancode-d* 7) 
(define *constant-sdl-scancode-e* 8) 
(define *constant-sdl-scancode-f* 9) 
(define *constant-sdl-scancode-g* 10) 
(define *constant-sdl-scancode-h* 11) 
(define *constant-sdl-scancode-i* 12) 
(define *constant-sdl-scancode-j* 13) 
(define *constant-sdl-scancode-k* 14) 
(define *constant-sdl-scancode-l* 15) 
(define *constant-sdl-scancode-m* 16) 
(define *constant-sdl-scancode-n* 17) 
(define *constant-sdl-scancode-o* 18) 
(define *constant-sdl-scancode-p* 19) 
(define *constant-sdl-scancode-q* 20) 
(define *constant-sdl-scancode-r* 21) 
(define *constant-sdl-scancode-s* 22) 
(define *constant-sdl-scancode-t* 23) 
(define *constant-sdl-scancode-u* 24) 
(define *constant-sdl-scancode-v* 25) 
(define *constant-sdl-scancode-w* 26) 
(define *constant-sdl-scancode-x* 27) 
(define *constant-sdl-scancode-y* 28) 
(define *constant-sdl-scancode-z* 29) 
(define *constant-sdl-scancode-1* 30) 
(define *constant-sdl-scancode-2* 31) 
(define *constant-sdl-scancode-3* 32) 
(define *constant-sdl-scancode-4* 33) 
(define *constant-sdl-scancode-5* 34) 
(define *constant-sdl-scancode-6* 35) 
(define *constant-sdl-scancode-7* 36) 
(define *constant-sdl-scancode-8* 37) 
(define *constant-sdl-scancode-9* 38) 
(define *constant-sdl-scancode-0* 39) 
(define *constant-sdl-scancode-return* 40) 
(define *constant-sdl-scancode-escape* 41) 
(define *constant-sdl-scancode-backspace* 42) 
(define *constant-sdl-scancode-tab* 43) 
(define *constant-sdl-scancode-space* 44) 
(define *constant-sdl-scancode-minus* 45) 
(define *constant-sdl-scancode-equals* 46) 
(define *constant-sdl-scancode-leftbracket* 47) 
(define *constant-sdl-scancode-rightbracket* 48) 
(define *constant-sdl-scancode-backslash* 49) 
(define *constant-sdl-scancode-nonushash* 50) 
(define *constant-sdl-scancode-semicolon* 51) 
(define *constant-sdl-scancode-apostrophe* 52) 
(define *constant-sdl-scancode-grave* 53) 
(define *constant-sdl-scancode-comma* 54) 
(define *constant-sdl-scancode-period* 55) 
(define *constant-sdl-scancode-slash* 56) 
(define *constant-sdl-scancode-capslock* 57) 
(define *constant-sdl-scancode-f1* 58) 
(define *constant-sdl-scancode-f2* 59) 
(define *constant-sdl-scancode-f3* 60) 
(define *constant-sdl-scancode-f4* 61) 
(define *constant-sdl-scancode-f5* 62) 
(define *constant-sdl-scancode-f6* 63) 
(define *constant-sdl-scancode-f7* 64) 
(define *constant-sdl-scancode-f8* 65) 
(define *constant-sdl-scancode-f9* 66) 
(define *constant-sdl-scancode-f10* 67) 
(define *constant-sdl-scancode-f11* 68) 
(define *constant-sdl-scancode-f12* 69) 
(define *constant-sdl-scancode-printscreen* 70) 
(define *constant-sdl-scancode-scrolllock* 71) 
(define *constant-sdl-scancode-pause* 72) 
(define *constant-sdl-scancode-insert* 73) 
(define *constant-sdl-scancode-home* 74) 
(define *constant-sdl-scancode-pageup* 75) 
(define *constant-sdl-scancode-delete* 76) 
(define *constant-sdl-scancode-end* 77) 
(define *constant-sdl-scancode-pagedown* 78) 
(define *constant-sdl-scancode-right* 79) 
(define *constant-sdl-scancode-left* 80) 
(define *constant-sdl-scancode-down* 81) 
(define *constant-sdl-scancode-up* 82) 
(define *constant-sdl-scancode-numlockclear* 83) 
(define *constant-sdl-scancode-kp-divide* 84) 
(define *constant-sdl-scancode-kp-multiply* 85) 
(define *constant-sdl-scancode-kp-minus* 86) 
(define *constant-sdl-scancode-kp-plus* 87) 
(define *constant-sdl-scancode-kp-enter* 88) 
(define *constant-sdl-scancode-kp-1* 89) 
(define *constant-sdl-scancode-kp-2* 90) 
(define *constant-sdl-scancode-kp-3* 91) 
(define *constant-sdl-scancode-kp-4* 92) 
(define *constant-sdl-scancode-kp-5* 93) 
(define *constant-sdl-scancode-kp-6* 94) 
(define *constant-sdl-scancode-kp-7* 95) 
(define *constant-sdl-scancode-kp-8* 96) 
(define *constant-sdl-scancode-kp-9* 97) 
(define *constant-sdl-scancode-kp-0* 98) 
(define *constant-sdl-scancode-kp-period* 99) 
(define *constant-sdl-scancode-nonusbackslash* 100) 
(define *constant-sdl-scancode-application* 101) 
(define *constant-sdl-scancode-power* 102) 
(define *constant-sdl-scancode-kp-equals* 103) 
(define *constant-sdl-scancode-f13* 104) 
(define *constant-sdl-scancode-f14* 105) 
(define *constant-sdl-scancode-f15* 106) 
(define *constant-sdl-scancode-f16* 107) 
(define *constant-sdl-scancode-f17* 108) 
(define *constant-sdl-scancode-f18* 109) 
(define *constant-sdl-scancode-f19* 110) 
(define *constant-sdl-scancode-f20* 111) 
(define *constant-sdl-scancode-f21* 112) 
(define *constant-sdl-scancode-f22* 113) 
(define *constant-sdl-scancode-f23* 114) 
(define *constant-sdl-scancode-f24* 115) 
(define *constant-sdl-scancode-execute* 116) 
(define *constant-sdl-scancode-help* 117) 
(define *constant-sdl-scancode-menu* 118) 
(define *constant-sdl-scancode-select* 119) 
(define *constant-sdl-scancode-stop* 120) 
(define *constant-sdl-scancode-again* 121) 
(define *constant-sdl-scancode-undo* 122) 
(define *constant-sdl-scancode-cut* 123) 
(define *constant-sdl-scancode-copy* 124) 
(define *constant-sdl-scancode-paste* 125) 
(define *constant-sdl-scancode-find* 126) 
(define *constant-sdl-scancode-mute* 127) 
(define *constant-sdl-scancode-volumeup* 128) 
(define *constant-sdl-scancode-volumedown* 129) 
(define *constant-sdl-scancode-lockingcapslock* 130) 
(define *constant-sdl-scancode-lockingnumlock* 131) 
(define *constant-sdl-scancode-lockingscrolllock* 132) 
(define *constant-sdl-scancode-kp-comma* 133) 
(define *constant-sdl-scancode-kp-equalsas400* 134) 
(define *constant-sdl-scancode-international1* 135) 
(define *constant-sdl-scancode-international2* 136) 
(define *constant-sdl-scancode-international3* 137) 
(define *constant-sdl-scancode-international4* 138) 
(define *constant-sdl-scancode-international5* 139) 
(define *constant-sdl-scancode-international6* 140) 
(define *constant-sdl-scancode-international7* 141) 
(define *constant-sdl-scancode-international8* 142) 
(define *constant-sdl-scancode-international9* 143) 
(define *constant-sdl-scancode-lang1* 144) 
(define *constant-sdl-scancode-lang2* 145) 
(define *constant-sdl-scancode-lang3* 146) 
(define *constant-sdl-scancode-lang4* 147) 
(define *constant-sdl-scancode-lang5* 148) 
(define *constant-sdl-scancode-lang6* 149) 
(define *constant-sdl-scancode-lang7* 150) 
(define *constant-sdl-scancode-lang8* 151) 
(define *constant-sdl-scancode-lang9* 152) 
(define *constant-sdl-scancode-alterase* 153) 
(define *constant-sdl-scancode-sysreq* 154) 
(define *constant-sdl-scancode-cancel* 155) 
(define *constant-sdl-scancode-clear* 156) 
(define *constant-sdl-scancode-prior* 157) 
(define *constant-sdl-scancode-return2* 158) 
(define *constant-sdl-scancode-separator* 159) 
(define *constant-sdl-scancode-out* 160) 
(define *constant-sdl-scancode-oper* 161) 
(define *constant-sdl-scancode-clearagain* 162) 
(define *constant-sdl-scancode-crsel* 163) 
(define *constant-sdl-scancode-exsel* 164) 
(define *constant-sdl-scancode-kp-00* 176) 
(define *constant-sdl-scancode-kp-000* 177) 
(define *constant-sdl-scancode-thousandsseparator* 178) 
(define *constant-sdl-scancode-decimalseparator* 179) 
(define *constant-sdl-scancode-currencyunit* 180) 
(define *constant-sdl-scancode-currencysubunit* 181) 
(define *constant-sdl-scancode-kp-leftparen* 182) 
(define *constant-sdl-scancode-kp-rightparen* 183) 
(define *constant-sdl-scancode-kp-leftbrace* 184) 
(define *constant-sdl-scancode-kp-rightbrace* 185) 
(define *constant-sdl-scancode-kp-tab* 186) 
(define *constant-sdl-scancode-kp-backspace* 187) 
(define *constant-sdl-scancode-kp-a* 188) 
(define *constant-sdl-scancode-kp-b* 189) 
(define *constant-sdl-scancode-kp-c* 190) 
(define *constant-sdl-scancode-kp-d* 191) 
(define *constant-sdl-scancode-kp-e* 192) 
(define *constant-sdl-scancode-kp-f* 193) 
(define *constant-sdl-scancode-kp-xor* 194) 
(define *constant-sdl-scancode-kp-power* 195) 
(define *constant-sdl-scancode-kp-percent* 196) 
(define *constant-sdl-scancode-kp-less* 197) 
(define *constant-sdl-scancode-kp-greater* 198) 
(define *constant-sdl-scancode-kp-ampersand* 199) 
(define *constant-sdl-scancode-kp-dblampersand* 200) 
(define *constant-sdl-scancode-kp-verticalbar* 201) 
(define *constant-sdl-scancode-kp-dblverticalbar* 202) 
(define *constant-sdl-scancode-kp-colon* 203) 
(define *constant-sdl-scancode-kp-hash* 204) 
(define *constant-sdl-scancode-kp-space* 205) 
(define *constant-sdl-scancode-kp-at* 206) 
(define *constant-sdl-scancode-kp-exclam* 207) 
(define *constant-sdl-scancode-kp-memstore* 208) 
(define *constant-sdl-scancode-kp-memrecall* 209) 
(define *constant-sdl-scancode-kp-memclear* 210) 
(define *constant-sdl-scancode-kp-memadd* 211) 
(define *constant-sdl-scancode-kp-memsubtract* 212) 
(define *constant-sdl-scancode-kp-memmultiply* 213) 
(define *constant-sdl-scancode-kp-memdivide* 214) 
(define *constant-sdl-scancode-kp-plusminus* 215) 
(define *constant-sdl-scancode-kp-clear* 216) 
(define *constant-sdl-scancode-kp-clearentry* 217) 
(define *constant-sdl-scancode-kp-binary* 218) 
(define *constant-sdl-scancode-kp-octal* 219) 
(define *constant-sdl-scancode-kp-decimal* 220) 
(define *constant-sdl-scancode-kp-hexadecimal* 221) 
(define *constant-sdl-scancode-lctrl* 224) 
(define *constant-sdl-scancode-lshift* 225) 
(define *constant-sdl-scancode-lalt* 226) 
(define *constant-sdl-scancode-lgui* 227) 
(define *constant-sdl-scancode-rctrl* 228) 
(define *constant-sdl-scancode-rshift* 229) 
(define *constant-sdl-scancode-ralt* 230) 
(define *constant-sdl-scancode-rgui* 231) 
(define *constant-sdl-scancode-mode* 257) 
(define *constant-sdl-scancode-audionext* 258) 
(define *constant-sdl-scancode-audioprev* 259) 
(define *constant-sdl-scancode-audiostop* 260) 
(define *constant-sdl-scancode-audioplay* 261) 
(define *constant-sdl-scancode-audiomute* 262) 
(define *constant-sdl-scancode-mediaselect* 263) 
(define *constant-sdl-scancode-www* 264) 
(define *constant-sdl-scancode-mail* 265) 
(define *constant-sdl-scancode-calculator* 266) 
(define *constant-sdl-scancode-computer* 267) 
(define *constant-sdl-scancode-ac-search* 268) 
(define *constant-sdl-scancode-ac-home* 269) 
(define *constant-sdl-scancode-ac-back* 270) 
(define *constant-sdl-scancode-ac-forward* 271) 
(define *constant-sdl-scancode-ac-stop* 272) 
(define *constant-sdl-scancode-ac-refresh* 273) 
(define *constant-sdl-scancode-ac-bookmarks* 274) 
(define *constant-sdl-scancode-brightnessdown* 275) 
(define *constant-sdl-scancode-brightnessup* 276) 
(define *constant-sdl-scancode-displayswitch* 277) 
(define *constant-sdl-scancode-kbdillumtoggle* 278) 
(define *constant-sdl-scancode-kbdillumdown* 279) 
(define *constant-sdl-scancode-kbdillumup* 280) 
(define *constant-sdl-scancode-eject* 281) 
(define *constant-sdl-scancode-sleep* 282) 
(define *constant-sdl-scancode-app1* 283) 
(define *constant-sdl-scancode-app2* 284) 
(define *constant-sdl-scancode-audiorewind* 285) 
(define *constant-sdl-scancode-audiofastforward* 286) 
(define *constant-sdl-scancode-softleft* 287) 
(define *constant-sdl-scancode-softright* 288) 
(define *constant-sdl-scancode-call* 289) 
(define *constant-sdl-scancode-endcall* 290) 
(define *constant-sdl-num-scancodes* 512) 

(define *keyboard-fn-vector* (make-vector 516 #f)) ;; somewhat largeer than 512

(define (register-keyboard-fn i fn)
  (vector-set! *keyboard-fn-vector* i fn))

(define (call-keyboard-fn i)
  (let ((fn (vector-ref *keyboard-fn-vector* i)))
    (cond
     (fn (fn))
     (#t (format #t "there is no keyboard fn dedicated to ~a ~%" i)))))


(register-keyboard-fn *constant-sdl-scancode-unknown* (lambda () (format #t "user pressed sdl-scancode-unknown key ~%")))
(register-keyboard-fn *constant-sdl-scancode-a* (lambda () (format #t "user pressed sdl-scancode-a key ~%")))
(register-keyboard-fn *constant-sdl-scancode-b* (lambda () (format #t "user pressed sdl-scancode-b key ~%")))
(register-keyboard-fn *constant-sdl-scancode-c* (lambda () (format #t "user pressed sdl-scancode-c key ~%")))
(register-keyboard-fn *constant-sdl-scancode-d* (lambda () (format #t "user pressed sdl-scancode-d key ~%")))
(register-keyboard-fn *constant-sdl-scancode-e* (lambda () (format #t "user pressed sdl-scancode-e key ~%")))
(register-keyboard-fn *constant-sdl-scancode-f* (lambda () (format #t "user pressed sdl-scancode-f key ~%")))
(register-keyboard-fn *constant-sdl-scancode-g* (lambda () (format #t "user pressed sdl-scancode-g key ~%")))
(register-keyboard-fn *constant-sdl-scancode-h* (lambda () (format #t "user pressed sdl-scancode-h key ~%")))
(register-keyboard-fn *constant-sdl-scancode-i* (lambda () (format #t "user pressed sdl-scancode-i key ~%")))
(register-keyboard-fn *constant-sdl-scancode-j* (lambda () (format #t "user pressed sdl-scancode-j key ~%")))
(register-keyboard-fn *constant-sdl-scancode-k* (lambda () (format #t "user pressed sdl-scancode-k key ~%")))
(register-keyboard-fn *constant-sdl-scancode-l* (lambda () (format #t "user pressed sdl-scancode-l key ~%")))
(register-keyboard-fn *constant-sdl-scancode-m* (lambda () (format #t "user pressed sdl-scancode-m key ~%")))
(register-keyboard-fn *constant-sdl-scancode-n* (lambda () (format #t "user pressed sdl-scancode-n key ~%")))
(register-keyboard-fn *constant-sdl-scancode-o* (lambda () (format #t "user pressed sdl-scancode-o key ~%")))
(register-keyboard-fn *constant-sdl-scancode-p* (lambda () (format #t "user pressed sdl-scancode-p key ~%")))
(register-keyboard-fn *constant-sdl-scancode-q* (lambda () (format #t "user pressed sdl-scancode-q key ~%")))
(register-keyboard-fn *constant-sdl-scancode-r* (lambda () (format #t "user pressed sdl-scancode-r key ~%")))
(register-keyboard-fn *constant-sdl-scancode-s* (lambda () (format #t "user pressed sdl-scancode-s key ~%")))
(register-keyboard-fn *constant-sdl-scancode-t* (lambda () (format #t "user pressed sdl-scancode-t key ~%")))
(register-keyboard-fn *constant-sdl-scancode-u* (lambda () (format #t "user pressed sdl-scancode-u key ~%")))
(register-keyboard-fn *constant-sdl-scancode-v* (lambda () (format #t "user pressed sdl-scancode-v key ~%")))
(register-keyboard-fn *constant-sdl-scancode-w* (lambda () (format #t "user pressed sdl-scancode-w key ~%")))
(register-keyboard-fn *constant-sdl-scancode-x* (lambda () (format #t "user pressed sdl-scancode-x key ~%")))
(register-keyboard-fn *constant-sdl-scancode-y* (lambda () (format #t "user pressed sdl-scancode-y key ~%")))
(register-keyboard-fn *constant-sdl-scancode-z* (lambda () (format #t "user pressed sdl-scancode-z key ~%")))
(register-keyboard-fn *constant-sdl-scancode-1* (lambda () (format #t "user pressed sdl-scancode-1 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-2* (lambda () (format #t "user pressed sdl-scancode-2 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-3* (lambda () (format #t "user pressed sdl-scancode-3 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-4* (lambda () (format #t "user pressed sdl-scancode-4 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-5* (lambda () (format #t "user pressed sdl-scancode-5 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-6* (lambda () (format #t "user pressed sdl-scancode-6 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-7* (lambda () (format #t "user pressed sdl-scancode-7 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-8* (lambda () (format #t "user pressed sdl-scancode-8 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-9* (lambda () (format #t "user pressed sdl-scancode-9 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-0* (lambda () (format #t "user pressed sdl-scancode-0 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-return* (lambda () (format #t "user pressed sdl-scancode-return key ~%")))
(register-keyboard-fn *constant-sdl-scancode-escape* (lambda () (format #t "user pressed sdl-scancode-escape key ~%")))
(register-keyboard-fn *constant-sdl-scancode-backspace* (lambda () (format #t "user pressed sdl-scancode-backspace key ~%")))
(register-keyboard-fn *constant-sdl-scancode-tab* (lambda () (format #t "user pressed sdl-scancode-tab key ~%")))
(register-keyboard-fn *constant-sdl-scancode-space* (lambda () (format #t "user pressed sdl-scancode-space key ~%")))
(register-keyboard-fn *constant-sdl-scancode-minus* (lambda () (format #t "user pressed sdl-scancode-minus key ~%")))
(register-keyboard-fn *constant-sdl-scancode-equals* (lambda () (format #t "user pressed sdl-scancode-equals key ~%")))
(register-keyboard-fn *constant-sdl-scancode-leftbracket* (lambda () (format #t "user pressed sdl-scancode-leftbracket key ~%")))
(register-keyboard-fn *constant-sdl-scancode-rightbracket* (lambda () (format #t "user pressed sdl-scancode-rightbracket key ~%")))
(register-keyboard-fn *constant-sdl-scancode-backslash* (lambda () (format #t "user pressed sdl-scancode-backslash key ~%")))
(register-keyboard-fn *constant-sdl-scancode-nonushash* (lambda () (format #t "user pressed sdl-scancode-nonushash key ~%")))
(register-keyboard-fn *constant-sdl-scancode-semicolon* (lambda () (format #t "user pressed sdl-scancode-semicolon key ~%")))
(register-keyboard-fn *constant-sdl-scancode-apostrophe* (lambda () (format #t "user pressed sdl-scancode-apostrophe key ~%")))
(register-keyboard-fn *constant-sdl-scancode-grave* (lambda () (format #t "user pressed sdl-scancode-grave key ~%")))
(register-keyboard-fn *constant-sdl-scancode-comma* (lambda () (format #t "user pressed sdl-scancode-comma key ~%")))
(register-keyboard-fn *constant-sdl-scancode-period* (lambda () (format #t "user pressed sdl-scancode-period key ~%")))
(register-keyboard-fn *constant-sdl-scancode-slash* (lambda () (format #t "user pressed sdl-scancode-slash key ~%")))
(register-keyboard-fn *constant-sdl-scancode-capslock* (lambda () (format #t "user pressed sdl-scancode-capslock key ~%")))
(register-keyboard-fn *constant-sdl-scancode-f1* (lambda () (format #t "user pressed sdl-scancode-f1 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-f2* (lambda () (format #t "user pressed sdl-scancode-f2 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-f3* (lambda () (format #t "user pressed sdl-scancode-f3 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-f4* (lambda () (format #t "user pressed sdl-scancode-f4 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-f5* (lambda () (format #t "user pressed sdl-scancode-f5 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-f6* (lambda () (format #t "user pressed sdl-scancode-f6 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-f7* (lambda () (format #t "user pressed sdl-scancode-f7 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-f8* (lambda () (format #t "user pressed sdl-scancode-f8 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-f9* (lambda () (format #t "user pressed sdl-scancode-f9 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-f10* (lambda () (format #t "user pressed sdl-scancode-f10 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-f11* (lambda () (format #t "user pressed sdl-scancode-f11 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-f12* (lambda () (format #t "user pressed sdl-scancode-f12 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-printscreen* (lambda () (format #t "user pressed sdl-scancode-printscreen key ~%")))
(register-keyboard-fn *constant-sdl-scancode-scrolllock* (lambda () (format #t "user pressed sdl-scancode-scrolllock key ~%")))
(register-keyboard-fn *constant-sdl-scancode-pause* (lambda () (format #t "user pressed sdl-scancode-pause key ~%")))
(register-keyboard-fn *constant-sdl-scancode-insert* (lambda () (format #t "user pressed sdl-scancode-insert key ~%")))
(register-keyboard-fn *constant-sdl-scancode-home* (lambda () (format #t "user pressed sdl-scancode-home key ~%")))
(register-keyboard-fn *constant-sdl-scancode-pageup* (lambda () (format #t "user pressed sdl-scancode-pageup key ~%")))
(register-keyboard-fn *constant-sdl-scancode-delete* (lambda () (format #t "user pressed sdl-scancode-delete key ~%")))
(register-keyboard-fn *constant-sdl-scancode-end* (lambda () (format #t "user pressed sdl-scancode-end key ~%")))
(register-keyboard-fn *constant-sdl-scancode-pagedown* (lambda () (format #t "user pressed sdl-scancode-pagedown key ~%")))
(register-keyboard-fn *constant-sdl-scancode-right* (lambda () (format #t "user pressed sdl-scancode-right key ~%")))
(register-keyboard-fn *constant-sdl-scancode-left* (lambda () (format #t "user pressed sdl-scancode-left key ~%")))
(register-keyboard-fn *constant-sdl-scancode-down* (lambda () (format #t "user pressed sdl-scancode-down key ~%")))
(register-keyboard-fn *constant-sdl-scancode-up* (lambda () (format #t "user pressed sdl-scancode-up key ~%")))
(register-keyboard-fn *constant-sdl-scancode-numlockclear* (lambda () (format #t "user pressed sdl-scancode-numlockclear key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-divide* (lambda () (format #t "user pressed sdl-scancode-kp-divide key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-multiply* (lambda () (format #t "user pressed sdl-scancode-kp-multiply key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-minus* (lambda () (format #t "user pressed sdl-scancode-kp-minus key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-plus* (lambda () (format #t "user pressed sdl-scancode-kp-plus key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-enter* (lambda () (format #t "user pressed sdl-scancode-kp-enter key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-1* (lambda () (format #t "user pressed sdl-scancode-kp-1 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-2* (lambda () (format #t "user pressed sdl-scancode-kp-2 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-3* (lambda () (format #t "user pressed sdl-scancode-kp-3 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-4* (lambda () (format #t "user pressed sdl-scancode-kp-4 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-5* (lambda () (format #t "user pressed sdl-scancode-kp-5 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-6* (lambda () (format #t "user pressed sdl-scancode-kp-6 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-7* (lambda () (format #t "user pressed sdl-scancode-kp-7 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-8* (lambda () (format #t "user pressed sdl-scancode-kp-8 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-9* (lambda () (format #t "user pressed sdl-scancode-kp-9 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-0* (lambda () (format #t "user pressed sdl-scancode-kp-0 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-period* (lambda () (format #t "user pressed sdl-scancode-kp-period key ~%")))
(register-keyboard-fn *constant-sdl-scancode-nonusbackslash* (lambda () (format #t "user pressed sdl-scancode-nonusbackslash key ~%")))
(register-keyboard-fn *constant-sdl-scancode-application* (lambda () (format #t "user pressed sdl-scancode-application key ~%")))
(register-keyboard-fn *constant-sdl-scancode-power* (lambda () (format #t "user pressed sdl-scancode-power key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-equals* (lambda () (format #t "user pressed sdl-scancode-kp-equals key ~%")))
(register-keyboard-fn *constant-sdl-scancode-f13* (lambda () (format #t "user pressed sdl-scancode-f13 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-f14* (lambda () (format #t "user pressed sdl-scancode-f14 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-f15* (lambda () (format #t "user pressed sdl-scancode-f15 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-f16* (lambda () (format #t "user pressed sdl-scancode-f16 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-f17* (lambda () (format #t "user pressed sdl-scancode-f17 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-f18* (lambda () (format #t "user pressed sdl-scancode-f18 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-f19* (lambda () (format #t "user pressed sdl-scancode-f19 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-f20* (lambda () (format #t "user pressed sdl-scancode-f20 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-f21* (lambda () (format #t "user pressed sdl-scancode-f21 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-f22* (lambda () (format #t "user pressed sdl-scancode-f22 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-f23* (lambda () (format #t "user pressed sdl-scancode-f23 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-f24* (lambda () (format #t "user pressed sdl-scancode-f24 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-execute* (lambda () (format #t "user pressed sdl-scancode-execute key ~%")))
(register-keyboard-fn *constant-sdl-scancode-help* (lambda () (format #t "user pressed sdl-scancode-help key ~%")))
(register-keyboard-fn *constant-sdl-scancode-menu* (lambda () (format #t "user pressed sdl-scancode-menu key ~%")))
(register-keyboard-fn *constant-sdl-scancode-select* (lambda () (format #t "user pressed sdl-scancode-select key ~%")))
(register-keyboard-fn *constant-sdl-scancode-stop* (lambda () (format #t "user pressed sdl-scancode-stop key ~%")))
(register-keyboard-fn *constant-sdl-scancode-again* (lambda () (format #t "user pressed sdl-scancode-again key ~%")))
(register-keyboard-fn *constant-sdl-scancode-undo* (lambda () (format #t "user pressed sdl-scancode-undo key ~%")))
(register-keyboard-fn *constant-sdl-scancode-cut* (lambda () (format #t "user pressed sdl-scancode-cut key ~%")))
(register-keyboard-fn *constant-sdl-scancode-copy* (lambda () (format #t "user pressed sdl-scancode-copy key ~%")))
(register-keyboard-fn *constant-sdl-scancode-paste* (lambda () (format #t "user pressed sdl-scancode-paste key ~%")))
(register-keyboard-fn *constant-sdl-scancode-find* (lambda () (format #t "user pressed sdl-scancode-find key ~%")))
(register-keyboard-fn *constant-sdl-scancode-mute* (lambda () (format #t "user pressed sdl-scancode-mute key ~%")))
(register-keyboard-fn *constant-sdl-scancode-volumeup* (lambda () (format #t "user pressed sdl-scancode-volumeup key ~%")))
(register-keyboard-fn *constant-sdl-scancode-volumedown* (lambda () (format #t "user pressed sdl-scancode-volumedown key ~%")))
(register-keyboard-fn *constant-sdl-scancode-lockingcapslock* (lambda () (format #t "user pressed sdl-scancode-lockingcapslock key ~%")))
(register-keyboard-fn *constant-sdl-scancode-lockingnumlock* (lambda () (format #t "user pressed sdl-scancode-lockingnumlock key ~%")))
(register-keyboard-fn *constant-sdl-scancode-lockingscrolllock* (lambda () (format #t "user pressed sdl-scancode-lockingscrolllock key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-comma* (lambda () (format #t "user pressed sdl-scancode-kp-comma key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-equalsas400* (lambda () (format #t "user pressed sdl-scancode-kp-equalsas400 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-international1* (lambda () (format #t "user pressed sdl-scancode-international1 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-international2* (lambda () (format #t "user pressed sdl-scancode-international2 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-international3* (lambda () (format #t "user pressed sdl-scancode-international3 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-international4* (lambda () (format #t "user pressed sdl-scancode-international4 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-international5* (lambda () (format #t "user pressed sdl-scancode-international5 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-international6* (lambda () (format #t "user pressed sdl-scancode-international6 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-international7* (lambda () (format #t "user pressed sdl-scancode-international7 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-international8* (lambda () (format #t "user pressed sdl-scancode-international8 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-international9* (lambda () (format #t "user pressed sdl-scancode-international9 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-lang1* (lambda () (format #t "user pressed sdl-scancode-lang1 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-lang2* (lambda () (format #t "user pressed sdl-scancode-lang2 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-lang3* (lambda () (format #t "user pressed sdl-scancode-lang3 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-lang4* (lambda () (format #t "user pressed sdl-scancode-lang4 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-lang5* (lambda () (format #t "user pressed sdl-scancode-lang5 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-lang6* (lambda () (format #t "user pressed sdl-scancode-lang6 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-lang7* (lambda () (format #t "user pressed sdl-scancode-lang7 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-lang8* (lambda () (format #t "user pressed sdl-scancode-lang8 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-lang9* (lambda () (format #t "user pressed sdl-scancode-lang9 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-alterase* (lambda () (format #t "user pressed sdl-scancode-alterase key ~%")))
(register-keyboard-fn *constant-sdl-scancode-sysreq* (lambda () (format #t "user pressed sdl-scancode-sysreq key ~%")))
(register-keyboard-fn *constant-sdl-scancode-cancel* (lambda () (format #t "user pressed sdl-scancode-cancel key ~%")))
(register-keyboard-fn *constant-sdl-scancode-clear* (lambda () (format #t "user pressed sdl-scancode-clear key ~%")))
(register-keyboard-fn *constant-sdl-scancode-prior* (lambda () (format #t "user pressed sdl-scancode-prior key ~%")))
(register-keyboard-fn *constant-sdl-scancode-return2* (lambda () (format #t "user pressed sdl-scancode-return2 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-separator* (lambda () (format #t "user pressed sdl-scancode-separator key ~%")))
(register-keyboard-fn *constant-sdl-scancode-out* (lambda () (format #t "user pressed sdl-scancode-out key ~%")))
(register-keyboard-fn *constant-sdl-scancode-oper* (lambda () (format #t "user pressed sdl-scancode-oper key ~%")))
(register-keyboard-fn *constant-sdl-scancode-clearagain* (lambda () (format #t "user pressed sdl-scancode-clearagain key ~%")))
(register-keyboard-fn *constant-sdl-scancode-crsel* (lambda () (format #t "user pressed sdl-scancode-crsel key ~%")))
(register-keyboard-fn *constant-sdl-scancode-exsel* (lambda () (format #t "user pressed sdl-scancode-exsel key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-00* (lambda () (format #t "user pressed sdl-scancode-kp-00 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-000* (lambda () (format #t "user pressed sdl-scancode-kp-000 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-thousandsseparator* (lambda () (format #t "user pressed sdl-scancode-thousandsseparator key ~%")))
(register-keyboard-fn *constant-sdl-scancode-decimalseparator* (lambda () (format #t "user pressed sdl-scancode-decimalseparator key ~%")))
(register-keyboard-fn *constant-sdl-scancode-currencyunit* (lambda () (format #t "user pressed sdl-scancode-currencyunit key ~%")))
(register-keyboard-fn *constant-sdl-scancode-currencysubunit* (lambda () (format #t "user pressed sdl-scancode-currencysubunit key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-leftparen* (lambda () (format #t "user pressed sdl-scancode-kp-leftparen key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-rightparen* (lambda () (format #t "user pressed sdl-scancode-kp-rightparen key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-leftbrace* (lambda () (format #t "user pressed sdl-scancode-kp-leftbrace key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-rightbrace* (lambda () (format #t "user pressed sdl-scancode-kp-rightbrace key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-tab* (lambda () (format #t "user pressed sdl-scancode-kp-tab key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-backspace* (lambda () (format #t "user pressed sdl-scancode-kp-backspace key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-a* (lambda () (format #t "user pressed sdl-scancode-kp-a key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-b* (lambda () (format #t "user pressed sdl-scancode-kp-b key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-c* (lambda () (format #t "user pressed sdl-scancode-kp-c key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-d* (lambda () (format #t "user pressed sdl-scancode-kp-d key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-e* (lambda () (format #t "user pressed sdl-scancode-kp-e key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-f* (lambda () (format #t "user pressed sdl-scancode-kp-f key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-xor* (lambda () (format #t "user pressed sdl-scancode-kp-xor key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-power* (lambda () (format #t "user pressed sdl-scancode-kp-power key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-percent* (lambda () (format #t "user pressed sdl-scancode-kp-percent key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-less* (lambda () (format #t "user pressed sdl-scancode-kp-less key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-greater* (lambda () (format #t "user pressed sdl-scancode-kp-greater key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-ampersand* (lambda () (format #t "user pressed sdl-scancode-kp-ampersand key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-dblampersand* (lambda () (format #t "user pressed sdl-scancode-kp-dblampersand key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-verticalbar* (lambda () (format #t "user pressed sdl-scancode-kp-verticalbar key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-dblverticalbar* (lambda () (format #t "user pressed sdl-scancode-kp-dblverticalbar key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-colon* (lambda () (format #t "user pressed sdl-scancode-kp-colon key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-hash* (lambda () (format #t "user pressed sdl-scancode-kp-hash key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-space* (lambda () (format #t "user pressed sdl-scancode-kp-space key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-at* (lambda () (format #t "user pressed sdl-scancode-kp-at key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-exclam* (lambda () (format #t "user pressed sdl-scancode-kp-exclam key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-memstore* (lambda () (format #t "user pressed sdl-scancode-kp-memstore key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-memrecall* (lambda () (format #t "user pressed sdl-scancode-kp-memrecall key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-memclear* (lambda () (format #t "user pressed sdl-scancode-kp-memclear key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-memadd* (lambda () (format #t "user pressed sdl-scancode-kp-memadd key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-memsubtract* (lambda () (format #t "user pressed sdl-scancode-kp-memsubtract key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-memmultiply* (lambda () (format #t "user pressed sdl-scancode-kp-memmultiply key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-memdivide* (lambda () (format #t "user pressed sdl-scancode-kp-memdivide key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-plusminus* (lambda () (format #t "user pressed sdl-scancode-kp-plusminus key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-clear* (lambda () (format #t "user pressed sdl-scancode-kp-clear key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-clearentry* (lambda () (format #t "user pressed sdl-scancode-kp-clearentry key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-binary* (lambda () (format #t "user pressed sdl-scancode-kp-binary key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-octal* (lambda () (format #t "user pressed sdl-scancode-kp-octal key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-decimal* (lambda () (format #t "user pressed sdl-scancode-kp-decimal key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kp-hexadecimal* (lambda () (format #t "user pressed sdl-scancode-kp-hexadecimal key ~%")))
(register-keyboard-fn *constant-sdl-scancode-lctrl* (lambda () (format #t "user pressed sdl-scancode-lctrl key ~%")))
(register-keyboard-fn *constant-sdl-scancode-lshift* (lambda () (format #t "user pressed sdl-scancode-lshift key ~%")))
(register-keyboard-fn *constant-sdl-scancode-lalt* (lambda () (format #t "user pressed sdl-scancode-lalt key ~%")))
(register-keyboard-fn *constant-sdl-scancode-lgui* (lambda () (format #t "user pressed sdl-scancode-lgui key ~%")))
(register-keyboard-fn *constant-sdl-scancode-rctrl* (lambda () (format #t "user pressed sdl-scancode-rctrl key ~%")))
(register-keyboard-fn *constant-sdl-scancode-rshift* (lambda () (format #t "user pressed sdl-scancode-rshift key ~%")))
(register-keyboard-fn *constant-sdl-scancode-ralt* (lambda () (format #t "user pressed sdl-scancode-ralt key ~%")))
(register-keyboard-fn *constant-sdl-scancode-rgui* (lambda () (format #t "user pressed sdl-scancode-rgui key ~%")))
(register-keyboard-fn *constant-sdl-scancode-mode* (lambda () (format #t "user pressed sdl-scancode-mode key ~%")))
(register-keyboard-fn *constant-sdl-scancode-audionext* (lambda () (format #t "user pressed sdl-scancode-audionext key ~%")))
(register-keyboard-fn *constant-sdl-scancode-audioprev* (lambda () (format #t "user pressed sdl-scancode-audioprev key ~%")))
(register-keyboard-fn *constant-sdl-scancode-audiostop* (lambda () (format #t "user pressed sdl-scancode-audiostop key ~%")))
(register-keyboard-fn *constant-sdl-scancode-audioplay* (lambda () (format #t "user pressed sdl-scancode-audioplay key ~%")))
(register-keyboard-fn *constant-sdl-scancode-audiomute* (lambda () (format #t "user pressed sdl-scancode-audiomute key ~%")))
(register-keyboard-fn *constant-sdl-scancode-mediaselect* (lambda () (format #t "user pressed sdl-scancode-mediaselect key ~%")))
(register-keyboard-fn *constant-sdl-scancode-www* (lambda () (format #t "user pressed sdl-scancode-www key ~%")))
(register-keyboard-fn *constant-sdl-scancode-mail* (lambda () (format #t "user pressed sdl-scancode-mail key ~%")))
(register-keyboard-fn *constant-sdl-scancode-calculator* (lambda () (format #t "user pressed sdl-scancode-calculator key ~%")))
(register-keyboard-fn *constant-sdl-scancode-computer* (lambda () (format #t "user pressed sdl-scancode-computer key ~%")))
(register-keyboard-fn *constant-sdl-scancode-ac-search* (lambda () (format #t "user pressed sdl-scancode-ac-search key ~%")))
(register-keyboard-fn *constant-sdl-scancode-ac-home* (lambda () (format #t "user pressed sdl-scancode-ac-home key ~%")))
(register-keyboard-fn *constant-sdl-scancode-ac-back* (lambda () (format #t "user pressed sdl-scancode-ac-back key ~%")))
(register-keyboard-fn *constant-sdl-scancode-ac-forward* (lambda () (format #t "user pressed sdl-scancode-ac-forward key ~%")))
(register-keyboard-fn *constant-sdl-scancode-ac-stop* (lambda () (format #t "user pressed sdl-scancode-ac-stop key ~%")))
(register-keyboard-fn *constant-sdl-scancode-ac-refresh* (lambda () (format #t "user pressed sdl-scancode-ac-refresh key ~%")))
(register-keyboard-fn *constant-sdl-scancode-ac-bookmarks* (lambda () (format #t "user pressed sdl-scancode-ac-bookmarks key ~%")))
(register-keyboard-fn *constant-sdl-scancode-brightnessdown* (lambda () (format #t "user pressed sdl-scancode-brightnessdown key ~%")))
(register-keyboard-fn *constant-sdl-scancode-brightnessup* (lambda () (format #t "user pressed sdl-scancode-brightnessup key ~%")))
(register-keyboard-fn *constant-sdl-scancode-displayswitch* (lambda () (format #t "user pressed sdl-scancode-displayswitch key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kbdillumtoggle* (lambda () (format #t "user pressed sdl-scancode-kbdillumtoggle key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kbdillumdown* (lambda () (format #t "user pressed sdl-scancode-kbdillumdown key ~%")))
(register-keyboard-fn *constant-sdl-scancode-kbdillumup* (lambda () (format #t "user pressed sdl-scancode-kbdillumup key ~%")))
(register-keyboard-fn *constant-sdl-scancode-eject* (lambda () (format #t "user pressed sdl-scancode-eject key ~%")))
(register-keyboard-fn *constant-sdl-scancode-sleep* (lambda () (format #t "user pressed sdl-scancode-sleep key ~%")))
(register-keyboard-fn *constant-sdl-scancode-app1* (lambda () (format #t "user pressed sdl-scancode-app1 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-app2* (lambda () (format #t "user pressed sdl-scancode-app2 key ~%")))
(register-keyboard-fn *constant-sdl-scancode-audiorewind* (lambda () (format #t "user pressed sdl-scancode-audiorewind key ~%")))
(register-keyboard-fn *constant-sdl-scancode-audiofastforward* (lambda () (format #t "user pressed sdl-scancode-audiofastforward key ~%")))
(register-keyboard-fn *constant-sdl-scancode-softleft* (lambda () (format #t "user pressed sdl-scancode-softleft key ~%")))
(register-keyboard-fn *constant-sdl-scancode-softright* (lambda () (format #t "user pressed sdl-scancode-softright key ~%")))
(register-keyboard-fn *constant-sdl-scancode-call* (lambda () (format #t "user pressed sdl-scancode-call key ~%")))
(register-keyboard-fn *constant-sdl-scancode-endcall* (lambda () (format #t "user pressed sdl-scancode-endcall key ~%")))
(register-keyboard-fn *constant-sdl-num-scancodes* (lambda () (format #t "user pressed sdl-num-scancodes key ~%")))

#|

int SDL_FillRect (SDL_Surface * dst, const SDL_Rect * rect, Uint32 color);

typedef struct SDL_Rect
{
    int x, y;
    int w, h;
} SDL_Rect;


================= SDL_Rect ============= 
SDL_Rect has size in bytes of : 16
SDL_Rect x : 0
SDL_Rect y : 4
SDL_Rect w: 8
SDL_Rect h : 12


signed int prefix s ; we can see x takes 4 bytes 0 1 2 3 ; since 4 bytes is 32bits  named is s32 

x sint 0
y sint 4
w sint 8
h sint 12

need create a bytevector of size 16 , offset 0 = x ; offset 4 = y ; offset w = 8 ; offset h = 12 


|#




(define (make-sdl-rect x y w h)
  (let* ((size 16)
	 (bv (make-bytevector size 0)))
    (bytevector-s32-native-set! bv 0 x);; x
    (bytevector-s32-native-set! bv 4 y);; y
    (bytevector-s32-native-set! bv 8 w);; width
    (bytevector-s32-native-set! bv 12 h);; height
    bv))

(define (make-sdl-rect-pointer x y w h)
  (bytevector->pointer (make-sdl-rect x y w h)))


(define (make-sdl-color red green blue)  (logior (ash red 16) (ash green 8) blue))

(define *mouse-x* 0)
(define *mouse-y* 0)

;; 640 x 480
(define *screen-width* 640)
(define *screen-height* 480)

;; determine how big the window actually is ?
;; have a number of bouncing blocks
(define *blocks-count* 100)
(define *blocks* (make-vector *blocks-count* #f))

;; (define (size-int) 4) 

;; initialise blocks
;; using bytevector during loading with shared libraries causes seg fault
(define (initialize-blocks)
  (letrec ((foo (lambda (i)
		  (when (< i *blocks-count*)
		    (let ((bv (make-vector 4)))
		      (vector-set! bv 0 (random 640))
		      (vector-set! bv 1 (random 480))
		      (vector-set! bv 2 (/ (random 10) 100))
		      (vector-set! bv 3 (/ (random 10) 100))
		      ;;(bytevector-s32-native-set! bv 16 (random 10))
		      ;;(bytevector-s32-native-set! bv 20 (random 10))u
		      (vector-set! *blocks* i bv))
		    (foo (+ i 1))))))
    (foo 0)))



;; update all blocks
(define (update-blocks)
  (letrec ((foo (lambda (i)
		  (when (< i *blocks-count*)
		    (let ((bv (vector-ref *blocks* i)))
		      (let ((x (vector-ref bv 0))
			    (y (vector-ref bv 1))
			    (vx (vector-ref bv 2))
			    (vy (vector-ref bv 3)))
			(set! x (+ x vx))
			(set! y (+ y vy))
			(when (> x *screen-width*)
			  (set! x *screen-width*)
			  (set! vx (- vx)))
			(when (> y *screen-height*)
			  (set! y *screen-height*)
			  (set! vy (- vy)))
			(when (< x 0)
			  (set! x 0)
			  (set! vx (- vx)))
			(when (< y 0)
			  (set! y 0)
			  (set! vy (- vy)))
			(vector-set! bv 0 x)
			(vector-set! bv 1 y)
			(vector-set! bv 2 vx)
			(vector-set! bv 3 vy)))
		    (foo (+ i 1))))))
  (foo 0)))
  
(define (show-blocks render)
  (letrec ((foo (lambda (i)
		  (when (< i *blocks-count*)
		    (let ((bv (vector-ref *blocks* i)))
		      (let ((x (vector-ref bv 0))
			    (y (vector-ref bv 1))
			    (vx (vector-ref bv 2))
			    (vy (vector-ref bv 3)))           ;;FI X  ME
			(let ((bvi (make-bytevector (* 4 (size-int)) 0)))
			  (bytevector-s32-native-set! bvi 0 (floor x)) ;; x
			  (bytevector-s32-native-set! bvi 4 (floor y)) ;; y
			  (bytevector-s32-native-set! bvi 8 20) ;; width 20 ?
			  (bytevector-s32-native-set! bvi 12 20) ;; height 20 ??			  
			  (sdl-render-fill-rect render (bytevector->pointer bvi)))))
		    (foo (+ i 1))))))
    (foo 0)))









;; keep looping until user quits window
;; https://lazyfoo.net/tutorials/SDL/03_event_driven_programming/index.php
;; 1 load a bitmap image
;; 2 optimized image for particular screen
;; 3 load images using IMG_Load jpeg gif - some other types just not a bitmap bmp ??
;; 4 moved to accelerated window 
;; 5 load texture
;; 6 
;;
;;
(define (skooldaze2)
  (let ((screen-width 1024)(screen-height 768))

    (define font-size 36)
    (define mTexture %null-pointer)
    (define mTexture-width 0)
    (define mTexture-height 0)
	   
    (sdl-init *constant-sdl-init-video*)
    (define image-init-result (image-init))
    (format #t "image-init-result ~a~%" image-init-result)

    (define ttf-init-result (ttf-init))
    (format #t "ttf-init-result ~a~%"  ttf-init-result)
    (cond
     ((zero? ttf-init-result) 'ok)
     (#t (format #t "ttf-init error~%")))
    
    
    (define window (create-window "hello world" screen-width screen-height))
    (define render (create-renderer window))    
    (cond
     ((equal? render %null-pointer)   (format #t "create render failed !~%"))
     (#t (format #t "created render success !~%")))

    (define texture (load-texture "zxspectrum.png" render))
    (format #t "texture created ~a~%" texture)
    
    (define surface (sdl-get-window-surface window))

    (format #t "surface pointer ptr ~a~%" surface)
    ;;(format #t "ptr->format ~a~%" (pixelformat (pointer-address surface)))
    (output-check)
    ;; 
    (define hello-bitmap *null*)
    ;;(define loaded-surface (sdl-load-bmp "hello.bmp"))

    ;; image-load only loads jpg png web tif 
    (define loaded-surface (image-load "zxspectrum.png"))
    (format #t "surface pointer ~a~%" surface)
    (format #t "surface address ~x~%" (pointer-address surface));; hex value
    (format #t "surface->format address ~x~%" (+ 8 (pointer-address surface)));; hex value
    (format #t "C pixelformat : surface->format address ~a~%" (pixelformat surface))

    ;; display actual bytes that make up surface->format a (SDL_PixelFormat *ptr)
    (pixelformat2 surface)
    
    ;; display bytes we think we see
    (let* ((length 8)
	   (offset 8)
	   (bv (pointer->bytevector surface length offset)))
      (format #t "scheme byte 0 : ~a ~%" (bytevector-u8-ref bv 0))
      (format #t "scheme byte 1 : ~a ~%" (bytevector-u8-ref bv 1))
      (format #t "scheme byte 2 : ~a ~%" (bytevector-u8-ref bv 2))
      (format #t "scheme byte 3 : ~a ~%" (bytevector-u8-ref bv 3))
      (format #t "scheme byte 4 : ~a ~%" (bytevector-u8-ref bv 4))
      (format #t "scheme byte 5 : ~a ~%" (bytevector-u8-ref bv 5))
      (format #t "scheme byte 6 : ~a ~%" (bytevector-u8-ref bv 6))
      (format #t "scheme byte 7 : ~a ~%" (bytevector-u8-ref bv 7)))
     
    ;;(define optimized-surface %null-pointer)    
    (define optimized-surface
      (let ((screen-format (pixelformat surface)))
	(sdl-convert-surface loaded-surface screen-format 0)))
    
    (cond
     ((equal? *null* optimized-surface)
      (set! hello-bitmap loaded-surface)
      (format #t "unable to optimize image~%")
      ;;(error "unable to optimize image ~a" (sdl-get-error))
      ) ;; c-string -> scheme string required     
     (#t (set! hello-bitmap optimized-surface)
	 (format #t "created optimized surface ~a~%" optimized-surface)
	 (sdl-free-surface loaded-surface)))

    (initialize-blocks)


    ;; your ttf-file goes here + point size
    ;; c char* not a guile string
    (define font %null-pointer)
    (let ((the-font "/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf"))
      (set! font (ttf-open-font (string->pointer the-font) font-size))
      (cond
       ((equal? font %null-pointer)
	(format #t "ttf font error cannot open font {~a}~%" the-font))
       (#t (format #t "ttf ~a obtained ok~%" the-font))))
    	      
    
    (define quit #f)

    (sdl-show-cursor 0) ;; 0=false 1=truthy
    ;; poll
    ;; create a C union struct the size of SDL_Event
    ;; and then manually populate struct obviating advantages of
    ;; make SDL_Event which is 32 bytes in size
    (define event (let ((size 36)(fill 0))
		    (make-bytevector size fill)))
    (define first-run #t)
    
    (while (not quit)
	   ;; poll for an event
	   (while (not (= 0 (sdl-poll-event (bytevector->pointer event))))
		  ;; if was new event then {event} itself will have the contents of it
		  ;; (endianness big)
		  ;; (endianness little)
		  (let ((type (bytevector-u32-native-ref event 0)))
		    (cond
		     ((= type *constant-sdl-quit*) ;; ======== quit event ==================
		      (format #t "the user quit the application !~%")
		      ;; if we quit - set quit flag to true and exit
		      (let ((type (bytevector-u32-native-ref event 0))
			    (timestamp (bytevector-u32-native-ref event 4)))
			(set! quit #t)))
		     ((= type *constant-sdl-keydown*) ;; ======== keydown event ==================
		      (let ((type (bytevector-u32-native-ref event 0))
			    (timestamp (bytevector-u32-native-ref event 4))
			    (windowid (bytevector-u32-native-ref event 8))
			    (state (bytevector-u8-ref event 12))
			    (repeat (bytevector-u8-ref event 13))
			    (padding2 (bytevector-u8-ref event 13))
			    (padding3 (bytevector-u8-ref event 14 ))
			    (keysym-scancode (bytevector-u32-native-ref event 16 ))
			    (keysym-sym (bytevector-s32-native-ref event 20 ))
			    (keysym-mod (bytevector-u16-native-ref event 24 )))

			;; do something first time this is run
			(when first-run
			  ;; allows us to escape the gui event loop easily
			  (register-keyboard-fn *constant-sdl-scancode-escape* (lambda () (set! quit #t)(format #t "user quit ! ~%")))
			  (set! first-run #f))
			
			;; call relevant key handler
			(call-keyboard-fn keysym-scancode)
			#|
			(cond
			 ((= keysym-scancode *constant-sdl-scancode-a*) (format #t "user pressed A key !~%"))
			 ((= keysym-scancode *constant-sdl-scancode-b*) (format #t "user pressed B key !~%"))
			 ((= keysym-scancode *constant-sdl-scancode-c*) (format #t "user pressed C key !~%"))
			 ((= keysym-scancode *constant-sdl-scancode-d*) (format #t "user pressed D key !~%"))
			 ((= keysym-scancode *constant-sdl-scancode-e*) (format #t "user pressed E key !~%"))
			(#t (format #t "user pressed key (scancode ~a) !~%" keysym-scancode)))
			|#
			
			))
		     ((= type *constant-sdl-keyup*) ;; ======== keyup event ==================
		      ;;(format #t "the user released a key !~%")
		      #f
		      )
		     ((= type *constant-sdl-mousemotion*) ;; ======== mouse motion event ==================
		      (let ((type (bytevector-u32-native-ref event 0 ))
			    (timestamp (bytevector-u32-native-ref event 4 ))
			    (windowid (bytevector-u32-native-ref event 8 ))
			    (state (bytevector-u32-native-ref event 12 ))
			    (x (bytevector-s32-native-ref event 20 ))
			    (y (bytevector-s32-native-ref event 24 ))
			    (xrel (bytevector-s32-native-ref event 28 ))
			    (yrel (bytevector-s32-native-ref event 32 )))
			;;(format #t "mouse move (~a ~a ~a ~a " type timestamp windowid state)
			;;(format #t " (pos:~a ~a) (rel:~a ~a) ~%" x y xrel yrel)
			(set! *mouse-x* x)
			(set! *mouse-y* y)))
		     (#t #f))))

	   ;; blue color
	   (sdl-set-render-draw-color render #x00 #x00 #xFF #xFF)
	   
	   ;; clear screen 
	   (sdl-render-clear render)

	   ;; display image
	   (sdl-render-copy render texture %null-pointer %null-pointer)

	   ;; red line
	   (sdl-set-render-draw-color render #xFF #x00 #x00 #xFF)

	   ;; draw-rect
	   (let ((bv (make-bytevector (* 4 (size-int)) 0)))
	     (bytevector-s32-native-set! bv 0 *mouse-x*)
	     (bytevector-s32-native-set! bv 4 *mouse-y*)
	     (bytevector-s32-native-set! bv 8 20)
	     (bytevector-s32-native-set! bv 12 20)
	     ;;(show-rect (bytevector->pointer bv))
	   
	     ;; dereference-pointer
	     ;; file:///usr/share/doc/guile-3.0.10/ref/Void-Pointers-and-Byte-Access.html
	     
	     ;;(format #t "bytevector pointer ~a ~%" (bytevector->pointer bv) 
	     (sdl-render-draw-rect render (bytevector->pointer bv)))	     
	     

	   ;; red
	   (sdl-set-render-draw-color render #xFF #x00 #x00 #xFF)	   
	   (let ((bv (make-bytevector (* 4 (size-int)) 0)))
	     (bytevector-s32-native-set! bv 0 100)
	     (bytevector-s32-native-set! bv 4 100)
	     (bytevector-s32-native-set! bv 8 100)
	     (bytevector-s32-native-set! bv 12 100)
	     (sdl-render-fill-rect render (bytevector->pointer bv)))

	   ;; green
	   (sdl-set-render-draw-color render #x00 #xFF #x00 #xFF)	   	   
	   (let ((bv (make-bytevector (* 4 (size-int)) 0)))
	     (bytevector-s32-native-set! bv 0 300)
	     (bytevector-s32-native-set! bv 4 100)
	     (bytevector-s32-native-set! bv 8 100)
	     (bytevector-s32-native-set! bv 12 100)
	     (sdl-render-fill-rect render (bytevector->pointer bv)))

	   ;; blue
	   (sdl-set-render-draw-color render #x00 #x00 #xFF #xFF)	   	   	   
	   (let ((bv (make-bytevector (* 4 (size-int)) 0)))
	     (bytevector-s32-native-set! bv 0 500)
	     (bytevector-s32-native-set! bv 4 100)
	     (bytevector-s32-native-set! bv 8 100)
	     (bytevector-s32-native-set! bv 12 100)
	     (sdl-render-fill-rect render (bytevector->pointer bv)))

	   ;; line from top left to mouse position
	   (sdl-set-render-draw-color render #xFF #x00 #x00 #xFF)	   	   	   
	   (let ((bv (make-bytevector (* 4 (size-int)) 0)))
	     (bytevector-s32-native-set! bv 0 *mouse-x*)
	     (bytevector-s32-native-set! bv 4 *mouse-y*)
	     (bytevector-s32-native-set! bv 8 20)
	     (bytevector-s32-native-set! bv 12 20)
	     (sdl-render-fill-rect render (bytevector->pointer bv)))
	   (sdl-render-draw-line render 0 0 *mouse-x* *mouse-y*)
	      
	   
	   ;; draw some random points
	   (sdl-set-render-draw-color render #x33 #x44 #x55 #xFF)	   
	   ;;(sdl-render-draw-point render 150 150)

	   ;; ;; update the blocks
	   (update-blocks)
	   
	   ;; ;; show the blocks
	   (show-blocks render)	   


	   ;; some writing
	   ;; SDL_Surface* textSurface = TTF_RenderText_Solid( gFont, textureText.c_str(), textColor );
	   ;; should dfree old texture if still around
	   (when (not (equal? mTexture %null-pointer))
	     (sdl-destroy-texture mTexture))	   
	   (set! mTexture %null-pointer)
	   (set! mTexture-width 0)
	   (set! mTexture-height 0)
	   (let* ((textColor #xFF00FFFF) ;; r g b a = each uint8  (ie 2 hex characters making total 8 hex chars alpha FF)
		  (textSurface (ttf-render-text-solid font
						      (string->pointer
						       (format #f "mouse position is ~a ~a" *mouse-x* *mouse-y*))
						      textColor)))
	     (cond
	      ((equal? textSurface %null-pointer) (format #t "failed to render text ~%"))
	      (#t (set! mTexture (sdl-create-texture-from-surface render textSurface))
		  (set! mTexture-width (%sdl-surface-width textSurface))
		  (set! mTexture-height (%sdl-surface-height textSurface))
		  (sdl-free-surface textSurface))))

	   (when (not (equal? mTexture %null-pointer))
	     (let ((bv (make-bytevector (* 4 (size-int)) 0)))
	       (bytevector-s32-native-set! bv 0 0)
	       (bytevector-s32-native-set! bv 4 0)
	       (bytevector-s32-native-set! bv 8 mTexture-width)
	       (bytevector-s32-native-set! bv 12 mTexture-height)	       
	       (sdl-render-copy render mTexture %null-pointer (bytevector->pointer bv))))
	   
	   
	   ;; show render
	   (sdl-render-present render)
	   
#|
	   //Clear screen
                SDL_RenderClear( gRenderer );

                //Render texture to screen
                SDL_RenderCopy( gRenderer, gTexture, NULL, NULL );

                //Update screen
                SDL_RenderPresent( gRenderer );
		
	   
	   ;; clear the surface?
	   (sdl-fill-rect surface *null* 0)	   
	   ;; apply image
	   ;;(sdl-blit-surface hello-bitmap *null* surface *null*)
	   ;;(applyStretchedImage surface screen-width screen-height)
	   (sdl-upper-blit-scaled hello-bitmap %null-pointer surface %null-pointer)
	   
	   ;; random rectangle somewhere
	   (sdl-fill-rect surface (make-sdl-rect-pointer 400 100 50 50) (make-sdl-color 255 0 0))
	   (sdl-fill-rect surface (make-sdl-rect-pointer 500 100 50 50) (make-sdl-color 0 0 255))
	   (sdl-fill-rect surface (make-sdl-rect-pointer 600 100 50 50) (make-sdl-color 0 255 0))
	   (sdl-fill-rect surface (make-sdl-rect-pointer (- *mouse-x* 25) (- *mouse-y* 25) 50 50) (make-sdl-color 0 0 255))
	   
	   ;; update surface
	   (sdl-update-window-surface window)
|#
	   
	   ) ;; while not quit 
    ;; cleanup
    (ttf-close-font font)	     
    (sdl-free-surface hello-bitmap)
    
    (sdl-destroy-renderer render)
    (sdl-destroy-window window)
    
    (ttf-quit)
    (img-quit)
    (sdl-quit)))








    
    
    


(define (test)
  (let ((width 640)(height 480))
    (let ((res (sdl-init *constant-sdl-init-video*)))
      (when (not (= res 0))
	(format #t "sdl-init failed with error ~a~%" res)
	(error "sdl-init fail")))
    
    (define window (create-window "hello world" width height)) ;; make 640 x 480 window
    (format #t "window was ~a~%" window)
    
    (define gSurface (sdl-get-window-surface window))
    (define gHelloBitmap (sdl-load-bmp "hello.bmp"))
    (format #t "hello bitmap was ~a~%" gHelloBitmap)

    ;; apply the image
    (sdl-blit-surface gHelloBitmap *null* gSurface *null*)

    ;; update surface
    (sdl-update-window-surface window) 
    
    (sleep 5)
    ;; that works !!

    

    ;;(define gHelloBitmap #f)
    ;;(define gSurface2 (create-rgb-surface 640 480)) ;; same as window dimensions

    ;; 8 bytes past SDL_Surface *p is p->format
    (define gSurface->format (make-pointer (+ (pointer-address gSurface) 8)))
    ;; 32 bytes past SDL_Surface *p is p->pixels
    (define gSurface->pixels (make-pointer (+ (pointer-address gSurface) 32)))

    ;; pitch is pixels wide multiplied by 3 colours each take 4 bytes per colour ??? this is my guess so far
    (define pitch (* width 3 4))
    
    (define gCairoSurf (cairo-image-surface-create-for-data gSurface->pixels
							    *constant-cairo-format-rgb24*
							    width
							    height
							    pitch))
    
    (format #t "~a~%" (list window gSurface gSurface->pixels gCairoSurf))

    ;; cr cairo context
    (define cr (cairo-create gCairoSurf))
    (format #t "~a~%" (list cr))
    ;;

    ;; FIXME - white pixel not working yet
    ;; (define white-pixel (sdl-map-rgb gSurface2->format 255 255 255))
    ;; (format #t "white pixel ~a ~%" white-pixel)
    
    ;;// Fill the window with a white rectangle
    ;;SDL_FillRect( sdlsurf, NULL, SDL_MapRGB( sdlsurf->format, 255, 255, 255 ) );
    ;; what is NULL is guile ffi ?
    ;; (let ((result (sdl-fill-rect gSurface2 null pixel-value)))
    ;;   (cond
    ;;    ((= 0 result) (format #t "fill rect ok~%"))
    ;;    (#t (format #t "fill rect bad~%"))))


    ;; TODO
    (cairo-set-source-rgb cr 255 0 0)
    (cairo-rectangle cr 100 100 200 200)
    (cairo-fill cr)


    ;;SDL_BlitSurface( sdlsurf , NULL, gScreenSurface, NULL );
    ;;(sdl-blit-surface gSurface2 *null* gSurface *null*)
    ;;(sdl-blit-surface gSurface2 *null* gSurface *null*)    
    (cairo-surface-flush gCairoSurf)
     
    ;; SDL_UpdateWindowSurface( window );
    (sdl-update-window-surface window) 
    
    ;;
    (sleep 3)
    ;; cleanup
    (sdl-destroy-window window)
    (sdl-quit)))









(define (bad-test2 n)
  (cond
   ((> n 0)
    (test)
    (bad-test2 (- n 1)))
   (#t #f)))


(define (bad-test)
  "a very bad test indeed - repeatedly creates and destroys a window"
  (bad-test2 100))




(define (test-strlen)
  (define strlen
    (pointer->procedure
     int (dynamic-func "strlen" (dynamic-link)) (list '*)))
  (strlen (string->pointer "hello, world")))

  


(define (test-loop)
  (skooldaze2)
  (test-loop))






  


#|
(define sdl3-init
  (foreign-library-function "libSDL3" "SDL_Init"
                            #:return-type int
                            #:arg-types (list int)))

|#



#|

#define SDL_INIT_TIMER          0x00000001u
#define SDL_INIT_AUDIO          0x00000010u
#define SDL_INIT_VIDEO          0x00000020u  /**< SDL_INIT_VIDEO implies SDL_INIT_EVENTS */
#define SDL_INIT_JOYSTICK       0x00000200u  /**< SDL_INIT_JOYSTICK implies SDL_INIT_EVENTS */
#define SDL_INIT_HAPTIC         0x00001000u
#define SDL_INIT_GAMECONTROLLER 0x00002000u  /**< SDL_INIT_GAMECONTROLLER implies SDL_INIT_JOYSTICK */
#define SDL_INIT_EVENTS         0x00004000u
#define SDL_INIT_SENSOR         0x00008000u
#define SDL_INIT_NOPARACHUTE    0x00100000u  /**< compatibility; this flag is ignored. */
#define SDL_INIT_EVERYTHING ( \
                SDL_INIT_TIMER | SDL_INIT_AUDIO | SDL_INIT_VIDEO | SDL_INIT_EVENTS | \
                SDL_INIT_JOYSTICK | SDL_INIT_HAPTIC | SDL_INIT_GAMECONTROLLER | SDL_INIT_SENSOR \
            )
|#




#|
(define daft
  (foreign-library-function "libBlanketyBlank" "SDL_Init"
                            #:return-type int
                            #:arg-types (list int)))



(define j0
  (foreign-library-function "libm" "j0"
                            #:return-type double
                            #:arg-types (list double)))


(define library (load-foreign-library "libSDL2-2.0.so"))
(define sdl-init (foreign-library-pointer "bessel" "init_math_bessel"))
  
(define init (foreign-library-pointer "bessel" "init_math_bessel"))


can we find a symbol SDL_Init which is defined in SDL2/SDL.h

we can find the files associated with SDL2

> locate SDL2

we can see C language include files

 /usr/include/SDL2/SDL.h

and the shared library

file /usr/lib/x86_64-linux-gnu/libSDL2.so
/usr/lib/x86_64-linux-gnu/libSDL2.so: symbolic link to libSDL2-2.0.so.0.3000.0

nm -D /usr/lib/x86_64-linux-gnu/libSDL2-2.0.so.0.3000.0 | less

nm -D /usr/lib/x86_64-linux-gnu/libSDL2-2.0.so.0.3000.0 | grep SDL_Init

nm -D /usr/lib/x86_64-linux-gnu/libSDL2.so | grep SDL_Init






https://www.nongnu.org/nyacc/ffi-help.html
guile> (use-modules (system foreign))
guile> (define strlen
          (pointer->procedure
           int (dynamic-func "strlen" (dynamic-link)) (list '*)))
guile> (strlen (string->pointer "hello, world"))
$1 = 12




|#


