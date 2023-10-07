;; Number 1
(define-syntax trace-ex
  (syntax-rules ()
    ((_ expr)
      (let ((x expr))
        (display 'expr)
        (display " => ")
        (display expr)
        (newline)
        expr))))


;; Number 2
(define-syntax test
  (syntax-rules ()
    ((test (func . param) expected)
     (list (func . param) expected '(func . param)))))

(define (run-test the-test)
  (if (equal? (list-ref the-test 0) (list-ref the-test 1))
    (begin
      (write (list-ref the-test 2))
      (display " ok\n")
      #t
    )
    (begin
      (write (list-ref the-test 2))
      (display " FAIL\n")
      (display "  Expected: ")
      (write (list-ref the-test 1))
      (newline)
      (display "  Returned: ")
      (write (list-ref the-test 0))
      (newline)
      #f)))

(define (run-tests the-tests)
  (let loop ((the-tests the-tests)
             (all-tests-passed #t))
    (cond
      ((null? the-tests) all-tests-passed)
      ((and (run-test (car the-tests)) all-tests-passed) (loop (cdr the-tests) #t))
      (else (loop (cdr the-tests) #f)))))


;; Number 3
(define (ref var ind . xs)
  (if (null? xs)
      (cond
        ((list? var)
          (if (< -1 ind (length var))
            (list-ref var ind)
            #f))
        
        ((string? var)
          (if (< -1 ind (length (string->list var)))
            (string-ref var ind)
            #f))
        
        ((vector? var)
          (if (< -1 ind (length (vector->list var)))
            (vector-ref var ind)
            #f)))

      (cond
        ((list? var) (insert-at var ind (list-ref xs 0)))

        ((string? var)
         (if (char? (list-ref xs 0))
           (begin
             (set! var (insert-at (string->list var) ind (list-ref xs 0)) )
               (if var
                 (list->string var)
                   #f))
            #f))

        ((vector? var)
          (begin
            (set! var (insert-at (vector->list var) ind (list-ref xs 0)))
            (if var
              (list->vector var)
              #f))))))

(define (insert-at lst index value)
  (if (or (< index 0) (> index (length lst))) 
      #f
  (cond
    ((null? lst) (list value))
    ((= 0 index) (cons value lst))
    (else (cons (car lst) (insert-at (cdr lst) (- index 1) value ))))))

(define the-tests-ref
  (list (test (ref '(1 2 3) 1) 2) ;; ok
        (test (ref '(1 2 3) 0) 1) ;; ok
        (test (ref '(1 2 3) 3) #f) ;; index out of range
        (test (ref '(1 2 3) -1) #f) ;; index out of range
        
        (test (ref #(1 2 3) 1) 2) ;; ok
        (test (ref #(1 2 3) 0) 1) ;; ok
        (test (ref #(1 2 3) 3) #f) ;; index out of range
        (test (ref #(1 2 3) -1) #f) ;; index out of range
        
        (test (ref "123" 1) #\2) ;; ok
        (test (ref "123" 0) #\1) ;; ok
        (test (ref "123" -1) #f) ;; index out of range
        (test (ref "123" 3) #f) ;; index out of range

        (test (ref '(1 2 3) 1 0) '(1 0 2 3)) ;; ok
        (test (ref '(1 2 3) 1 "1") '(1 "1" 2 3)) ;; ok
        (test (ref '(1 2 3) 1 '(4 5)) '(1 (4 5) 2 3)) ;; ok
        (test (ref '(1 2 3) 1 #\r) '(1 #\r 2 3)) ;; ok
        (test (ref '(1 2 3) 1 #(4 5)) '(1 #(4 5) 2 3)) ;; ok
        (test (ref '(1 2 3) 5 0) #f) ;; index out of range
        (test (ref '(1 2 3) -1 0) #f) ;; index out of range

        (test (ref #(1 2 3) 1 #\0) #(1 #\0 2 3)) ;; ok
        (test (ref #(1 2 3) 1 "1") #(1 "1" 2 3)) ;; ok
        (test (ref #(1 2 3) 1 0) #(1 0 2 3)) ;; ok
        (test (ref #(1 2 3) 1 #(4 5)) #(1 #(4 5) 2 3)) ;; ok
        (test (ref #(1 2 3) 5 0) #f) ;; index out of range
        (test (ref #(1 2 3) -1 0) #f) ;; index out of range

        (test (ref "123" 3 #\4) "1234") ;; ok
        (test (ref "123" 1 #\4) "1423") ;; ok
        (test (ref "123" 1 "1") #f) ;; wrong type(string)
        (test (ref "123" 1 '(4 5)) #f) ;; wrong type(list)
        (test (ref "123" 1 0) #f) ;; wrong type(integer)
        (test (ref "123" 1 #(4 5)) #f) ;; wrong type(vector)
        (test (ref "123" 5 #\4) #f) ;; index out of range
        (test (ref "123" -1 #\4) #f) ;; index out of range
))


;; Number 4


