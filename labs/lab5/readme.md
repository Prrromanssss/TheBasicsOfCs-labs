# Лабораторная работа №5

## Интерпретатор стекового языка программирования

### Условие задачи

Реализуйте интерпретатор стекового языка программирования, описание
которого представлено ниже. Интерпретатор должен вызываться как
процедура `(interpret program stack)` которая принимает программу на
исходном языке `program` и начальное состояние стека данных `stack` и
возвращает его состояние после вычисления программы. Программа на
исходном языке задана вектором литеральных констант, соответствующих
словам исходного языка. Исходное и конечное состояния стека данных
являются списком, голова которого соответствует вершине стека.

Примеры вызова интерпретатора (здесь и далее в примерах код на исходном
языке выделен синим цветом):

<pre>
(interpret #(   <span style="color: blue;">define abs
                  dup 0 &lt;
                  if neg endif
                end
                abs</span>    ) ; программа
           '(-9))        ; исходное состояние стека
  &#8658; (9)
</pre>

При реализации интерпретатора избегайте императивных конструкций,
используйте модель вычислений без состояний. Для хранения программы и
состояния интерпретатора **запрещается** использовать глобальные
переменные. Перечисленные ниже встроенные слова обязательны для
реализации и будут проверены сервером тестирования.

### Описание языка

Язык, интерпретатор которого следует реализовать, является
видоизмененным ограниченным подмножеством языка Forth.

В нашем языке операции осуществляются с целыми числами. Используется
постфиксная запись операторов. Все вычисления осуществляются на стеке
данных. Стек данных является глобальным. При запуске интерпретатора стек
может быть инициализирован некоторыми исходными данными или быть пустым.

Программа на исходном языке представляет собой последовательность слов.
Интерпретатор анализирует слова по очереди. Если слово является целым
числом, то оно число помещается на вершину стека данных. В противном
случае слово интерпретируется как оператор (процедура). Если в программе
уже встретилось определение этого слова (статья), то выполняется код
этого определения. В противном случае слово рассматривается как
встроенное в интерпретатор и выполняется соответствующей процедурой
интерпретатора. Затем осуществляется возврат из процедуры (переход к
слову, следующему за последним вызовом). Выполнение программы
заканчивается, когда выполнено последнее слово.

Процедуры (операторы) снимают свои аргументы с вершины стека данных и
кладут результат вычислений также на вершину стека данных.

Ввод-вывод или какое-либо взаимодействие с пользователем не
предусматривается.

Например:

