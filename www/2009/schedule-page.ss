#lang scheme

(require (file "/Users/clements/sw2009/schedule.ss"))

(provide content)

(define em-space (string #\U2003))

(define (&person info)
  (match info
    [(list name institution)
     `(li (b ,name) ,em-space "(" ,institution ")")]
    [else (error)]))

(define (&a ref text)
  `(a (@ (href ,ref)) ,text))

(define (schedule-block->div block)
  (match block
    [(list (? symbol? start-time) (? string? description))
     `(div (@ (class "inbetween"))
           (table (tr (td (@ (class "time")),(symbol->string start-time)) (td ,description))))]
    [(cons (? symbol? start-time) talks)
     `(div (@ (class "rounded"))
       (table (tr (td (@ (valign "top") (class "time")) ,(symbol->string start-time))
                  (td (@ (valign "top"))
                      (table ,@(apply append
                                      (add-between (map talk->rows talks)
                                                   `((td (& nbsp))))))))))]))


(define (talk->rows talk)
  (match talk
    [(list (? string? title) (? string? authors))
     `((tr (td (b ,title)))
       (tr (td ,authors)))]))

;; the-schedule : 
;;  (listof (union (cons symbol[start-time] (listof (union (list string)
;;                                                         (list desc string)))  ;; session
;;                 (list symbol[start-time] string)))                            ;; break
;;  desc = (union string (listof special string))
;;  special = (union `(sup ,string) `(i ,string)



(define content
  `(div (@ (id "Content"))
        
        
        (div (@ (id "TitleLine")) (h1 "Scheme and Functional Programming 2009")
             (h2 "Preliminary Schedule"))
        
        (div #;(@ (id "mainbox"))
             
             ,@(map schedule-block->div the-schedule))
        
        (div (@ (class "centerdiv"))
             (p "built using "(a (@ (href "http://www.plt-scheme.org")) "PLT Scheme") " and " 
                (a (@ (href "http://www.html.it/articoli/niftycube/index.html")) "NiftyCube")
                " and "(a (@ (href "http://continue.cs.brown.edu/"))"Continue")". Thanks!")
             (p "want to see the "(a (@ (href "../schedule-page.ss")) "source code")"?")) 
        
        ))

