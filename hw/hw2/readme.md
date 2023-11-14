# Домашнее задание №2

При выполнении заданий **не используйте** присваивание, циклы
и обращение к элементам последовательности по индексу. Избегайте
возврата логических значений из условных конструкций. Подготовьте
примеры для демонстрации работы разработанных вами процедур.

## 1. Обработка списков

Определите следующие процедуры для обработки списков:

-   Процедуру `(my-range a b d)`, возвращающую список чисел в интервале
    `[a, b)` с шагом `d`.
-   Процедуру `my-flatten`, раскрывающую вложенные списки.
-   Предикат `(my-element? x xs)`, проверяющий наличие элемента `x`
    в списке `xs`. Рекомендация: для проверки равенства элементов
    используйте встроенный предикат `equal?`.
-   Предикат `(my-filter pred? xs)`, возвращающий список только тех
    элементов списка `xs`, которые удовлетворяют предикату `pred?`.
-   Процедуру `(my-fold-left op xs)` для левоассоциативной свертки
    списка `xs` с помощью оператора (процедуры двух аргументов) `op`.
-   Процедуру `(my-fold-right op xs)` для правоассоциативной свертки
    списка `xs` с помощью оператора (процедуры двух аргументов) `op`.

Примеры вызова процедур:

``` example
(my-range  0 11 3) ⇒ (0 3 6 9)

(my-flatten '((1) 2 (3 (4 5)) 6)) ⇒ (1 2 3 4 5 6)

(my-element? 1 '(3 2 1)) ⇒ #t
(my-element? 4 '(3 2 1)) ⇒ #f

(my-filter odd? (my-range 0 10 1))
  ⇒ (1 3 5 7 9)
(my-filter (lambda (x) (= (remainder x 3) 0)) (my-range 0 13 1))
  ⇒ (0 3 6 9 12)

(my-fold-left  quotient '(16 2 2 2 2)) ⇒ 1
(my-fold-left  quotient '(1))          ⇒ 1
(my-fold-right expt     '(2 3 4))      ⇒ 2417851639229258349412352
(my-fold-right expt     '(2))          ⇒ 2
```

``` scheme
;; 1
(define (my-range a b d)
  (if (>= a b)
      '()
      (cons a (my-range (+ a d) b d))))

;; 2
(define (my-flatten xs)
  (cond
    ((null? xs) '())
    ((list? xs) (append (my-flatten (car xs)) (my-flatten (cdr xs))))
    (else (list xs)) ))

;; 3
(define (my-element? x xs)
  (cond
    ((null? xs) #f)
    ((equal? x (car xs)) #t)
    (else (my-element? x (cdr xs)))))

;; 4
(define (my-filter pred? xs)
  (let loop ((new_xs '())
             (xs xs))
    (cond
      ((null? xs) new_xs)
      ((not (pred? (car xs))) (loop new_xs (cdr xs)))
      (else (loop (append new_xs (cons (car xs) '())) (cdr xs))))))

;; 5
(define (my-fold-left op xs)
  (let my-fold-left-reverse ((op op)
                             (xs (reverse xs)))
    (if (null? (cdr xs))
        (car xs)
        (op (my-fold-left-reverse op (cdr xs)) (car xs)))))

;; 6
(define (my-fold-right op xs)
  (if (null? (cdr xs))
      (car xs)
      (op (car xs) (my-fold-right op (cdr xs)))))


(newline)
(display (my-range 0 11 3))
(newline)
(display (my-range (- 10) 10 1))
(newline)
(newline)

(display (my-flatten '((1) 2 (3 (4 5)) 6)))
(newline)
(display (my-flatten '()))
(newline)
(display (my-flatten 1))
(newline)
(display (my-flatten '(1 2 (3))))
(newline)
(display (my-flatten '(() 1 () 3)))
(newline)
(newline)

(display (my-element? 1 '(3 2 1)))
(newline)
(display (my-element? 4 '(3 2 1)))
(newline)
(newline)

(display (my-filter odd? (my-range 0 10 1)))
(newline)
(display (my-filter (lambda (x) (= (remainder x 3) 0)) (my-range 0 13 1)))
(newline)
(newline)

(display (my-fold-left  quotient '(16 2 2 2 2)))
(newline)
(display (my-fold-left  quotient '(1)))
(newline)
(newline)

(display (my-fold-right expt '(2 3 4)))
(newline)
(display (my-fold-right expt '(2)))
(newline)
```

## 2. Множества

