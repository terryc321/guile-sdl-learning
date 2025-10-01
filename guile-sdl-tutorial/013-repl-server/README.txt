
012-repl-server


===========================
emacs hello.scm &
> M-x geiser
> (demo)
... this starts gui up and polls guile repl for input

OR equivalently we can run server.sh script
this does exact same thing ?? does it ??
===========================


emacs hello.scm &
> M-x geiser-connect
 localhost 38945
> (special-foo)
> (special-bar)

OR equivalently we can run client.sh script
this calls special-foo special-bar 

===========================
