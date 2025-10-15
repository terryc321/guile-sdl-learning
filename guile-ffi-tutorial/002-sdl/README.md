# guile ffi tutorial

## 002-silly

here is silly.c 

```
#include <stdio.h>
#include <math.h>
#include <stdbool.h>
#include <time.h>

#include <SDL2/SDL.h>
#include <cairo/cairo.h>
#include <libguile.h>

SCM silly_sdl_wrapper (SCM x)
{
  return SCM_BOOL_F; //scm_from_double (j0 (scm_to_double (x)));
}

void init_sdl ()
{
  scm_c_define_gsubr ("silly_init_sdl", 0, 0, 0, silly_sdl_wrapper);
}
```

to compile the bessel wrapper we use incantation

```
bash build.sh
```

load the library into guile itself , using hacky shell variable to find the shared library

```
> LTDL_LIBRARY_PATH=./ guile 
scheme@(guile-user)> (load-extension "libguile-bessel" "init_bessel")
scheme@(guile-user)> (j0 2)
$1 = 0.22389077914123567
```


