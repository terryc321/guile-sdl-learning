
;; guile scheme parse file called keys.el extract required values

(use-modules (ice-9 rdelim)) ;; rdelim read-line
(use-modules (ice-9 pretty-print)) ;; make nice
(use-modules (ice-9 regex)) ;; for regex capability

(define pp pretty-print) ;; helper

(chdir "/home/terry/code/guile-scheme/guile-sdl-learning/guile-ffi-tutorial/foreign-library-001/keyboard")
;;(getcwd)

(define (readlines filename)
  (call-with-input-file filename
    (lambda (p)
      (let loop ((line (read-line p))
                 (result '()))
        (if (eof-object? line)
            (reverse result)
            (loop (read-line p) (cons line result)))))))


(define lines (readlines "keys.el"))

(pp lines)

(provided? 'regex) ;; do we have regex capability in guile

;; define constants
(define (make-constants)
  (begin
    (map (lambda (line)
	   (let ((m (string-match "([A-Z_0-9]+).=.([0-9]+)" line)))
	     (cond
	      (m (let ((word (string-downcase (match:substring m 1)))
		       (value (match:substring m 2)))
		   (let ((word (regexp-substitute/global #f "_"  word
							 'pre (lambda (m) "-") 'post)))
		     (format #t "(define *constant-~a* ~a) ~%" word value)))))))
	 lines)
    #t))


;; define register-keyboard-fn calls 
;;(register-keyboard-fn *constant-sdl-scancode-tab* (lambda () (format #t "user pressed TAB key~%")))
(define (register-keyboard-fns)
  (begin
    (map (lambda (line)
	   (let ((m (string-match "([A-Z_0-9]+).=.([0-9]+)" line)))
	     (cond
	      (m (let ((word (string-downcase (match:substring m 1)))
		       (value (match:substring m 2)))
		   (let ((word (regexp-substitute/global #f "_"  word
							 'pre (lambda (m) "-") 'post)))
		     (format #t "(register-keyboard-fn *constant-~a* " word)
		     (format #t "(lambda () (format #t \"")
		     (format #t "user pressed ~a key ~a~a" word "~" "%")
		     (format #t "\")))~%")))))))
	 lines)
    #t))
















(string-match "([A-Z_]+)" "0123")
