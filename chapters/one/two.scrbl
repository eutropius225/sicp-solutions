#lang scribble/manual
@(require racket/sandbox
          scribble/example
          scribble-math/dollar
          "../sicp-eval.rkt")

@title[#:style (with-html5 manual-doc-style)]{Procedures and the Processes They Generate}
@(use-katex)

@section{Exercise 1.9}

The first, recursive @tt{+}.
@racketblock[
 (+ 4 5)
 (inc (+ 3 5))
 (inc (inc (+ 2 5)))
 (inc (inc (inc (+ 1 5))))
 (inc (inc (inc (inc (+ 0 5)))))
 (inc (inc (inc (inc 5))))
 (inc (inc (inc 6)))
 (inc (inc 7))
 (inc 8)
 9]

The second, iterative @tt{+}.
@racketblock[
 (+ 4 5)
 (+ 3 6)
 (+ 2 7)
 (+ 1 8)
 (+ 0 9)
 9]

@section{Exercise 1.10}
@sicpnl[
 (define (A x y)
   (cond ((= y 0) 0)
         ((= x 0) (* 2 y))
         ((= y 1) 2)
         (else (A (- x 1)
                  (A x (- y 1))))))]

@sicp[#:label "Here we just evaluate the examples:"
      (A 1 10)
      (A 2 4)
      (A 3 3)]

These procedures:

@racketblock[
 (define (f n) (A 0 n))
 (define (g n) (A 1 n))
 (define (h n) (A 2 n))]

Can be written as such:
@$${f(n) = 2n}
@$${g(n) = 2^n}
@$${h(n) = 2 \uparrow\uparrow n}

Where @${\uparrow\uparrow} denotes @(hyperlink "https://en.wikipedia.org/wiki/Tetration" "tetration").

Or, using @${[n]} for general @(hyperlink "https://en.wikipedia.org/wiki/Hyperoperation" "hyperoperation"):
@$${f(n) = 2[2]n}
@$${g(n) = 2[3]n}
@$${h(n) = 2[4]n}

For positive integer values of @tt{n}.

@section{Exercise 1.11}

@tt{f} recursively:
@sicpnl[
 (define (f n)
   (if (< n 3)
       n
       (+ (f (- n 1))
          (* 2 (f (- n 2)))
          (* 3 (f (- n 3))))))]

@sicp[
 (f 1)
 (f 2)
 (f 3)
 (f 5)
 (f 7)
 (f 10)]

@tt{f} iteratively:
@sicpnl[
 (define (f n)
   (if (< n 3)
       n
       (f-iter 0 1 2 n)))
          
 (define (f-iter a b c count)
   (if (< count 3)
       c
       (f-iter b
               c
               (+ c
                  (* 2 b)
                  (* 3 a))
               (dec count))))]

@sicp[
 (f 1)
 (f 2)
 (f 3)
 (f 5)
 (f 7)
 (f 10)]

@section{Exercise 1.12}
@sicpnl[
 (define (pascal row index)
   (if (or (= index 0)
           (>= index row))
       1
       (+ (pascal (dec row)
                  (dec index))
          (pascal (dec row)
                  index))))]

@sicp[
 (display (list (pascal 0 0)))
 (display (list (pascal 1 0) (pascal 1 1)))
 (display (list (pascal 2 0) (pascal 2 1) (pascal 2 2)))
 (display (list (pascal 3 0) (pascal 3 1) (pascal 3 2) (pascal 3 3)))
 (display (list (pascal 4 0) (pascal 4 1) (pascal 4 2) (pascal 4 3) (pascal 4 4)))]

@section{Exercise 1.13}
@${Fib(n)} is defined as:
@$${Fib(0) = 0}
@$${Fib(1) = 1}
@$${Fib(n) = Fib(n-1) + Fib(n-2)}

Let
@${\phi={1+\sqrt{5}\over2}}
and
@${\psi={1-\sqrt{5}\over2}}.

Let's assume:
@$${Fib(n) = {\phi^n - \psi^n \over \sqrt{5}}}
Which holds true for @${n = 0} and @${n = 1}:
@$${Fib(0) = {\phi^0 - \psi^0 \over \sqrt{5}} = 0}
@$${Fib(1) = {\phi^1 - \psi^1 \over \sqrt{5}} = 1}

Using the other definition of @${Fib(n)}:
@$${Fib(n) = {{\phi^{n-1} - \psi^{n-1} \over \sqrt{5}} + {\phi^{n-2} - \psi^{n-2} \over \sqrt{5}}}}

Since @${\psi} and @${\phi} both satisfy the equation
@${x^2 = x + 1},
they also both satisfy the equation
@${x^n = x^{n-1} x^{n-2}}.

Thus,
@$${Fib(n) = {{(\phi^{n-1} + \phi^{n-2}) - (\psi^{n-1} + \psi^{n-2}) \over \sqrt{5}}}}
can be simplified to
@$${Fib(n) = {\phi^n - \psi^n \over \sqrt{5}}}

Thus, by induction, it holds true for all positive integers @${n}.

It can be rearranged as such:
@$${{\phi^n \over \sqrt{5}} - Fib(n) = {\psi^n \over \sqrt{5}}}

Since @${-1 < \psi < 1}, for all positive @${n}:
@$${|\psi^n| < |\psi|}
@$${|{\psi^n \over \sqrt{5}}| < 0.5}
@$${|{\phi^n \over \sqrt{5}} - Fib(n)| < 0.5}
And thus @${Fib(n)} is the closest integer to @${\phi^n \over \sqrt{5}}.

@section{Exercise 1.14}
@image["chapters/one/asymptote-images/fb44e5436c9fd8cd1af1bb2b4b8337da"
       #:scale 0.35
       #:suffixes (list ".svg"
                        ".png"
                        ".pdf")]

