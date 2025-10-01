
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





