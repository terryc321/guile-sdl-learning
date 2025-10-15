# guile ffi tutorial

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


