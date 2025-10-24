
;; pixelformat.scm
;; load c shared library from pixelformat directory
(use-modules (system foreign))
(use-modules (system foreign-library))

;; (load-foreign-library "libSDL2")
;; (load-foreign-library "libSDL2_image")



;;(define show-pixelformat (foreign-library-pointer "pixelformat" "show_pixelformat_format"))
;;(define init-pixelformat (foreign-library-pointer "pixelformat" "init_pixelformat"))

(define pixelformat
  (foreign-library-function "libpixelformat" "pixelformat_wrapper"
                            #:return-type '*
                            #:arg-types (list '*)))

(define pixelformat2
  (foreign-library-function "libpixelformat" "pixelformat2"
                            #:return-type void
                            #:arg-types (list '*)))

(define output-check
  (foreign-library-function "libpixelformat" "output_check"
                            #:return-type void
                            #:arg-types (list)))


(define applyStretchedImage
  (foreign-library-function "libpixelformat" "applyStretchedImage"
                            #:return-type '*
                            #:arg-types (list '* int int)))


(define size-int
  (foreign-library-function "libpixelformat" "size_int"
                            #:return-type int
                            #:arg-types (list)))




;; int SDL_UpperBlitScaled
;;   (SDL_Surface * src, const SDL_Rect * srcrect,
;;   SDL_Surface * dst, SDL_Rect * dstrect);
(define sdl-upper-blit-scaled
  (foreign-library-function "libSDL2" "SDL_UpperBlitScaled"
                            #:return-type int
                            #:arg-types (list '* '* '* '*)))
  


#|
;; (define sdl-upper-blit-scaled
;;   (foreign-library-function "libSDL2_image-2.0" "SDL_IMAGE2_C_FUNCTION_HERE"
;;                             #:return-type int
;;                             #:arg-types (list '* '* '* '*)))
typedef enum IMG_InitFlags
{
    IMG_INIT_JPG    = 0x00000001,
    IMG_INIT_PNG    = 0x00000002,
    IMG_INIT_TIF    = 0x00000004,
    IMG_INIT_WEBP   = 0x00000008,
    IMG_INIT_JXL    = 0x00000010,
    IMG_INIT_AVIF   = 0x00000020
    } IMG_InitFlags;
|#

(define *constant-sdl-image-init-jpg*  #x00000001)
(define *constant-sdl-image-init-png*  #x00000002)
(define *constant-sdl-image-init-tif*  #x00000004)
(define *constant-sdl-image-init-webp* #x00000008)
(define *constant-sdl-image-init-jxl*  #x00000010)
(define *constant-sdl-image-init-avif* #x00000020)


;;int IMG_Init(int flags);
(define %img-init
  (foreign-library-function "libSDL2_image" "IMG_Init"
                            #:return-type int
                            #:arg-types (list int)))


(define (image-init)
  (let* ((flags (logior *constant-sdl-image-init-jpg*
			*constant-sdl-image-init-png*
			*constant-sdl-image-init-tif*
			*constant-sdl-image-init-webp*
			;;*constant-sdl-image-init-jxl*
			;;*constant-sdl-image-init-avif*
			))
	 (result (%img-init flags)))
    (= result flags)))

;;SDL_Surface * IMG_Load(const char *file);
(define %img-load
  (foreign-library-function "libSDL2_image" "IMG_Load"
                            #:return-type '*
                            #:arg-types (list '*)))

;; convert guile string to char* 
(define (image-load path)
  (%img-load (string->pointer path)))

 
;; (define sdl-upper-blit-scaled
;;   (foreign-library-function "libSDL2_ttf" "TTF-C-FUNCTION-HERE"
;;                             #:return-type int
;;                             #:arg-types (list '* '* '* '*)))

;; (define sdl-upper-blit-scaled
;;   (foreign-library-function "libSDL2_mixer" "MIXER-C-FUNCTION-HERE"
;;                             #:return-type int
;;                             #:arg-types (list '* '* '* '*)))


;; SDL_Renderer * SDL_CreateRenderer(SDL_Window * window,
;;                        int index, Uint32 flags);
(define %sdl-create-renderer
  (foreign-library-function "libSDL2" "SDL_CreateRenderer"
                            #:return-type '*
                            #:arg-types (list '* int uint32)))

;; int surface_width(SDL_Surface *s)
(define %sdl-surface-width
  (foreign-library-function "libpixelformat" "surface_width"
                            #:return-type int
                            #:arg-types (list '*)))

;;int surface_height(SDL_Surface *s)
(define %sdl-surface-height
  (foreign-library-function "libpixelformat" "surface_height"
                            #:return-type int
                            #:arg-types (list '*)))




;; SDL_SetRenderDrawColor
;; int SDL_SetRenderDrawColor(SDL_Renderer * renderer,
;;                    Uint8 r, Uint8 g, Uint8 b,
;;                    Uint8 a);
(define sdl-set-render-draw-color
  (foreign-library-function "libSDL2" "SDL_SetRenderDrawColor"
                            #:return-type int
                            #:arg-types (list '* uint8 uint8 uint8 uint8)))

(define show-rect
  (foreign-library-function "libpixelformat" "show_rect"
                            #:return-type void
                            #:arg-types (list '*)))



;; (define %load-texture
;;   (foreign-library-function "libpixelformat" "loadTexture"
;;                             #:return-type '*
;;                             #:arg-types (list '* '*)))
  
;; (define (load-texture s render)
;;   (%load-texture (string->pointer s) render))



#|
typedef enum SDL_RendererFlags
{
    SDL_RENDERER_SOFTWARE = 0x00000001,         /**< The renderer is a software fallback */
    SDL_RENDERER_ACCELERATED = 0x00000002,      /**< The renderer uses hardware
                                                     acceleration */
    SDL_RENDERER_PRESENTVSYNC = 0x00000004,     /**< Present is synchronized
                                                     with the refresh rate */
    SDL_RENDERER_TARGETTEXTURE = 0x00000008     /**< The renderer supports
                                                     rendering to texture */
} SDL_RendererFlags;
|#

(define *constant-sdl-renderer-software* #x00000001)
(define *constant-sdl-renderer-accelerated* #x00000002)
(define *constant-sdl-renderer-present-vsync* #x00000004)
(define *constant-sdl-renderer-target-texture* #x00000008)

;; if %null-pointer create renderer failed
(define (create-renderer window)
  (%sdl-create-renderer window -1 (logior *constant-sdl-renderer-accelerated*
					  *constant-sdl-renderer-target-texture*)))



