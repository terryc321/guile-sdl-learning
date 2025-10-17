

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
  (let ((width 1024)(height 768))
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

|#



(define *constant-sdl-quit* #x100)
(define *constant-sdl-keydown* #x300)
(define *constant-sdl-keyup* #x301)
(define *constant-sdl-mousemotion* #x400)




;; keep looping until user quits window
;; https://lazyfoo.net/tutorials/SDL/03_event_driven_programming/index.php
(define (skooldaze2)
  (let ((width 1024)(height 768))
    (sdl-init *constant-sdl-init-video*)
    (define window (create-window "hello world" width height))
    (define surface (sdl-get-window-surface window))
    (define hello-bitmap (sdl-load-bmp "hello.bmp"))
    (define quit #f)
    ;; poll
    ;; create a C union struct the size of SDL_Event
    ;; and then manually populate struct obviating advantages of
    ;; make SDL_Event which is 32 bytes in size
    (define event (let ((size 36)(fill 0))
		    (make-bytevector size fill)))
    
    
    (while (not quit)
	   ;; poll for an event
	   (while (not (= 0 (sdl-poll-event (bytevector->pointer event))))
		  ;; if was new event then {event} itself will have the contents of it
		  ;; (endianness big)
		  ;; (endianness little)
		  (let ((type (bytevector-u32-ref event 0 (endianness little))))
		    (cond
		     ((= type *constant-sdl-quit*) ;; ======== quit event ==================
		      (format #t "the user quit the application !~%")
		      ;; if we quit - set quit flag to true and exit
		      (let ((type (bytevector-u32-ref event 0 (endianness little)))
			    (timestamp (bytevector-u32-ref event 4 (endianness little))))
			(set! quit #t)))
		     ((= type *constant-sdl-keydown*) ;; ======== keydown event ==================
		      (format #t "the user pressed a key !~%"))
		     ((= type *constant-sdl-keyup*) ;; ======== keyup event ==================
		      (format #t "the user released a key !~%"))
		     ((= type *constant-sdl-mousemotion*) ;; ======== mouse motion event ==================
		      (let ((type (bytevector-u32-ref event 0 (endianness little)))
			    (timestamp (bytevector-u32-ref event 4 (endianness little)))
			    (windowid (bytevector-u32-ref event 8 (endianness little)))
			    (state (bytevector-u32-ref event 12 (endianness little)))
			    (x (bytevector-s32-ref event 20 (endianness little)))
			    (y (bytevector-s32-ref event 24 (endianness little)))
			    (xrel (bytevector-s32-ref event 28 (endianness little)))
			    (yrel (bytevector-s32-ref event 32 (endianness little))))
			(format #t "mouse move (~a ~a ~a ~a " type timestamp windowid state)
			(format #t " (pos:~a ~a) (rel:~a ~a) ~%" x y xrel yrel)))
		     (#t #f))))
		  
	   ;; apply image
	   (sdl-blit-surface hello-bitmap *null* surface *null*)
	   ;; update surface
	   (sdl-update-window-surface window)
	   ) ;; while not quit 
    ;; cleanup
    (sdl-free-surface hello-bitmap)
    (sdl-destroy-window window)
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