<pre>
(interpret #(<span style="color: blue;">2 3 * 4 5 * +</span>) '()) &#8658; (26)
</pre>

### Встроенные слова

Ниже представлен список встроенных слов с кратким описанием их значений.
Состояние стека до и после интерпретации каждого слова показаны с
помощью схем — стековых диаграмм. Порядок, в котором элементы были
помещены в стек, отражен в индексах элементов. Например, программа:

<pre>
<span style="color: blue;">1 2 3</span>
</pre>

может быть показана стековой диаграммой () → (1 2 3)

Внимание! В нашем интерпретаторе в качестве стека используется список.
Голова этого списка является вершиной стека, поэтому вершина стека в
этих диаграммах находится слева! Такая запись отличается от традиционных
стековых диаграмм, принятых, например, в языке Forth, в которых голова
стека записывается справа.

##### 1. Арифметические операции

<table>
  <tr>
<td style="text-align: left; vertical-align: top">+</td>
<td style="text-align: left; vertical-align: top">
    (n2 n1) → (сумма)
</td>
<td style="text-align: left; vertical-align: top">Сумма n1 и n2</td>
  </tr>
  ```

  <tr>
<td style="text-align: left; vertical-align: top">−</td>

<td style="text-align: left; vertical-align: top">(n2 n1) → (разность)</td>

<td style="text-align: left; vertical-align: top">Разность: n1 − n2</td>
  </tr>

  <tr>
<td style="text-align: left; vertical-align: top">*</td>
<td style="text-align: left; vertical-align: top">
    (n2 n1) → (произведение);
</td>
<td style="text-align: left; vertical-align: top">Произведение n2 на n1</td>
  </tr>
  ```

  <tr>
<td style="text-align: left; vertical-align: top">/</td>

<td style="text-align: left; vertical-align: top">(n2 n1) → (частное)</td>

<td style="text-align: left; vertical-align: top">
    Целочисленное деление n1 на n2
</td>
  </tr>

  <tr>
<td style="text-align: left; vertical-align: top">mod</td>

<td style="text-align: left; vertical-align: top">(n2 n1) → (остаток)</td>

<td style="text-align: left; vertical-align: top">
    Остаток от деления n1 на n2
</td>
  </tr>

  <tr>
<td style="text-align: left; vertical-align: top">neg</td>

<td style="text-align: left; vertical-align: top">n → (−n)</td>

<td style="text-align: left; vertical-align: top">Смена знака числа</td>
  </tr>
</table>


##### 2. Операции сравнения

<table>
  <tr>
<td style="text-align: left; vertical-align: top">=</td>

<td style="text-align: left; vertical-align: top">(n2 n1) → (флаг)</td>

<td style="text-align: left; vertical-align: top">
    Флаг равен −1, если n1 = n2, иначе флаг равен 0
</td>
  </tr>

  <tr>
<td style="text-align: left; vertical-align: top">></td>

<td style="text-align: left; vertical-align: top">(n2 n1) → (флаг)</td>

<td style="text-align: left; vertical-align: top">
    Флаг равен −1, если n1 > n2, иначе флаг равен 0
</td>
  </tr>

  <tr>
<td style="text-align: left; vertical-align: top"><</td>

<td style="text-align: left; vertical-align: top">(n2 n1) → (флаг)</td>

<td style="text-align: left; vertical-align: top">
    Флаг равен −1, если n1 < n2, иначе флаг равен 0
</td>
  </tr>
</table>


    Таким образом, булевы значения представлены с помощью целых чисел: −1
    соответствует значению «истина», 0 — значению «ложь».

##### 3. Логические операции

<table>
  <tr>
<td style="text-align: left; vertical-align: top">not</td>
<td style="text-align: left; vertical-align: top">(n) → (результат)</td>
<td style="text-align: left; vertical-align: top">НЕ n</td>
  </tr>
  <tr>
<td style="text-align: left; vertical-align: top">and</td>

<td style="text-align: left; vertical-align: top">(n2 n1) → (результат)</td>

<td style="text-align: left; vertical-align: top">n2 И n1</td>
  </tr>

  <tr>
<td style="text-align: left; vertical-align: top">or</td>

<td style="text-align: left; vertical-align: top">(n2 n1) → (результат)</td>

<td style="text-align: left; vertical-align: top">n2 ИЛИ n1</td>
  </tr>
</table>

    Эти операции также должны давать правильный результат, если в одном
    или обеих операндах «истина» представлена любым ненулевым целым
    числом.


##### 4. Операции со стеком


    При выполнении вычислений на стеке часто возникает необходимость
    изменять порядок следования элементов, удалять значения, копировать
    их и т.д. Для этого реализуйте следующие операции:

<table>
  <tr>
<td style="text-align: left; vertical-align: top">drop</td>

<td style="text-align: left; vertical-align: top">(n1) → ()</td>

<td style="text-align: left; vertical-align: top">
Удаляет элемент на вершине стека
</td>
  </tr>

  <tr>
<td style="text-align: left; vertical-align: top">swap</td>

<td style="text-align: left; vertical-align: top">(n2 n1) → (n1 n2)</td>

<td style="text-align: left; vertical-align: top">
Меняет местами два элемента на вершине стека
</td>
  </tr>

  <tr>
<td style="text-align: left; vertical-align: top">dup</td>

<td style="text-align: left; vertical-align: top">(n1) → (n1 n1)</td>

<td style="text-align: left; vertical-align: top">
    Дублирует элемент на вершине стека
</td>
  </tr>

  <tr>
    <td style="text-align: left; vertical-align: top">over</td>

<td style="text-align: left; vertical-align: top">(n2 n1) → (n1 n2 n1)</td>

<td style="text-align: left; vertical-align: top">
    Копирует предпоследний элемент на вершину стека
</td>
  </tr>

  <tr>
    <td style="text-align: left; vertical-align: top">rot</td>

<td style="text-align: left; vertical-align: top">
    (n3 n2 n1) → (n1 n2 n3)
</td>

<td style="text-align: left; vertical-align: top">
    Меняет местами первый и третий элемент от головы стека
</td>
  </tr>

  <tr>
<td style="text-align: left; vertical-align: top">depth</td>

<td style="text-align: left; vertical-align: top">(…) → (n …)</td>

<td style="text-align: left; vertical-align: top">
    Возвращает число элементов в стеке перед своим вызовом
</td>
  </tr>
</table>


##### 5. Управляющие конструкции

<table>
  <tr>
    <td style="text-align: left; vertical-align: top">define word</td>
    <td style="text-align: left; vertical-align: top">() → ()</td>
    <td style="text-align: left; vertical-align: top">
      Начинает словарную статью — определение слова word
    </td>
  </tr>
  <tr>
<td style="text-align: left; vertical-align: top">end</td>
<td style="text-align: left; vertical-align: top">() → ()</td>
<td style="text-align: left; vertical-align: top">Завершает статью</td>
  </tr>

  <tr>
<td style="text-align: left; vertical-align: top">exit</td>

<td style="text-align: left; vertical-align: top">() → ()</td>

<td style="text-align: left; vertical-align: top">
    Завершает выполнение процедуры (кода статьи)
</td>
  </tr>

  <tr>
<td style="text-align: left; vertical-align: top">if</td>

<td style="text-align: left; vertical-align: top">(флаг) → ()</td>

<td style="text-align: left; vertical-align: top">
    Если флаг не равен 0, то выполняется код в теле if..endif, иначе
    выполнение кода до endif пропускается
</td>
  </tr>

  <tr>
<td style="text-align: left; vertical-align: top">endif</td>

<td style="text-align: left; vertical-align: top">() → ()</td>

<td style="text-align: left; vertical-align: top">Завершает тело if</td>
  </tr>
</table>


    Пусть слово define word начинает определение слова word. В теле
    определения (словарной статьи) следуют слова, которые надо
    вычислить, чтобы вычислить слово word. Статья заканчивается словом
    end. Определенное таким образом слово может быть использовано в
    программе так же, как и встроенное. Например, унарный декремент
    может быть определен, а затем использован так:

<pre>
    (interpret #(   <span style="color: blue;">define -- 1 - end
                    5 -- --</span>      ) '())
      &#8658; (3)
</pre>

    Завершить выполнение процедуры до достижения её окончания `end`
    можно с помощью слова `exit`.

    В статьях допускаются рекурсивные определения. Вложенные словарные
    статьи не допускаются.

    Конструкции if…endif не должны быть вложенными (в ЛР). В программах
    ниже даны примеры их использования.

### Примеры программ

Ниже представлены программы, которые будут выполнены сервером
тестирования с помощью вашего интерпретатора (наряду с более короткими
примерами).

<pre>
(interpret #(   <span style="color: blue;">define abs
                    dup 0 &lt;
                    if neg endif
                end
                 9 abs
                -9 abs</span>      ) (quote ()))
  &#8658; (9 9)

