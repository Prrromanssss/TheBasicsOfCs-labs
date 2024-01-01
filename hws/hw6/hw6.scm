(load "../../labs/lab6/stream.scm")
(load "../../labs/lab3/lab3.scm")

(define call/cc call-with-current-continuation)

;; Number 1


;; <Expression> ::= <Spaces> <Object> <Spaces> <Expression> | <Empty>
;; <Spaces> ::= SPACE-SYMBOL <spaces> | <Empty>
;; <Object> ::= + | - | * | / | ^ | ( | ) | <Variable> <Digit>
;; <Variable> ::= LETTER-SYMBOL <Variable-tail>
;; <Variable-tail> ::= LETTER-SYMBOL <Variable-tail> | <Empty>
;; <Digit> ::= DIGIT-SYMBOL <Digit-tail>
;; <Digit-tail> ::= DIGIT-SYMBOL <Digit-tail> | e <Digit-tail> | . <Digit-tail> | <Empty>
;; <Empty> ::=



(define (tokenize input)
  (let ((built-in-symbols '((#\- -)
                            (#\+ +)
                            (#\* *)
                            (#\/ /)
                            (#\^ ^)
                            (#\( "(")
                            (#\) ")"))))

    (define (my-element? x xs)
      (cond
        ((null? xs) #f)
        ((equal? x (car xs)) #t)
        (else (my-element? x (cdr xs)))))

    
    ;; <Expression> ::= <Spaces> <Object> <Spaces> <Expression> | <Empty>
    (define (parse-expression stream error)
      (cond ((start-expression? (peek stream))
             (parse-spaces stream error)
             (let ((term-object (parse-object stream error))
                   (term-spaces (parse-spaces stream error))
                   (term-expression (parse-expression stream error)))
               (cons term-object term-expression)))
            (else '())))

    (define (start-expression? symbol)
      (or
       (start-spaces? symbol)
       (start-built-in-symbol? symbol)
       (start-variable? symbol)
       (start-digit? symbol)))


    ;; <Spaces> ::= SPACE-SYMBOL <spaces> | <Empty>
    (define (parse-spaces stream error)
      (cond ((start-spaces? (peek stream))
             (next stream)
             (parse-spaces stream error))
            (else '())))

    (define (start-spaces? symbol)
      (and (char? symbol) (char-whitespace? symbol)))


    ;; <Object> ::= + | - | * | / | ^ | ( | ) | <Variable> <Digit>
    (define (parse-object stream error)
      (cond ((start-built-in-symbol? (peek stream))
             (cadr (assoc (next stream) built-in-symbols)))
            ((start-variable? (peek stream))
             (parse-variable stream error))
            ((start-digit? (peek stream))
             (parse-digit stream error))
            (else (error #f))))

    (define (start-built-in-symbol? symbol)
      (and (char? symbol) (assoc symbol built-in-symbols)))

    
    ;; <Variable> ::= LETTER-SYMBOL <Variable-tail>
    (define (parse-variable stream error)
      (cond ((start-variable? (peek stream))
             (let ((term-letter (next stream))
                   (term-variable-tail (parse-variable-tail stream error)))
               (string->symbol (list->string
                                (cons term-letter term-variable-tail)))))
            (else (error #f))))

    (define (start-variable? symbol)
      (and (char? symbol) (char-alphabetic? symbol)))


    ;; <Variable-tail> ::= LETTER-SYMBOL <Variable-tail> | <Empty>
    (define (parse-variable-tail stream error)
      (cond ((start-variable? (peek stream))
             (let ((term-letter (next stream))
                   (term-variable-tail (parse-variable-tail stream error)))
               (cons term-letter term-variable-tail)))
            (else '())))


    ;; <Digit> ::= DIGIT-SYMBOL <Digit-tail>
    (define (parse-digit stream error)
      (cond ((start-digit? (peek stream))
             (let ((term-digit (next stream))
                   (term-digit-tail (parse-digit-tail stream error)))
               (string->number (list->string
                                (cons term-digit term-digit-tail)))))
            (else (error #f))))

    (define (start-digit? symbol)
      (and (char? symbol) (char-numeric? symbol)))

    
    ;; <Digit-tail> ::= DIGIT-SYMBOL <Digit-tail> | e <Digit-tail> | . <Digit-tail> | <Empty>
    (define (parse-digit-tail stream error)
      (cond ((start-digit-tail? (peek stream))
             (let ((term-digit (next stream))
                   (term-digit-tail (parse-digit-tail stream error)))
               (cons term-digit term-digit-tail)))
            (else '())))

    (define (start-digit-tail? symbol)
      (and (char? symbol) (or
                           (start-digit? symbol)
                           (char=? #\e symbol)
                           (char=? #\. symbol))))
 

    (define stream (make-stream (string->list input) 'EOF))
  
    (call/cc
     (lambda (error)
       (define tokens (parse-expression stream error))
       (if (equal? (peek stream) 'EOF) tokens #f)))))


(define tokenize-tests
  (list (test (tokenize "1")
              '(1))
        (test (tokenize "-a")
              '(- a))
        (test (tokenize "-a + b * x^2 + dy")
              '(- a + b * x ^ 2 + dy))
        (test (tokenize "(a - 1)/(b + 1)")
              '("(" a - 1 ")" / "(" b + 1 ")"))))

;; (run-tests tokenize-tests)


;; Number 2

;; Expr    ::= Term Expr' .
;; Expr'   ::= AddOp Term Expr' | .
;; Term    ::= Factor Term' .
;; Term'   ::= MulOp Factor Term' | .
;; Factor  ::= Power Factor' .
;; Factor' ::= PowOp Power Factor' | .
;; Power   ::= value | "(" Expr ")" | unaryMinus Power .

(define (parse tokens)
  ;; Expr    ::= Term Expr' .
  (define (parse-expr stream error)
    (let inner ((ans-term (parse-term stream error)))
      (cond ((start-expr1? (peek stream))
             (let ((add-op-term (next stream))
                   (term-term (parse-term stream error)))
               (inner (list ans-term add-op-term term-term))))
            (else ans-term))))

  (define (start-expr1? symbol)
    (or (equal? symbol '+) (equal? symbol '-)))

  ;; Term    ::= Factor Term' .
  (define (parse-term stream error)
    (let inner ((ans-term (parse-factor stream error)))
      (cond ((start-term1? (peek stream))
             (let ((mul-op-term (next stream))
                   (factor-term (parse-factor stream error)))
               (inner (list ans-term mul-op-term factor-term))))
            (else ans-term))))

  (define (start-term1? symbol)
    (or (equal? symbol '*) (equal? symbol '/)))

  ;; Factor  ::= Power Factor' .
  (define (parse-factor stream error)
    (let ((term-power (parse-power stream error))
          (term-factor1 (parse-factor1 stream error)))
      (cond ((not (null? term-factor1)) (cons term-power term-factor1))
            (else term-power))))

  ;; Factor' ::= PowOp Power Factor' | .
  (define (parse-factor1 stream error)
    (cond ((start-factor1? (peek stream))
           (let ((pow-op-term (next stream))
                 (term-power (parse-power stream error))
                 (term-factor1 (parse-factor1 stream error)))
             (cond ((not (null? term-factor1))
                    (list pow-op-term (cons term-power term-factor1)))
                   (else
                    (cons pow-op-term (list term-power))))))
          (else '())))

  (define (start-factor1? symbol)
    (equal? symbol '^))

  ;; Power   ::= value | "(" Expr ")" | unaryMinus Power .
  (define (parse-power stream error)
    (cond ((number? (peek stream))
           (next stream))
          ((equal? (peek stream) "(")
           (next stream)
           (let ((term-expr (parse-expr stream error)))
             (if (not (equal? (peek stream) ")"))
                 (error #f))
             (next stream)
             term-expr))
          ((equal? (peek stream) '-)
           (let ((unary-minus-term (next stream))
                 (power-term (parse-power stream error)))
             (list unary-minus-term power-term)))
          ((symbol? (peek stream))
           (next stream))
          (else (error #f))))

  (define stream (make-stream tokens 'EOF))
  
  (call/cc
   (lambda (error)
     (define tree (parse-expr stream error))
     (if (equal? (peek stream) 'EOF) tree #f))))               


(define parse-tests
  (list (test (parse (tokenize "a + b + c+d"))
              '(((a + b) + c) + d))
        (test (parse (tokenize "a/b/c/d"))
              '(((a / b) / c) / d))
        (test (parse (tokenize "a^b^c^d"))
              '(a ^ (b ^ (c ^ d))))
        (test (parse (tokenize "a/(b/c)"))
              '(a / (b / c)))
        (test (parse (tokenize "a + b/c^2 - d"))
              '((a + (b / (c ^ 2))) - d))
        (test (parse (tokenize "(-a)^1e10"))
              '((- a) ^ 1e10))))

;; (run-tests parse-tests)


(define (tree->scheme tree)
  (cond ((not (list? tree))
         tree)
        ((equal? (car tree) '-)
         (list '- (tree->scheme (cadr tree))))
        ((equal? '^ (cadr tree))
         (list 'expt
               (tree->scheme (car tree))
               (tree->scheme (caddr tree))))
        (else (list (cadr tree)
                    (tree->scheme (car tree))
                    (tree->scheme (caddr tree))))))


(define tree->scheme-tests
  (list (test (tree->scheme (parse (tokenize "x^(a + 1)")))
              '(expt x (+ a 1)))
        (test (eval (tree->scheme (parse (tokenize "2^2^2^2")))
                    (interaction-environment))
              65536)))

;; (run-tests tree->scheme-tests)





  
  
