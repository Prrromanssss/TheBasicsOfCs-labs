# Домашнее задание №5

Нужно дополнить интерпретатор как минимум тремя из описанных ниже
конструкций на выбор студента. За каждое выполненное расширение
(с отдельным подзаголовком) ставится по одному баллу.

Все расширения интерпретатора опциональны. Чтобы тестирующий бот смог
проверить корректность расширения, в исходный текст программы
(в произвольное место, кроме комментария) нужно добавить символ с именем
`feature-***`. Это можно сделать например так:

``` scheme
(define feature-nested-if #t)
```

или так:

``` scheme
'feature-nested-if
```

или даже так:

``` scheme
(define feature-nested-if
  (list (test (interpret #(0 if 1 if 2 endif 3 endif 4) '()) '(4))
        (test (interpret #(1 if 2 if 3 endif 4 endif 5) '()) '(5 4 3))))

(run-tests feature-nested-if)
```

Имена расширений указаны в скобках в подзаголовках.

В комментариях символы `feature-***` будут проигнорированы.

## `if` с альтернативной веткой (`feature-if-else`)

Предлагается добавить ветку `else` к оператору `if`. Примеры:

``` scheme
(interpret #(1 if 100 else 200 endif) '())       →  '(100)
(interpret #(0 if 100 else 200 endif) '())       →  '(200)
```

## Вложенные `if` (`feature-nested-if`)

Внутри оператора `if … endif` допустимы вложенные операторы
`if … endif`. Примеры:

``` scheme
(interpret #(0 if 1 if 2 endif 3 endif 4) '())   →  '(4)
(interpret #(1 if 2 if 3 endif 4 endif 5) '())   →  '(5 4 3)
(interpret #(1 if 0 if 2 endif 3 endif 4) '())   →  '(4 3)
```

## Цикл с предусловием `while … wend` (`feature-while-loop`)

Слово `while` работает аналогично слову `if`:

-   снимается со стека число,
-   если снятое число `0= --- передаёт управление на оператор, следующий
     за =wend`,
-   иначе — передаёт управление внутрь тела цикла.

Слово `wend` передаёт управление на предшествующее слово `while`.

Таким образом, цикл продолжается до тех пор, пока слово `while`
не снимет со стека `0`.

Примеры:

``` scheme
(interpret #(while wend) '(3 7 4 0 5 9))         → '(5 9)

(interpret #(define sum
               dup
               while + swap dup wend
               drop
             end
             1 2 3 0 4 5 6 sum)
           '())                                  → '(15 3 2 1)

(interpret #(define power2
               1 swap dup
               while
                 swap 2 * swap 1 - dup
               wend
               drop
             end
             5 power2 3 power2 power2) '())      → '(256 32)
```

Цикл должен допускать вложение, если реализован вложенный `if`.

## Цикл с постусловием `repeat … until` (`feature-repeat-loop`)

Слово `repeat` ничего не делает.

Слово `until` снимает со стека число. Если оно нулевое, управление
передаётся на предшествующее слово `repeat`, иначе — на следующую
инструкцию.

Таким образом, цикл делает всегда как минимум одну итерацию.

Если реализован вложенный `if`, цикл `repeat … until` также должен
допускать вложение.

## Цикл с параметром `for … next` (`feature-for-loop`)

Цикл `for` в FORTH вызывается, как правило, так:

``` example
for … next : ... ‹от› ‹до›  →  ...
```

Т.е. цикл снимает со стека два числа `‹от›` и =‹до›= и повторяет тело
цикла для всех чисел в диапазоне `‹от›`…=‹до›= включительно, т.е. =‹до›
− ‹от› + 1= раз.

Внутри цикла можно пользоваться словом `i`, которое кладёт на стек
текущее значение счётчика цикла. (Вне цикла результат работы этого слова
не определён.)

