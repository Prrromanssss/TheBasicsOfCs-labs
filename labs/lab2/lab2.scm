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
  (if (= n 0)
      '()
      (cons x (iterate f (f x) (- n 1)))))


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
      (or (null? xs) (and (pred? (car xs)) (all? pred? (cdr xs)))))


;; Number 6
(define (o . xs)
  (define (compose funcs)
    (if (null? funcs)
        (lambda (x) x)
        (lambda (x) ((car funcs) ((compose (cdr funcs)) x)))))
  (compose xs))