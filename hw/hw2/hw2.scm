;; Number 1

;; 1
(define (my-range a b d)
  (if (>= a b)
      '()
      (cons a (my-range (+ a d) b d))))
;; (my-range  0 11 3)

;; 2
(define (my-flatten xs)
  (cond
    ((null? xs) '())
    ((list? xs) (append (my-flatten (car xs)) (my-flatten (cdr xs))))
    (else (list xs)) ))
;; (my-flatten '((1) 2 (3 (4 5)) 6))

;; 3
(define (my-element? x xs)
  (cond
    ((null? xs) #f)
    ((equal? x (car xs)) #t)
    (else (my-element? x (cdr xs)))))
;; (my-element? 1 '(3 2 1))
;; (my-element? 4 '(3 2 1))

;; 4
(define (my-filter pred? xs)
  (let loop ((new_xs '())
             (xs xs))
    (cond
      ((null? xs) new_xs)
      ((not (pred? (car xs))) (loop new_xs (cdr xs)))
      (else (loop (append new_xs (cons (car xs) '())) (cdr xs))))))
;; (my-filter odd? (my-range 0 10 1))
;; (my-filter (lambda (x) (= (remainder x 3) 0)) (my-range 0 13 1))

;; 5
(define (my-fold-left op xs)
  (let my-fold-left-reverse ((op op)
                             (xs (reverse xs)))
    (if (null? (cdr xs))
        (car xs)
        (op (my-fold-left-reverse op (cdr xs)) (car xs)))))
;; (my-fold-left  quotient '(16 2 2 2 2))
;; (my-fold-left  quotient '(1))

;; 6
(define (my-fold-right op xs)
  (if (null? (cdr xs))
      (car xs)
      (op (car xs) (my-fold-right op (cdr xs)))))
;; (my-fold-right expt     '(2 3 4))
;; (my-fold-right expt     '(2)) 


;; Number 2

(define (count x xs)
  (let loop ((i 0)
             (xs xs))
    (cond
      ((null? xs) i)
      ((equal? x (car xs)) (loop (+ i 1) (cdr xs)))
      (else (loop i (cdr xs))))))

;; 1
(define (list->set xs)
  (let loop ((new_xs '())
             (xs xs))
    (cond
      ((null? xs) new_xs)
      ((> (count (car xs) xs) 1) (loop new_xs (cdr xs)))
      (else (loop (append new_xs (cons (car xs) '())) (cdr xs))))))
;; (list->set '(1 1 2 3))

;; 2
(define (set? xs)
  (cond
    ((null? xs) #t)
    ((> (count (car xs) xs) 1) #f)
    (else (set? (cdr xs)))))
;; (set? '(1 2 3))
;; (set? '(1 2 3 3))
;; (set? '())

;; 3
(define (union xs ys)
  (let loop ((new '())
             (xs xs)
             (ys ys))
    (cond
      ((null? xs) (list->set (append ys new)))
      ((null? ys) (list->set (append xs new)))
      (else
       (loop (cons (car ys) (cons (car xs) new))
             (cdr xs) (cdr ys))))))
;; (union '(1 2 3) '(2 3 4))

;; 4
(define (intersection xs ys)
  (let loop ((new '())
             (xs xs))
    (cond
      ((null? xs) (list->set new))
      ((my-element? (car xs) ys)
       (loop (cons (car xs) new) (cdr xs)))
      (else (loop new (cdr xs))))))
;; (intersection '(1 2 3) '(2 3 4)) 

;; 5
(define (difference xs ys)
  (let loop ((new '())
             (xs xs))
    (cond
      ((null? xs) (list->set new))
      ((not (my-element? (car xs) ys))
       (loop (cons (car xs) new) (cdr xs)))
      (else (loop new (cdr xs))))))
;; (difference '(1 2 3 4 5) '(2 3))

;; 6
(define (symmetric-difference xs ys)
  (let loop ((new '())
             (xs xs)
             (ys ys))
    (cond
      ((null? xs) (list->set (append ys new)))
      ((null? ys) (list->set (append xs new)))
      ((not (my-element? (car xs) ys))
       (loop (cons (car xs) new) (cdr xs) ys))
      ((not (my-element? (car ys) xs))
       (loop (cons (car ys) new) xs (cdr ys)))
      (else (loop new (cdr xs) (cdr ys))))))
;; (symmetric-difference '(1 2 3 4) '(3 4 5 6))
      
;; 7
(define (set-eq? xs ys)
  (let loop ((new_xs xs)
             (new_ys ys))
    (cond
      ((and (null? new_xs) (null? new_ys)) #t)
      ((and (null? new_xs) (not (null? new_ys))) #f)
      ((and (not (null? new_xs)) (null? new_ys)) #f)
      ((not (my-element? (car new_xs) ys)) #f)
      ((not (my-element? (car new_ys) xs)) #f)
      (else (loop (cdr new_xs) (cdr new_ys))))))
;; (set-eq? '(1 2 3) '(3 2 1))
;; (set-eq? '(1 2) '(1 3))


;; Number 3

;; 1.1
(define (string-trim-left str)
  (define (list-trim-left lst)
    (cond
      ((null? lst) (list->string lst))
      ((char-whitespace? (car lst))
       (list-trim-left (cdr lst)))
      (else (list->string lst))))
  (list-trim-left (string->list str)))
;; (string-trim-left  "\t\tabc def")

;; 1.2
(define (string-trim-right str)
  (define (list-trim-right lst)
    (cond
      ((null? lst) (list->string (reverse lst)))
      ((char-whitespace? (car lst))
       (list-trim-right (cdr lst)))
      (else (list->string (reverse lst)))))
  (list-trim-right (reverse (string->list str))))
;; (string-trim-right "abc def\t")

;; 1.3
(define (string-trim str)
  (string-trim-left (string-trim-right str)))
;; (string-trim       "\t abc def \n")

;; 2.1
(define (string-prefix? a b)
  (define (list-prefix? aim lst is_prefix)
    (cond
      ((and (null? lst) (not (null? aim))) #f)
      ((null? aim) is_prefix)
      ((equal? (car aim) (car lst))
       (list-prefix? (cdr aim) (cdr lst) #t))
      (else #f)))
  (list-prefix? (string->list a) (string->list b) #f))
;; (string-prefix? "abc" "abcdef")
;; (string-prefix? "bcd" "abcdef")
;; (string-prefix? "abcdef" "abc")

;; 2.2
(define (string-suffix? a b)
  (define (list-suffix? aim lst is_suffix)
    (cond
      ((and (null? lst) (not (null? aim))) #f)
      ((null? aim) is_suffix)
      ((equal? (car aim) (car lst))
       (list-suffix? (cdr aim) (cdr lst) #t))
      (else #f)))
  (list-suffix?
   (reverse (string->list a))
   (reverse (string->list b))
   #f))
;; (string-suffix? "def" "abcdef")
;; (string-suffix? "bcd" "abcdef")

;; 2.3
(define (string-infix? a b)
  (cond
    ((equal? b "") #f)
    ((string-prefix? a b) #t)
    (else
     (string-infix? a
                    (list->string (cdr (string->list b)))))))
;; (string-infix? "def" "adefcdefgh")
;; (string-infix? "abc" "abcdefgh")
;; (string-infix? "fgh" "abcdefgh")
;; (string-infix? "ijk" "abcdefgh")
;; (string-infix? "bcd" "abc")

;; 3
(define (concat str1 str2)
  (list->string
   (append (string->list str1) (string->list str2))))

(define (string-split str sep)
  (let loop ((res '())
             (str_to_add "")
             (str str))
    (cond
      ((equal? str "") (append res (cons str_to_add '())))
      ((string-prefix? sep str)   
        (loop
          (append res (cons str_to_add '()))
          ""
          (substring str (string-length sep) (string-length str))))
      (else
        (loop
          res
          (concat str_to_add (make-string 1 (string-ref str 0)))
          (list->string (cdr (string->list str))))))))
      
;; (string-split "x;y;z" ";")
;; (string-split "x-->y-->z" "-->")


;; Number 4

;; 1
(define (make-multi-vector sizes . fill)
  (vector 'multi-vector
        sizes
        (if (null? fill)
            (make-vector (apply * sizes) 0)
            (make-vector (apply * sizes) (car fill)))))
(define m (make-multi-vector '(1 3 4 5)))

;; 2
(define (multi-vector? m)
  (and
    (not (list? m))
    (not (string? m))
    (not (number? m))
    (not (char? m))
    (equal? (vector-ref m 0) 'multi-vector)))

(define (get-indices res sizes indices)
  (cond
    ((null? indices) res)
    ((get-indices (+ (* res (car sizes)) (car indices))
                  (cdr sizes) (cdr indices)))))

;; 3
(define (multi-vector-ref m indices)
  (vector-ref (vector-ref m 2) 
  (get-indices (car indices) (cdr (vector-ref m 1)) (cdr indices))))

;; 4
(define (multi-vector-set! m indices x)
  (vector-set! (vector-ref m 2) 
  (get-indices (car indices) (cdr (vector-ref m 1)) (cdr indices)) x))

;; (define m (make-multi-vector '(11 12 9 16)))
;; (multi-vector? m)
;; (multi-vector-set! m '(10 7 6 12) 'test)
;; (multi-vector-ref m '(10 7 6 12))
;; Индексы '(1 2 1 1) и '(2 1 1 1) — разные индексы
;; (multi-vector-set! m '(1 2 1 1) 'X)
;; (multi-vector-set! m '(2 1 1 1) 'Y)
;; (multi-vector-ref m '(1 2 1 1))
;; (multi-vector-ref m '(2 1 1 1))

;; (define m (make-multi-vector '(3 5 7) -1))
;; (multi-vector-ref m '(0 0 0))

;; Number 5
(define (f x) (+ x 2))
(define (g x) (* x 3))
(define (h x) (- x))

(define (o . xs)
  (define (compose funcs)
    (if (null? funcs)
        (lambda (x) x)
        (lambda (x) ((car funcs) ((compose (cdr funcs)) x)))))
  (compose xs))
;; ((o f g h) 1)
;; ((o f g) 1)
;; ((o h) 1)
;; ((o) 1)