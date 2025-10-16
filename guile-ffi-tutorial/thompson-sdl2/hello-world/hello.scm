(use-modules (sdl2)
             (sdl2 render)
             (sdl2 surface)
             (sdl2 video))

(define (draw ren)
  (let* ((surface (load-bmp "hello.bmp"))
         (texture (surface->texture ren surface)))
    (clear-renderer ren)
    (render-copy ren texture)
    (present-renderer ren)
    (sleep 20)))

(sdl-init)

(call-with-window (make-window)
  (lambda (window)
    (call-with-renderer (make-renderer window) draw)))

(sdl-quit)