Реализуйте библиотеку процедур для работы со множествами (для хранения
множеств используйте списки):

-   Процедуру `(list->set xs)`, преобразующую список `xs` в множество.
-   Предикат `(set? xs)`, проверяющий, является ли список `xs`
    множеством.
-   Процедуру `(union xs ys)`, возвращающую объединение множеств `xs`
    и =ys=.
-   Процедуру `(intersection xs ys)`, возвращающую пересечение множеств
    `xs` и =ys=.
-   Процедуру `(difference xs ys)`, возвращающую разность множеств `xs`
    и `ys`.
-   Процедуру `(symmetric-difference xs ys)`, возвращающую симметричную
    разность множеств `xs` и `ys`.
-   Предикат `(set-eq? xs ys)`, проверяющий множества `xs` и =ys=
    на равенство друг другу.
-   Примеры вызова процедур (порядок элементов множества не
    существенен):

``` example
(list->set '(1 1 2 3))                       ⇒ (3 2 1)
(set? '(1 2 3))                              ⇒ #t
(set? '(1 2 3 3))                            ⇒ #f
(set? '())                                   ⇒ #t
(union '(1 2 3) '(2 3 4))                    ⇒ (4 3 2 1)
(intersection '(1 2 3) '(2 3 4))             ⇒ (2 3)
(difference '(1 2 3 4 5) '(2 3))             ⇒ (1 4 5)
(symmetric-difference '(1 2 3 4) '(3 4 5 6)) ⇒ (6 5 2 1)
(set-eq? '(1 2 3) '(3 2 1))                  ⇒ #t
(set-eq? '(1 2) '(1 3))                      ⇒ #f
```

``` scheme
(define (count x xs)
  (let loop ((i 0)
             (xs xs))
    (cond
      ((null? xs) i)
      ((equal? x (car xs)) (loop (+ i 1) (cdr xs)))
      (else (loop i (cdr xs))))))

;; 1
(define (list->set xs)
  (let loop ((new_xs '())
             (xs xs))
    (cond
      ((null? xs) new_xs)
      ((> (count (car xs) xs) 1) (loop new_xs (cdr xs)))
      (else (loop (append new_xs (cons (car xs) '())) (cdr xs))))))

;; 2
(define (set? xs)
  (cond
    ((null? xs) #t)
    ((> (count (car xs) xs) 1) #f)
    (else (set? (cdr xs)))))

;; 3
(define (union xs ys)
  (let loop ((new '())
             (xs xs)
             (ys ys))
    (cond
      ((null? xs) (list->set (append ys new)))
      ((null? ys) (list->set (append xs new)))
      (else
       (loop (cons (car ys) (cons (car xs) new))
             (cdr xs) (cdr ys))))))

;; 4
(define (intersection xs ys)
  (let loop ((new '())
             (xs xs))
    (cond
      ((null? xs) (list->set new))
      ((my-element? (car xs) ys)
       (loop (cons (car xs) new) (cdr xs)))
      (else (loop new (cdr xs))))))

;; 5
(define (difference xs ys)
  (let loop ((new '())
             (xs xs))
    (cond
      ((null? xs) (list->set new))
      ((not (my-element? (car xs) ys))
       (loop (cons (car xs) new) (cdr xs)))
      (else (loop new (cdr xs))))))

;; 6
(define (symmetric-difference xs ys)
  (let loop ((new '())
             (xs xs)
             (ys ys))
    (cond
      ((null? xs) (list->set (append ys new)))
      ((null? ys) (list->set (append xs new)))
      ((not (my-element? (car xs) ys))
       (loop (cons (car xs) new) (cdr xs) ys))
      ((not (my-element? (car ys) xs))
       (loop (cons (car ys) new) xs (cdr ys)))
      (else (loop new (cdr xs) (cdr ys))))))
      
;; 7
(define (set-eq? xs ys)
  (let loop ((new_xs xs)
             (new_ys ys))
    (cond
      ((and (null? new_xs) (null? new_ys)) #t)
      ((and (null? new_xs) (not (null? new_ys))) #f)
      ((and (not (null? new_xs)) (null? new_ys)) #f)
      ((not (my-element? (car new_xs) ys)) #f)
      ((not (my-element? (car new_ys) xs)) #f)
      (else (loop (cdr new_xs) (cdr new_ys))))))


(newline)
(display (list->set '(1 1 2 3)))
(newline)

(newline)
(display (set? '(1 2 3)))
(newline)
(display (set? '(1 2 3 3)))
(newline)
(display (set? '()))
(newline)

(newline)
(display (union '(1 2 3) '(2 3 4)))
(newline)
(newline)
(display (intersection '(1 2 3) '(2 3 4)))
(newline)
(newline)
(display (difference '(1 2 3 4 5) '(2 3)))
(newline)
(newline)
(display (symmetric-difference '(1 2 3 4) '(3 4 5 6)))
(newline)
(newline)
(display (set-eq? '(1 2 3) '(3 2 1)))
(newline)
(display (set-eq? '(1 2) '(1 3)))
(newline)
(display (set-eq? '(1 2 3) '(1 2 3 4)))
(newline)
(display (set-eq? '() '()))
```