@section{Exercise 1.15}

@subsection{Exercise 1.15.a}
@tt{p} is applied five times:
@sicpnl[
 (define (cube x) (* x x x))
 (define (p x)
   (begin (display "p called\n")
          (- (* 3 x) (* 4 (cube x)))))
 (define (sine angle)
   (if (not (> (abs angle) 0.1))
       angle
       (p (sine (/ angle 3.0)))))
 (sine 12.5)]

@subsection{Exercise 1.15.b}
The order of growth, for both space and number of steps, is:
@$${log(a)}

@section{Exercise 1.16}
@sicp[#:label "Defining abstract hyperoperation:"
      (define (hyperop base exponent op identity)
        (define (hyperop-iter state base exponent)
          (cond ((= exponent 0) state)
                ((even? exponent) (hyperop-iter state
                                                (op base base)
                                                (/ exponent 2)))
                (else (hyperop-iter (op state base)
                                    base
                                    (dec exponent)))))
        (define (even? n)
          (= (remainder n 2) 0))
            
        (hyperop-iter identity base exponent))]

@sicp[#:label "Exponentiation:"
      (define (fast-exp a b) (hyperop a b * 1))
          
      (fast-exp 10 10)
      (fast-exp 3 3)
      (fast-exp 2 16)]

@section{Exercise 1.17}
@sicp[#:label "Multiplication:"
      (define (fast-mult a b) (hyperop a b + 0))
          
      (fast-mult 10 10)
      (fast-mult 3 3)
      (fast-mult 2 16)]

@section{Exercise 1.18}
what

@section{Exercise 1.19}
@sicp[#:label "Fibbonaci"
      (define (fib n)
        (fib-iter 1 0 0 1 n))
      (define (fib-iter a b p q count)
        (cond ((= count 0) b)
              ((even? count)
               (fib-iter a
                         b
                         (+ (square p) (square q))
                         (+ (* (+ p q) q)
                            (* q p))
                         (/ count 2)))
              (else (fib-iter (+ (* b q) (* a q) (* a p))
                              (+ (* b p) (* a q))
                              p
                              q
                              (- count 1)))))]

@sicp[
 (fib 3)
 (fib 15)
 (fib 63)]

@section{Exercise 1.20}
@racketblock[
 (gcd 206 40)
 (gcd 40 (remainder 206 40))
 (gcd 40 6)
 (gcd 6 (remainder 40 6))
 (gcd 6 4)
 (gcd 4 (remainder 6 4))
 (gcd 4 2)
 (gcd 2 (remainder 4 2))
 (gcd 2 0)
 2]

@section{Exercise 1.21}
@sicp[#:label "Just define it as in the book..."
      (define (smallest-divisor n)
        (define (find-divisor n test-divisor)
          (cond ((> (square test-divisor) n) n)
                ((divides? test-divisor n) test-divisor)
                (else (find-divisor n (+ test-divisor 1)))))
        (define (divides? a b)
          (= (remainder b a) 0))
        (find-divisor n 2))]

@sicp[#:label "And evaluate:"
      (smallest-divisor 199)
      (smallest-divisor 1999)
      (smallest-divisor 19999)]

