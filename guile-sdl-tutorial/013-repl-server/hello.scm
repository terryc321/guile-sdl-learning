
#|
changelog

guile language - keyword arguments used
sdl - set title
sdl - set size of screen
sdl - display an image loaded from another directory
006 - explicit module prefixes and explicit naming in preparation for much larger systems
007 - rectangle , coloured and draw to r g b
008 - animation clock by checking loops through event-loop or if a second has passed
     to do : sub second timing + callbacks ? 
009 - 
010 - mouse click release motion animations 
011 - fonts and message generated at time of render - mouse position reported at top of screen
012 - repl server , there seems to be some sort of memory leak that grows until it consumes all resources
|#

(use-modules (ice-9 pretty-print))
(define pp pretty-print)


(use-modules ((system repl coop-server) #:prefix coop-repl:))
(use-modules ((system repl server) #:prefix repl-server:))

;; try use threads to change *mouse-message* foo -> bar and vice versa
(use-modules (ice-9 threads))

(use-modules ((sdl2) #:prefix sdl2:))
(use-modules ((sdl2 render) #:prefix sdl2-render:))
(use-modules ((sdl2 surface) #:prefix sdl2-surface:))
(use-modules ((sdl2 video) #:prefix sdl2-video:))
(use-modules ((sdl2 input keyboard) #:prefix sdl2-keyboard:))
(use-modules ((sdl2 input mouse) #:prefix sdl2-mouse:))
(use-modules ((sdl2 input joystick) #:prefix sdl2-joystick:))
(use-modules ((sdl2 events) #:prefix sdl2-events:))
(use-modules ((sdl2 rect) #:prefix sdl2-rect:))

(use-modules ((sdl2 ttf) #:prefix sdl2-ttf:)) ;; fonts
(use-modules ((sdl2 mixer) #:prefix sdl2-mixer:)) ;; sound - we dont use that here...
(use-modules ((sdl2 image) #:prefix sdl2-image:)) ;; image stuff ??


;; allow geiser to talk to the program 
(define *coop-repl-server* #f)
(define *coop-repl-socket* #f) 

(define *font* #f)
(define *font-size* #f)
(define *title* "010 - mouse motion and clicks")
(define *last-render-time* 0)
(define *event-loop-counter* 0)
(define *event-loop-counter-spillover* 10000)


(define *quit-state* #f)
(define *pos-x* 150)
(define *pos-y* 150)

(define *pos2-x* 150)
(define *pos2-y* 150)

(define *pos3-x* 150)
(define *pos3-y* 150)

(define *pos4-x* 150)
(define *pos4-y* 150)

(define *mouse-message* "hello owld")
(define *mouse-x* 0)
(define *mouse-y* 0)

(define *surface* #f)


#|
reset state of application here
|#
(define (reset)
  (set! *quit-state* #f)
  ;; keyboard square
  (set! *pos-x* 150)
  (set! *pos-y* 150)
  ;; mouse square
  (set! *pos2-x* 150)
  (set! *pos2-y* 150)
  ;; mouse position
  (set! *mouse-x* 0)
  (set! *mouse-y* 0)  
  ;; clicked down location
  (set! *pos3-x* 0)
  (set! *pos3-y* 0)
  ;; clicked up/release location
  (set! *pos4-x* 0)
  (set! *pos4-y* 0)
  ;; font-size
  (set! *font-size* 32)

  (set! *surface* (sdl2-surface:load-bmp (format #f "~a/../images/~a" (dirname (current-filename)) "hello.bmp"))))




;; bitmap image hello.bmp needs to be in current directory running binary or else guile will crash
(define (draw ren)
  (let* ((texture (sdl2-render:surface->texture ren *surface*)))
    (sdl2-render:clear-renderer ren)
    (sdl2-render:render-copy ren texture)
    
    
#|
    (sdl2-render:set-renderer-draw-color! ren 0 255 0 255) ;; green
    ;; make a rectange 300 by 300 , fill it green
    (let ((rect (sdl2-rect:make-rect 0 0 300 300)))
      (sdl2-render:fill-rect ren rect))

    ;; draw a blue rect at 150,150
    (sdl2-render:set-renderer-draw-color! ren 0 0 255 255) ;; blue    
    (let ((rect (sdl2-rect:make-rect (- *pos-x* 25) (- *pos-y* 25) 50 50)))
      (sdl2-render:fill-rect ren rect))

    ;; draw a red rect at 150,150
    (sdl2-render:set-renderer-draw-color! ren 255 0 0 255) ;; red
    (let ((rect (sdl2-rect:make-rect (- *pos2-x* 25) (- *pos2-y* 25) 50 50)))
      (sdl2-render:fill-rect ren rect))

    ;; draw a red + green  rect at 150,150
    (sdl2-render:set-renderer-draw-color! ren 255 255 0 125) ;; red + green half alpha 125
    (let ((rect (sdl2-rect:make-rect (- *pos3-x* 25) (- *pos3-y* 25) 50 50)))
      (sdl2-render:fill-rect ren rect))

    
    ;; draw a green + blue  rect at 150,150
    (sdl2-render:set-renderer-draw-color! ren 0 255 255 125) 
    (let ((rect (sdl2-rect:make-rect (- *pos4-x* 25) (- *pos4-y* 25) 50 50)))
      (sdl2-render:fill-rect ren rect))

    ;; try output some text
    (let* ((text-surface
	    (sdl2-ttf:render-font-solid *font*
					(format #f "~a mouse ~a, ~a" *mouse-message* *mouse-x* *mouse-y*)
					(sdl2:make-color 255 0 0 0)))
	   (text-width (sdl2-surface:surface-width text-surface))
	   (text-height (sdl2-surface:surface-height text-surface)))	   
      ;;(format #t "text surface ~a ~%" text-surface)
      (let ((texture2 (sdl2-render:surface->texture ren text-surface)))
	;;(format #t "texture2 = ~a ~%" texture2)
	;; (sdl2-render:render-copy ren texture2 #:angle 45)
	;; (sdl2-render:render-copy ren texture2 #:angle 0)
	(sdl2-render:render-copy ren texture2
				 #:dstrect `(0 0 ,text-width ,text-height))
	
	))
    	
	;; (sdl2-render:render-copy ren texture2
	;; 			 ;;#:srcrect #f  ;; all of the text - top left of screen 50,50
	;; 			 #:dstrect (sdl2-rect:make-rect 50
	;; 							50
	;; 							text-width
	;; 							text-height))))
       
    
    
    
    (set! *last-render-time* (current-time))
    ;;(format #t "rendered at time [~a] ~%" *last-render-time*)
|#
    
    ;; present renderer to window? 
    (sdl2-render:present-renderer ren)

    ;; do we need to dispose of texture ? surface ?
    ;; do we still have a space leak ?
    ))


#|
flag want to quit application by pressing escape key

|#
(define (key-event-handler event)
  (cond
   ((sdl2-events:keyboard-down-event? event)
    (let ((key (sdl2-events:keyboard-event-key event)))
      (format #t "key pressed [~a]~%" key)
      (case key
	((escape) (set! *quit-state* #t))))))

  ;; individual keys down ?
  (when (sdl2-keyboard:key-pressed? 'w)
    (set! *pos-y* (- *pos-y* 10)))

  (when (sdl2-keyboard:key-pressed? 'a)
    (set! *pos-x* (- *pos-x* 10)))

  (when (sdl2-keyboard:key-pressed? 's)
    (set! *pos-y* (+ *pos-y* 10)))

  (when (sdl2-keyboard:key-pressed? 'd)
    (set! *pos-x* (+ *pos-x* 10)))

  )



#|
where click
left middle right mouse button
coordinate clicked
|#
(define (mouse-button-event-handler event)
  (cond
   ((sdl2-events:mouse-button-down-event? event)
    (let ((x (sdl2-events:mouse-button-event-x event))
	  (y (sdl2-events:mouse-button-event-y event))
	  (button (sdl2-events:mouse-button-event-button event)))
      ;;(format #t "mouse button down : ~a ~a : ~a ~%" x y button)
      (set! *pos3-x* x)
      (set! *pos3-y* y)      
      ))
   ((sdl2-events:mouse-button-up-event? event)
    (let ((x (sdl2-events:mouse-button-event-x event))
	  (y (sdl2-events:mouse-button-event-y event))
	  (button (sdl2-events:mouse-button-event-button event)))
      ;;(format #t "mouse button up : ~a ~a : ~a ~%" x y button)
      (set! *pos4-x* x)
      (set! *pos4-y* y)
      ))
   ))



#|
mouse motion

|#
(define (mouse-motion-event-handler event)
  (let ((x (sdl2-events:mouse-motion-event-x event))
	(y (sdl2-events:mouse-motion-event-y event)))
    ;;(format #t "mouse position : ~a ~a ~%" x y)
    (set! *pos2-x* x)
    (set! *pos2-y* y)
    (set! *mouse-x* x)
    (set! *mouse-y* y)
    
    ))


;; get-internal-real-time 
(define (event-loop ren)
  (let ((event (sdl2-events:poll-event)))
    (cond
     ;; major quit event -- simply exits event-loop by falling through conditional
     ;; so no recursive call again back up to event-loop
     ((or *quit-state* (sdl2-events:quit-event? event))
      (display "bye!"))
     (#t
      ;; handle events 
      (cond
       ((sdl2-events:keyboard-event? event)
	(key-event-handler event))
       ((sdl2-events:mouse-button-event? event)
	(mouse-button-event-handler event))
       ((sdl2-events:mouse-motion-event? event)
	(mouse-motion-event-handler event))       
       )

      ;; poll for repl -- does this activate something ? run repl code ? 
      (coop-repl:poll-coop-repl-server *coop-repl-server*)
             
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


;; foo bar change mouse-message string
;; special-foo , special-bar launch new threads and forever keep looping , every n-seconds calls proc provided
(define (foo)
  (set! *mouse-message* "foo"))

(define (bar)  
  (set! *mouse-message* "bar"))

(define (forever title n-seconds proc)
  (letrec ((self (lambda (prev)
		   ;; (format #t "in-self...")
		   (let* ((now (current-time))
			  (diff (abs (- now prev))))
		     ;; (format #t "diff = ~a~%" diff)
		     (cond
		      ((> diff n-seconds)
		       (format #t "running ~a~%" title)
		       (proc)
		       (yield) ;; yield to another thread
		       (self (current-time)))
		      (#t (self prev)))))))
    (self (current-time))))






(define (special-foo)
  (call-with-new-thread (lambda () (forever "special-foo" 3 foo))))

(define (special-bar)
  (call-with-new-thread (lambda () (forever "special-bar" 4 bar))))



;; delayed-1second does not work since sleep has no effect 
(define delayed-1second
  (let ((iter 0)(max-iter 100))
    (lambda (msg)
      (letrec ((self (lambda ()
		       (display "Waiting 5s...")
		       (force-output)
		       ;;(usleep 1000)
		       (sleep 1)
		       (newline)
		       (display msg)
		       (newline)
		       (set! iter (+ iter 1))
		       (when (< iter max-iter)
			 (self)))))
	(self)))))

(define sanity
  (lambda ()
    (format #t "font is ~a~%" *font*)
    (format #t "current *mouse-message* is (~a)~%" *mouse-message*)))

    

 


(define (demo)

  ;; reset - loads a surface bitmap
  (reset)

  (set! *coop-repl-socket* (repl-server:make-tcp-server-socket #:host #f #:port 38945))

  ;; show we got a socket
  (format #t "coop repl socket ~a ~%" *coop-repl-socket*)

  ;; from the socket , make a repl server ?
  (set! *coop-repl-server* (coop-repl:spawn-coop-repl-server *coop-repl-socket*))

  ;; show we got a repl server
  (format #t "started coop repl server on ~a ~%" *coop-repl-server*)

  ;; now for the SDL2 stuff
  
  ;; true type fonts ...   
  (sdl2:sdl-init)
  (sdl2-ttf:ttf-init)
  
  ;; load a font
  (set! *font* (sdl2-ttf:load-font "/usr/share/fonts/truetype/freefont/FreeMono.ttf" *font-size*))
  (format #t "font = ~a ~%" *font*)
  
  
  (sdl2-video:call-with-window (sdl2-video:make-window #:title *title*
				 #:maximize? #t
				 #:fullscreen? #f
				 #:resizable? #t
				 ;;#:size '(1920 1080)
				 #:size '(640 480)
				 )
		    (lambda (window)
		      (sdl2-render:call-with-renderer (sdl2-render:make-renderer window) event-loop)))
  
  (sdl2-ttf:ttf-quit)
  (sdl2:sdl-quit)
  )

;; 
;; in original geiser repl - a server with SDL gui
;; (demo)
;;
;; client (1)
;; C-u M-x geiser-connect localhost 39845
;;(delayed-1second "foo")

;; client (2)
;; C-u M-x geiser-connect localhost 39845
;;(delayed-1second "bar")

;; want to see message on screen flipping between foo and bar 
;; both connected to *mouse-message* which is string pulled in by gui itself in event loop makes a string
;; 
