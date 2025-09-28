# About

set of increasing complex programs for very basic user interface

keyboard
mouse
rectangular graphics
bitmap images

lacks polygon colouring - aka cairo library no ffi in guile yet.

![Alt text](/images/Screenshot_2024-04-07_00-35-52.png?raw=true "after 12 steps can end up with something on screen")


decided to explore SDL2 using C language as i think there are some memory leaks in guile SDL2 package

# SDL tutorial

sdl-tutorial directory contains C code experiments

# Cairo SDL tutorial

cairo has some nice shape functions to draw to screen 

## 001 Window

get a window on screen where we can do some SDL rectangle drawing and Cairo drawing 

essentially 32 bit colour screen , can do fullscreen also

cursor arrow keys move square rectangle around screen 

no timing so everything happens as fast as computer can handle , 
events are processed as recognised , otherwise ignored

does identify keyboard left right shift keys ,alt keys , control keys , f1 keys 
and keeps track if key is currently down or up - useful for emacs like key combinations

some key combinations are trapped by window manager , so that is a game loss to alt + tab

does not identify mouse enter , leave , mouse position yet, mouse right left middle clikcs

```
001-window : can we open a sdl2 cairo window and draw something onto screen with cairo 
 simplest proof of concept
```

![screenshot](cairo-sdl-tutorial/001-window/window-2025-09-28_22-32.png)

besides that it seems fairly stable , no growing memory problems at the moment