## 3. Работа со строками

Реализуйте библиотеку процедур для работы со строками. Реализуйте
следующие процедуры:

-   Процедуры `string-trim-left`, `string-trim-right` и =string-trim=,
    удаляющие все пробельные символы в начале, конце и с обеих сторон
    строки соответственно.
-   Предикаты `(string-prefix? a b)`, `(string-suffix? a b)`
    и =(string-infix? a b)=, соответственно, проверяющие, является ли
    строка `a` началом строки `b`, окончанием строки `b` или строка `a`
    где-либо встречается в строке `b`.
-   Процедуру `(string-split str sep)`, возвращающую список подстрок
    строки `str`, разделённых в строке `str` разделителями `sep`, где
    `sep= --- непустая строка. Т.е. процедура =(string-split str sep)`
    должна разбивать строку на подстроки по строке-разделителю `sep`.

**Рекомендуется** преобразовывать входные строки к спискам символов
и анализировать уже эти списки.

Примеры вызова процедур:

``` example
(string-trim-left  "\t\tabc def")   ⇒ "abc def"
(string-trim-right "abc def\t")     ⇒ "abc def"
(string-trim       "\t abc def \n") ⇒ "abc def"

(string-prefix? "abc" "abcdef")  ⇒ #t
(string-prefix? "bcd" "abcdef")  ⇒ #f
(string-prefix? "abcdef" "abc")  ⇒ #f

(string-suffix? "def" "abcdef")  ⇒ #t
(string-suffix? "bcd" "abcdef")  ⇒ #f

(string-infix? "def" "abcdefgh") ⇒ #t
(string-infix? "abc" "abcdefgh") ⇒ #t
(string-infix? "fgh" "abcdefgh") ⇒ #t
(string-infix? "ijk" "abcdefgh") ⇒ #f
(string-infix? "bcd" "abc")      ⇒ #f

(string-split "x;y;z" ";")       ⇒ ("x" "y" "z")
(string-split "x-->y-->z" "-->") ⇒ ("x" "y" "z")
```

