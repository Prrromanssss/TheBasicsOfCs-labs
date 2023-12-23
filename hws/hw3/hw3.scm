(define (derivative expr)
  (define (get-denom expr) (caddr expr))
  (define (get-numer expr) (cadr expr))
  (define (get-base expr) (cadr expr))
  (define (get-exponent expr) (caddr expr))
  (let ((current-symbol (if (list? expr) (car expr) expr)))
    (cond ((not (list? expr)) (if (number? expr)
                                  0
                                  (if (symbol? expr)
                                      1)))

          ((null? (cdr expr)) (derivative current-symbol))

          ;; y = x
          ((and (symbol? (cadr expr)) (equal? '- current-symbol)) -1)

          ;; y = number ^ f(x)
          ((equal? 'expt current-symbol)
           (let* ((base (get-base expr))
                  (exponent (get-exponent expr)))
             (if (symbol? base)
                 `(* ,exponent (expt ,base ,(- exponent 1)))
                 `(* ,expr (log ,base) ,(derivative exponent)))))

          ;; y = sin(f(x))
          ((equal? 'sin current-symbol) `(* (cos ,(cadr expr)) ,(derivative (cadr expr))))

          ;; y = cos(f(x))
          ((equal? 'cos current-symbol) `(* (- (sin ,(cadr expr))) ,(derivative (cadr expr))))

          ;; y = log(f(x))
          ((equal? 'log current-symbol) `(/ ,(derivative (cadr expr)) ,(cadr expr)))

          ;; y = f(x) - g(x)
          ((equal? '- current-symbol) `(- ,@(map derivative (cdr expr))))

          ;; y = f(x) + g(x)
          ((equal? '+ current-symbol) `(+ ,@(map derivative (cdr expr))))

          ;; y = f(x) / g(x)
          ((equal? '/ current-symbol)
           (let ((numer (get-numer expr))
                 (denom (get-denom expr)))
             `(/ (- (* ,(derivative numer) ,denom)
                    (* ,(derivative denom) ,numer))
                 (* ,denom ,denom))))

          ;; y = f(x) * g(x)
          ((equal? '* current-symbol)
           (if (null? (cddr expr))
               (derivative (cadr expr))
               (let* ((f (cadr expr))
                      (g (if (null? (cdddr expr))
                             (caddr expr)
                             (cons '* (cddr expr)))))
                 `(+ (* ,(derivative f) ,g)
                     (* ,f ,(derivative g))))))

          ;; y = f(x) ^ number
          ((equal? 'exp current-symbol)
           (let ((deg (cadr expr)))
             `(* (exp ,deg) ,(derivative deg))))

          (else expr))))
