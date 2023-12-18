;;
;; test.ss - simple test system
;;



;; test - compare the result of an operation to the result that is expected 
;;    (possibly using a user-supplied predicate)
(define print-passed-tests
  (case-lambda
   [() (getprop 'print-passed-tests 'tests)]
   [(x) (putprop 'print-passed-tests 'tests x)]))

(define-syntax test
  (syntax-rules ()
    [(test code result) (test equal? code result)]
    [(test pred? code expected)
     (let ([exv expected]
           [cdv code])
     (let ([result (pred? cdv exv)])
       (if (and (not (print-passed-tests)) result)
           (printf ".")
           (let ([p (open-output-string)])
             (fprintf p "\n")
             (pretty-print 'code p)
             (if result
                 (fprintf p ": passed" result)
                 (fprintf p ": failed.\n  expected ~s\n  got ~s\n" exv cdv))
             (printf "~a\n" (get-output-string p))))))]))

;; test-error - execute an expression, expecting some sort of error code.  
(define-syntax test-error
  (syntax-rules ()
    [(test-error code)
     (let ([result
            ;; use dynamic-wind to temporarily re-bind the error handler to
            ;; "return" true.  "Return" false if supplied code doesn't error.
            (call/cc
             (lambda (cont)
               (let ([old-handler (error-handler)]
                     [new-handler (lambda (who msg . args) (cont #t))])
                 (dynamic-wind
                     (lambda () (error-handler new-handler))
                     (lambda ()
                       (begin
                         code
                         (cont #f)))
                     (lambda () (error-handler old-handler))))))])
       (if (and (not (print-passed-tests)) result)
           (printf ".")
           (let ([p (open-output-string)])
             (pretty-print 'code p)
             (fprintf p ": ~s" result)
             (printf "~a\n" (get-output-string p)))))]))

;; test-warning - execute an expression, expecting some sort of warning
(define-syntax test-warning
  (syntax-rules ()
    [(test-error code)
     (let ([result
            ;; use dynamic-wind to temporarily re-bind the warning handler to
            ;; "return" true.  "Return" false if supplied code doesn't error.
            (call/cc
             (lambda (cont)
               (let ([old-handler (warning-handler)]
                     [new-handler (lambda (who msg . args) (cont #t))])
                 (dynamic-wind
                     (lambda () (warning-handler new-handler))
                     (lambda ()
                       (begin
                         code
                         (cont #f)))
                     (lambda () (warning-handler old-handler))))))])
       (if (and (not (print-passed-tests)) result)
           (printf ".")
           (let ([p (open-output-string)])
             (pretty-print 'code p)
             (fprintf p ": ~s" result)
             (printf "~a\n" (get-output-string p)))))]))