``` scheme
;; 1.1
(define (string-trim-left str)
  (define (list-trim-left lst)
    (cond
      ((null? lst) (list->string lst))
      ((char-whitespace? (car lst))
       (list-trim-left (cdr lst)))
      (else (list->string lst))))
  (list-trim-left (string->list str)))

;; 1.2
(define (string-trim-right str)
  (define (list-trim-right lst)
    (cond
      ((null? lst) (list->string (reverse lst)))
      ((char-whitespace? (car lst))
       (list-trim-right (cdr lst)))
      (else (list->string (reverse lst)))))
  (list-trim-right (reverse (string->list str))))

;; 1.3
(define (string-trim str)
  (string-trim-left (string-trim-right str)))

;; 2.1
(define (string-prefix? a b)
  (define (list-prefix? aim lst)
    (cond
      ((and (null? lst) (not (null? aim))) #f)
      ((null? aim) #t)
      ((equal? (car aim) (car lst))
       (list-prefix? (cdr aim) (cdr lst)))
      (else #f)))
  (list-prefix? (string->list a) (string->list b)))

;; 2.2
(define (string-suffix? a b)
  (define (list-suffix? aim lst)
    (cond
      ((and (null? lst) (not (null? aim))) #f)
      ((null? aim) #t)
      ((equal? (car aim) (car lst))
       (list-suffix? (cdr aim) (cdr lst)))
      (else #f)))
  (list-suffix?
   (reverse (string->list a))
   (reverse (string->list b))))

;; 2.3
(define (string-infix? a b)
  (cond
    ((equal? a "") #t)
    ((equal? b "") #f)
    ((string-prefix? a b) #t)
    (else
     (string-infix? a
                    (list->string (cdr (string->list b)))))))

;; 3
(define (concat str1 str2)
  (list->string
   (append (string->list str1) (string->list str2))))

(define (string-split str sep)
  (let loop ((res '())
             (str_to_add "")
             (str str))
    (cond
      ((equal? str "") (append res (cons str_to_add '())))
      ((string-prefix? sep str)   
        (loop
          (append res (cons str_to_add '()))
          ""
          (substring str (string-length sep) (string-length str))))
      (else
        (loop
          res
          (concat str_to_add (make-string 1 (string-ref str 0)))
          (list->string (cdr (string->list str))))))))


(display (string-trim-left "\t\tabc def"))
(newline)
(display (string-trim-right "abc def\t"))
(newline)
(display (string-trim "\t abc def \n"))
(newline)
(newline)

(display (string-prefix? "abc" "abcdef"))
(newline)
(display (string-prefix? "bcd" "abcdef"))
(newline)
(display (string-prefix? "abcdef" "abc"))
(newline)
(display (string-prefix? "" ""))
(newline)
(newline)

(display (string-suffix? "def" "abcdef"))
(newline)
(display (string-suffix? "bcd" "abcdef"))
(newline)
(display (string-suffix? "" "abcdef"))
(newline)
(display (string-suffix? "abcdef" "def"))
(newline)
(newline)

(display (string-infix? "def" "abcdefgh"))
(newline)
(display (string-infix? "abc" "abcdefgh"))
(newline)
(display (string-infix? "fgh" "abcdefgh"))
(newline)
(display (string-infix? "ijk" "abcdefgh"))
(newline)
(display (string-infix? "bcd" "abc"))
(newline)
(display (string-infix? "abcd" "abc"))
(newline)
(newline)

(display (string-split "x;y;z" ";"))
(newline)
(display (string-split "x-->y-->z" "-->"))
(newline)
(display (string-split "xyz-->yx-->z-->" "-->"))
(newline)
(display (string-split "-->" "-->"))
(newline)
(display (string-split "-->xyz-->x-->abc" "-->"))
(newline)
(newline)

(define (calc-last-whitespaces l)
  (define (loop l res k)
    (if (null? l)
        (list res k)
        (loop (cdr l)
              (cons (car l) res)
              (if (and (char? (car l)) (char-whitespace? (car l)))
                  (+ k 1)
                  0))))
  (loop l '() 0))

(define (list-trim-right l)
  (define (loop res l k)
    (if (null? l)
        res
        (if (= 0 k)
            (loop (cons (car l) res) (cdr l) 0)
            (loop res (cdr l) (- k 1)))))
  (apply loop (cons '() (calc-last-whitespaces l))))

(display (list-trim-right '((1) 2 3 #\space 5 #\space #\tab)))

;; TODO: переделать без reverse
```

## 4. Многомерные вектора

Реализуйте поддержку типа «многомерный вектор» — вектор произвольной
размерности (1 и более). Пусть элементы такого вектора хранятся
не во вложенных векторах, а в едином одномерном векторе встроенного
типа.

Реализуйте следующие процедуры:

-   `(make-multi-vector sizes)` и `(make-multi-vector sizes fill)` для
    создания многомерного вектора. Число элементов в каждой размерности
    задается списком `sizes`. Второй вариант вызова процедуры позволяет
    заполнить все элементы значением `fill`.
-   `(multi-vector? m)` для определения, является ли `m` многомерным
    вектором. Для вектора в общем случае (т.е. для такого, который
    не является представлением многомерного вектора) должна возвращать
    `#f`.
-   `(multi-vector-ref m indices)` для получения значения элемента
    с индексами, перечисленными в списке `indices`.
-   `(multi-vector-set! m indices x)` для присваивания значения `x`
    элементу с индексами, перечисленными в списке `indices`.

Примеры вызова процедур:

``` example
(define m (make-multi-vector '(11 12 9 16)))
(multi-vector? m)
(multi-vector-set! m '(10 7 6 12) 'test)
(multi-vector-ref m '(10 7 6 12)) ⇒ test

; Индексы '(1 2 1 1) и '(2 1 1 1) — разные индексы
(multi-vector-set! m '(1 2 1 1) 'X)
(multi-vector-set! m '(2 1 1 1) 'Y)
(multi-vector-ref m '(1 2 1 1)) ⇒ X
(multi-vector-ref m '(2 1 1 1)) ⇒ Y

(define m (make-multi-vector '(3 5 7) -1))
(multi-vector-ref m '(0 0 0)) ⇒ -1
```

