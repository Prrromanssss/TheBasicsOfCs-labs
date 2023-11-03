
# Лабораторная работа №4

## Цели работы

На примере языка Scheme ознакомиться со средствами метапрограммирования
(«код как данные», макросы) и подходами к оптимизации вычислений
(мемоизация результатов вычислений, отложенные вычисления).

В работе также предлагается разработать дополнительное средство отладки
программ — каркас для отладки с помощью утверждений. На этом примере
предлагается ознакомится с типичным применением программирования с
использованием продолжений.

## Задания

### 1. Продолжения.

Утверждение (assertion) — проверка на истинность некоторого условия,
заданного программистом. По традиции осуществляется процедурой
(функцией) с именем `assert`. Включается в код во время написания кода и
отладки с целью установки ограничений на значения и выявления
недопустимых значений. Если в процессе выполнения программы указанное
условие нарушается, то программа завершается с выводом диагностического
сообщения о том, какое условие было нарушено. Если условие соблюдено, то
выполнение программы продолжается, никаких сообщений не выводится.

Реализуйте каркас (фреймворк) для отладки с помощью утверждений. Пусть
Ваш каркас перед использованием инициализируется вызовом
`(use-assertions)`, а сами утверждения записываются в коде ниже в виде
`(assert <statement>)`. Если условие не выполнено, происходит завершение
работы программы без возникновения ошибки выполнения и вывод в консоль
диагностического сообщения вида `FAILED: <statement>`. Пример
использования каркаса:

``` scheme
(use-assertions) ; Инициализация вашего каркаса перед использованием

; Определение процедуры, требующей верификации переданного ей значения:

(define (1/x x)
  (assert (not (zero? x))) ; Утверждение: x ДОЛЖЕН БЫТЬ ≠ 0
  (/ 1 x))

; Применение процедуры с утверждением:

(map 1/x '(1 2 3 4 5)) ; ВЕРНЕТ список значений в программу

(map 1/x '(-2 -1 0 1 2)) ; ВЫВЕДЕТ в консоль сообщение и завершит работу программы
```

Сообщение, которое должно быть выведено при выполнении примера,
показанного выше:

``` example
FAILED: (not (zero? x))
```

Важно! Если в программе используются гигиенические макросы и эта
программа будет выполнена в среде guile 1.8.x (в том числе на сервере
тестирования), то следует подключить модуль поддержки таких макросов,
написав в начале программы следующую строку:

``` example
(use-syntax (ice-9 syncase))
```


``` scheme
(define call/cc call-with-current-continuation)

(define (exit) (display "You need include assert using use-assertions macros"))

(define-syntax use-assertions
  (syntax-rules ()
    ((use-assertions)
     (call/cc
      (lambda (cc)
        (set! exit cc))))))

(use-assertions)

(define-syntax assert
  (syntax-rules ()
    ((assert condition)
     (if (not condition)
         (begin
           (write "FAILED: ")
           (write 'condition)
           (exit))))))
```


### 2. Код как данные. Порты ввода-вывода.

-   *Сериализация данных.* Реализуйте процедуры для записи данных из
    переменной в файл по заданному пути (т.е. для сериализации) и
    последующего чтения данных (десериализации) из такого файла:

    ``` example
    (save-data данные путь-к-файлу)
    (load-data путь-к-файлу) ⇒ данные
    ```


        ``` scheme
        (define (save-data data path)
          (call-with-output-file path
            (lambda (port)
              (write data port))))

        (define (load-data path)
          (call-with-input-file path
            (lambda (port)
              (read port))))
        ```

-   *Подсчет строк в текстовом файле.* Реализуйте процедуру, принимающую
    в качестве аргумента путь к текстовому файлу и возвращающую число
    *непустых* строк в этом файле. Используйте процедуры, разработанные
    вами ранее в рамках выполнения домашних заданий.

    -   решение

        ``` scheme
        (define (count-lines path)
          (call-with-input-file path
            (lambda (port)
              (let loop ((port port)
                         (count 0)
                         (symbol (read-char port)))
                (cond
                  ((eof-object? symbol) (newline) count)
                  ((and (equal? #\newline symbol)
                        (not (equal? #\newline (peek-char port))))
                   (loop port (+ 1 count) (read-char port)))
                  (else (begin
                          (display symbol)
                          (loop port count (read-char port)))))))))
        ```


### 3. Мемоизация результатов вычислений.

Реализуйте функцию вычисления n-го "числа трибоначчи"
(последовательности чисел, которой первые три числа равны соответственно
0, 0 и 1, а каждое последующее число — сумме предыдущих трех чисел):

![Функция](../pics/lab3v2-trib.gif)

![Область определения функции](../pics/lab3v2-trib-domain.gif)

Реализуйте версию этой функции с мемоизацией результатов вычислений.
Сравните время вычисления значения функций для разных (умеренно больших)
значений её аргументов без мемоизации и с мемоизацией. Для точного
измерения вычисления рекомендуется использовать команду REPL Guile
`time` (Guile 2.x).

