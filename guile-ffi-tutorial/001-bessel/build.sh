#!/bin/bash

# guile library bessel 
gcc `pkg-config --cflags guile-3.0` -shared -o libguile-bessel.so -fPIC bessel.c

