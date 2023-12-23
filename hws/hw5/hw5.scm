(load "../../labs/lab3/lab3.scm")

(define feature-if-else #t)
(define feature-while-loop #t)
(define feature-break-continue #t)


(define (interpret program stack)
  (let ((env '())
        (oper_with_stack '(+ - * /
                             mod neg drop swap
                             dup over rot and
                             = > < not or depth))
        (end (vector-length program))
        (func-ignore #f)
        (if-ignore #f)
        (while-ignore #f))
    
    (let inner ((loc_stack stack)
                (ind 0)
                (return '()))
      (if (equal? ind end)
          loc_stack
          (let* ((current_symb (vector-ref program ind))
                 (new_stack (if (and
                                 (equal? func-ignore #f)
                                 (equal? if-ignore #f)
                                 (equal? while-ignore #f))
                                (case current_symb
                                  ('+ (+$ loc_stack))
                                  ('- (-$ loc_stack))
                                  ('* (*$ loc_stack))
                                  ('/ (/$ loc_stack))
                                  ('mod (mod$ loc_stack))
                                  ('neg (neg$ loc_stack))
                                  ('drop (drop$ loc_stack))
                                  ('swap (swap$ loc_stack))
                                  ('dup (dup$ loc_stack))
                                  ('over (over$ loc_stack))
                                  ('rot (rot$ loc_stack))
                                  ('depth (depth$ loc_stack))
                                  ('and (and$ loc_stack))
                                  ('or (or$ loc_stack))
                                  ('not (not$ loc_stack))
                                  ('= (=$ loc_stack))
                                  ('> (>$ loc_stack))
                                  ('< (<$ loc_stack))
                                  (else loc_stack)) loc_stack)))
            (cond
              ;; end of definition of the article
              ((and (null? return) (equal? current_symb 'end))
               (set! func-ignore #f)
               (inner new_stack (+ ind 1) return))
              
              ;; end of execution of the article and return up the call stack
              ((and (not (null? return)) (equal? current_symb 'end))
               (set! func-ignore #f)
               (inner new_stack (car return) (cdr return)))
              
              ;; definition of the article so ignoring the program
              ((equal? func-ignore #t)
               (inner new_stack (+ ind 1) return))

              ;; first while-statement is false or break operator has worked
              ((and
                (equal? current_symb 'wend)
                (equal? while-ignore #t))
               (set! while-ignore #f)
               (inner new_stack (+ ind 1) return))
              
              ;; if true while statement repeat loop
              ((and
                (equal? current_symb 'wend)
                (equal? if-ignore #f))
               (if (not (equal? (car loc_stack) 0))
                   (inner (cdr new_stack) (car return) return)
                   (inner (cdr new_stack) (+ ind 1) (cdr return))))

              ;; while-statement is false so ignoring the program
              ((equal? while-ignore #t)
               (inner new_stack (+ ind 1) return))
              
              ;; end of if-statement
              ((equal? current_symb 'endif)
               (set! if-ignore #f)
               (inner new_stack (+ ind 1) return))

              ;; executing else-statement
              ((and (equal? current_symb 'else) (equal? if-ignore #t))
               (set! if-ignore #f)
               (inner new_stack (+ ind 1) return))

              ;; ignoring else-statement 'cause if-statement has already worked
              ((and (equal? current_symb 'else) (equal? if-ignore #f))
               (set! if-ignore #t)
               (inner new_stack (+ ind 1) return))
              
              ;; if-statement is false so ignoring the program
              ((equal? if-ignore #t)
               (inner new_stack (+ ind 1) return))
              
              ;; exit is outside the articles so we are completing the program
              ((and (null? return) (equal? current_symb 'exit))
               (inner new_stack end return))
              
              ;; exit is in the articles so we are moving up the call stack
              ((and (not (null? return)) (equal? current_symb 'exit))
               (inner new_stack (car return) (cdr return)))
              
              ;; symbol is a number so it is added to stack
              ((number? current_symb)
               (inner (cons current_symb loc_stack) (+ ind 1) return))
              
              ;; check if term is an operation with stack
              ((my-element? current_symb oper_with_stack)
               (inner new_stack (+ ind 1) return))
              
              ;; definition of the article 
              ((equal? current_symb 'define)
               (set! func-ignore #t)
               (set! env
                     (append env
                             (cons
                              (cons (vector-ref program (+ ind 1))
                                    (cons (+ ind 2) '())) '())))
               (inner new_stack (+ ind 1) return))
              
              ;; executing previously defined  article
              ((assoc current_symb env)
               (inner new_stack (cadr (assoc current_symb env))
                      (cons (+ ind 1) return)))
              
              ;; if-statement
              ((equal? current_symb 'if)
               (if (not (equal? (car loc_stack) 0))
                   (inner (cdr new_stack) (+ ind 1) return)
                   (begin
                     (set! if-ignore #t)
                     (inner (cdr new_stack) (+ ind 1) return))))

              ;; while ... wend
              ((equal? current_symb 'while)
               (if (not (equal? (car loc_stack) 0))
                   (inner (cdr new_stack) (+ ind 1) (cons (+ ind 1) return))
                   (begin
                     (set! while-ignore #t)
                     (inner (cdr new_stack) (+ ind 1) return))))

              ;; break operator
              ((equal? current_symb 'break)

               (set! while-ignore #t)
               (inner new_stack (+ ind 1) return))

              ;; continue operator
              ((equal? current_symb 'continue)
               (if (not (equal? (car loc_stack) 0))
                   (inner (cdr new_stack) (car return) return)
                   (begin
                     (set! while-ignore #t)
                     (inner (cdr new_stack) (+ ind 1) return))))))))))


;; Arithmetic operations

(define (+$ stack)
  (cons (+ (cadr stack) (car stack)) (cddr stack)))

(define (-$ stack)
  (cons (- (cadr stack) (car stack)) (cddr stack)))

(define (*$ stack)
  (cons (* (cadr stack) (car stack)) (cddr stack)))

(define (/$ stack)
  (if (< (cadr stack) (car stack))
      (cons 0 (cddr stack))
      (cons (/ (cadr stack) (car stack)) (cddr stack))))

(define (mod$ stack)
  (cons (remainder (cadr stack) (car stack)) (cddr stack)))

(define (neg$ stack)
  (cons (- (car stack)) (cdr stack)))


;; Comparison Operations

(define (=$ stack)
  (if (= (cadr stack) (car stack))
      (cons -1 (cddr stack))
      (cons 0 (cddr stack))))

(define (>$ stack)
  (if (> (cadr stack) (car stack))
      (cons -1 (cddr stack))
      (cons 0 (cddr stack))))

(define (<$ stack)
  (if (< (cadr stack) (car stack))
      (cons -1 (cddr stack))
      (cons 0 (cddr stack))))


;; Logical operations

(define (not$ stack)
  (if (= (car stack) 0)
      (cons -1 (cdr stack))
      (cons 0 (cdr stack))))

(define (and$ stack)
  (if (and (not (= (car stack) 0)) (not (= (cadr stack) 0)))
      (cons -1 (cddr stack))
      (cons 0 (cddr stack))))

(define (or$ stack)
  (if (or (not (= (car stack) 0)) (not (= (cadr stack) 0)))
      (cons -1 (cddr stack))
      (cons 0 (cddr stack))))


;; Stack Operations

(define (drop$ stack)
  (cdr stack))

(define (swap$ stack)
  (cons (cadr stack)
        (cons (car stack)
              (cddr stack))))

(define (dup$ stack)
  (cons (car stack) stack))

(define (over$ stack)
  (cons (cadr stack) stack))

(define (rot$ stack)
  (cons (caddr stack)
        (cons (cadr stack)
              (cons (car stack)
                    (cdddr stack)))))

(define (depth$ stack)
  (cons (length stack) stack))

  
(define (my-element? x xs)
  (cond
    ((null? xs) #f)
    ((equal? x (car xs)) #t)
    (else (my-element? x (cdr xs)))))


;; Testing
(define tests
  (list
   (test (interpret #() '()) '())
        (test (interpret #(1 2 3) '(7 8 9)) '(3 2 1 7 8 9))
        (test (interpret #(+) '(5 7)) '(12))
        (test (interpret #(-) '(4 14)) '(10))
        (test (interpret #(*) '(21 2)) '(42))
        (test (interpret #(/) '(7 42)) '(6))
        (test (interpret #(mod) '(7 40)) '(5))
        (test (interpret #(neg) '(77)) '(-77))
        (test (interpret #(=) '(13 32)) '(0))
        (test (interpret #(=) '(11 11)) '(-1))
        (test (interpret #(>) '(13 32)) '(-1))
        (test (interpret #(>) '(11 11)) '(0))
        (test (interpret #(>) '(32 13)) '(0))
        (test (interpret #(<) '(13 32)) '(0))
        (test (interpret #(<) '(11 11)) '(0))
        (test (interpret #(<) '(32 13)) '(-1))
        (test (interpret #(not) '(0)) '(-1))
        (test (interpret #(not) '(-1)) '(0))
        (test (interpret #(not) '(77)) '(0))
        (test (interpret #(and) '(-1 -1)) '(-1))
        (test (interpret #(and) '(12 34)) '(-1))
        (test (interpret #(and) '(12 0)) '(0))
        (test (interpret #(and) '(0 34)) '(0))
        (test (interpret #(and) '(0 0)) '(0))
        (test (interpret #(or) '(-1 -1)) '(-1))
        (test (interpret #(or) '(12 34)) '(-1))
        (test (interpret #(or) '(12 0)) '(-1))
        (test (interpret #(or) '(0 34)) '(-1))
        (test (interpret #(or) '(0 0)) '(0))
        (test (interpret #(drop) '(2 3 5 7 11)) '(3 5 7 11))
        (test (interpret #(swap) '(2 3 5 7 11)) '(3 2 5 7 11))
        (test (interpret #(dup) '(2 3 5 7 11)) '(2 2 3 5 7 11))
        (test (interpret #(over) '(2 3 5 7 11)) '(3 2 3 5 7 11))
        (test (interpret #(rot) '(2 3 5 7 11)) '(5 3 2 7 11))
        (test (interpret #(depth) '(2 3 5 7 11)) '(5 2 3 5 7 11))
        (test (interpret #(depth) '()) '(0))
        (test (interpret #(define square dup * end square) '(11)) '(121))
        (test (interpret #(define x 1 2 exit 3 4 end x) '()) '(2 1))
        (test (interpret #(if 1 2 3 endif 4 5 6) '(0)) '(6 5 4))
        (test (interpret #(if 1 2 3 endif 4 5 6) '(-1)) '(6 5 4 3 2 1))
        (test (interpret #(if 1 2 3 endif 4 5 6) '(77)) '(6 5 4 3 2 1))
        (test (interpret #(1) '()) '(1))
        (test (interpret #(1 2) '(10)) '(2 1 10))
        (test (interpret #(1 2 +) '(10)) '(3 10))
        (test (interpret #(1 2 -) '(10)) '(-1 10))
        (test (interpret #(1 2 *) '(10)) '(2 10))
        (test (interpret #(1 2 /) '(10)) '(0 10))
        (test (interpret #(1 2 mod) '(10)) '(1 10))
        (test (interpret #(1 2 neg) '(10)) '(-2 1 10))
        (test (interpret #(2 3 * 4 5 * +) '()) '(26))
        (test (interpret #(10 10 =) '()) '(-1))
        (test (interpret #(10 0 >) '()) '(-1))
        (test (interpret #(0 10 <) '()) '(-1))
        (test (interpret #(10 5 =) '()) '(0))
        (test (interpret #(0 10 >) '()) '(0))
        (test (interpret #(10 0 <) '()) '(0))
        (test (interpret #(0 0 and) '()) '(0))
        (test (interpret #(1000 7 -) '()) '(993))
        (test (interpret #(100 100 and) '()) '(-1))
        (test (interpret #(100 0 or) '()) '(-1))
        (test (interpret #(100 not) '()) '(0))
        (test (interpret #(0 not) '()) '(-1))
        (test (interpret #(define -- 1 - exit end) '()) '())
        (test (interpret #(define -- 1 - end
                            5 -- --)
                         '())
              '(3))
        (test (interpret #(10 15 +
                              define -- 1 - end
                              exit
                              5 -- --)
                         '())
              '(25))
        (test (interpret #(10 15 +
                              define -- exit 1 - end
                              5 -- --)
                         '())
              '(5 25))
        (test (interpret #(10 4 dup) '()) '(4 4 10))
        (test (interpret #(define abs
                            dup 0 <
                            if neg endif
                            end
                            9 abs
                            -9 abs
                            10 abs
                            -10 abs)
                         '())
              '(10 10 9 9))
        (test (interpret #(define =0? dup 0 = end
                            define <0? dup 0 < end
                            define signum
                            =0? if exit endif
                            <0? if drop -1 exit endif
                            drop
                            1
                            end
                            0 signum
                            -5 signum
                            10 signum)
                         '())
              '(1 -1 0))
        (test (interpret #(define -- 1 - end
                            define =0? dup 0 = end
                            define =1? dup 1 = end
                            define factorial
                            =0? if drop 1 exit endif
                            =1? if drop 1 exit endif
                            dup --
                            factorial
                            *
                            end
                            0 factorial
                            1 factorial
                            2 factorial
                            3 factorial
                            4 factorial)
                         '())
              '(24 6 2 1 1))
        (test (interpret #(define =0? dup 0 = end
                            define =1? dup 1 = end
                            define -- 1 - end
                            define fib
                            =0? if drop 0 exit endif
                            =1? if drop 1 exit endif
                            -- dup
                            -- fib
                            swap fib
                            +
                            end
                            define make-fib
                            dup 0 < if drop exit endif
                            dup fib
                            swap --
                            make-fib
                            end
                            10 make-fib)
                         '())
              '(0 1 1 2 3 5 8 13 21 34 55))
        (test (interpret #(define =0? dup 0 = end
                            define gcd
                            =0? if drop exit endif
                            swap over mod
                            gcd
                            end
                            90 99 gcd
                            234 8100 gcd)
                         '())
              '(18 9))
        (test (interpret #(define =0? dup 0 = end =0?) '(0)) '(-1 0))
        (test (interpret #(define =0? dup 0 = end
                            define kek 0 =0? end
                            kek)
                         '())
              '(-1 0))
        (test (interpret #(1 if 100 else 200 endif) '())
              '(100))
        (test (interpret #(0 if 100 else 200 endif) '())
              '(200))
        (test (interpret #(while wend) '(3 7 4 0 5 9))
              '(5 9))
        (test (interpret #(define sum
                            dup
                            while + swap dup wend
                            drop
                            end
                            1 2 3 0 4 5 6 sum)
                         '())
              '(15 3 2 1))
        (test (interpret #(define power2
                            1 swap dup
                            while
                            swap 2 * swap 1 - dup
                            wend
                            drop
                            end
                            5 power2 3 power2 power2) '())
              '(256 32))
        (test (interpret #(0 while 9 if 100 else 200 endif wend) '())
              '())
        (test (interpret #(1 while 1 if 100 endif 0 wend) '())
              '(100))
        (test (interpret #(1 while 0 if 100 else 200 endif 0 wend) '())
              '(200))
        (test (interpret #(1 if
                             5 1 swap dup
                             while
                             swap 2 * swap 1 - dup
                             wend
                             drop
                             else 200
                             endif) '())
              '(32))
        (test (interpret #(0 if
                             200
                             else
                             5 1 swap dup
                             while
                             swap 2 * swap 1 - dup
                             wend
                             drop
                             endif) '())
              '(32))
        (test (interpret #(0 swap dup
                             while
                             dup 3 =
                             if break endif
                             swap 1000 * over + swap 2 - dup 0 >
                             wend
                             drop) '(15))
              '(15013011009007005))
        (test (interpret #(0 swap dup
                             while
                             dup 3 = if break endif
                             swap 1000 * over +
                             swap 2 -
                             dup
                             wend
                             drop)
                         '(14))
              '(14012010008006004002))
        (test (interpret #(0 swap dup
                             while
                             dup 2 mod if 1 - dup continue endif
                             swap 1000 * over +
                             swap 1 -
                             dup
                             wend
                             drop)
                         '(15))
              '(14012010008006004002))
        (test (interpret #(0 swap dup
                             while
                             dup 2 mod if 1 - dup continue endif
                             swap 1000 * over +
                             swap 1 -
                             dup
                             wend
                             drop)
                         '(14))
              '(14012010008006004002))))

;; (run-tests tests)
