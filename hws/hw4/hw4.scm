;; Number 1
(define memoized-factorial
  (let ((cash '()))
    (lambda (n)
      (let* ((args (list n))
             (res (assoc args cash)))
        (if res
            (cadr res)
            (let ((res
                   (cond
                     ((<= n 1) 1)
                     (else (* n (memoized-factorial (- n 1)))))))
              (set! cash (cons (list args res) cash))
              res))))))

;; Number 2

;; 2.1
(define-syntax lazy-cons
  (syntax-rules ()
    ((lazy-cons a b) (delay (cons a b)))))

;; 2.2
(define (lazy-car p)
  (car (force p)))

;; 2.3
(define (lazy-cdr p)
  (cdr (force p)))

;; 2.4
(define (lazy-head xs k)
  (let loop ((xs xs)
             (new_xs '())
             (i k))
    (cond ((= i 0) new_xs)
          (else (loop (lazy-cdr xs) (append new_xs (cons (lazy-car xs) '())) (- i 1))))))

;; 2.4
(define (lazy-ref xs k)
  (let loop ((xs xs)
             (i k))
    (cond ((= i 0) (lazy-car xs))
          (else (loop (lazy-cdr xs) (- i 1))))))

(define (naturals start)
  (lazy-cons start (naturals (+ start 1))))

(define (lazy-factorial n)
  (define (inner start val)
    (lazy-cons val (inner (+ start 1) (* val (+ start 1)))))
  (lazy-ref (inner 0 1) n))


;; Number 3
(define (read-words)
  (define (concat str1 str2)
    (list->string
     (append (string->list str1) (string->list str2))))

  (let loop ((res '())
             (current-string "")
             (data (read-char)))
    (cond ((eof-object? data) res)
          ((and
            (char? data)
            (char-whitespace? data)
            (not (equal? current-string "")))
           (loop (append res (cons current-string '()))
                 ""
                 (read-char)))
          ((and
            (char? data)
            (char-whitespace? data)
            (equal? current-string ""))
           (loop res
                 current-string
                 (read-char)))
          ((and
            (char? data)
            (not (char-whitespace? data)))
           (loop res (concat current-string (make-string 1 data)) (read-char))))))


;; Number 4
(define-syntax define-struct
  (syntax-rules ()
    ((_ name fields)
     (let ((struct_name (symbol->string 'name)))
       (begin
         (eval `(begin
                  (define (,(string->symbol (string-append
                                             "make-"
                                             struct_name))
                           . args)
                    (list->vector (cons ',(string->symbol (string-append
                                                           "struct_"
                                                           struct_name))
                                        args)))
                
                  (define (,(string->symbol (string-append struct_name "?"))
                           obj)
                    (and
                     (vector? obj)
                     (> (vector-length obj) 0)
                     (equal?
                      (vector-ref obj 0)
                      ',(string->symbol (string-append
                                         "struct_"
                                         struct_name))))))
               (interaction-environment))

         (let make-fields-procedures ((struct_fields (map symbol->string 'fields))
                                      (i 1))
           (if (not (null? struct_fields))
               (begin 
                 (eval `(begin
                          (define (,(string->symbol (string-append
                                                     struct_name
                                                     "-"
                                                     (car struct_fields)))
                                   struct)
                            (vector-ref struct ,i))
                        
                          (define (,(string->symbol (string-append
                                                     "set-"
                                                     struct_name
                                                     "-"
                                                     (car struct_fields)
                                                     "!"))
                                   struct value)
                            (vector-set! struct ,i value)))
                       (interaction-environment))
                 (make-fields-procedures (cdr struct_fields) (+ i 1))))))))))


;; Number 5
(define-syntax define-data
  (syntax-rules ()
    ((_ name func-constructors)
     (let ((data-name (symbol->string 'name)))
       (begin 
         (eval `(define (,(string->symbol (string-append
                                           data-name
                                           "?"))
                         obj)
                  (and
                   (list? obj)
                   (> (length obj) 0)
                   (equal? 'data (car obj))
                   (equal? 'name (cadr obj))))
               (interaction-environment))
         (let make-cons ((funcs 'func-constructors))
           (if (not (null? funcs))
               (begin
                 (eval `(define (,(caar funcs) . args)
                          (append (list 'data (string->symbol ,data-name) ',(caar funcs)) args))
                       (interaction-environment))
                 (make-cons (cdr funcs))))))))))


(define-syntax match
  (syntax-rules ()
    ((match value ((name args ...) expr))
     (apply (lambda (args ...)
              expr)
            (cdddr value)))
    ((match value ((name args ...) expr) patterns ...)
     (if (equal? 'name (caddr value))
         (apply (lambda (args ...)
                  expr)
                (cdddr value))
         (match value patterns ...)))))




;; Определяем тип
(define-data figure ((square a)
                     (rectangle a b)
                     (triangle a b c)
                     (circle r)))

;; Определяем значения типа
(define s (square 10))
(define r (rectangle 10 20))
(define t (triangle 10 20 30))
(define c (circle 10))

(display (and (figure? s)
              (figure? r)
              (figure? t)
              (figure? c)))
(newline)

(define pi (acos -1)) ;; Для окружности

(define (perim f)
  (match f
    ((square a)       (* 4 a))
    ((rectangle a b)  (* 2 (+ a b)))
    ((triangle a b c) (+ a b c))
    ((circle r)       (* 2 pi r))))

(display (perim s))
(newline)
(display (perim r))
(newline)
(display (perim t))
(newline)
(display (perim c))
(newline)