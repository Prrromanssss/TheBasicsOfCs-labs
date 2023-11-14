;; Number 1
(define (day-of-week day month year)
  (set! month (remainder (+ month 10) 12) )
  (cond ((= month 0) (inexact->exact (modulo (+ day (floor (- (* 2.6 12) 0.2)) (* (quotient year 100) -2) (- (modulo year 100) 1) (quotient (- (modulo year 100) 1) 4) (quotient (quotient year 100) 4)) 7)))

      ((= month 11) (inexact->exact (modulo (+ day (floor (- (* 2.6 month) 0.2)) (* (quotient year 100) -2) (- (modulo year 100) 1)  (quotient (- (modulo year 100) 1) 4) (quotient (quotient year 100) 4)) 7)))
      
      (else (inexact->exact (modulo (+ day (floor (- (* 2.6 month) 0.2)) (* (quotient year 100) -2) (modulo year 100) (quotient (modulo year 100) 4) (quotient (quotient year 100) 4)) 7)))
      ))

;; Number 2
(define (sq a b c)
  (cond
    ( (= 0 (D a b c)) (list (/ (- b) (* 2 a))))
    ( (> (D a b c) 0) (list (/ (+ (- b) (sqrt (D a b c))) (* 2 a)) (/ (- (- b) (sqrt (D a b c))) (* 2 a)) ))
    (else '())
    ))

(define (D a b c)
  (- (* b b) (* 4 a c)))

;; Number 3
(define (my-gcd a b) 
  (define (my-gcd-positive a b)
    (if (= b 0)
        a
        (my-gcd-positive b (remainder a b))))
  (my-gcd-positive (abs a) (abs b)))
  

(define (my-lcm a b)
  (/ (* (abs a) (abs b)) (my-gcd a b)))


(define (prime? n)
  (let loop ((n n)
    (cur (- n 1)))
     (cond
       ((<= n 1) #f)
       ((<= cur 1) #t)
       ((= (/ n cur) (quotient n cur) ) #f)
       (else (loop n (- cur 1))))))