@section{Exercise 1.22}
@sicp[#:label "Boilerplate from the book..."
      (define (timed-prime-test n)
        (define result (start-prime-test n (runtime)))
        (if result
            (begin (newline)
                   (display n)
                   (display result))
            #f))
      (define (start-prime-test n start-time)
        (if (prime? n)
            (report-prime (- (runtime) start-time))
            #f))
      (define (report-prime elapsed-time)
        (string-append " *** " (number->string elapsed-time)))
      (define (prime? n)
        (= n (smallest-divisor n)))]

@sicpnl[
 (define (search-for-primes start)
   (define (iter i count)
     (if (< count 3)
         (iter (+ i 2)
               (if (timed-prime-test i)
                   (inc count)
                   count))))
   (iter start 0))]

@sicp[
 (search-for-primes 100001)
 (search-for-primes 1000001)
 (search-for-primes 10000001)
 (search-for-primes 100000001)]

@section{Exercise 1.23}
@sicpnl[
 (define (smallest-divisor n)
   (define (find-divisor n test-divisor)
     (cond ((> (square test-divisor) n) n)
           ((divides? test-divisor n) test-divisor)
           (else (find-divisor n (next test-divisor)))))
   (define (divides? a b)
     (= (remainder b a) 0))
   (define (next x)
     (if (= x 2)
         3
         (+ x 2)))
   (find-divisor n 2))]

@sicp[
 (search-for-primes 100001)
 (search-for-primes 1000001)
 (search-for-primes 10000001)
 (search-for-primes 100000001)]

The expectation is not entirely correct, since the @tt{if} statement requires calculation as well.

@section{Exercise 1.24}
@sicp[#:label "From the book:"
      (define (expmod base exp m)
        (cond ((= exp 0) 1)
              ((even? exp)
               (remainder (square (expmod base (/ exp 2) m))
                          m))
              (else
               (remainder (* base (expmod base (- exp 1) m))
                          m))))
      (define (fermat-test n)
        (define (try-it a)
          (= (expmod a n n) a))
        (try-it (+ 1 (random (- n 1)))))
      (define (fast-prime? n times)
        (cond ((= times 0) true)
              ((fermat-test n) (fast-prime? n (- times 1)))
              (else false)))]

@sicpnl[
 (define (start-prime-test n start-time)
   (if (fast-prime? n 3)
       (let ((time (- (runtime) start-time)))
         (if (prime? n)
             (string-append (report-prime time)
                            " <- true positive")
             (begin (newline)
                    (display n)
                    (display (report-prime time))
                    (display " <- false positive")
                    #f)))
       #f))]

@sicp[
 (search-for-primes 100001)
 (search-for-primes 1000001)
 (search-for-primes 10000001)
 (search-for-primes 100000001)]

The times are expected to be much better, and scale much slower, than those in the previous exercises.

@section{Exercise 1.25}
Alyssa is incorrect. @tt{(exp a b)} requires @${a^b} to be calculated, which can get very large and be irrepresentable.
However, @tt{expmod} is not tail-recursive, and thus must retain all sub-computations in memory.

@section{Exercise 1.26}
The given @tt{expmod} procedure calls at most one more @tt{expmod} itself, passing it to @tt{square} having calculated it once,
while Louis' calculates it twice, multiplying them together, wasting time.

@section{Exercise 1.27}

@sicpnl[
 (define (all-congruent? number)
   (define (is-congruent? a n)
     (= (expmod a n n) a))
   (define (iter tested)
     (cond ((= 1 tested) #t)
           ((is-congruent? tested number) (iter (dec tested)))
           (else #f)))
   (iter (dec number)))]

@sicp[#:label "Some expected results:"
      (all-congruent? 100)
      (all-congruent? 113)
      (all-congruent? 560)]

@sicp[#:label "Some Carmichael numbers:"
      (all-congruent? 561)
      (all-congruent? 1105)
      (all-congruent? 1729)]

@section{Exercise 1.28}

@sicpnl[
 (define (miller-rabin n times)
   (define n-1 (dec n))
   (define (do-test a)
     (= 1 (expmod a n-1 n)))
   (define (expmod base exp m)
     (define (mulmod x y)
       (define rem (remainder (* x y) m))
       (if (and (= x y)
                (= rem 1)
                (not (= x 1))
                (not (= x (dec m))))
           0
           rem))
     (hyperop base exp mulmod 1))
   (define (loop i)
     (cond ((= i 0) #t)
           ((do-test (inc (random (dec n)))) (loop (dec i)))
           (else #f)))
   (loop times))]

@sicp[
 (miller-rabin 1105 10)
 (miller-rabin 5 10)
 (miller-rabin 23 10)
 (miller-rabin 113 10)]

@section{Exercise 1.29}

Firstly, define @tt{sum} and @tt{integral} as in the book:
@sicpnl[
 (define (sum term a next b)
   (if (> a b)
       0
       (+ (term a)
          (sum term (next a) next b))))

 (define (integral f a b dx)
   (define (add-dx x) (+ x dx))
   (* (sum f (+ a (/ dx 2.0)) add-dx b)
      dx))]

Then, define the @tt{simpson} procedure:
@sicpnl[
 (define (simpson f a b n)
   (define h (/ (- b a)
                n))
   (define (y k)
     (f (+ a
           (* k h))))
   (* (/ h 3)
      (+ (y 0)
         (sum (lambda (i)
                (* (if (even? i)
                       2
                       (/ 1 2))
                   (y i)))
              1
              inc
              (dec n))
         (y n))))]

@sicp[
 (integral cube 0 1 0.01)
 (simpson cube 0 1 100)
 (integral cube 0 1 0.001)
 (simpson cube 0 1 1000)]
