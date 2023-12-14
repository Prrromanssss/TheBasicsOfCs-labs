(load "../lab3/lab3.scm")

;; Конструктор потока
(define (make-stream items . eos)
  (if (null? eos)
      (make-stream items #f)
      (list items (car eos))))

;; Запрос текущего символа
(define (peek stream)
  (if (null? (car stream))
      (cadr stream)
      (caar stream)))

;; Запрос первых двух символов
(define (peek2 stream)
  (if (null? (car stream))
      (cadr stream)
      (if (null? (cdar stream))
          (list (caar stream))
          (list (caar stream) (cadar stream)))))

;; Продвижение вперёд
(define (next stream)
  (let ((n (peek stream)))
    (if (not (null? (car stream)))
        (set-car! stream (cdr (car stream))))
    n))

(define call/cc call-with-current-continuation)

;; Number 1

;; <Дробь> ::= <Число-со-знаком> / <Число-без-знака>
;; <Число-со-знаком> ::= + <Число-без-знака> | - <Число-без-знака> | <Число-без-знака>
;; <Число-без-знака> ::= ЦИФРА <Хвост-числа>
;; <Хвост-числа> ::= ЦИФРА <Хвост-числа> | <Пустота>
;; <Пустота> ::= 


;; 1.1
(define (check-frac str)
  (define (check stream error)
    (signed-num stream error)
    (sign stream #\/ error)
    (unsigned-num stream error))

  (define (sign stream term error)
    (if (equal? (peek stream) term)
        (next stream)
        (error #f)))

  (define (signed-num stream error)
    (cond ((equal? (peek stream) #\+)
           (next stream)
           (if (unsigned-num stream error)
               #t
               (error #f)))
          ((equal? (peek stream) #\-)
           (next stream)
           (if (unsigned-num stream error)
               #t
               (error #f)))
          ((unsigned-num stream error) #t)
          (else (error #f))))
  
  (define (unsigned-num stream error)
    (cond ((and (char? (peek stream)) (char-numeric? (peek stream)))
           (next stream)
           (tail-num stream error))
          (else (error #f))))

  (define (tail-num stream error)
    (cond ((and (char? (peek stream)) (char-numeric? (peek stream)))
           (next stream)
           (tail-num stream error))
          (else #t)))

  (define stream (make-stream (string->list str) 'EOF))

  (call/cc
   (lambda (error)
     (check stream error)
     (equal? (peek stream) 'EOF))))


(define check-frac-tests
  (list (test (check-frac "110/111")
              #t)
        (test (check-frac "-4/3")
              #t)
        (test (check-frac "+5/10")
              #t)
        (test (check-frac "5.0/10")
              #f)
        (test (check-frac "FF/10")
              #f)
        (test (check-frac "/")
              #f)
        (test (check-frac "1/")
              #f)
        (test (check-frac "/1")
              #f)
        (test (check-frac "")
              #f)
        (test (check-frac "+/1")
              #f)
        (test (check-frac "+1 1/1")
              #f)
        (test (check-frac "+56+4/10")
              #f)
        (test (check-frac "-2/1")
              #t)
        (test (check-frac "+1/")
              #f)
        (test (check-frac "-/1")
              #f)))
;; (run-tests check-frac-tests)


;; <Дробь> ::= <Число-со-знаком> / <Число-без-знака>
;; <Число-со-знаком> ::= + <Число-без-знака> | - <Число-без-знака> | <Число-без-знака>
;; <Число-без-знака> ::= ЦИФРА <Хвост-числа>
;; <Хвост-числа> ::= ЦИФРА <Хвост-числа> | <Пустота>
;; <Пустота> ::= 


;; 1.2
(define (scan-frac str)
  (let ((res '()))
    (define (scan stream error)
      (signed-num stream error)
      (sign stream #\/ error)
      (unsigned-num stream error))

    (define (sign stream term error)
      (if (equal? (peek stream) term)
          (begin
            (set! res (append res (cons (peek stream) '())))
            (next stream))
          (error #f)))

    (define (signed-num stream error)
      (cond ((equal? (peek stream) #\+)
             (begin
               (set! res (append res (cons (peek stream) '())))
               (next stream))
             (if (unsigned-num stream error)
                 #t
                 (error #f)))
            ((equal? (peek stream) #\-)
             (begin
               (set! res (append res (cons (peek stream) '())))
               (next stream))
             (if (unsigned-num stream error)
                 #t
                 (error #f)))
            ((unsigned-num stream error) #t)
            (else (error #f))))
  
    (define (unsigned-num stream error)
      (cond ((and (char? (peek stream)) (char-numeric? (peek stream)))
             (begin
               (set! res (append res (cons (peek stream) '())))
               (next stream))
             (tail-num stream error))
            (else (error #f))))

    (define (tail-num stream error)
      (cond ((and (char? (peek stream)) (char-numeric? (peek stream)))
             (begin
               (set! res (append res (cons (peek stream) '())))
               (next stream))
             (tail-num stream error))
            (else #t)))

    (define (print-frac lst)
      (string->number (list->string lst)))

    (define stream (make-stream (string->list str) 'EOF))

    (call/cc
     (lambda (error)
       (scan stream error)
       (if (equal? (peek stream) 'EOF)
           (print-frac res)
           #f)))))


(define scan-frac-tests
  (list (test (scan-frac "110/111")
               110/111)
        (test (scan-frac "-4/3")
               -4/3)
        (test (scan-frac "+5/10")
               1/2)
        (test (scan-frac "5.0/10")
              #f)
        (test (scan-frac "FF/10")
              #f)
        (test (scan-frac "/")
              #f)
        (test (scan-frac "1/")
              #f)
        (test (scan-frac "/1")
              #f)
        (test (scan-frac "")
              #f)
        (test (scan-frac "+/1")
              #f)
        (test (scan-frac "+1 1/1")
              #f)
        (test (scan-frac "+56+4/10")
              #f)
        (test (scan-frac "-2/1")
               -2/1)
        (test (scan-frac "+1/")
              #f)
        (test (scan-frac "-/1")
              #f)))
;; (run-tests scan-frac-tests)

;; <Список дробей> ::= <Пробелы> <Дробь> <Пробелы> <Список дробей> | <Пусто>
;; <Пробелы> ::= ПРОБЕЛЬНЫЙ-СИМВОЛ <Пробелы> | <Пусто>
;; <Дробь> ::= <Число-со-знаком> / <Число-без-знака>
;; <Число-со-знаком> ::= + <Число-без-знака> | - <Число-без-знака> | <Число-без-знака>
;; <Число-без-знака> ::= ЦИФРА <Хвост-числа>
;; <Хвост-числа> ::= ЦИФРА <Хвост-числа> | <Пустота>
;; <Пустота> ::=


;; 1.3
(define (scan-many-fracs str)
  (define (clean-string str)
    (define (concat str1 str2)
      (list->string
      (append (string->list str1) (string->list str2))))

    (let loop ((res '())
               (current-string "")
               (data (string->list (concat str " "))))
      (cond ((null? data) res)
            ((and
              (char? (car data))
              (char-whitespace? (car data))
              (not (equal? current-string "")))
             (loop (append res (cons current-string '()))
                   ""
                   (cdr data)))
            ((and
              (char? (car data))
              (char-whitespace? (car data))
              (equal? current-string ""))
             (loop res
                   current-string
                   (cdr data)))
             ((and
               (char? (car data))
               (not (char-whitespace? (car data))))
              (loop res (concat current-string (make-string 1 (car data))) (cdr data))))))

  (let inner ((data (clean-string str))
        (res '()))
    (cond ((null? data) res)
          ((equal? (scan-frac (car data)) #f) #f)
          (else (inner (cdr data) (append res (cons (scan-frac (car data)) '())))))))


(define scan-many-fracs-tests
  (list (test (scan-many-fracs
               "\t1/2 1/3\n\n10/8")
              '(1/2 1/3 5/4))
        (test (scan-many-fracs
               "\t1/2 1/3\n\n2/-5")
              #f)
        (test (scan-many-fracs
               "\t1/2 1/32/-5")
              #f)))

;; (run-tests scan-many-fracs-tests)


