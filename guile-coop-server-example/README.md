# Guile repl socket

## Multiple clients 

how do unix sockets work , is this what we are talking about 

a named file , that acts like a unix socket ? 

multiple clients , one server 

Q - how do get interaction on computer but tied to a narrow user interaction window ?

```
cooperative multitasking ?
coroutines ? 
yield ?
```




## The server

```
(use-modules (ice-9 format))
(use-modules (system repl coop-server))
(use-modules (system repl server))

(define *server-socket* (make-unix-domain-server-socket #:path "./guile-socket"))
(define *server* (spawn-coop-repl-server *server-socket*))
(define *myglobal* 5)

(define loop
  (lambda ()
    (sleep 1) ;; sleep 1 second    
    (format #t "*myglobal* has value ~a~%" *myglobal*)
    (poll-coop-repl-server *server*)
    (loop)))
```

## The clients 

```
;; start server.scm as repl server
;; M-x geiser-connect-local
;; then evaluate this line below , should see output change from 5 to 3 if it works

(define *myglobal* 3)
```

## Recompilation should change runtime 

We can see guile does not respect redefinition of loop procedure , since we now have a global *halt* 

this should be sufficient to stop loop from endlessly looping

since loop is redefined , on next iteration new loop routine should be executed . But it does not.

```
(use-modules (ice-9 format))
(use-modules (system repl coop-server))
(use-modules (system repl server))

(define *server-socket* (make-unix-domain-server-socket #:path "./guile-socket"))
(define *server* (spawn-coop-repl-server *server-socket*))
(define *myglobal* 5)
(define *halt* #t)


(define loop
  (lambda ()
    (when (not *halt*)
      (sleep 1) ;; sleep 1 second    
      (format #t "*myglobal* has value ~a~%" *myglobal*)
      (poll-coop-repl-server *server*)
      (loop))))


(define halt!
  (lambda ()
    (stop-server-and-clients!))) 
```

## redefinition 

for procedures to be redefined at runtime they cannot be main loop itself , it has to be some offshoot procedure that
is called ? intermitently ? so that routine can be redefined or reloaded when it is not currently ? engaged ?

## Startup delay

Big side effect is a long delay when we start coop repl server up , on order of seconds 

contrast this with common lisp - see baggers youtube keep repl alive




