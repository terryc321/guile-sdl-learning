

;; guile 3 code
#|
(use-modules (sdl2)
             (sdl2 render)
             (sdl2 surface)
             (sdl2 video))
|#

;; does module need to match file name source ?
(define-module (hello)
  #:export (main))

(use-modules (sdl2))
(use-modules (sdl2 render))
(use-modules (sdl2 surface))
(use-modules (sdl2 video))


(format #t "current-filename ~a~%" (current-filename))


;; bitmap image hello.bmp needs to be in current directory running binary or else guile will crash
(define (draw ren)
  (let* ((surface (load-bmp (format #f "~a/../images/~a" (dirname (current-filename)) "hello.bmp")))
         (texture (surface->texture ren surface)))
    (clear-renderer ren)
    (render-copy ren texture)
    (present-renderer ren)
    (sleep 2)))

(define (main)
  (sdl-init)
  (call-with-window (make-window)
		    (lambda (window)
		      (call-with-renderer (make-renderer window) draw)))
  (sdl-quit)
  )




