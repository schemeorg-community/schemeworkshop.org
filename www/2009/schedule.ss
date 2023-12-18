#lang scheme 

;; adapted from schedule.ss, written by Robby Findler
;; 2009-07-30, John Clements

(provide the-schedule)

;; the-schedule : 
;;  (listof (union (cons symbol[start-time] (listof (union (list string)
;;                                                         (list string string)))  ;; session
;;                 (list symbol[start-time] string)))                            ;; break
;;  desc = (union string (listof special string))
;;  special = (union `(sup ,string) `(i ,string)

(define the-schedule
  ;; john clements
  '((8:15am "Coffee and a bit more besides")
    
    (8:45am
     ("Invited Talk: If programming is like math, why don't math teachers teach programming?"
      "Emmanuel Schanzer"))
    
    (9:30am "Break (but no new snacks)")

    ;; matthew might
    (9:55am
     ("Sequence Traces for Object-Oriented Executions"
      "Carl Eastlund, Matthias Felleisen")
     
     ("Scalable Garbage Collection with Guaranteed MMU"
      "William D Clinger, Felix S. Klock II")
     
     ("Randomized Testing in PLT Redex"
      "Casey Klein, Robert Bruce Findler"))

    (11:10am "Break (with new snacks!)")

    ;; dave herman
    (11:30am
     ("A pattern-matcher for miniKanren -or- How to get into trouble with CPS macros"
      "Andrew W. Keep, Michael D. Adams, Lindsey Kuper, William E. Byrd, Daniel P. Friedman")
     
     ("Higher-Order Aspects in Order"
      "Eric Tanter")
     
     ("Fixing Letrec (reloaded)"
      "Abdulaziz Ghuloum, R. Kent Dybvig"))

    (12:45pm "Lunch")


    ;; abdulaziz ghuloum
    (1:45pm 
     ("The Scribble Reader: An Alternative to S-expressions for Textual Content"
      "Eli Barzilay")
     
     ("Interprocedural Dependence Analysis of Higher-Order Programs via Stack Reachability"
      "Matthew Might, Tarun Prabhu")
     
     ("Descot: Distributed Code Repository Framework"
      "Aaron W. Hsu")
     
     ("Keyword and Optional Arguments in PLT Scheme"
      "Matthew Flatt, Eli Barzilay")
     
     ("Screen-Replay: A Session Recording and Analysis Tool for DrScheme"
      "Mehmet Fatih Köksal, Remzi Emre Başar, Suzan Üsküdarlı"))


    (3:00pm "Break (with new snacks!)")

    ;; shriram krishnamurthi
    (3:20pm
     ("Get stuffed: Tightly packed abstract protocols in Scheme"
      "John Moore")
     
     ("Distributed Software Transactional Memory"
      "Anthony Cowley")
     
     ("World With Web: A compiler from world applications to JavaScript"
      "Remzi Emre Başar, Caner Derici, Çağdaş Şenol"))
    
    (4:05pm "Break (but no new snacks)")

    ;; david van horn
    (4:25pm 
     ("Peter J Landin (1930-2009)"
      "Olivier Danvy")
     
     ("Invited Talk: Future Directions for the Scheme Language"
      "The Newly Elected Scheme Language Steering Committee"))))
