# Лабораторная работа №3

## Цели работы

-   На практике ознакомиться с системой типов языка Scheme.
-   На практике ознакомиться с юнит-тестированием.
-   Разработать свои средства отладки программ на языке Scheme.
-   На практике ознакомиться со средствами метапрограммирования языка
    Scheme.

## Задания

1.  Реализуйте макрос `trace` для трассировки. Трассировка — способ
    отладки, при котором отслеживаются значения переменных или выражений
    на каждом шаге выполнения программы. Необходимость и вывести
    значение в консоль, и вернуть его в программу нередко требует
    существенной модификации кода, что может стать источником
    дополнительных ошибок. Реализуйте макрос, который позволяет ценой
    небольшой вставки, не нарушающей декларативность кода, выполнить и
    вывод значения в консоль с комментарием в виде текста выражения,
    которое было вычислено, и возврат его значения в программу.

    Код без трассировки:

    ``` scheme
    (define (zip . xss)
      (if (or (null? xss)
              (null? (car xss))) ; Надо отслеживать значение (car xss) здесь...
          '()
          (cons (map car xss)
                (apply zip (map cdr xss))))) ; ...и значение xss здесь.
    ```

    Код с трассировкой:

    ``` scheme
    (load "trace.scm")

    (define (zip . xss)
      (if (or (null? xss)
              (null? (trace-ex (car xss)))) ; Здесь...
          '()
          (cons (map car xss)
                (apply zip (map cdr (trace-ex xss)))))) ; ... и здесь
    ```

    Консоль:

    ``` example
    > (zip '(1 2 3) '(one two three))
    (car xss) => (1 2 3)
    xss => ((1 2 3) (one two three))
    (car xss) => (2 3)
    xss => ((2 3) (two three))
    (car xss) => (3)
    xss => ((3) (three))
    (car xss) => ()
    ((1 one) (2 two) (3 three))
    ```

    Вычисление значения выражения осуществляется после вывода цитаты
    этого выражения в консоль. Таким образом, в случае аварийного
    завершения программы из-за невозможности вычисления значения, вы
    всегда сможете определить, в каком выражении возникает ошибка.

    **Проследите, чтобы выражение вычислялось ровно один раз**, в
    противном случае можно получить неверный результат работы программы.

    В дальнейшем используйте этот макрос при отладке своих программ на
    языке Scheme.

    ``` scheme
    (define-syntax trace-ex
      (syntax-rules ()
        ((_ expr)
         (begin
           (write 'expr)
           (display " => ")
           (let ((x expr))
             (write x)
             (newline)
             x)))))
    ```

2.  Юнит-тестирование — способ проверки корректности отдельных
    относительно независимых частей программы. При таком подходе для
    каждой функции (процедуры) пишется набор тестов — пар "выражение —
    значение, которое должно получиться". Процесс тестирования
    заключается в вычислении выражений тестов и автоматизированном
    сопоставлении результата вычислений с ожидаемым результатом. При
    несовпадении выдается сообщение об ошибках.

    Реализуйте свой каркас для юнит-тестирования. Пусть каркас включает
    следующие компоненты:

    -   Макрос `test` — конструктор теста вида
        `(выражение ожидаемый-результат)`.

    -   Процедуру `run-test`, выполняющую отдельный тест. Если
        вычисленный результат совпадает с ожидаемым, то в консоль
        выводятся выражение и признак того, что тест пройден. В
        противном случае выводится выражение, признак того, что тест не
        пройден, а также ожидаемый и фактический результаты. Функция
        возвращает `#t`, если тест пройден и `#f` в противном случае.
        Вывод цитаты выражения в консоль должен выполняться до
        вычисления его значения, чтобы при аварийном завершении
        программы последним в консоль было бы выведено выражение, в
        котором произошла ошибка.

    -   Процедуру `run-tests`, выполняющую серию тестов, переданную ей в
        виде списка. Эта процедура должна выполнять все тесты в списке и
        возвращает `#t`, если все они были успешными, в противном случае
        процедура возвращает `#f`.

    Какой предикат вы будете использовать для сравнения ожидаемого
    результата с фактическим? Почему?

    Пример:

    ``` scheme
    ; Пример процедуры с ошибкой
    ; 
    (define (signum x)
      (cond
        ((< x 0) -1)
        ((= x 0)  1) ; Ошибка здесь!
        (else     1)))

    ; Загружаем каркас
    ;
    (load "unit-test.scm")

    ; Определяем список тестов
    ;
    (define the-tests
      (list (test (signum -2) -1)
            (test (signum  0)  0)
            (test (signum  2)  1)))

    ; Выполняем тесты
    ;
    (run-tests the-tests)
    ```

    Пример результата в консоли:

    ``` example
    (signum -2) ok
    (signum 0) FAIL
      Expected: 0
      Returned: 1
    (signum 2) ok
    #f
    ```

    Используйте разработанные вами средства отладки для выполнения
    следующих заданий этой лабораторной работы и последующих домашних
    заданий.

    ``` scheme
    (define-syntax test
        (syntax-rules ()
            ((test (func . param) expected)
                (list (func . param) expected '(func . param)))))

    (define (run-test the-test)
      (if (equal? (car the-test) (cadr the-test))
          (begin
            (write (caddr the-test))
            (display " ok\n")
            #t)
          (begin
            (write (caddr the-test))
            (display " FAIL\n")
            (display "  Expected: ")
            (write (cadr the-test))
            (newline)
            (display "  Returned: ")
            (write (car the-test))
            (newline)
            #f)))

    (define (run-tests the-tests)
        (let loop ((the-tests the-tests)
                   (all-tests-passed #t))
            (cond
                ((null? the-tests) all-tests-passed)
                ((and (run-test (car the-tests)) all-tests-passed) (loop (cdr the-tests) #t))
                (else (loop (cdr the-tests) #f)))))
     
    ```

