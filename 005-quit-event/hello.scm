
;; guile 3 code
#|
(use-modules (sdl2)
             (sdl2 render)
             (sdl2 surface)
             (sdl2 video))
|#


(use-modules (sdl2))
(use-modules (sdl2 render))
(use-modules (sdl2 surface))
(use-modules (sdl2 video))
(use-modules (sdl2 input keyboard))
(use-modules (sdl2 input mouse))
(use-modules (sdl2 input joystick)) ;; never used them
(use-modules (sdl2 events)) ;; events 

;;(format #t "current-filename ~a~%" (current-filename))

;; bitmap image hello.bmp needs to be in current directory running binary or else guile will crash
(define (draw ren)
  (let* ((surface (load-bmp (format #f "~a/../images/~a" (dirname (current-filename)) "hello.bmp")))
         (texture (surface->texture ren surface)))
    (clear-renderer ren)
    (render-copy ren texture)
    (present-renderer ren)))


(define (event-loop ren)
  (let ((event (poll-event)))
    (cond
     ((quit-event? event)
      (display "bye!"))
     (#t
      (draw ren)
      (event-loop ren)))))
 



#|
guile language - keyword arguments used
sdl - set title
sdl - set size of screen
sdl - display an image loaded from another directory
|#

(define (demo)
  (sdl-init)
  (call-with-window (make-window #:title "freddy"
				 #:maximize? #t
				 #:fullscreen? #f
				 ;;#:size '(1920 1080)
				 #:size '(640 480)
				 )
		    (lambda (window)
		      (call-with-renderer (make-renderer window) event-loop)))
  (sdl-quit)
  )


;;(demo)





