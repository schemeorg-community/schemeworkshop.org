(import (scheme base)
        (scheme file)
        (only (srfi 13) string-contains)
        (only (srfi 193) script-directory))

(define (replace string old new)
  (let loop ((acc "") (a 0))
    (let ((b (string-contains string old a)))
      (if (not b)
          (string-append acc (string-copy string a))
          (loop (string-append acc (string-copy string a b) new)
                (+ b (string-length old)))))))

(define (read-all-chars)
  (let loop ((all ""))
    (let ((some (read-string 100)))
      (if (eof-object? some) all (loop (string-append all some))))))

(define (read-template file)
  (let ((file (string-append (script-directory) "../templates/" file)))
    (with-input-from-file file read-all-chars)))

(define (write-www file string)
  (write-string (string-append "Writing " file "\n"))
  (let ((file (string-append (script-directory) "../www/" file)))
    (with-output-to-file file (lambda () (write-string string)))))

(define (template body-file title)
  (let ((page (read-template "page.html"))
        (body (read-template body-file)))
    (set! page (replace page "{{{title}}}" title))
    (set! page (replace page "{{{body}}}" body))
    page))

(define (index)
  (template "index.html"
            "Scheme and Functional Programming Workshop"))

(define (sc)
  (template "sc.html"
            "Scheme and Functional Programming Workshop: Steering Committee"))

(define (chair-advice)
  (template "chair-advice.html"
            "Notes on Running a Scheme Workshop"))

(define (main)
  (write-www "index.html" (index))
  (write-www "sc.html" (sc))
  (write-www "chair-advice/index.html" (chair-advice)))

(main)