(interpret #(   <span style="color: blue;">define =0? dup 0 = end
                define &lt;0? dup 0 &lt; end
                define signum
                    =0? if exit endif
                    &lt;0? if drop -1 exit endif
                    drop
                    1
                end
                 0 signum
                -5 signum
                10 signum</span>       ) (quote ()))
  &#8658; (1 -1 0)

(interpret #(   <span style="color: blue;">define -- 1 - end
                define =0? dup 0 = end
                define =1? dup 1 = end
                define factorial
                    =0? if drop 1 exit endif
                    =1? if drop 1 exit endif
                    dup --
                    factorial
                    *
                end
                0 factorial
                1 factorial
                2 factorial
                3 factorial
                4 factorial</span>     ) (quote ()))
  &#8658; (24 6 2 1 1)

(interpret #(   <span style="color: blue;">define =0? dup 0 = end
                define =1? dup 1 = end
                define -- 1 - end
                define fib
                    =0? if drop 0 exit endif
                    =1? if drop 1 exit endif
                    -- dup
                    -- fib
                    swap fib
                    +
                end
                define make-fib
                    dup 0 &lt; if drop exit endif
                    dup fib
                    swap --
                    make-fib
                end
                10 make-fib</span>     ) (quote ()))
  &#8658; (0 1 1 2 3 5 8 13 21 34 55)

