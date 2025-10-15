# guile ffi tutorial

## 001-bessel

here is bessel.c 

```
#include <math.h>
#include <libguile.h>

SCM
j0_wrapper (SCM x)
{
  return scm_from_double (j0 (scm_to_double (x)));
}

void
init_bessel ()
{
  scm_c_define_gsubr ("j0", 1, 0, 0, j0_wrapper);
}
```

to compile the bessel wrapper we use incantation

```
gcc `pkg-config --cflags guile-3.0` -shared -o libguile-bessel.so -fPIC bessel.c
```

load the library into guile itself , using hacky shell variable to find the shared library

```
> LTDL_LIBRARY_PATH=./ guile 
GNU Guile 3.0.9
Copyright (C) 1995-2023 Free Software Foundation, Inc.

Guile comes with ABSOLUTELY NO WARRANTY; for details type `,show w'.
This program is free software, and you are welcome to redistribute it
under certain conditions; type `,show c' for details.

Enter `,help' for help.
scheme@(guile-user)> (load-extension "libguile-bessel" "init_bessel")
scheme@(guile-user)> (j0 2)
$1 = 0.22389077914123567
```


