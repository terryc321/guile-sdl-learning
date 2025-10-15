# guile ffi tutorial

looks like cannot just put C include files together and expect an application because SDL uses macros extensively

that means that SDL_Init is not even defined in the sdl2 shared library libSDL2.so

so we have to have an sdl2 cairo c application and see how we can plug guile in as background

then expose a couple of draw routines draw-rectangle , fill-rectangle that we can call from guile , but then how do we orchestrate everything ?



```
;; can i extend LTDL_LIBRARY_PATH at runtime ?
;; LTDL_LIBRARY_PATH=./ guile
(use-modules (system foreign-library))
(load-foreign-library "libSDL2-2.0.so")
(load-extension "libguile-sdl" "sdl_init")

guile: symbol lookup error: ./libguile-sdl.so: undefined symbol: SDL_Init
```



1 create an SDL window , here just 640 x 480 window only
2 close the window
3 keep it open so the user can see it
4 respond to user clicking the close window button
5 <todo>



can we call c routines from guile using library creation and shared library code

currently we use scm_c_define_gsubr which defines routine and creates a binding at toplevel , dual functions

## 002-silly

## procedures of no arguments
```
(falsey) => #f
(truthy) => #t
(empty-list) => ()
(zero) => 0
(one) => 1
(two) => 2
(three) => 3
```

## procedures of one argument understood by C
```
(plus1 3) => 4
```

## procedures of two arguments understood by C

```
(fixnum-add 2 3) => 5
```


```
> bash build.sh

load the library into guile itself , using hacky shell variable to find the shared library
`
> LTDL_LIBRARY_PATH=./ guile 
scheme@(guile-user)> (load-extension "libguile-sdl" "silly_init")
scheme@(guile-user)> falsey
scheme@(guile-user)> truthy
scheme@(guile-user)> (plus1 3) => 4
scheme@(guile-user)> (fixnum-add 2 3) => 5

```


