#!/bin/bash

# a silly routine to call sdl and maybe some cairo
gcc `pkg-config --cflags sdl2` `pkg-config --cflags guile-3.0` `pkg-config --cflags cairo` -shared -o libguile-sdl.so -fPIC silly.c





