# guile ffi tutorial

# CLANG vs GCC

gcc simply cannot compile without being babied over which parameters come first

clang just slam everything together and it just works first time

Makefile - simple

```
make && ./main
```

starts a guile repl

```
>(sdl-init)
```

we get a window open 640 x 480

so thats a big step forward

can we go back and put this as a library again , so we have the advantage of sdl-library , database-library etc
as explained in guile manual





# BIG PROBLEMS

cannot now even compile a simple libguile example

```
/usr/bin/ld: sdl.c:(.text+0x16b): undefined reference to `scm_c_define_gsubr'
/usr/bin/ld: sdl.c:(.text+0x190): undefined reference to `scm_c_define_gsubr'
```

## test.c + hello-guile.scm

```
#include <stdio.h>
#include <libguile.h>

SCM hello_from_guile(int argc, char ** argv) {

    SCM guileHello;
    scm_init_guile();

    char code[] = "(display \"Hello from Guile! As simple function.\")";
    char newline[] = "(newline)";

    char filename[] = "scripts/helloGuile.scm";

    scm_c_eval_string(code);
    scm_c_eval_string(newline);

    scm_c_primitive_load(filename);

    guileHello = scm_variable_ref(scm_c_lookup("guile-hello"));
    scm_call_0(guileHello);

    return 0;
}
```

try compile test.c with

```
gcc -o test `pkg-config --cflags guile-3.0` `pkg-config --libs guile-3.0` test.c
```
FAILED

try this instead
```
gcc -shared -fPIC -o libtest.so `pkg-config --cflags guile-3.0` test.c
```



# 

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


