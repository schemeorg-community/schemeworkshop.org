(module home mzscheme
  (require scheme/match)
  
  (provide content)
  
  (define em-space (string #\U2003))
   
  (define (&person info)
    (match info
      [(list name institution)
       `(li (b ,name) ,em-space "(" ,institution ")")]
      [else (error)]))
  
  (define (&a ref text)
    `(a (@ (href ,ref)) ,text))
  
  (define content
    `(div (@ (id "Content"))
          (div (@ (id "lambdapic"))(img (@ (src "./lambda.png"))))
          
          (div (@ (id "TitleLine")) (h1 "Scheme and Functional Programming 2009")
               (h4 "Coordinated with the ",(&a "http://www.ccs.neu.edu/events/wand-symposium/index.html" "Symposium in honor of Mitchell Wand"))
               (h2 "August 22, 2009")
               (h3 "Boston, Massachusetts"))
          
          (div (@ (id "mainbox"))
               
               (div (p "The purpose of the workshop is to report experience with the Scheme family of programming languages, "
                       "to foster collaboration among the members of the community, "
                       "and to present research related to Scheme and functional programming."))
               
               (div (h3 "T-Shirt")
                    (p "To remind you of your heady time at the Scheme Workshop 2009, a t-shirt is "
                       ,(&a "http://www.cafepress.com/brinckerhoff/" "now available") " from cafepress.com. ")
                    (p "It appears to me (having now purchased one of them) that I (John Clements) don't actually "
                       "earn any money from the sale of these t-shirts.  Ah well.")
                    (p (center ,(&a "http://www.cafepress.com/brinckerhoff/" `(img (@ (src "./tshirt-sample.jpg")))))))
               
               (div (h3 "Final Program, Schedule, and Proceedings")
                    (p ,(&a "./pre-program/index.html"
                          "The titles, authors, and abstracts of the accepted papers are now available online."))
                    (p ,(&a "./schedule-page/index.html"
                            "So is the schedule."))
                    (p ,(&a "./scheme2009.pdf"
                            "Here's a  (single-file) PDF of the proceedings.")))
               
               (div (h3 "Program Committee")
                    (ul ,@(map &person
                               `(("John Clements" "Cal Poly State University (organizer & chair)")
                                 ("Dominique Boucher" "Nu Echo")
                                 ("Abdulaziz Ghuloum" "Indiana University")
                                 ("David Herman" "Northeastern University")
                                 ("Shriram Krishnamurthi" "Brown University")
                                 ("Matthew Might" "University of Utah")
                                 ("David Van Horn" "Northeastern University")))))
               
               (div (h3 "Steering Committee")
                    (ul
                     ,@(map &person
                            `(("William D. Clinger" "Northeastern University")
                              ("Marc Feeley" "University of Montréal")
                              ("Robby Findler" "University of Chicago")
                              ("Dan Friedman" "Indiana University")
                              ("Christian Queinnec" "University Paris 6")
                              ("Manuel Serrano" "INRIA Sophia Antipolis")
                              ("Olin Shivers" "Northeastern University")
                              ("Mitchell Wand" "Northeastern University")))))
               
               (div (h3 "Past Workshops")
                    
                    "Past workshops have been held in Victoria (2008), Freiburg (2007), Portland (2006), Tallinn (2005), "
                    "Snowbird (2004), Boston (2003), Pittsburgh (2002), Florence (2001), and Montréal "
                    "(2000). For information concerning past workshops, please see the "
                    (a (@ (href "http://www.schemeworkshop.org"))"main workshop site."))
               
               (div (h3 "To Attend (archived)")
                    (ul (li (b "Date: ") "Saturday, August 22, 2009")
                        (li (b "Location: ") "Northeastern University, ",(&a "http://www.northeastern.edu/campusmap/map/qad5.html" "Curry Student Center Ballroom"))
                        (li (b "Fee: ") "$40, payable online by request")
                        (li (b "Registration Deadline: ") "August 11, 2009"))
                    (p "To register, send e-mail to ",(&a "mailto:aoeuswreg@brinckerhoff.org"
                                                        "aoeuswreg@brinckerhoff.org")
                       " containing your name and any dietary preferences."))
               
               (div (h3 "Important Dates (archived)")
                    (table (@ (class "datetable"))
                           (tr (td (@ (id "foo"))"Submission Deadine") (td "June 5, 2009 (FIRM)"))
                           (tr (td "Author Notification") (td "June 26, 2009"))
                           (tr (td "Final Papers Due") (td "July 24, 2009"))
                           (tr (td "Register by") (td "August 11, 2009"))
                           (tr (td "Workshop") (td "August 22, 2009"))
                           (tr (td ,(&a "http://www.ccs.neu.edu/events/wand-symposium/index.html" "Symposium in honor of Mitchell Wand")) (td "August 23-24, 2009"))))
               
               (div (h3 "Lodging (archived)")
                    (p "The fine folks at Northeastern have arranged a limited number of rooms at discount prices in the Boston area. Some of these rates expire earlier than others, so make your reservations promptly.")
                    
                    (h4 "Le Méridien Hotel")
                    (p ,(&a "http://www.starwoodmeeting.com/Book/neu" "Click here for the group rate") " ($109, expires *July 27*)")

                    (p ,(&a "http://www.starwoodhotels.com/lemeridien/index.html" "Le Méridien Hotel")" in Cambridge is close to the "
                       ,(&a "http://www.mbta.com/schedules_and_maps/subway/lines/stations/?stopId=10919" "Central Square")" station on the "
                       ,(&a "http://www.mbta.com/schedules_and_maps/subway/lines/?route=RED" "red line")". The group rate is $109 per night; the usual taxes will apply. To make reservations, "
                       ,(&a "http://www.starwoodmeeting.com/Book/neu" "follow this link")" for the group rate or call the hotel reservation line at +1 617 551 0134. Make sure to request the Northeastern University group rate.")
                    
                    (h4 "Colonnade Hotel")
                    (p ,(&a "https://gc.synxis.com/rez.aspx?Hotel=2&Chain=2&group=NOH23A" "Click here for the group rate") " ($179)")

                    (p "The ",(&a "http://www.colonnadehotel.com/" "Colonnade Hotel")" is within walking distance of Northeastern University. "
                       "The group rate is $179 per night; the usual taxes will apply. To make reservations, follow this "
                       ,(&a "https://gc.synxis.com/rez.aspx?Hotel=2&Chain=2&group=NOH23A" "link for the group rate")
                       " or call the hotel reservation line at 800-962-3030 or +1 617 424 7000. Make sure to request the Northeastern University group rate.")

                    

                    (h4 "Park Plaza Hotel")
                    (p ,(&a "http://www.starwoodmeeting.com/Book/neu0819" "Click here for the group rate") " ($149, expires *August 8*)")

                    "The Boston ",(&a "http://www.bostonparkplaza.com/" "Park Plaza Hotel")" is close to the "
                    ,(&a "http://www.mbta.com/schedules_and_maps/subway/lines/stations/?stopId=15595" "Arlington station")
                    " on the "
                    ,(&a "http://www.mbta.com/schedules_and_maps/subway/lines/?route=GREEN"
                                   "green line")
                    ". The group rate is $149 per night; the usual taxes will apply. To make reservations, follow "
                    ,(&a "http://www.starwoodmeeting.com/Book/neu0819" "this link for the group rate")
                    " or call the hotel reservation line at +1 617 426 2000. Make sure to request the Northeastern University group rate.")
               #;(div (h3 "Areas of Interest")
                    
                    (ul
                     (li (h4 "Language design")
                         
                         (p "Scheme's simple syntactic framework and minimal"
                            "  static semantics has historically made the language"
                            "  an attractive lab bench for the development and"
                            "  experimentation of novel language features and"
                            "  mechanisms.")
                         
                         (p "Topics in this area include module systems,"
                            "  exceptions, control mechanisms, distributed"
                            "  programming, concurrency and synchronisation, macro"
                            "  systems, reactive programming, domain-specific"
                            "  (embedded) languages, and objects. Past, present and"
                            "  future SRFIs are welcome."))
                     
                     (li (h4 "Type systems")
                         
                         (p "Static analyses for dynamic type systems, type"
                            "  systems that bridge the gap between static and"
                            "  dynamic types, static systems with type dynamic"
                            "  extensions, weak typing."))
                     
                     (li (h4 "Theory")
                         
                         (p "Formal semantics, calculi, correctness of analyses"
                            " and transformations, lambda calculus. "))
                     
                     (li (h4 "Implementation")
                         
                         (p "  Compilers, runtime systems, optimization, virtual"
                            "  machines, resource management, interpreters,"
                            "  foreign-function and operating system interfaces,"
                            "  partial evaluation, program analysis and"
                            "  transformation, embedded systems, malware, and"
                            "  generally implementations with novel or noteworthy"
                            "  features. "))
                     
                     (li (h4 "Program-development environments and tools")
                         
                         (p "The Lisp and Scheme family of programming languages"
                            "  have traditionally been the source of innovative"
                            "  program-development environments. Authors working on"
                            "  these issues are encouraged to submit papers"
                            "  describing their technologies.")
                         
                         (p "Topics include profilers, tracers, debuggers, program"
                            " understanding tools, performance and conformance test"
                            "  suites and tools."))
                     
                     (li (h4 "Education")
                         
                         (p "Scheme has achieved widespread use as a tool for"
                            "  teaching computer science. Papers on the theory and"
                            "  practice of teaching with Scheme are invited."))
                     
                     (li (h4 "Agile Methodologies")
                         
                         (p "Dynamic languages seem to share a symbiotic"
                            "  relationship with agile software development"
                            "  methodologies. In particular, the dynamic type"
                            "  checking of Scheme clearly benefits from test-driven"
                            "  development, but that same dynamic checking makes the"
                            "  software more easily adapted to changing"
                            "  requirements."))
                     
                     (li (h4 "Applications and experience")
                         
                         (p "Interesting applications which illuminate aspects of"
                            "  Scheme experience with Scheme in commercial or"
                            " real-world contexts; use of Scheme as an extension or"
                            " scripting language. "))
                     
                     (li (h4 "Scheme pearls")
                         
                         (p "Elegant, instructive examples of functional"
                            " programming.  A Scheme pearl should be a short paper"
                            " presenting an algorithm, idea or programming device"
                            " using Scheme in a way that is particularly elegant. ")))
                    
                    (p "Of course, the best papers are those that bridge"
                       " several of these categories."))
               
               (div (h3 "Paper Formatting and Submission (archived)")

                    (p "Your submissions should be no longer than 12 pages,"
                       " including bibliography and appendices. Papers may be"
                       " shorter than this limit, and the Program Committee"
                       " encourages authors to submit shorter papers where"
                       " appropriate.")
                    
                    (p "Prepare your papers in standard ACM format: two"
                       " columns, nine point font on ten point baseline, page"
                       " 20pc (3.33in) wide and 54pc (9in) tall with a column"
                       " gutter of 2pc (0.33in), suitable for printing on US"
                       " Letter sized paper. We recommend (but do not require)"
                       " that citations be put into author-date form.")
                    
                    (p "A suggested LaTex "(a (@(href "./sigplanconf.cls"))"class file")
                       " is provided, with accompanying "(a (@(href "./sigplanconf-guide.pdf"))"guide")
                       ", "(a (@(href "./sigplanconf-template.tex"))"template")
                       ", and "(a (@(href "./retrospective.tex"))"example")
                       " including "(a (@(href "./retrospective.bbl"))"references")".")
                    
                    (p "Submit your papers using our "
                       (a (@ (href "http://continue2.cs.brown.edu/scheme2009/")) "submission page")"."))
               
               (div (h3 "Publication Policy (archived)")
                    
                    (p "Submitted papers must have content that has not"
                       " previously been published in other conferences or"
                       " refereed venues, and simultaneous submission to other"
                       " conferences or refereed venues is unacceptable.")

                    (p "Publication of a paper at this workshop is not intended"
                       " to replace conference or journal publication, and does"
                       " not preclude re-publication of a more complete or"
                       " finished version of the paper at some later conference"
                       " or in a journal."))
               
               
               
          
               )
          
          (div (@ (class "centerdiv"))
               (p "built using "(a (@ (href "http://www.plt-scheme.org")) "PLT Scheme") " and " 
                  (a (@ (href "http://www.html.it/articoli/niftycube/index.html")) "NiftyCube")
                  " and "(a (@ (href "http://continue.cs.brown.edu/"))"Continue")". Thanks!")
               (p "want to see the "(a (@ (href "./home.ss")) "source code")"?")) 
          
           
            )))
