#lang scheme

(require scheme/match)

(provide content)

(define em-space (string #\U2003))
(define em-dash (string #\U2014))

(define (&person info)
  (match info
    [(list name institution)
     `(li (b ,name) ,em-space "(" ,institution ")")]
    [else (error)]))

(define content
  `(div (@ (id "Content"))
        
        (div (@ (id "TitleLine")) (h1 "Scheme and Functional Programming 2009")
             (h2 "Preliminary Program"))
        
        (div (@ (id "mainbox"))
             
             (div (@ (id "i1-schanzer"))
                  (h3 "Invited Talk: If programming is like math, why don't math teachers teach programming?")
                  (h4 "Emmanuel Schanzer")
                  (p "It's been forty years since Logo, so why aren't middle schools teaching
programming? Educational research has highlighted the pre-teen years as a
crucial stage in the development of student attitudes and competencies in
all subjects. With the growing pressure on these schools to raise student
scores in Mathematics and to expose them to technology, many once again
believe that computer programming holds the answer. In this talk I explore
some of the recent research about mathematics education and cognitive
science, and compare several of the current child-friendly programming
environments. In the process, I identify the orthogonal strengths of each
approach, the obstacles that prevent each from gaining traction in typical
middle schools, and present a hybrid approach under development,
 called Bootstrap [http://www.bootstrapworld.org] that is currently
in use at middle schools around the country.
"))
             
             (div (@ (id "s1-barzilay"))
                  (h3 "The Scribble Reader: An Alternative to S-expressions for Textual Content")
                  (h4 "Eli Barzilay")
                  (p " For decades, S-expressions have been one of the fundamental
 advantages of languages in the Lisp family—a major factor in
 shaping these languages as an ideal platform for symbolic
 computations, including meta-programming and much more.")

                  (p "As convenient as this minimalist syntax may be, it is highly
 inconvenient for dealing with textual content.  In this paper we
 describe the reader used by Scribble—the PLT Scheme
 documentation system.  The reader implements a syntax that is easy
 to use, uniform and meshes well with the Scheme philosophy.  The
 syntax makes \"here-strings\" and string interpolation easy, yet it is
 more powerful than a combination of the two."))
             
             (div (@ (id "ss2-basar"))
                  (h3 "World With Web: A compiler from world applications to Javascript")
                  (h4 "Remzi Emre Başar, Caner Derici, Çağdaş Şenol")
                  (p "Our methods for interacting with computers have changed drastically over the last 
10 years. As web based technologies improve, online applications are starting to replace their offline 
counterparts. In the world of online interaction, our educational tools also need to be adapted for this 
environment. This paper presents WorldWithWeb, a compiler and run-time libraries for mapping programs 
written in Beginning Student Language of PLT Scheme with World teachpack to JavaScript. This tool is 
intended to exploit the sharing-enabled nature of the web to support the learning process of students. 
Although it is designed as an extension to DrScheme, it is also possible to use it in various settings 
to enable different methods of user interaction and collaboration."))
             
             (div (@ (id "l1-clinger"))
                  (h3 "Scalable Garbage Collection with Guaranteed MMU")
                  (h4 "William D Clinger, Felix S. Klock II")
                  (p "Regional garbage collection offers a useful
compromise between real-time and generational collection.
Regional collectors resemble generational collectors,
but are scalable: our main theorem guarantees a positive
lower bound, independent of mutator and live storage,
for the theoretical worst-case minimum mutator utilization
(MMU). The theorem also establishes fixed upper bounds for space
usage and collection pauses.")
                  (p "Standard generational collectors are not scalable.
Some real-time collectors are scalable, while others
assume a well-behaved mutator or provide no worst-case
guarantees at all.")
                  (p "Regional collectors cannot compete with hard real-time
collectors at millisecond resolutions, but offer
efficiency comparable to contemporary generational
collectors combined with improved latency and MMU at
resolutions on the order of hundreds of milliseconds to
a few seconds."))
             
             (div (@ (id "ss1-cowley"))
                  (h3 "Distributed Software Transactional Memory")
                  (h4 "Anthony Cowley")
                  (p "This report describes an implementation of a distributed software transactional
memory (DSTM) system in PLT Scheme. The system is built using PLT Scheme's Unit
construct to encapsulate the various concerns of the system, and allow for
multiple communication layer backends. The front-end API exposes true parallel
processing to PLT Scheme programmers, as well as cluster-based computing using a
shared namespace for transactional variables. The ramifications of the
availability of such a system are considered in the novel context of highly
dynamic robot swarm programming scenarios. In robotics programming scenarios,
difficulty with expressing complex distributed computing patterns often
supercedes raw performance in importance. In fact, for many applications the
data to be shared among networked peers is relatively small in size, but the
manner in which data sharing is expressed leads to tremendous inefficiencies
both at development time and runtime. In an effort to maintain focus on behavior
specification, we reduce the emphasis on messaging protocols typically found in
distributed robotics software, while providing even greater flexibility in terms
of how data is mixed and matched as it moves over the network."))
             
             (div (@ (id "l2-eastlund"))
                  (h3 "Sequence Traces for Object-Oriented Executions")
                  (h4 "Carl Eastlund and Matthias Felleisen")
                  
                  (p"                  Researchers have developed a large variety of semantic models of
object-oriented computations. These include object calculi as well as
denotational, small-step operational, big-step operational, and reduction
semantics. Some focus on pure object-oriented computation in small
calculi; many others mingle the object-oriented and the procedural aspects
of programming languages.
")
                  (p "In this paper, we present a novel, two-level framework of object-oriented
computation. The upper level of the framework borrows elements from UML's
sequence diagrams to express the message exchanges among objects. The
lower level is a parameter of the upper level; it represents all those
elements of a programming language that are not object-oriented.  We show
that the framework is a good foundation for both generic theoretical
results and practical tools, such as object-oriented tracing debuggers.
"))
             
             (div (@ (id "s2-flatt"))
                  (h3 "Keyword and Optional Arguments in PLT Scheme")
                  (h4 "Matthew Flatt and Eli Barzilay")
                  (p "The 'lambda' and procedure-application forms in PLT Scheme support
arguments that are tagged with keywords, instead of identified by
position, as well as optional arguments with default values. Unlike
previous keyword-argument systems for Scheme, a keyword is not
self-quoting as an expression, and keyword arguments use a different
calling convention than non-keyword arguments. Consequently, a keyword
serves more reliably (e.g., in terms of error reporting) as a
lightweight syntactic delimiter on procedure arguments. Our design
requires no changes to the PLT Scheme core compiler, because 'lambda'
and application forms that support keywords are implemented by macros
over conventional core forms that lack keyword support."))
             
             (div (@ (id "l3-ghuloum"))
                  (h3 "Fixing Letrec (reloaded)")
                  (h4 "Abdulaziz Ghuloum and R. Kent Dybvig")
                  (p " The Revised^6 Report on Scheme introduces three fundamental changes
 involving Scheme's recursive variable binding constructs.  First, it
 standardizes the sequential recursive binding construct,
 "(tt "letrec*")", which evaluates its initialization expressions in a
 strict left-to-right order.  Second, it specifies that internal and
 library definitions have "(tt "letrec*")" semantics.  Third, it
 prohibits programs from invoking the continuation of a letrec
 or "(tt "letrec*")" init expression more than once.  The first two
 changes increase the incentive for handling "(tt "letrec*")"
 efficiently, while the third change gives the compiler more options for
 transforming "(tt "letrec")" and "(tt "letrec*")" expressions.
")
                  (p "
 This paper extends an earlier effort of Waddell, Sarkar, and Dybvig to
 handle the Revised^5 Report "(tt "letrec")" and the (then nonstandard)
 "(tt "letrec*")" efficiently.  It presents more aggressive
 transformations for "(tt "letrec")" and "(tt "letrec*")" that take
 advantage of the new prohibition on invoking the continuations of
 initialization expressions multiple times.  The implementation employs
 Tarjan's algorithm for finding strongly connected components in a graph
 that encodes the dependencies among the bindings.
"))
             
             (div (@ (id "s3-hsu"))
                  (h3 "Descot: Distributed Code Repository Framework")
                  (h4 "Aaron W. Hsu")
                  (p "Programming language communities often have repositories of code to which
the community submits libraries and from which libraries are downloaded
and installed.  In communities where many implementations of the language
exist, or where the community uses a number of language varieties, many
such repositories can exist, each with their own toolset to access them.
These diverse communities often have trouble collaborating accross
implementation boundaries, because existing tools have not addressed
inter-repository communication. Descot enables this collaboration, making
it possible to collaborate without forcing large social change within
the community.  Descot is a metalanguage for describing libraries and a
set of protocols for repositories to communicate and share information.
This paper discuss the benefits of a public interface for library
repositories and detail the library metalanguage, the server protocol, and
a server API for convenient implementation of Descot-compatible servers."))
             
             (div (@ (id "l4-keep"))
                  (h3 "A pattern-matcher for miniKanren -or- How to get into trouble with CPS macros")
                  (h4 "Andrew W. Keep, Michael D. Adams, Lindsey Kuper, William E. Byrd and Daniel P. Friedman")
                  (p "CPS macros written using Scheme's "(tt"syntax-rules")" macro system allow for easier 
composition of macros and control over the order of macro expansion. We identify a limitation of CPS macros when used 
to generate bindings from a non-unique list of user-specified identifiers.  Implementing a pattern matcher for the Kanren 
family of relational programming languages revealed this limitation.  Identifiers come from the pattern, and repetition 
indicates that the same variable binding should be used.  Using a CPS macro, binding is delayed until after the comparisons 
are performed.  This may cause free identifiers that are symbolically equal to be conflated, even when they are introduced 
by different parts of the source program.  After expansion, this leaves some identifiers unbound that should be bound.  
In our first solution,"" we use ""syntax-case"" with "(tt "bound-identifier=?")" to correctly compare the delayed bindings.  
Our second solution uses eager binding with "(tt "syntax-rules")", which requires abandoning CPS macros when discovering "
                                             "new identifiers."))
             
             (div (@ (id "l5-klein"))
                  (h3"Randomized Testing in PLT Redex")
                  (h4 "Casey Klein and Robert Bruce Findler")
                  (p "This paper presents new support for randomized testing in PLT Redex, a
domain-specific language for formalizing operational semantics. In
keeping with the overall spirit of Redex, the testing support is as
lightweight as possible—Redex programmers simply write down
predicates that correspond to facts about their calculus and the tool
randomly generates program expressions in an attempt to falsify the
predicates. Redex's automatic test case generation begins with simple
expressions, but as time passes, it broadens its search to include
increasingly complex expressions. To improve test coverage, test
generation exploits the structure of the model's metafunction and
reduction-relation definitions.")
                  (p"The paper also reports on a case-study applying Redex's testing
support to the latest revision of the Scheme standard. Despite a
community review period, as well as a comprehensive,
manually-constructed test suite, Redex's random test case generation
was able to identify several bugs in the semantics."))
             
             (div (@ (id "s4-koksal"))
                  (h3 "Screen-Replay: A Session Recording and Analysis Tool for DrScheme")
                  (h4 "Mehmet Fatih Köksal, Remzi Emre Başar, Suzan Üsküdarlı")
                  (p "Approaches to teaching \"Introduction to Programming\" vary considerably.  However, two broad 
categories may be considered: product oriented vs process oriented. Whereas, in the former the final product is most 
significant, in the latter the process for achieving the final product is also considered very important. Process 
oriented programming courses strive to equip students with good programming habits. In such courses, assessment 
is challenging since it requires the observation of how students develop their programs. Conventional methods 
and tools that assess final products are not adequate for such observation.")
                  (p "This paper introduces a tool for non-intrusive observation of program development process. 
This tool is designed to support the process oriented approach of \"How to Design Programs\" (HtDP) and is 
implemented for the DrScheme environment. The design, implementation and utility of this tool is described with examples."))
             
             (div (@ (id "s5-might"))
                  (h3 "Interprocedural Dependence Analysis of Higher-Order Programs via Stack Reachability")
                  (h4 "Matthew Might and Tarun Prabhu")
                  (p "We present a small-step abstract interpretation for the
  administrative normal form lambda-calculus (ANF), which has been
  instrumented to find data dependence information for expressions and
  procedures.
")
                  (p "  Our goal is parallelization: 
  when two expressions have no dependence conflicts, it is safe to
  evaluate them in parallel.
")
                  (p "  The underlying principle for discovering dependences is 
  Harrison's principle: whenever a resources is accessed or modified,
  procedures that have frames live on the stack have a dependence upon
  that resource.
")
                  (p "  The abstract interpretation models the stack of a CESK machine with
  high precision by mimicking heap-allocation of continuations.
")
                  (p "  Abstractions of continuation marks are employed so that the abstract
  semantics retain proper tail-call optimization without sacrificing
  dependence information."))
             
             (div (@ (id "ss3-moore"))
                  (h3 "Get stuffed: Tightly packed abstract protocols in Scheme")
                  (h4 "John Moore")
                  (p "This paper describes a layered approach to encoding and decod-
ing tightly packed binary protocols. The protocols developed are
based on an abstract syntax described via an s-expression. This ap-
proach utilises simple built-in features of the Scheme programming
language to provide a dynamic environment that facilitates the de-
velopment of extensible protocols. A tool called Packedobjects has
been developed which demonstrates this functionality. An exam-
ple application is presented to illustrate the flexibility of both the
tool and the Scheme programming language in this domain. In par-
ticular we will show how it is possible to embed this technology
into another application programming language such as C to power
its network communication. Using the example application we will
also highlight the choices available to the developer when deciding
whether or not to embed such technology."))
             
             (div (@ "l6-tanter")
                  (h3"Higher-Order Aspects in Order")
                  (h4 "Eric Tanter")
                  (p "In aspect-oriented programming languages, evaluating advice
is usually considered on the same level as evaluating the base
program. This is also the case of certain pointcuts, such as if
pointcuts in AspectJ, or simply all pointcuts in higher-order aspect
languages like AspectScheme.")
                  (p "While seeing pointcuts and advice as base level computation clearly
departs AOP from reflection, it also comes at a price: because aspects
observe base level computation, evaluating pointcuts and advice at the
base level can trigger infinite regression. To avoid these pitfalls,
aspect languages propose (sometimes insufficient) ad-hoc mechanisms,
which make aspect-oriented programming more complex.")
                  (p "This paper proposes to clarify the situation by introducing explicit
levels of execution in the programming language, thereby allowing
aspects to observe and run at specific, possibly different, levels. We
adopt a defensive default that avoids infinite regression, and give
programmers the means to override this default through explicit level
shifting expressions. We implement our proposal as an extension of
AspectScheme, and formalize its  semantics.")
                  (p "This work recognizes that different aspects differ in their intended
nature, and shows that structuring execution contexts helps in taming
the power of aspects and metaprogramming."))
             
             (div (@ (id "d1-tdanvy"))
                  (h3 "Peter J Landin (1930-2009)")
                  (h4 "Olivier Danvy"))
             )
        
        (div (@ (class "centerdiv"))
             (p "built using "(a (@ (href "http://www.plt-scheme.org")) "PLT Scheme") " and " 
                (a (@ (href "http://www.html.it/articoli/niftycube/index.html")) "NiftyCube")
                " and "(a (@ (href "http://continue.cs.brown.edu/"))"Continue")". Thanks!")
             (p "want to see the "(a (@ (href "../pre-program.ss")) "source code")"?")) 
        
        
        ))