Текущее и конечное значение счётчика цикла рекомендуется хранить
на стеке возвратов (см. книжку [Баранова
и Ноздрунова](https://archive.org/details/Baranov.Forth.language.and.its.implementation/mode/2up)).
Таким образом, внутри цикла `for … next` нельзя будет использовать слово
`exit`.

Слово `for` снимает со стека данных и кладёт на стек возвратов значения
`‹до›` (подвершина стека возвратов) и =‹от›= (вершина стека возвратов).

Слово `i` кладёт на стек данных содержимое верхушки стека возвратов,
стек возвратов не меняется.

Слово `next` декрементирует вершину стека возвратов и сравнивает её
с подвершиной:

-   если вершина меньше подвершины, то оба значения удаляются из стека
    возвратов, управление передаётся слову, следующему за =next=,
-   иначе управление передаётся на слово, следующее за предшествующим
    `for`.

Цикл `for … next` вложенным можно не реализовывать. (В реализациях FORTH
во вложенных циклах со счётчиком слово `j` позволяет получить значение
счётчика внешнего цикла.)

Пример.

``` scheme
(interpret #(define fact
               1 1 rot for i * next
             end
             6 fact 10 fact)
           '())                                  →  (3628800 720)
```

Вместо стека возвратов можно создать третий стек специально для цикла
`for … next`.

## Операторы `break` и =continue= (`feature-break-continue`)

(Один балл за оба.)

Слово `break` прерывает выполнение цикла — выполняет переход на слово,
следующее за словом-окончанием цикла (`wend`, `repeat` или =next=).

Слово `continue` завершает текущую итерацию цикла — выполняет переход
на слово-окончание цикла (`wend`, `repeat` или `next`).

## Конструкция `switch`-`case` (`feature-switch-case`)

**Синтаксис:**

``` example
switch
…
case ‹КОНСТ1›  … exitcase …
…
case ‹КОНСТn›  … exitcase …
…
endswitch
```

После слова `case` должна располагаться целочисленная константа.

**Семантика** идентична семантике `switch` в Си.

-   Слово `switch` снимает со стека число, ищет метку `case` с заданной
    константой (если нашлось несколько меток с одинаковой константой,
    поведение не определено) и переходит на неё. Если константа
    не найдена, осуществляется переход на слово после `endswitch`.
-   Слово `case` осуществляет переход на слово после метки.
-   Слово `exitcase` осуществляет переход на слово после `endswitch`.
-   Слово `endswitch` ничего не делает.

Таким образом, слово `exitcase` эквивалентно `break` внутри `switch`
в Си, через метки, как и в Си, можно «проваливаться».

Аналог метки `default` можно не реализовывать. Вложенные `switch` тоже
можно не реализовывать.

## Статьи высшего порядка — косвенный вызов и лямбды

(`feature-hi-level`)

Предлагается добавить в интерпретатор поддержку статей высшего порядка,
аналог функций/процедур высшего порядка в других языках
программирования.

**Синтаксис и семантика.**

-   Слово `& ‹имя›` требует после себя имя статьи, определённой
    пользователем, при выполнении оставляет на стеке данных адрес
    статьи — номер слова, на который выполнился бы переход при обычном
    вызове слова. Адрес встроенной статьи получить нельзя.

-   `lam … endlam` определяет безымянную статью:

    -   `lam` помещает на стек данных адрес слова, следующего за словом
        `lam` и осуществляет переход на слово, следующее за =endlam=,
    -   `endlam` снимает адрес со стека возвратов и осуществляет на него
        переход — аналогично словам `end` и =exit=.

-   `apply= --- снимает со стека данных адрес статьи и осуществляет её
     вызов --- кладёт на стек возвратов номер слова, следующего за =apply`
    и осуществляет переход на слово, снятое со стека данных.

Пример. Слово `power` применяет функцию указанное количество раз:

``` scheme
(interpret #(define power
               ; power : x λ n ≡ λ(λ(λ…λ(x)…)) (n раз)
               dup 0 = if drop drop exit endif
               rot                               ; n  λ  x
               over                              ; n  λ  x  λ
               apply                             ; n  λ  x′
               over                              ; x′ λ  n
               1 -                               ; x′ λ  n−1
               power                             ; рекурсивный вызов
             end
             define square dup * end
             3 & square 3 power                  ; ((3²)²)² = 6561
             2 lam dup dup * * endlam 2 power    ; (2³)³ = 512
            )
           '())                                  →  (6561 512)
```

Безымянные статьи `lam … endlam` могут быть вложенными.

## Хвостовая рекурсия (`feature-tail-call`)

Слово `tail ‹имя›` осуществляет вызов определённого пользователем слова
`‹имя›` без помещения адреса следующего слова на стек возвратов. Таким
образом, остаток предыдущей статьи игнорируется (на него возврата
не будет), вызов `tail ‹имя›` в некотором смысле эквивалентен `goto`,
где роль метки играет определение статьи.

Поведение `tail ‹имя›` эквивалентно `‹имя› exit` с единственным
отличием, что первое не заполняет стек возвратов.

Пример.

``` scheme
(interpret #(define F 11 22 33 tail G 44 55 end
             define G 77 88 99 end
             F)
           '())                                  → (99 88 77 33 22 11)
(interpret #(define =0? dup 0 = end
             define gcd
                 =0? if drop exit endif
                 swap over mod
                 tail gcd
             end
             90 99 gcd
             234 8100 gcd) '())                  → (18 9)
```

## Глобальные переменные (`feature-global`)

-   Определение переменной выглядит как
    `defvar ‹имя› ‹начальное значение›`, при выполнении `defvar`
    определяется слово `‹имя›`, которое кладёт на стек текущее значение
    переменной.
-   Запись в переменную осуществляется словом `set ‹имя›`, слово `set`
    снимает со стека число и присваивает его переменной с заданным
    именем.

Пример.

``` scheme
(interpret #(defvar counter 0
             define next
               counter dup 1 + set counter
             end
             counter counter
             counter counter +
             counter counter *)
           '())                                  → (42 5 1 0)
```

``` scheme
(load "../../labs/lab3/lab3.scm")

(define feature-if-else #t)
(define feature-while-loop #t)
(define feature-break-continue #t)


(define (interpret program stack)
  (let ((env '())
        (oper_with_stack '(+ - * /
                             mod neg drop swap
                             dup over rot and
                             = > < not or depth))
        (end (vector-length program))
        (func-ignore #f)
        (if-ignore #f)
        (while-ignore #f))
    
    (let inner ((loc_stack stack)
                (ind 0)
                (return '()))
      (if (equal? ind end)
          loc_stack
          (let* ((current_symb (vector-ref program ind))
                 (new_stack (if (and
                                 (equal? func-ignore #f)
                                 (equal? if-ignore #f)
                                 (equal? while-ignore #f))
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
               (set! func-ignore #f)
               (inner new_stack (+ ind 1) return))
              
              ;; end of execution of the article and return up the call stack
              ((and (not (null? return)) (equal? current_symb 'end))
               (set! func-ignore #f)
               (inner new_stack (car return) (cdr return)))
              
              ;; definition of the article so ignoring the program
              ((equal? func-ignore #t)
               (inner new_stack (+ ind 1) return))

              ;; first while-statement is false or break operator has worked
              ((and
                (equal? current_symb 'wend)
                (equal? while-ignore #t))
               (set! while-ignore #f)
               (inner new_stack (+ ind 1) return))
              
              ;; if true while statement repeat loop
              ((and
                (equal? current_symb 'wend)
                (equal? if-ignore #f))
               (if (not (equal? (car loc_stack) 0))
                   (inner (cdr new_stack) (car return) return)
                   (inner (cdr new_stack) (+ ind 1) (cdr return))))

              ;; while-statement is false so ignoring the program
              ((equal? while-ignore #t)
               (inner new_stack (+ ind 1) return))
              
              ;; end of if-statement
              ((equal? current_symb 'endif)
               (set! if-ignore #f)
               (inner new_stack (+ ind 1) return))

              ;; executing else-statement
              ((and (equal? current_symb 'else) (equal? if-ignore #t))
               (set! if-ignore #f)
               (inner new_stack (+ ind 1) return))

              ;; ignoring else-statement 'cause if-statement has already worked
              ((and (equal? current_symb 'else) (equal? if-ignore #f))
               (set! if-ignore #t)
               (inner new_stack (+ ind 1) return))
              
              ;; if-statement is false so ignoring the program
              ((equal? if-ignore #t)
               (inner new_stack (+ ind 1) return))
              
              ;; exit is outside the articles so we are completing the program
              ((and (null? return) (equal? current_symb 'exit))
               (inner new_stack end return))
              
              ;; exit is in the articles so we are moving up the call stack
              ((and (not (null? return)) (equal? current_symb 'exit))
               (inner new_stack (car return) (cdr return)))
              
              ;; symbol is a number so it is added to stack
              ((number? current_symb)
               (inner (cons current_symb loc_stack) (+ ind 1) return))
              
              ;; check if term is an operation with stack
              ((my-element? current_symb oper_with_stack)
               (inner new_stack (+ ind 1) return))
              
              ;; definition of the article 
              ((equal? current_symb 'define)
               (set! func-ignore #t)
               (set! env
                     (append env
                             (cons
                              (cons (vector-ref program (+ ind 1))
                                    (cons (+ ind 2) '())) '())))
               (inner new_stack (+ ind 1) return))
              
              ;; executing previously defined  article
              ((assoc current_symb env)
               (inner new_stack (cadr (assoc current_symb env))
                      (cons (+ ind 1) return)))
              
              ;; if-statement
              ((equal? current_symb 'if)
               (if (not (equal? (car loc_stack) 0))
                   (inner (cdr new_stack) (+ ind 1) return)
                   (begin
                     (set! if-ignore #t)
                     (inner (cdr new_stack) (+ ind 1) return))))

              ;; while ... wend
              ((equal? current_symb 'while)
               (if (not (equal? (car loc_stack) 0))
                   (inner (cdr new_stack) (+ ind 1) (cons (+ ind 1) return))
                   (begin
                     (set! while-ignore #t)
                     (inner (cdr new_stack) (+ ind 1) return))))

              ;; break operator
              ((equal? current_symb 'break)

               (set! while-ignore #t)
               (inner new_stack (+ ind 1) return))

              ;; continue operator
              ((equal? current_symb 'continue)
               (if (not (equal? (car loc_stack) 0))
                   (inner (cdr new_stack) (car return) return)
                   (begin
                     (set! while-ignore #t)
                     (inner (cdr new_stack) (+ ind 1) return))))))))))


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
  (cons (length stack) stack))

  
(define (my-element? x xs)
  (cond
    ((null? xs) #f)
    ((equal? x (car xs)) #t)
    (else (my-element? x (cdr xs)))))


;; Testing
(define tests
  (list
   (test (interpret #() '()) '())
        (test (interpret #(1 2 3) '(7 8 9)) '(3 2 1 7 8 9))
        (test (interpret #(+) '(5 7)) '(12))
        (test (interpret #(-) '(4 14)) '(10))
        (test (interpret #(*) '(21 2)) '(42))
        (test (interpret #(/) '(7 42)) '(6))
        (test (interpret #(mod) '(7 40)) '(5))
        (test (interpret #(neg) '(77)) '(-77))
        (test (interpret #(=) '(13 32)) '(0))
        (test (interpret #(=) '(11 11)) '(-1))
        (test (interpret #(>) '(13 32)) '(-1))
        (test (interpret #(>) '(11 11)) '(0))
        (test (interpret #(>) '(32 13)) '(0))
        (test (interpret #(<) '(13 32)) '(0))
        (test (interpret #(<) '(11 11)) '(0))
        (test (interpret #(<) '(32 13)) '(-1))
        (test (interpret #(not) '(0)) '(-1))
        (test (interpret #(not) '(-1)) '(0))
        (test (interpret #(not) '(77)) '(0))
        (test (interpret #(and) '(-1 -1)) '(-1))
        (test (interpret #(and) '(12 34)) '(-1))
        (test (interpret #(and) '(12 0)) '(0))
        (test (interpret #(and) '(0 34)) '(0))
        (test (interpret #(and) '(0 0)) '(0))
        (test (interpret #(or) '(-1 -1)) '(-1))
        (test (interpret #(or) '(12 34)) '(-1))
        (test (interpret #(or) '(12 0)) '(-1))
        (test (interpret #(or) '(0 34)) '(-1))
        (test (interpret #(or) '(0 0)) '(0))
        (test (interpret #(drop) '(2 3 5 7 11)) '(3 5 7 11))
        (test (interpret #(swap) '(2 3 5 7 11)) '(3 2 5 7 11))
        (test (interpret #(dup) '(2 3 5 7 11)) '(2 2 3 5 7 11))
        (test (interpret #(over) '(2 3 5 7 11)) '(3 2 3 5 7 11))
        (test (interpret #(rot) '(2 3 5 7 11)) '(5 3 2 7 11))
        (test (interpret #(depth) '(2 3 5 7 11)) '(5 2 3 5 7 11))
        (test (interpret #(depth) '()) '(0))
        (test (interpret #(define square dup * end square) '(11)) '(121))
        (test (interpret #(define x 1 2 exit 3 4 end x) '()) '(2 1))
        (test (interpret #(if 1 2 3 endif 4 5 6) '(0)) '(6 5 4))
        (test (interpret #(if 1 2 3 endif 4 5 6) '(-1)) '(6 5 4 3 2 1))
        (test (interpret #(if 1 2 3 endif 4 5 6) '(77)) '(6 5 4 3 2 1))
        (test (interpret #(1) '()) '(1))
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
              '(-1 0))
        (test (interpret #(1 if 100 else 200 endif) '())
              '(100))
        (test (interpret #(0 if 100 else 200 endif) '())
              '(200))
        (test (interpret #(while wend) '(3 7 4 0 5 9))
              '(5 9))
        (test (interpret #(define sum
                            dup
                            while + swap dup wend
                            drop
                            end
                            1 2 3 0 4 5 6 sum)
                         '())
              '(15 3 2 1))
        (test (interpret #(define power2
                            1 swap dup
                            while
                            swap 2 * swap 1 - dup
                            wend
                            drop
                            end
                            5 power2 3 power2 power2) '())
              '(256 32))
        (test (interpret #(0 while 9 if 100 else 200 endif wend) '())
              '())
        (test (interpret #(1 while 1 if 100 endif 0 wend) '())
              '(100))
        (test (interpret #(1 while 0 if 100 else 200 endif 0 wend) '())
              '(200))
        (test (interpret #(1 if
                             5 1 swap dup
                             while
                             swap 2 * swap 1 - dup
                             wend
                             drop
                             else 200
                             endif) '())
              '(32))
        (test (interpret #(0 if
                             200
                             else
                             5 1 swap dup
                             while
                             swap 2 * swap 1 - dup
                             wend
                             drop
                             endif) '())
              '(32))
        (test (interpret #(0 swap dup
                             while
                             dup 3 =
                             if break endif
                             swap 1000 * over + swap 2 - dup 0 >
                             wend
                             drop) '(15))
              '(15013011009007005))
        (test (interpret #(0 swap dup
                             while
                             dup 3 = if break endif
                             swap 1000 * over +
                             swap 2 -
                             dup
                             wend
                             drop)
                         '(14))
              '(14012010008006004002))
        (test (interpret #(0 swap dup
                             while
                             dup 2 mod if 1 - dup continue endif
                             swap 1000 * over +
                             swap 1 -
                             dup
                             wend
                             drop)
                         '(15))
              '(14012010008006004002))
        (test (interpret #(0 swap dup
                             while
                             dup 2 mod if 1 - dup continue endif
                             swap 1000 * over +
                             swap 1 -
                             dup
                             wend
                             drop)
                         '(14))
              '(14012010008006004002))))

;; (run-tests tests)
```