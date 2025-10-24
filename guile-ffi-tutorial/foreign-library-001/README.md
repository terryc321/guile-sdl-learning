# graphical user interface

sdl2 interface using guile

almost exclusively using SDL2 from dynamically linked libraries
only C code required was for stuff that i did not manage to figure out how to do through guile scheme

notably pointer indirection or dereference a pointer when inside a structure

paid a little attention to memory consumption when demo is running so it is actually free-ing up memory correctly

a running sdl demo should not cause more and more memory to be consumed until machine grinds to a halt
- low if not noticeable fast substantial memory leaks should be apparent

- helper script startup.sh
add current path and pixelformat directory to dynamic load table for guile LTDL_LIBRARY_PATH=./:./pixelformat rlwrap guile

[?] - should we have a graphical front end ?
      long running computations simply do not fall into a gui application directly since result take so long to get back
      go on holiday come back , still not done

[X] - ability to put a coloured rectangle on screen 
[X] - ability to clear screen
[ ] - ability to time the animation ?
[X] - have some ability put text on screen
    - uses TTF fonts , as long as the font is 'there'
    fc-list to get a list of true type fonts

[ ] - can we run cairo graphics also

[ ] - can we control the coordinate system