```scheme
(load "./unit-test.scm")

(define tribonacci-memo
  (let ((known-results '()))
    (lambda (n)
      (let* ((args (list n))
             (res (assoc args known-results)))
        (if res
            (cadr res)
            (let ((res
                   (cond
                     ((<= n 1) 0)
                     ((= n 2) 1)
                     (else (+
                            (tribonacci-memo (- n 1))
                            (tribonacci-memo (- n 2))
                            (tribonacci-memo (- n 3)))))))
              (set! known-results (cons (list args res) known-results))
              res))))))

(define tests-tribonacci-memo
  (list (test (tribonacci-memo 0) 0)
        (test (tribonacci-memo 1) 1)
        (test (tribonacci-memo 2) 1)
        (test (tribonacci-memo 3) 2)
        (test (tribonacci-memo 4) 4)
        (test (tribonacci-memo 4) 4)
        (test (tribonacci-memo 5) 7)))

(define (tribonacci n)
  (cond
    ((<= n 1) 0)
    ((= n 2) 1)
    (else (+ (tribonacci (- n 1)) (tribonacci (- n 2)) (tribonacci (- n 3))))))

(define tests-tribonacci
  (list (test (tribonacci 0) 0)
        (test (tribonacci 1) 1)
        (test (tribonacci 2) 1)
        (test (tribonacci 3) 2)
        (test (tribonacci 4) 4)
        (test (tribonacci 4) 4)
        (test (tribonacci 5) 7)))
```


### 4. Отложенные вычисления.

Используя примитивы для отложенных вычислений `delay` и `force`,
реализуйте макрос `my-if`, который полностью воспроизводит поведение
встроенной условной конструкции (специальной формы) `if` для выражений,
возвращающих значения. Например, такие примеры должны вычисляться
корректно:

``` example
(my-if #t 1 (/ 1 0)) ⇒ 1
(my-if #f (/ 1 0) 1) ⇒ 1
```

*Запрещается* использовать встроенные условные конструкции `if`, `cond`,
`case` и перехват исключений.


``` scheme
(load "./unit-test.scm")

(define-syntax my-if
  (syntax-rules ()
    ((my-if condition true-state false-state)
     (let
         ((promise1 (delay true-state))
          (promise2 (delay false-state)))
       (force (or (and condition promise1) promise2))))))

(define tests-my-if
  (list (test (my-if #t 1 (/ 1 0)) 1)
        (test (my-if #f (/ 1 0) 1) 1)
        (test (my-if (= (+ 1 1) 2) 2 (/ 1 0)) 2)))
```


### 5. Локальные определения.

Реализуйте макросы `my-let` и `my-let*`, полностью воспроизводящие
поведение встроенных макросов `let` и `let*`.

```scheme
(load "./unit-test.scm")

(define-syntax my-let
  (syntax-rules ()
    ((my-let ((var val) ...) expr)
     ((lambda (var ...) expr) val ...))))

(define tests-my-let
  (list
   (test (my-let ((x 5) (y 7))
                 (+ x 1 y))
         13)
   (test (my-let ((=> #f))
                 (cond (#t => 'ok)))
         ok)))

(define-syntax my-let*
  (syntax-rules ()
    ((my-let* () expr) expr)
    ((my-let* ((var1 expr1) (varn exprn) ...) expr)
     ((lambda (var1)
        (my-let* ((varn exprn) ...)
                 expr))
      expr1))))

(define tests-my-let*
  (list
   (test (my-let* ((x 5) (y (+ x 7)))
                  y) 12)))
```


### 6. Управляющие конструкции.

Используя *гигиенические* макросы языка Scheme, реализуйте управляющие
конструкции, свойственные императивным языкам программирования.

#### А. Условия *when* и *unless*

Напишите макросы:

-   *(when cond? expr1 expr2 … exprn)*, который *выполняет*
    последовательность выражений *expr1 expr2 … exprn*, если условие
    *cond?* истинно.
-   *(unless cond? expr1 expr2 … exprn)*, который *выполняет*
    последовательность выражений *expr1 expr2 … exprn*, если условие
    *cond?* ложно.

Предполагается, что *when* и *unless* возвращают результат последнего
вычисленного в них выражения. *When* и *unless* могут быть вложенными.

Пример:

``` scheme
; Пусть x = 1
;
(when   (> x 0) (display "x > 0")  (newline))
(unless (= x 0) (display "x != 0") (newline))
```

В стандартный поток будет выведено:

``` example
x > 0
x != 0
```

```scheme
(define-syntax when
  (syntax-rules ()
    ((when cond? . actions)
     (if cond?
         (begin . actions)))))

(define-syntax unless
  (syntax-rules ()
    ((when cond? . actions)
     (if (not cond?)
         (begin . actions)))))
```

#### Б. Циклы *for*