(interpret #(   <span style="color: blue;">define =0? dup 0 = end
                define gcd
                    =0? if drop exit endif
                    swap over mod
                    gcd
                end
                90 99 gcd
                234 8100 gcd</span>    ) '())
  &#8658; (18 9)
</pre>

### Рекомендации

В составе интерпретатора определите главную процедуру, которая будет
обрабатывать каждое слово программы. Пусть состояние интерпретатора
описывают аргументы этой процедуры: вектор слов, счетчик слов (индекс
текущего слова), стек данных, стек возвратов и словарь (ассоциативный
список).

Главная процедура классифицирует слово, на которое указывает счетчик, и
интерпретирует его как число или слово (определенное в программе или
встроенное). Встроенные слова принимают состояние интерпретатора и
возвращают его измененным согласно семантике слова.

Изменяться могут счетчик, стек данных, стек возвратов и словарь. Не
храните ни их, ни интерпретируемую программу в глобальных или
статических переменных (почему?).

Если в программе встречается определение статьи, то в словарь помещается
новое слово (ключ) и индекс первого слова в статье (значение).

При вызове такой статьи в стек возвратов помещается индекс слова,
следующего за вызовом. Он будет снят с вершины стека и возвращен в
качестве значения счетчика слов при возврате из статьи (слова `end` и
`exit`). Такой подход позволяет интерпретировать вложенные и рекурсивные
вызовы. Также в коде интерпретатора целесообразно определить словарь
соответствий слов исходного языка встроенным процедурам интерпретатора.

При необходимости организуйте отложенные вычисления. В процессе
разработки используйте юнит-тестирование.

### Решение

