
#|
changelog

guile language - keyword arguments used
sdl - set title
sdl - set size of screen
sdl - display an image loaded from another directory
006 - explicit module prefixes and explicit naming in preparation for much larger systems
007 - rectangle , coloured and draw to r g b
008 - check event loop time to see if we should render - ie a very rough animation clock 
|#


(use-modules ((sdl2) #:prefix sdl2:))
(use-modules ((sdl2 render) #:prefix sdl2-render:))
(use-modules ((sdl2 surface) #:prefix sdl2-surface:))
(use-modules ((sdl2 video) #:prefix sdl2-video:))
(use-modules ((sdl2 input keyboard) #:prefix sdl2-keyboard:))
(use-modules ((sdl2 input mouse) #:prefix sdl2-mouse:))
(use-modules ((sdl2 input joystick) #:prefix sdl2-joystick:))
(use-modules ((sdl2 events) #:prefix sdl2-events:))
(use-modules ((sdl2 rect) #:prefix sdl2-rect:))

(define *title* "longshaw")
(define *last-render-time* 0)
(define *event-loop-counter* 0)
(define *event-loop-counter-spillover* 30000)



;; bitmap image hello.bmp needs to be in current directory running binary or else guile will crash
(define (draw ren)
  (let* ((surface (sdl2-surface:load-bmp (format #f "~a/../images/~a" (dirname (current-filename)) "hello.bmp")))
         (texture (sdl2-render:surface->texture ren surface)))
    (sdl2-render:clear-renderer ren)
    (sdl2-render:render-copy ren texture)

    (sdl2-render:set-renderer-draw-color! ren 0 255 0 255) ;; green
    ;; make a rectange 300 by 300 , fill it green
    (let ((rect (sdl2-rect:make-rect 0 0 300 300)))
      (sdl2-render:fill-rect ren rect))

    ;; draw a blue rect at 150,150
    (sdl2-render:set-renderer-draw-color! ren 0 0 255 255) ;; blue    
    (let ((rect (sdl2-rect:make-rect 150 150 50 50)))
      (sdl2-render:fill-rect ren rect))

    (set! *last-render-time* (current-time))
    (format #t "rendered at time [~a] ~%" *last-render-time*)
    
    ;; present renderer to window? 
    (sdl2-render:present-renderer ren)))


(define (key-event-handler event)
  (cond
   ((sdl2-events:keyboard-down-event? event)
    (let ((key (sdl2-events:keyboard-event-key event)))
      (format #t "key pressed [~a]~%" key)))))




;; get-internal-real-time 
(define (event-loop ren)
  (let ((event (sdl2-events:poll-event)))
    (cond
     ;; major quit event 
     ((sdl2-events:quit-event? event)
      (display "bye!")
      (sdl2:sdl-quit))
     (#t
      ;; handle events 
      (cond
       ((sdl2-events:keyboard-event? event)
	(display "keypress!")
	(key-event-handler event)))

      ;;(format #t "event-loop counter ~a ~%" *event-loop-counter*)
      (set! *event-loop-counter* (+ 1 *event-loop-counter*))
      
      ;; redraw every time an event is processed
      (let* ((a (current-time))
	     (b *last-render-time*)
	     (c (- a b)))
	;;(format #t "~a vs ~a : a - b => ~a~%" a b c)
	(cond
	 ((or (> *event-loop-counter* *event-loop-counter-spillover*)
	      (> c 1))
	  (set! *event-loop-counter* 0)
	  (draw ren))))
      
      (event-loop ren)))))




 


(define (demo)
  (sdl2:sdl-init)
  (sdl2-video:call-with-window (sdl2-video:make-window #:title *title*
				 #:maximize? #t
				 #:fullscreen? #f
				 ;;#:size '(1920 1080)
				 #:size '(640 480)
				 )
		    (lambda (window)
		      (sdl2-render:call-with-renderer (sdl2-render:make-renderer window) event-loop)))
  (sdl2:sdl-quit)
  )


;;(demo)