3.  Реализуйте процедуру доступа к произвольному элементу
    последовательности (правильного списка, вектора или строки) по
    индексу. Пусть процедура возвращает `#f` если получение элемента не
    возможно. Примеры применения процедуры:

    ``` scheme
    (ref '(1 2 3) 1) ⇒ 2
    (ref #(1 2 3) 1) ⇒ 2
    (ref "123" 1)    ⇒ #\2
    (ref "123" 3)    ⇒ #f
    ```

    Реализуйте процедуру "вставки" произвольного элемента в
    последовательность, в позицию с заданным индексом (процедура
    возвращает новую последовательность). Пусть процедура возвращает
    `#f` если вставка не может быть выполнена. Примеры применения
    процедуры:

    ``` scheme
    (ref '(1 2 3) 1 0)   ⇒ (1 0 2 3)
    (ref #(1 2 3) 1 0)   ⇒ #(1 0 2 3)
    (ref #(1 2 3) 1 #\0) ⇒ #(1 #\0 2 3)
    (ref "123" 1 #\0)    ⇒ "1023"
    (ref "123" 1 0)      ⇒ #f
    (ref "123" 3 #\4)    ⇒ "1234"
    (ref "123" 5 #\4)    ⇒ #f
    ```

    Попробуйте предусмотреть все возможные варианты.

    **Примечание.** Результатом выполнения задания должно быть **одно**
    определение процедуры `ref`. Алгоритм её работы должен определяться
    числом аргументов и их типами.

    ``` scheme
    (define (ref var ind . xs)
      (if (null? xs)
          (cond
            ((list? var)
             (if (< -1 ind (length var))
                 (list-ref var ind)
                 #f))        
            ((string? var)
             (if (< -1 ind (string-length var))
                 (string-ref var ind)
                 #f))       
            ((vector? var)
             (if (< -1 ind (vector-length var))
                 (vector-ref var ind)
                 #f)))
          (cond
            ((list? var) (insert-at var ind (car xs)))
            ((string? var)
             (if (char? (car xs))
                 (begin
                   (set! var (insert-at (string->list var) ind (car xs)) )
                   (if var
                       (list->string var)
                       #f))
                 #f))
            ((vector? var)
             (begin
               (set! var (insert-at (vector->list var) ind (car xs)))
               (if var
                   (list->vector var)
                   #f))))))


    (define (insert-at lst index value)
        (if (or (< index 0) (> index (length lst))) 
            #f
        (cond
            ((null? lst) (list value))
            ((= 0 index) (cons value lst))
            (else (cons (car lst) (insert-at (cdr lst) (- index 1) value))))))

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
    
    ;; (run-tests the-tests-ref)
    ;; (newline)
    ```

