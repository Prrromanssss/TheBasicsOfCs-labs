;; Number 1
(define (count x xs)
  (let loop ((i 0)
             (xs xs))
    (cond
      ((null? xs) i)
      ((equal? x (car xs)) (loop (+ i 1) (cdr xs)))
      (else (loop i (cdr xs))))))


;; Number 2
(define (delete pred? xs)
  (let loop ((new_xs '())
             (xs xs))
    (cond
      ((null? xs) new_xs)
      ((pred? (car xs)) (loop new_xs (cdr xs)))
      (else (loop (append new_xs (cons (car xs) '())) (cdr xs))))))


;; Number 3
(define (iterate f x n)
    (let loop ((new_xs '())
               (new_n n)
               (x x))
      (cond ((= new_n 0) new_xs)
            ((= new_n n) (loop (cons x '()) (- new_n 1) x))
            (else (loop (append new_xs (cons (f x) '())) (- new_n 1) (f x))))))


;; Number 4
(define (intersperse e xs)
  (let loop ((new_xs '())
             (xs xs)
             (flag #f))
    (cond
      ((null? xs) new_xs)
      (flag (loop (append new_xs (cons e '())) xs #f))
      (else (loop (append new_xs (cons (car xs) '())) (cdr xs) #t)))))


;; Number 5
(define (any? pred? xs)
  (and (not (null? xs)) (or (pred? (car xs)) (any? pred? (cdr xs)))))


(define (all? pred? xs)
      (or (null? xs) (and (pred? (car xs)) (any? pred? (cdr xs)))))


;; Number 6
(define (f x) (+ x 2))
(define (g x) (* x 3))
(define (h x) (- x))

;;(define (o . xs)
 ;; (if (null? xs)
      
 ;; (lambda (x) (o . (cdr xs))))