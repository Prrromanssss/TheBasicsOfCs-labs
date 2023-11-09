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

(define (list->set xs)
  (let loop ((new_xs '())
             (xs xs))
    (cond
      ((null? xs) new_xs)
      ((> (count (car xs) xs) 1) (loop new_xs (cdr xs)))
      (else (loop (append new_xs (cons (car xs) '())) (cdr xs))))))
;; (list->set '(1 1 2 3))

(define (set? xs)
  (cond
    ((null? xs) #t)
    ((> (count (car xs) xs) 1) #f)
    (else (set? (cdr xs)))))
;; (set? '(1 2 3))
;; (set? '(1 2 3 3))
;; (set? '())

(define (union xs ys)
  (let loop ((new '())
             (xs xs)
             (ys ys))
    (cond
      ((and (null? xs) (null? ys)) new)
      ((null? xs) (loop (append new ys) xs '() ))
      ((null? ys) (loop (append new xs) '() ys))
      ((and (< (count (car xs) new) 1)
            (< (count (car ys) (cons (car xs) new)) 1))
       (loop (cons (car ys) (cons (car xs) new)) (cdr xs) (cdr ys)))
      ((< (count (car xs) new) 1) (loop (cons (car xs) new) (cdr xs) (cdr ys)))
      ((< (count (car ys) new) 1) (loop (cons (car ys) new) (cdr xs) (cdr ys))))))
;; (union '(1 2 3) '(2 3 4))


    
      



      