``` scheme
;; 1
(define (make-multi-vector sizes . fill)
  (vector 'multi-vector
        sizes
        (if (null? fill)
            (make-vector (apply * sizes) 0)
            (make-vector (apply * sizes) (car fill)))))

;; 2
(define (multi-vector? m)
  (and
    (not (list? m))
    (not (string? m))
    (not (number? m))
    (not (char? m))
    (equal? (vector-ref m 0) 'multi-vector)))

(define (get-indices res sizes indices)
  (cond
    ((null? indices) res)
    ((get-indices (+ (* res (car sizes)) (car indices))
                  (cdr sizes) (cdr indices)))))

;; 3
(define (multi-vector-ref m indices)
  (vector-ref (vector-ref m 2) 
  (get-indices (car indices) (cdr (vector-ref m 1)) (cdr indices))))

;; 4
(define (multi-vector-set! m indices x)
  (vector-set! (vector-ref m 2) 
  (get-indices (car indices) (cdr (vector-ref m 1)) (cdr indices)) x))

(define m (make-multi-vector '(11 12 9 16)))
(display (multi-vector? m))
(newline)
(display (multi-vector? '((1 2) (1 2 3))))
(newline)
(multi-vector-set! m '(10 7 6 12) 'test)
(display (multi-vector-ref m '(10 7 6 12)))
(newline)

(multi-vector-set! m '(1 2 1 1) 'X)
(multi-vector-set! m '(2 1 1 1) 'Y)
(display (multi-vector-ref m '(1 2 1 1)))
(newline)
(display (multi-vector-ref m '(2 1 1 1)))
(newline)

(define m (make-multi-vector '(3 5 7) -1))
(display (multi-vector-ref m '(0 0 0)))
(newline)
(define m3 (make-multi-vector '(2 2 2)))
(multi-vector-set! m3 '(0 0 0) 1000)
(multi-vector-set! m3 '(0 0 1) 1001)
(multi-vector-set! m3 '(0 1 0) 1010)
(multi-vector-set! m3 '(1 0 0) 1100)
(display (map (lambda (idx)
       (multi-vector-ref m3 idx))
     '((0 0 0) (0 0 1) (0 1 0) (1 0 0))))
```

## 5. Композиция функций

Реализуйте композицию функций (процедур) одного аргумента, для чего
напишите процедуру `o`, принимающую произвольное число процедур одного
аргумента и возвращающую процедуру, являющуюся композицией этих
процедур.

Примеры применения процедуры:

``` example
(define (f x) (+ x 2))
(define (g x) (* x 3))
(define (h x) (- x))

((o f g h) 1) ⇒ -1
((o f g) 1)   ⇒ 5
((o h) 1)     ⇒ -1
((o) 1)       ⇒ 1
```

``` scheme
(define (o . xs)
  (define (compose funcs)
    (if (null? funcs)
        (lambda (x) x)
        (lambda (x) ((car funcs) ((compose (cdr funcs)) x)))))
  (compose xs))

(define (f x) (+ x 2))
(define (g x) (* x 3))
(define (h x) (- x))

(newline)
(newline)
(display ((o f g h) 1))
(newline)
(display ((o f g) 1))
(newline)
(display ((o h) 1))
(newline)
(display ((o) 1))
(newline)
```

``` example
-1
5
-1
1
```

## «Ачивки»

Эти задачки решаются по желанию, в обязательную часть не входят.

-   Написать функцию `flatten` без использование функции `append` (или
    её аналога, написанного вручную) — **+1 балл.**
-   Написать функцию `flatten` без использование функции `append` (или
    её аналога, написанного вручную), с хвостовой рекурсией —
    **+2 балла.**
-   Написать функцию `list-trim-right`, удаляющую пробельные символы
    на конце *списка,* без реверса этого списка (встроенной функции
    `reverse` или её аналога, написанного вручную) — **+1 балл.**
-   Написать функцию `list-trim-right`, удаляющую пробельные символы
    на конце *списка,* без реверса этого списка (встроенной функции
    `reverse` или её аналога, написанного вручную) и работающую
    со сложностью =O(len(xs))= — **+2 балла.**
-   При решении задачи № 5 (композиция функций) воспользоваться одной
    из функций, написанных при решении одной из предыдущих задач.
    Решение должно получиться нерекурсивным. **+1 балл.**