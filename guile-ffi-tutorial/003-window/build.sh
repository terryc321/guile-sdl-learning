#!/bin/bash


gcc `pkg-config --cflags sdl2` `pkg-config --cflags guile-3.0` `pkg-config --cflags cairo` -shared -o libguile-sdl.so -fPIC sdl.c





