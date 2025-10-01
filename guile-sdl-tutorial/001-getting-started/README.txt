
https://files.dthompson.us/docs/guile-sdl2/latest/
-------------------------------------------------------

dthompson guile sdl2 dependencies

sudo apt install libsdl2-dev libsdl2-doc \
libsdl2-ttf-dev libsdl2-ttf-2.0-0 \
libsdl2-image-dev libsdl2-image-2.0-0 \
libsdl2-mixer-dev libsdl2-mixer-2.0-0

should see

Reading state information... Done
libsdl2-dev is already the newest version (2.30.0+dfsg-1ubuntu3.1).
libsdl2-doc is already the newest version (2.30.0+dfsg-1ubuntu3.1).
libsdl2-ttf-dev is already the newest version (2.22.0+dfsg-1).
libsdl2-ttf-2.0-0 is already the newest version (2.22.0+dfsg-1).
libsdl2-image-dev is already the newest version (2.8.2+dfsg-1build2).
libsdl2-image-2.0-0 is already the newest version (2.8.2+dfsg-1build2).
libsdl2-mixer-dev is already the newest version (2.8.0+dfsg-1build3).
libsdl2-mixer-2.0-0 is already the newest version (2.8.0+dfsg-1build3).

now we can build guile's sdl2 library

dthompson guile sdl2 library
----------------------------------------------------------------------------
wget https://files.dthompson.us/releases/guile-sdl2/guile-sdl2-0.8.0.tar.gz
tar xf guile-sdl2-0.8.0.tar.gz
cd guile-sdl2-0.8.0
./configure
make
make install

may need install guile-3.0-dev

guile + geiser
-------------------------------
setup melpa on emacs 
M-x package-install geiser-guile
M-x run-geiser
scheme implementation : guile


bashrc
needed to add this chestnut so guile can find site wide compiled files
-----------------------------------------------------------------------
export GUILE_LOAD_COMPILED_PATH="/usr/local/lib/guile/3.0/site-ccache/"





