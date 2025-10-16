

;; 6.19.5 Foreign Functions - guile manual
(use-modules (system foreign))
(use-modules (system foreign-library))

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

;; convenience 
(define (create-window title width height)
  (let ((x 200)(y 200)
	(flags (logior *constant-sdl-window-resizeable*
		       *constant-sdl-window-allow-highdpi*
		       *constant-sdl-window-always-on-top*
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



;; usage
;;  gHelloWorld = SDL_LoadBMP( "hello_world2.bmp" );
;; <<< This does not work as SDL_LoadBMP is a C macro and has no binding that guile can find in the SDL2 library >>>
;; (define sdl-load-bmp
;;   (foreign-library-function "libSDL2" "SDL_LoadBMP"
;;                             #:return-type '*
;;                             #:arg-types (list '* )))


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

  

#|
cairo_surface_t *cairosurf = cairo_image_surface_create_for_data (
									    (unsigned char*)sdlsurf->pixels,
									    CAIRO_FORMAT_RGB24,
									    sdlsurf->w,
									    sdlsurf->h,
									    sdlsurf->pitch);
	  
|#

(define *constant-cairo-format-rgb24* 1)

(define cairo-image-surface-create-for-data
  (foreign-library-function "libcairo" "cairo_image_surface_create_for_data "
                            #:return-type '*
                            #:arg-types (list '* int int int int)))





#|
https://www.nongnu.org/nyacc/ffi-help.html
guile> (use-modules (system foreign))
guile> (define strlen
          (pointer->procedure
           int (dynamic-func "strlen" (dynamic-link)) (list '*)))
guile> (strlen (string->pointer "hello, world"))
$1 = 12

|#



(define (test)
  (let ((width 640)(height 480))
    (test-sdl-init)
    (define gWindow (create-window "hello world" width height)) ;; make 640 x 480 window
    (define gSurface (sdl-get-window-surface gWindow))
    ;;(define gHelloBitmap (sdl-load-bmp "../thompson-sdl2/hello-world/hello.bmp"))
    (define gHelloBitmap #f)
    (define gSurface2 (create-rgb-surface 640 480)) ;; same as window dimensions
    (define gCairoSurf (cairo-image-surface-create-for-data pixels??
							    *constant-cairo-format-rgb24*
							    width
							    height
							    pitch))
    
    
    
    (format #t "~a~%" (list gWindow gSurface gHelloBitmap gSurface2))
    ;;
    (sleep 10)
    ;; cleanup
    (sdl-destroy-window gWindow)
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


#|
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


|#

|#


