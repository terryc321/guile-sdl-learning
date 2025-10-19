
;; pixelformat.scm
;; load c shared library from pixelformat directory
(use-modules (system foreign))
(use-modules (system foreign-library))

;;(define show-pixelformat (foreign-library-pointer "pixelformat" "show_pixelformat_format"))
;;(define init-pixelformat (foreign-library-pointer "pixelformat" "init_pixelformat"))

(define pixelformat
  (foreign-library-function "pixelformat" "pixelformat_wrapper"
                            #:return-type '*
                            #:arg-types (list '*)))

(define pixelformat2
  (foreign-library-function "pixelformat" "pixelformat2"
                            #:return-type void
                            #:arg-types (list '*)))

(define output-check
  (foreign-library-function "pixelformat" "output_check"
                            #:return-type void
                            #:arg-types (list)))