```scheme
 (define (interpret program stack)
  (let ((env '())
        (oper_with_stack '(+ - * /
                             mod neg drop swap
                             dup over rot and
                             = > < not or depth))
        (end (vector-length program)))
    
    (let inner ((loc_stack stack)
                (ind 0)
                (func-ignore #f)
                (return '())
                (if-ignore #f))
      (if (equal? ind end)
          loc_stack
          (let* ((current_symb (vector-ref program ind))
                 (new_stack (if (and (equal? func-ignore #f) (equal? if-ignore #f))
                                (case current_symb
                                  ('+ (+$ loc_stack))
                                  ('- (-$ loc_stack))
                                  ('* (*$ loc_stack))
                                  ('/ (/$ loc_stack))
                                  ('mod (mod$ loc_stack))
                                  ('neg (neg$ loc_stack))
                                  ('drop (drop$ loc_stack))
                                  ('swap (swap$ loc_stack))
                                  ('dup (dup$ loc_stack))
                                  ('over (over$ loc_stack))
                                  ('rot (rot$ loc_stack))
                                  ('depth (depth$ loc_stack))
                                  ('and (and$ loc_stack))
                                  ('or (or$ loc_stack))
                                  ('not (not$ loc_stack))
                                  ('= (=$ loc_stack))
                                  ('> (>$ loc_stack))
                                  ('< (<$ loc_stack))
                                  (else loc_stack)) loc_stack)))
            (cond
              ;; end of definition of the article
              ((and (null? return) (equal? current_symb 'end))
               (inner new_stack (+ ind 1) #f return if-ignore))
              
              ;; end of execution of the article and return up the call stack
              ((and (not (null? return)) (equal? current_symb 'end))
               (inner new_stack (car return) #f (cdr return) if-ignore))
              
              ;; definition of the article so ignoring the program
              ((equal? func-ignore #t)
               (inner new_stack (+ ind 1) func-ignore return if-ignore))
              
              ;; end of if-statement
              ((equal? current_symb 'endif)
               (inner new_stack (+ ind 1) func-ignore return #f))
              
              ;; if-statement is false so ignoring the program
              ((equal? if-ignore #t)
               (inner new_stack (+ ind 1) func-ignore return if-ignore))
              
              ;; exit is outside the articles so we are completing the program
              ((and (null? return) (equal? current_symb 'exit))
               (inner new_stack end func-ignore return if-ignore))
              
              ;; exit is in the articles so we are moving up the call stack
              ((and (not (null? return)) (equal? current_symb 'exit))
               (inner new_stack (car return) func-ignore (cdr return) if-ignore))
              
              ;; symbol is a number so it add to stack
              ((number? current_symb)
               (inner (cons current_symb loc_stack) (+ ind 1) func-ignore return if-ignore))
              
              ;; check if term is an operation with stack
              ((my-element? current_symb oper_with_stack)
               (inner new_stack (+ ind 1) func-ignore return if-ignore))
              
              ;; definition of the article 
              ((equal? current_symb 'define)
               (begin
                 (set! env
                       (append env
                               (cons
                                (cons (vector-ref program (+ ind 1))
                                      (cons (+ ind 2) '())) '())))
                 (inner new_stack (+ ind 1) #t return if-ignore)))
              
              ;; executing previously defined  article
              ((assoc current_symb env)
               (inner new_stack (cadr (assoc current_symb env)) func-ignore (cons (+ ind 1) return) if-ignore))
              
              ;; if-statement
              ((equal? current_symb 'if)
               (if (not (equal? (car loc_stack) 0))
                   (inner (cdr new_stack) (+ ind 1) func-ignore return if-ignore)
                   (inner (cdr new_stack) (+ ind 1) func-ignore return #t)))))))))


;; Arithmetic operations

(define (+$ stack)
  (cons (+ (cadr stack) (car stack)) (cddr stack)))

(define (-$ stack)
  (cons (- (cadr stack) (car stack)) (cddr stack)))

(define (*$ stack)
  (cons (* (cadr stack) (car stack)) (cddr stack)))

(define (/$ stack)
  (if (< (cadr stack) (car stack))
      (cons 0 (cddr stack))
      (cons (/ (cadr stack) (car stack)) (cddr stack))))

(define (mod$ stack)
  (cons (remainder (cadr stack) (car stack)) (cddr stack)))

(define (neg$ stack)
  (cons (- (car stack)) (cdr stack)))


;; Comparison Operations

(define (=$ stack)
  (if (= (cadr stack) (car stack))
      (cons -1 (cddr stack))
      (cons 0 (cddr stack))))

(define (>$ stack)
  (if (> (cadr stack) (car stack))
      (cons -1 (cddr stack))
      (cons 0 (cddr stack))))

(define (<$ stack)
  (if (< (cadr stack) (car stack))
      (cons -1 (cddr stack))
      (cons 0 (cddr stack))))


;; Logical operations

(define (not$ stack)
  (if (= (car stack) 0)
      (cons -1 (cdr stack))
      (cons 0 (cdr stack))))

(define (and$ stack)
  (if (and (not (= (car stack) 0)) (not (= (cadr stack) 0)))
      (cons -1 (cddr stack))
      (cons 0 (cddr stack))))

(define (or$ stack)
  (if (or (not (= (car stack) 0)) (not (= (cadr stack) 0)))
      (cons -1 (cddr stack))
      (cons 0 (cddr stack))))


;; Stack Operations

(define (drop$ stack)
  (cdr stack))

(define (swap$ stack)
  (cons (cadr stack)
        (cons (car stack)
              (cddr stack))))

(define (dup$ stack)
  (cons (car stack) stack))

(define (over$ stack)
  (cons (cadr stack) stack))

(define (rot$ stack)
  (cons (caddr stack)
        (cons (cadr stack)
              (cons (car stack)
                    (cdddr stack)))))

(define (depth$ stack)
  (length stack))

  
(define (my-element? x xs)
  (cond
    ((null? xs) #f)
    ((equal? x (car xs)) #t)
    (else (my-element? x (cdr xs)))))
```

