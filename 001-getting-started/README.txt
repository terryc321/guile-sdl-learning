
https://files.dthompson.us/docs/guile-sdl2/latest/
-------------------------------------------------------

guile-sdl2 library
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





