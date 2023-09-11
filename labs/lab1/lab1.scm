;; Number 1
(define (my-even? x)
  (= (remainder x 2) 0))

(define (my-odd? x)
  (= (remainder x 2) 1))

;; Number 2
(define (power base exp)
  (if (= exp 1)
    base
  (* base (power base (- exp 1)))))