### Тесты

```scheme
(load "../lab3/lab3.scm")

(define tests
  (list (test (interpret #(1) '()) '(1))
        (test (interpret #(1 2) '(10)) '(2 1 10))
        (test (interpret #(1 2 +) '(10)) '(3 10))
        (test (interpret #(1 2 -) '(10)) '(-1 10))
        (test (interpret #(1 2 *) '(10)) '(2 10))
        (test (interpret #(1 2 /) '(10)) '(0 10))
        (test (interpret #(1 2 mod) '(10)) '(1 10))
        (test (interpret #(1 2 neg) '(10)) '(-2 1 10))
        (test (interpret #(2 3 * 4 5 * +) '()) '(26))
        (test (interpret #(10 10 =) '()) '(-1))
        (test (interpret #(10 0 >) '()) '(-1))
        (test (interpret #(0 10 <) '()) '(-1))
        (test (interpret #(10 5 =) '()) '(0))
        (test (interpret #(0 10 >) '()) '(0))
        (test (interpret #(10 0 <) '()) '(0))
        (test (interpret #(0 0 and) '()) '(0))
        (test (interpret #(1000 7 -) '()) '(993))
        (test (interpret #(100 100 and) '()) '(-1))
        (test (interpret #(100 0 or) '()) '(-1))
        (test (interpret #(100 not) '()) '(0))
        (test (interpret #(0 not) '()) '(-1))
        (test (interpret #(define -- 1 - exit end) '()) '())
        (test (interpret #(define -- 1 - end
                            5 -- --)
                         '())
              '(3))
        (test (interpret #(10 15 +
                              define -- 1 - end
                              exit
                              5 -- --)
                         '())
              '(25))
        (test (interpret #(10 15 +
                              define -- exit 1 - end
                              5 -- --)
                         '())
              '(5 25))
        (test (interpret #(10 4 dup) '()) '(4 4 10))
        (test (interpret #(define abs
                            dup 0 <
                            if neg endif
                            end
                            9 abs
                            -9 abs
                            10 abs
                            -10 abs)
                         '())
              '(10 10 9 9))
        (test (interpret #(define =0? dup 0 = end
                            define <0? dup 0 < end
                            define signum
                            =0? if exit endif
                            <0? if drop -1 exit endif
                            drop
                            1
                            end
                            0 signum
                            -5 signum
                            10 signum)
                         '())
              '(1 -1 0))
        (test (interpret #(define -- 1 - end
                            define =0? dup 0 = end
                            define =1? dup 1 = end
                            define factorial
                            =0? if drop 1 exit endif
                            =1? if drop 1 exit endif
                            dup --
                            factorial
                            *
                            end
                            0 factorial
                            1 factorial
                            2 factorial
                            3 factorial
                            4 factorial)
                         '())
              '(24 6 2 1 1))
        (test (interpret #(define =0? dup 0 = end
                            define =1? dup 1 = end
                            define -- 1 - end
                            define fib
                            =0? if drop 0 exit endif
                            =1? if drop 1 exit endif
                            -- dup
                            -- fib
                            swap fib
                            +
                            end
                            define make-fib
                            dup 0 < if drop exit endif
                            dup fib
                            swap --
                            make-fib
                            end
                            10 make-fib)
                         '())
              '(0 1 1 2 3 5 8 13 21 34 55))
        (test (interpret #(define =0? dup 0 = end
                            define gcd
                            =0? if drop exit endif
                            swap over mod
                            gcd
                            end
                            90 99 gcd
                            234 8100 gcd)
                         '())
              '(18 9))
        (test (interpret #(define =0? dup 0 = end =0?) '(0)) '(-1 0))
        (test (interpret #(define =0? dup 0 = end
                            define kek 0 =0? end
                            kek)
                         '())
              '(-1 0))))

(run-tests tests)
```
