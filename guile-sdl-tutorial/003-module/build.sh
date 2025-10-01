#!/bin/bash

guild compile -o hello.go hello.scm

# run as binary ??
time guile -C "$PWD" -c "(use-modules (hello)) (main)"

#time guile -C "$PWD" -c "(use-modules (hello)) (main)"


