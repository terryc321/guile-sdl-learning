
;; can i extend LTDL_LIBRARY_PATH at runtime ?
;; LTDL_LIBRARY_PATH=./ guile
(use-modules (system foreign-library))
(load-foreign-library "libSDL2-2.0.so")
(load-extension "libguile-sdl" "sdl_init")


