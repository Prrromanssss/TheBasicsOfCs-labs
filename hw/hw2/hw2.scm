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


;; Number 4


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








   