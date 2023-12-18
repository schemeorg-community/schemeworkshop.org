;;
;; pscheme.ss - A dynamic system for data-directed programming in scheme
;; 
;; Author: Ronald Garcia

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Utility Functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Transform a syntax object of a list into a list of syntax objects.
;; Chez Scheme guarantees that this will work (see release notes).
;; PLT Scheme has a user-level operation that will do this.
(define syntax->list
  (lambda (stx)
    (with-syntax ([(ls* ...) stx])
      #'(ls* ...))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Application-specific Functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Get the zero-based index for the identifier id in the list ls.
(define mem-idx
  (lambda (id ls)
    (let loop ([ls ls] [idx 0])
      (cond
       [(null? ls) #f]
       [(free-identifier=? (car ls) id) idx]
       [else (loop (cdr ls) (add1 idx))]))))


;; Build the syntax to check for instance matches on operator calls.
(define build-pred-check-macro
  (lambda (p^* p* macro-name)
    (with-syntax ([pred* #'pred*]
                  [macro-name macro-name])
      (let ()
        ;; pred* is implicit in loop
        (define loop
          (lambda (p^* idx)
            (cond
             [(null? p^*) #'()]
             [(mem-idx (car p^*) p*) =>
              (lambda (n)
                (with-syntax ([n n]
                              [idx^ idx]
                              [p^ (car p^*)]
                              [(rest* ...) (loop (cdr p^*) (add1 idx))])
                  #'(((vector-ref pred* n) (list-ref args idx^))
                     rest* ...)))]
             [else (loop (cdr p^*) (add1 idx))])))
        (with-syntax ([(check* ...) (loop p^* 0)])
          #'(define-syntax macro-name
              (syntax-rules ()
                [(_ pred*) (and check* ...)])))))))


;;  Given a list of identifiers and an associative list, sort the alist to
;;  match the order of the identifier list. 
;;  - There must be an alist entry for every identifier.  
;;  - any extra alist entries are dropped.
;;  - later alist entries that duplicate earlier identifiers are dropped.
(define sort-identifier-alist
  (let ()
    ;; Search an associated list of identifiers for a match
    (define assoc-id
      (lambda (id als)
        (let loop ([als als])
          (cond
           [(null? als) #f]
           [(naked-identifier=? id (caar als)) (car als)]
           [else (loop (cdr als))]))))

    ;; compare the underlying symbols of two identifiers
    (define naked-identifier=?
      (lambda (stx-a stx-b)
        (let ([a (syntax-object->datum stx-a)]
              [b (syntax-object->datum stx-b)])
          (eq? a b))))

    (lambda (stx key* als default* ctx Classname)
      (let loop ([key* key*]
                 [default* default*])
        (cond
         [(null? key*) '()]
         [(assoc-id (car key*) als) =>
          (lambda (entry)
            ;; Add the class table poop to it
            (with-syntax ([(op-name op) entry]
                          [Classname Classname])
            (cons #'(op-name
                     (lambda (Ct)
                       (Classname rebuild-ops op-name Ct)
                       (Classname rebind-table op-name Ct)
                       (let () op)))
                  (loop (cdr key*) (cdr default*)))))]
         [(syntax-object->datum (car default*))
          ;; no method supplied, default exists: use it.
          (let ([op
                 (datum->syntax-object ctx
                     (syntax-object->datum (car key*)))])
          (cons (list op (car default*))
                (loop (cdr key*) (cdr default*))))]
         [else
          (syntax-error stx (format "Missing operator ~a:"
                                    (syntax-object->datum (car key*))))])))))




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Language proper starts hers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(define-syntax define-class
  (lambda (x)

    (define dynamify-ops
      (lambda (op* ctx)
        op*))

    (define get-op-sigs
      (lambda (op-spec*)
        (map (lambda (op-spec)
               (syntax-case op-spec ()
                 [[(op pv* ...) default-expr] #'(op pv* ...)]                 
                 [(op pv* ...) #'(op pv* ...)])) op-spec*)))

    (define get-op-defaults
      (lambda (op-spec*)
        (map (lambda (op-spec)
               (syntax-case op-spec ()
                 [[(op pv* ...) default-expr] #'default-expr ]                 
                 [(op pv* ...) #f])) op-spec*)))

    (define make-default-names
      (lambda (op-spec* _)
        (map (lambda (op-spec)
               (syntax-case op-spec ()
                 [[(op pv* ...) default-expr]
                  (datum->syntax-object _ (gensym))]
                 [(op pv* ...) #f])) op-spec*)))

     (define make-default-defines
      (lambda (op-default* default-name* Classname)
        (with-syntax ([Classname Classname])
        (let loop ([op-default* op-default*]
                   [default-name* default-name*])
          (cond
           [(null? op-default*) '()]
           [(car op-default*)
            (cons
             (with-syntax ([op-default (car op-default*)]
                           [default-name (car default-name*)])
               ;; need to wrap op in a table-lambda and rebuild-ops.
               #'(define default-name
                   (lambda (Ct)
                     (Classname rebuild-ops Classname Ct)
                     (Classname rebind-table Classname Ct)
                     (let () op-default))))
             (loop (cdr op-default*) (cdr default-name*)))]
           [else (loop (cdr op-default*) (cdr default-name*))])))))
       
    ;; For a specific class operator, build: 
    ;; - a function that dispatches to the proper operator implementation. the
    ;;   class table for a matching entry. 
    ;; - a macro that properly signals a compile-time warning if an
    ;;   operator is syntactically referenced used before any valid
    ;;   instances are declared, and signals an error when that reference
    ;;   is reached at runtime.
    (define make-class-operator
      (lambda (op-spec p* op-fn op-name*)
        (with-syntax ([(op p^* ...) op-spec]
                      [op-fn op-fn])
          (with-syntax ([instance-macro
                         (build-pred-check-macro #'(p^* ...) p* #'check-pred*)]
                        [op-idx (mem-idx #'op op-name*)]
                        [min-num-args (length (syntax->list #'(p^* ...)))])
            #'(begin
                (define-syntax (op x)
                  (syntax-case x ()
                    [(_ c0 (... ...))
                     (begin
                       (warning
                        #f "Possible call to operator ~s with no instances" 'op)
                       #'(error 'op "Operator has no instances:"))]
                    [_
                     (begin
                       (warning
                        #f "Possible reference to operator ~s with no instances"
                        'op)
                       #'(error 'op "Operator has no instances:"))]))
                ;; class table entries are of the form:
                ;; [Predicates] X [Operators]
                (define op-fn
                  (lambda (Ctable)
                    (lambda args
                      instance-macro
                      (if (< (length args) min-num-args)
                          (error 'op "Too few arguments to function."))
                      ;; RG - could put an args length check here!
                      (let loop ([entry* Ctable])
                        (cond
                         [(null?  entry*)
                          (error 'op "Bad call to class operator ~s" 'op)]
                         [(let ([pred* (caar entry*)])
                            #;(and check* ...)
                            (check-pred* pred*)) ;; check
                          (apply
                           ((vector-ref (cdar entry*) op-idx) Ctable) args)]
                         [else (loop (cdr entry*))]))))))))))

            
    (define make-class-macro
      (lambda (Classname Tablename op* op-fn* default-name*)
        (with-syntax ([Classname Classname]
                      [Tablename Tablename] 
                      [(op* ...) op*]
                      [(op-fn* ...) op-fn*]
                      [(default-name* ...) default-name*]
                      [op-len (length (syntax-object->datum op*))])
        (with-syntax ([op-macro*
                       (map
                        (lambda (op op-fn)
                          (with-syntax ([op op] [op-fn op-fn])
                            #'(define-syntax op
                                (lambda (x)
                                  (syntax-case x ()
                                    [(_ args (... (... ...)))
                                     #'((op-fn Tablename)
                                        args (... (... ...)))]
                                    [_
                                     #'(op-fn Tablename)])))))
                        #'(op* ...) #'(op-fn* ...))])
          #'(define-syntax Classname
                (lambda (y)
                  (syntax-case y (get-classtable instances-declaration
                                  rebind-table instances-definition rebuild-ops)
                    [(_ rebind-table stx Tparm)
                     (with-syntax ([Tablename
                                    (datum->syntax-object #'stx 'Tablename)])
                       #'(define Tablename Tparm))]
                    [(_ rebuild-ops stx Tablename)
                     (with-syntax ([(op^* (... ...))
                                    (datum->syntax-object #'stx '(op* ...))]
                                   [(op-fn^* (... ...)) #'(op-fn* ...)])
                     ;; expand the class table with the new set of ops.
                     #'(begin
                         (define-syntax op^*
                           (lambda (x)
                             (syntax-case x ()
                               [(_ args (... (... ...)))
                                #'((op-fn^* Tablename) args (... (... ...)))]
                               [_
                                #'(op-fn^* Tablename)]))) (... ...)))]
                    [(_ get-classtable stx)
                     (with-syntax ([Tablename
                                    (datum->syntax-object #'stx 'Tablename)])
                       #'Tablename)]
                    [(Classname instances-declaration __ stx
                                (pred* (... ...)) ([op-name^* op^*] (... ...))
                                body* (... ...))
                     (with-syntax ([Tablename
                                    (datum->syntax-object #'Classname 'Tablename)])
                     (begin
                       (if (> (length
                               (syntax-object->datum #'(op^* (... ...))))
                                   op-len)
                           (syntax-error
                            #'stx "Bad instance: Too many operators"))
                       (with-syntax ([([op-name^* op^*] (... ...))
                                      (sort-identifier-alist #'stx 
                                                (syntax->list #'(op* ...))
                                                #'([op-name^* op^*] (... ...))
                                                (syntax->list
                                                 #'(default-name* ...))
                                                #'__
                                                #'Classname)]
                                     [(op-fn^* (... ...)) #'(op-fn* ...)])
                                                            
                         ;; expand the class table with the new set of ops.
                         #'(let ([Tablename
                                  (cons (cons (vector pred* (... ...))
                                              (vector op^* (... ...)))
                                        Tablename)])
                             (define-syntax op-name^*
                               (lambda (x)
                                 (syntax-case x ()
                                   [(_ co (... (... ...)))
                                    #'((op-fn^* Tablename) co (... (... ...)))]
                                   [_
                                    #'(op-fn^* Tablename)]))) (... ...)
                             (let () body* (... ...))))))]
                    [(Classname instances-definition __ stx
                                (pred* (... ...)) ([op-name^* op^*] (... ...)))
                     (with-syntax ([Tablename
                                    (datum->syntax-object #'__ 'Tablename)])
                     (begin
                       (if (> (length
                               (syntax-object->datum #'(op^* (... ...))))
                                   op-len)
                           (syntax-error
                            #'stx "Bad instance: Too many operators"))
                       (with-syntax ([([op-name^* op^*] (... ...))
                                      (sort-identifier-alist #'stx 
                                                (syntax->list #'(op* ...))
                                                #'([op-name^* op^*] (... ...))
                                                (syntax->list
                                                 #'(default-name* ...))
                                                #'__
                                                #'Classname)]
                                     [(op-fn^* (... ...)) #'(op-fn* ...)])
                         ;; expand the class table with the new set of ops.
                         #'(begin
                             (Classname rebuild-ops __ Tablename)
                             (set!  Tablename (cons (cons (vector pred* (... ...))
                                                          (vector op^* (... ...)))
                                                    Tablename))))))])))))))

    (syntax-case x ()
      ;; differentiate op-spec and op-sig (op-spec can now include default
      ;; implementations.) 
      [(define-class (Classname p* ...) op-spec ...)
       (with-syntax ([((op* p^* ...) ...)
                      (get-op-sigs (syntax->list #'(op-spec ...)))]
                     [(op-default* ...)
                      (get-op-defaults (syntax->list #'(op-spec ...)))]
                     [(default-name* ...)
                        (make-default-names (syntax->list #'(op-spec ...))
                                            #'define-class)])
       (with-syntax ([Tablename
                      (datum->syntax-object #'define-class (gensym))]
                     [(op-fn* ...) (generate-temporaries #'(op* ...))]
                     [(default-define* ...) 
                      (make-default-defines (syntax->list #'(op-default* ...))
                                     (syntax->list #'(default-name* ...))
                                     #'Classname)])

       (with-syntax ([class-macro (make-class-macro #'Classname
                                                    #'Tablename
                                                    #'(op* ...)
                                                    #'(op-fn* ...)
                                                    #'(default-name* ...))]
                     [(op-macro* ...)
                      (map (lambda (op-spec op-fn)
                             (make-class-operator op-spec  #'(p* ...)
                                      op-fn #'(op* ...)))
                           #'((op* p^* ...) ...) #'(op-fn* ...))])
         #'(begin
             (define Tablename '())
             class-macro
             op-macro* ...
             default-define* ...))))])))


;; let-class - syntactic sugar 
(define-syntax let-class
  (lambda (x)
    (syntax-case x ()
      [(_ ([(Classname p* ...) op-spec ...]) body* ...)
       (with-syntax ([define-class (datum->syntax-object #'_ 'define-class)])
         #'(let ()
             (define-class (Classname p* ...) op-spec ...)
             (let () body* ...)))])))


(define-syntax define-instance
  (lambda (x)
    (syntax-case x ()
      [(_ (Classname pred* ...) [op-name* op*] ...)
       #'(Classname
          instances-definition _ x (pred* ...) ([op-name* op*] ...))])))

(define-syntax let-instance
  (lambda (x)
    (syntax-case x ()
      [(_ ([(Classname pred* ...) [op-name* op*] ...]) body* ...)
       #'(Classname
          instances-declaration _ x (pred* ...) ([op-name* op*] ...) body* ...)])))
                 

(define-syntax define-open-qualified
  (lambda (x)
    (syntax-case x ()
      [(_ fn-name (C* ...) fn-body)
       ;; Not just generate-temporaries
       (with-syntax ([(Ct* ...) (generate-temporaries #'(C* ...))])
         #'(begin
             (define-syntax (fn-name x)
               (syntax-case x ()
                 [(__ args (... ...))
                  #'((fn (C* get-classtable __) ...) args (... ...))]
                 [__
                  #'(fn (C* get-classtable __) ...)]))
             (define fn
               (lambda (Ct* ...)
                 (C* rebuild-ops _ Ct*) ...
                 (C* rebind-table _ Ct*) ...
                 (let () fn-body)))))])))
               
(define-syntax define-qualified
  (lambda (x)
    (syntax-case x ()
      [(_ fn-name (C* ...) fn-body)
       (with-syntax ([define-open-qualified
                       (datum->syntax-object #'_ 'define-open-qualified)])
         #'(define-open-qualified fn-name (C* ...) 
             (letrec ([fn-name fn-body]) fn-name)))])))
       
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Test cases
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#!eof
(load "test.ss")
;(print-passed-tests #t)
;; make sure that it gets past syntax expansion
(expand
 '(let-class ([(Eq a) (== a a)])
    (let-instance ([(Eq integer?) (== =)])
      (== 5 7))))

(test
 (let-class ([(Eq a) (== a a)])
   (let-instance ([(Eq integer?) (== =)])
     (== 5 7)))
 #f)

(test
 (let-class ([(Eq a) (== a a)])
   (let-instance ([(Eq integer?) (== =)])
     (== 5 5)))
 #t)

(test-error
(let-class ([(Eq a) (== a a)])
  (let-instance ([(Eq integer?) (== =)])
    (== 5 'x)))) ;; -> Error: bad call to class operator.

(test-error
(let-class ([(Eq a) (== a a)])
  (let-instance ([(Eq integer?) (== =)])
    (== 5)))) ;; -> Error: incorrect number of parameters.


;; Call to a class operator without any instances declared.
(test-error
  (let-class ([(Eq a) (== a a)])
     (== 5 'x)))

(test-error
  (let-class ([(Eq a) (== a a)])
     ==))

(test-warning
 (expand
  '(let-class ([(Eq a) (== a a)])
     (if #f (== 5 'x)))))
 
(test-warning
 (expand
  '(let-class ([(Eq a) (== a a)])
     (if #f ==))))

;; test out unchecked parameters
(test
 (let-class ([(Eq a) (== a _)])
   (let-instance ([(Eq integer?) (== =)])
     (== 5 4)))
 #f)

;; unchecked parameter, bad parameter passed.
(test-error
(let-class ([(Eq a) (== a _)])
  (let-instance ([(Eq integer?) (== =)])
    (== 5 'x)))) ;; -> Error in =: x is not a number 

(test
 (let-class ([(B a) (== a a) (pl a a)])
   (let-instance ([(B integer?) (== =) (pl +)])
     (== 5 (pl 4 1))))
 #t)


;; define-instance example
(test
 (let ()
   (define-class (B a) (== a a) (pl a a))
   (let ()
     (define-instance (B integer?) (== =) (pl +))
     (== 5 (pl 4 1))))
 #t)


(test-error 
 (expand
  '(let-class ([(B a) (== a a) (+ a a)])
     (let-instance ([(B integer?) [== =]])
       (== 5 'x))))) ;; -> Error: wrong number of operators specified. 

(test-error
 (expand
  '(let-class ([(B a) (== a a)])
     (let-instance ([(B integer?) (== =) (pl +)])
       (== 5 'x))))) ;; -> Error: wrong number of operators specified. 

;; Make sure that the order of operations doesn't matter
(test
 (let-class ([(B a) (== a a) (pl a a)])
   (let-instance ([(B integer?) (pl +) (== =)])
     (pl 4 1))) 
 5)

;; generic operation calls should close over the lexical instance.
(test
 (let-class ([(B z) (o z z)])
   (let-instance ([(B integer?) (o +)])
     ((let-instance ([(B integer?) (o -)])
        (lambda () (o 6 6))))))
 0)
            

(test
 (let-class ([(B z) (o z z)])
   (let-instance ([(B string?) (o string-append)])
     ((let-instance ([(B integer?) (o +)])
        (lambda () (o 6 6))))))
 12)


(test
 (let-class ([(B z) (o z z)])
   (let-instance ([(B string?) (o string-append)])
     ((let-instance ([(B integer?) (o +)])
        (lambda () (o "hello, " "world!"))))))
 "hello, world!")

;; Don't supply the proper operators.
(test-error
 (expand
  '(let-class ([(B a) (== a a) (pl a a)])
     (let-instance ([(B integer?) (pl^ +) (== =)])
       (pl 4 1))))) ;; -> Error: missing operator pl

;; Make sure that defaults don't need to be supplied
(test
 (let-class ([(B a) [(o a a) (lambda (l r) 'blathering-blatherskite)]])
   (let-instance ([(B integer?)])
       (o 4 1)))
 'blathering-blatherskite)


;; Make sure that defaults result in dynamic calls to ops
(test
 (let-class ([(B a)
              [(o1 a) (lambda (x) (o2 x))]
              (o2 a)])
   (let-instance ([(B integer?) (o2 (lambda (x) 'blathering-blatherskite))])
       (o1 4)))
 'blathering-blatherskite)

;; The Mother-test of dynamic defaults
(test
 (let-class ([(Eq a)
              [(== a) (lambda (l r) (not (/= l r)))]
              [(/= a) (lambda (l r) (not (== l r)))]])

   (list 
    (let-instance ([(Eq integer?) (== =)])
      (list (== 5 5) (== 5 4) (/= 5 5) (/= 5 4)))
    (let-instance ([(Eq integer?) (/= (lambda (l r) (not (= l r))))])
      (list (== 5 5) (== 5 4) (/= 5 5) (/= 5 4)))))
 '((#t #f #f #t) (#t #f #f #t)))

(test 
 (let ()
   (define-class (Eq a) [(== a) (lambda (l r) (not (/= l r)))]
                        [(/= a) (lambda (l r) (not (== l r)))])
   
   (let ()
    (list 
      (let-instance ([(Eq integer?) (== =)])
        (list (== 5 5) (== 5 4) (/= 5 5) (/= 5 4)))
      (let-instance ([(Eq integer?) (/= (lambda (l r) (not (= l r))))])
        (list (== 5 5) (== 5 4) (/= 5 5) (/= 5 4))))))
 '((#t #f #f #t) (#t #f #f #t)))

;; Capture an operator and use it
(test
 (let-class ([(A z) (o z)])
   (let ([op (let-instance ([(A integer?) (o add1)]) o)])
     (op 6)))
 7)

;; Captures stay captured (new lexical instance doesn't change things)
(test
 (let-class ([(A z) (o z)])
   (let ([op (let-instance ([(A integer?) (o add1)]) o)])
     (let-instance ([(A integer?) (o sub1)]) 
       (op 6))))
 7)

;; Captures even work once you've left class scope
(test
 (let ([op
        (let-class ([(A z) (o z)])
          (let-instance ([(A integer?) (o add1)])
            o))])
   (op 6))
 7)

(test
 (let ()
   (define-qualified f () (lambda (x) x))
   (f 6))
 6)

(test
 (let-class ([(B p) (o p)])
   (define-qualified f (B) (lambda (x) x))
   (f 6))
 6)

;; instance operators implemented in terms of other instance operators
;; statically bind to the result of adding the current instance.
;; (this is not the most flexible model, but there's some weirdness to 
;; making it completely dynamic).
(let-class ([(Eq p) (== p _) (/= _ p)])
  (let-instance ([(Eq string?)
                  (== string=?)
                  (/= (lambda (l r) (not (== l r))))])
    (/= "hello" "bob")))


;; Simple example of using a generic function
(let-class ([(B p) (o p)])
  (let-instance ([(B integer?) (o (lambda (x) (add1 x)))])
    (define-qualified f (B)
      (lambda (x) (o x)))
    (let-instance ([(B integer?) (o (lambda (x) x))])
      (f 77))))

(test
 (let-class ([(B p) (o p)])
   (define-qualified f (B)
     (lambda (x) (o x)))
   (cons (let-instance ([(B integer?) (o (lambda (x) (add1 x)))])
           (f 77))
         (let-instance ([(B integer?) (o (lambda (x) x))])
           (f 77))))
 '(78 . 77))


;; Dispatch from within generic functions
(test
 (let-class ([(B p) (o p)])
   (let-instance ([(B boolean?)  (o (lambda (x) 'boolean))])
     (define-open-qualified f (B)
       (lambda (x)
         (cons (o x)
               (if x
                   (let-instance ([(B boolean?)  (o (lambda (x) x))])
                     (f #f))
                   '()))))
     (f #t)))
 '(boolean #f))

(test
 (let-class ([(B p) (o p)])
   (let-instance ([(B null?)  (o (lambda (x) x))])
     (define-open-qualified f (B)
       (lambda (x)
         (cond
          [(= x 0) (cons (o 5) (cons (o #f) (o '())))]
          [(= x 1) (let-instance ([(B integer?) (o (lambda (x) x))]) (f 0))]
          [(= x 2) (let-instance ([(B boolean?) (o (lambda (x) x))]) (f 1))])))
     (f 2)))
 '(5 #f))


