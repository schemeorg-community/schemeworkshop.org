#lang scheme/base

(require scheme/date scheme/match
         (planet "sxml.ss" ("lizorkin" "sxml.plt" 2 0))
         (lib "html-webit-abbreviations.ss" "web-utilities")
         scheme/runtime-path)

(define-runtime-path this-dir ".")

(define (&footer from-file)
  (let ([modified-seconds 
         (if from-file
             (file-or-directory-modify-seconds from-file)
             (current-seconds))])
    `(div (@ (id "Footer"))
          ,(format "last updated: ~a" (date->string (seconds->date modified-seconds) #t)))))

(define (&sub-footer)
  `(div (@ (id "SubFooter"))
        ,(&a "http://www.plt-scheme.org"
             (h4:img `(@ (src ,(path->string (site-relative "images/thfd.png")))
                         (alt "Thank Heavens For DrScheme."))))))

;; To add a new sub-page:
;; 0. choose a name, n
;; 1. add an entry with the name (perhaps n-stem) to this set of defns
;; 2. add an entry to the div whose id is "Menu", below
;; 3. add an entry to the list of calls to output-main-type-page
;; 4. add a directory with the name of the stem
;; 5. add a scheme file with the name 'n.stem' which provides a div named 'content'
(define home-stem "home")
(define pre-program-stem "pre-program")
(define schedule-stem "schedule-page")

(define (site-relative path) (build-path "/~clements/" path))

(define (stem->target-html x)
  (site-relative (string-append x "/index.html")))
(define (stem->source-html x)
  (string-append "./" x "/index.html"))  
(define (stem->ss x)
  (string-append x ".ss"))



(define (make-page-xml content source-file)
  (h4:html
   (h4:head (h4:meta `(@ (http-equiv "Content-Type") (content "text/html;charset=utf-8")))
            (&css-link (string->path "./index.css"))
            (h4:title "Scheme Workshop 2009")
            (h4:meta `(@ (name "generator") (content "DrScheme")))
            `(script (@ (type "text/javascript") (src "niftycube.js")) " ")
            `(script (@ (type "text/javascript"))
#<<|
window.onload=function(){ 
  Nifty("div#mainbox div,div.rounded");
}
|
))

   (h4:body
    (h4:div
     `(@ (id "RealBody")) 
     #;`(div (@ (id "Header"))
           (img (@ (src "buttonbar.png"))))
     (h4:div
      content
      (&footer source-file))
     #;(h4:div `(@ (id "SubMenu"))
                        (&a "http://validator.w3.org/check/referer"
                            (h4:img `(@ (src "http://www.w3.org/Icons/valid-xhtml10")
                                        (alt "Valid XHTML 1.0!")
                                        (height "31")
                                        (width "88")))))))))





;  	font-family: "Trebuchet MS", "Bitstream Vera Sans", verdana, lucida, arial, helvetica, sans-serif;

(define (random-hex)
  (let ([r (random 16)])
    (if (< r 10)
        (number->string r)
        (case r
          [(10) "a"]
          [(11) "b"]
          [(12) "c"]
          [(13) "d"]
          [(14) "e"]
          [(15) "f"]))))

(define (random-hex-6)
  (apply string-append (build-list 6 (lambda (dont-care) (random-hex)))))

(define border-color "#9295B7")
(define border-width "3px")

(define bg-color "#f1dca0")

(define index-css
  `((body (font-family "\"Lucida Grande\", Verdana, Helvetica, Arial, sans-serif")
          (font-size "12px")
          (line-height "20px")
          (color "#222")
          (text-align "center") ; for !@#$ MSIE which doesn't handle margin: auto
          (margin-left "auto")
          (margin-right "auto")
          (background-color ,bg-color))
    (|div#mainbox div|
     (width "660px")
     (padding "20px")
     (margin "20px 0px 20px 0px")
     (background "#f9f4dc")
     (color "#000"))
    (|div.rounded|
     (width "660px")
     (padding "20px")
     (margin "20px 0px 20px 0px")
     (background "#f9f4dc")
     (color "#000")
     (font-size "110%"))
    (|div.inbetween|
     (margin "0px 0px 0px 20px")
     (font-size "110%"))
    (|td.time|
     (min-width "5em"))
    (|#RealBody|
     (margin-left "auto")
     (margin-right "auto")
     (text-align "left")
     (width "700px"))
    (|#Header| 
     (margin "-11px 0px 50px 0px")
     (padding "0px 0px 0px 0px")
     #;(border-style "solid")
     #;(border-color ,border-color)
     #;(border-width ,border-width)
     (color "#000000")
     #;(background-color "#ffb900")
     (text-align "center"))
    (|#TitleLine|
     (text-align "center"))
    (|#Content|
     (margin "0px 0px 0px 0px")
     (padding "10px")
     #;(background-color "#d5e9ed" ))
    (|#SubMenu|
     (margin "10px 0px 0px 0px"))
    (|#Footer|
     #;(border-style "dotted")
     #;(border-style "black")
     #;(border-width ,border-width)
     (margin "0px 0px 0px 173px")
     (text-align "right"))
    (|#SubFooter|
     (text-align "center")
     (margin "30px 0px 0px 0px"))
    (|#arrowbox|
     (height "20px"))
    (|#lambdapic|
     (align "center")
     (text-align "center"))
    (.textright
     (text-align "right"))
    (.borderpic
     (border-style "solid")
     (border-width "1px")
     (border-color "black"))
    (.leftpic
     (float "left"))
    (.rightpic
     (float "right"))
    (.centerdiv 
     (text-align "center"))
    (.namefont
     (font-family "sans-serif")
     (font-size "300%")
     (color "#6E74B7"))
    (.bodyblock
     (padding "10px 10px 10px 10px")
     (margin "20px 0px 20px 0px")
     (background-color "#ffffff"))
    (.datetable
     (margin "0px 0px 0px 50px")
     (border-spacing "80px 0px"))))

(define (output-main-type-page stem)
  (let* ([source-file (stem->ss stem)]
         [content (dynamic-require (build-path this-dir source-file) 'content)])
    (output-any-old-page (stem->source-html stem) (make-page-xml content source-file))))

(define (output-any-old-page filename content)
  (with-output-to-file filename
    (lambda ()
      (display "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">\n")
      (with-handlers (#;[exn:fail? (lambda (exn)
                                     (fprintf (current-error-port) "~v\n" content))])
        (srl:sxml->xml
         `(*TOP*
           #;(*PI* xml "version='1.0'  encoding=\"utf-8\"")
           ,content)
         (current-output-port))))
    #:exists 'truncate))

(output-main-type-page home-stem)
(output-main-type-page pre-program-stem)
(output-main-type-page schedule-stem)

; CSS


(define (write-css path css)
  (with-output-to-file path
    (lambda ()
      (for-each 
       (match-lambda
         [`(,tag . ,elts)
          (printf "~a {\n" tag)
          (for-each (match-lambda 
                      [`(,field ,value)
                       (printf "~a: ~a;\n" field value)]
                      [other (error 'write-css "expects (list field value), given: ~v" other)])
                    elts)
          (printf "}\n")]
         [else (error 'foo2 'bar2)])
       css))
    #:exists
    'truncate))

(write-css "index.css" index-css)

