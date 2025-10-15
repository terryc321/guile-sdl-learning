# guile ffi tutorial

## 002-silly

here is silly.c 

```
```

to compile the bessel wrapper we use incantation

```
bash build.sh
```

load the library into guile itself , using hacky shell variable to find the shared library

```
> LTDL_LIBRARY_PATH=./ guile 
scheme@(guile-user)> (load-extension "libguile-sdl" "silly_init")
scheme@(guile-user)> falsey
scheme@(guile-user)> truthy

```