Реализуйте макрос *for*, который позволит организовывать циклы с
переменной — параметром цикла. Определение должно допускать две
различных формы записи:

-   *(for x in xs expr1 expr2 … exprn)* и
-   *(for xs as x expr1 expr2 … exprn),*

где *x* — переменная, *xs* — список значений, которые должна принимать,
переменная на каждой итерации, *expr1 expr2 … exprn* —
последовательность инструкций, которые должны быть выполнены в теле
цикла.

Примеры применения:

``` scheme
(for i in '(1 2 3)
  (for j in '(4 5 6)
    (display (list i j))
    (newline)))

(for '(1 2 3) as i
  (for '(4 5 6) as j
    (display (list i j))
    (newline)))
```

```scheme
(define-syntax for
  (syntax-rules (in as)
    ((for x in xs . actions)
     (if (not (null? xs))
         (let loop ((x (car xs))
                    (new_xs (cdr xs)))
           (cond
             ((null? new_xs) (begin . actions))
             (else
              (begin
                (begin . actions)
                (loop (car new_xs) (cdr new_xs))))))))
    ((for xs as x . actions)
     (for x in xs . actions))))
```

#### В. Цикл *while*

Реализуйте макрос *while*, который позволит организовывать циклы с
предусловием:

*(while cond? expr1 expr2 … exprn)*,

где *cond?* — условие, *expr1 expr2 … exprn* — последовательность
инструкций, которые должны быть выполнены в теле цикла. Проверка условия
осуществляется перед каждой итерацией, тело цикла выполняется, если
условие выполняется. Если при входе в цикл условие не выполняется, то
тело цикла не будет выполнено ни разу.

Пример применения:

``` scheme
(let ((p 0)
      (q 0))
  (while (< p 3)
         (set! q 0)
         (while (< q 3)
                (display (list p q))
                (newline)
                (set! q (+ q 1)))
         (set! p (+ p 1))))
```

Выведет:

``` example
(0 0)
(0 1)
(0 2)
(1 0)
(1 1)
(1 2)
(2 0)
(2 1)
(2 2)
```

*Рекомендация.* Целесообразно разворачивать макрос в вызов анонимной
процедуры без аргументов со статической переменной, содержащей анонимную
процедуру с проверкой условия, рекурсивным вызовом и телом цикла. Для
краткой записи такой процедуры и ее вызова можно использовать встроенную
конструкцию *letrec*, которая аналогична *let* и <u>let\*</u>, но
допускает рекурсивные определения, например:

``` example
(letrec ((iter (lambda (i)
                 (if (= i 10)
                     '()
                     (cons i (iter (+ i 1)))))))
  (iter 0))
  => (0 1 2 3 4 5 6 7 8 9)
```

```scheme
(define-syntax while
  (syntax-rules ()
    ((while cond? . actions)
     (let loop ((continue? cond?))
       (if continue?
           (begin
             (begin . actions)
             (loop cond?)))))))
```

#### Г. Цикл *repeat..until*

Реализуйте макрос *repeat..until*, который позволит организовывать циклы
с предусловием:

*(repeat (expr1 expr2 … exprn) until cond?)*,

где *cond?* — условие, *expr1 expr2 … exprn* — последовательность
инструкций, которые должны быть выполнены в теле цикла. Проверка условия
осуществляется после каждой итерации. Если условие возвращает истину,
цикл завершается, иначе цикл выполняется снова. Таким образом, тело
цикла выполняется по меньшей мере 1 раз.

Например:

``` scheme
(let ((i 0)
      (j 0))
  (repeat ((set! j 0)
           (repeat ((display (list i j))
                    (set! j (+ j 1)))
                   until (= j 3))
           (set! i (+ i 1))
           (newline))
          until (= i 3)))
```

Выведет:

``` example
(0 0)(0 1)(0 2)
(1 0)(1 1)(1 2)
(2 0)(2 1)(2 2)
```

```scheme
(define-syntax repeat
  (syntax-rules (until)
    ((repeat (expr1 . others) until cond?)
     (let loop ()
       (begin
         (begin expr1)
         (begin . others)
         (if (not cond?)
             (loop cond?)))))))
```

#### Д. Вывод «в стиле С++»

Реализуйте макрос для последовательного вывода значений в стандартный
поток вывода вида:

``` example
(cout << "a = " << 1 << endl << "b = " << 2 << endl)
```

Здесь *cout* — имя макроса, указывающее, что будет осуществляться вывод
в консоль (от console output), символы *\<\<* разделяют значения, *endl*
означает переход на новую строку.

Данный пример выведет следующий текст:

``` example
a = 1
b = 2
```

```scheme
(define-syntax cout
  (syntax-rules (<< endl)
    ((cout << endl) (newline))
    ((count << expr) (display expr))
    ((cout << endl . actions)
     (begin
       (newline)
       (cout . actions)))
    ((cout << expr . actions)
     (begin
       (display expr)
       (cout . actions)))))
```