4.  Разработайте наборы юнит-тестов и используйте эти тесты для
    разработки процедуры, выполняющей разложение на множители.

    Реализуйте процедуру `factorize`, выполняющую разложение многочленов
    вида a2−b2, a3−b3 и a3+b3 по формулам.

    Пусть процедура принимает единственный аргумент — выражение на языке
    Scheme, которое следует разложить на множители, и возвращает
    преобразованное выражение. Возведение в степень в исходных
    выражениях пусть будет реализовано с помощью встроенной процедуры
    expt. Получаемое выражение должно быть пригодно для выполнения в
    среде интерпретатора с помощью встроенной процедуры eval. Упрощение
    выражений не требуется.

    Примеры вызова процедуры:

    ``` example
    (factorize '(- (expt x 2) (expt y 2))) 
      ⇒ (* (- x y) (+ x y))

    (factorize '(- (expt (+ first 1) 2) (expt (- second 1) 2)))
      ⇒ (* (- (+ first 1) (- second 1))
             (+ (+ first 1) (- second 1)))

    (eval (list (list 'lambda 
                          '(x y) 
                          (factorize '(- (expt x 2) (expt y 2))))
                    1 2)
              (interaction-environment))
      ⇒ -3
    ```

    ``` scheme
    (define (x xs)
        (cadadr xs))
    (define (y ys)
        (car (cdaddr ys)))
  
    (define (factorize expr)
      (cond
        ((and (equal? (car expr) '-) (equal? (car (cddadr expr)) 2))
         `(* (- ,(x expr) ,(y expr))
             (+ ,(x expr) ,(y expr))))
        ((and (equal? (car expr) '-) (equal? (car (cddadr expr)) 3))
         `(* (- ,(x expr) ,(y expr))
             (+ (* ,(x expr) ,(x expr))
                (* ,(x expr) ,(y expr))
                (* ,(y expr) ,(y expr)))))
        ((and (equal? (car expr) '+) (equal? (car (cddadr expr)) 3))
         `(* (+ ,(x expr) ,(y expr))
             (+  (* ,(x expr) ,(x expr))
                 (- (* ,(x expr) ,(y expr)))
                 (* ,(y expr) ,(y expr)))))))


    (define the-tests-factorize
      (list (test (factorize '(- (expt x 2) (expt y 2)))                          ;; a^2 - b^2
                  '(* (- x y) (+ x y)))
            (test (factorize '(- (expt (+ first 1) 2) (expt (- second 1) 2)))     ;; a^2 - b^2 (complex expr)
                  '(* (- (+ first 1) (- second 1)) (+ (+ first 1) (- second 1))))
            (test (eval (list (list 'lambda '(x y)                                ;; a^2 - b^2 with eval
                          (factorize '(- (expt x 2) (expt y 2))))
                    1 2) (interaction-environment)) 
                  -3)
            (test (factorize '(- (expt x 3) (expt y 3)))                          ;; a^3 - b^3
                  '(* (- x y) (+ (* x x) (* x y) (* y y))))
            (test (factorize '(- (expt (+ first 1) 3) (expt (- second 1) 3)))     ;; a^3 - b^3 (complex expr)
                  '(* (- (+ first 1) (- second 1))
                      (+ (* (+ first 1) (+ first 1))
                         (* (+ first 1) (- second 1))
                         (* (- second 1) (- second 1)))))
            (test (factorize '(+ (expt x 3) (expt y 3)))                          ;; a^3 + b^3
                  '(* (+ x y) (+ (* x x) (- (* x y)) (* y y))))
            (test (factorize '(+ (expt (+ first 1) 3) (expt (- second 1) 3)))     ;; a^3 + b^3 (complex expr)
                  '(* (+ (+ first 1) (- second 1))
                      (+ (* (+ first 1) (+ first 1))
                         (- (* (+ first 1) (- second 1)))
                         (* (- second 1) (- second 1)))))
            (test (factorize '(+ (expt x 5) (expt y 5)))                          ;; wrong parametrs
                  '(+ (expt x 5) (expt y 5)))
    ))

    ;; (run-tests the-tests-factorize)
    ;; (newline)
    ```
