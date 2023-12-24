# Лабораторная работа №7

## Цель работы

Получение навыков написания сценариев на «скриптовых» языках.

Скриптовый язык, на котором будет выполняться лабораторная работа,
студентом выбирается самостоятельно. Примеры возможных скриптовых
языков: JavaScipt (Node.js), Python, Ruby, Lua, Perl, Racket и т.д.

## Задания

При демонстрации результатов работы преподавателю все скрипты должны
запускаться командой, содержащей только имя скрипта (т.е. без указания
в командной строке пути к скрипту и интерпретатора), то есть так:

`./myscript arg1 arg2`

а не так:

`bash ./myscript.sh arg1 arg2`

1.  Ha Bash напишите скрипт, который будет запускать долго выполняющуюся
    программу (напишите скрипт, имитирующий такую программу, скажем,
    просто ожидающий несколько минут и завершающийся) строго каждые *t*
    минут, но так, чтобы одновременно выполнялось не более 1 экземпляра
    этой программы. Путь к программе и периодичность запуска передавайте
    в виде аргументов командной строки. Вывод и ошибки запускаемой
    программы направляйте в файлы, имена этих файлов формируйте
    автоматически.

    ``` bash
    #!/bin/bash

    if [[ "$#" -ne 2 ]]; then
        echo "Usage: $0 <filename> <period time>"
    fi


    file_path=$1
    per_time=$2

    while true; do
        timestamp=$(date +%Y%m%d%H%M%S)
        output_log="output_$timestamp.log"
        error_log="error_$timestamp.log"
    
        if [[ -f $file_path ]]; then
            touch $output_log
            echo "file exists" > $output_log
        fi

        if [[ ! -f $file_path ]]; then
            touch $error_log
            echo "file doesn't exist" > $error_log
        fi

        sleep $per_time 
    done
    ```

2.  Ha Bash напишите скрипт, который принимает путь к проекту на языке C
    и выводит общее число непустых строк во всех файлах `.c` и =.h=
    указанного проекта. Предусмотрите рекурсивный обход вложенных папок.

    ``` bash
    #!/bin/bash

    if [[ "$#" -ne 1 ]]; then
        echo "Usage: $0 <directory>"
        exit 1
    fi

    grep -rn -E --include=\*.c --include=\*.h '^\S+$' "$1" | wc -l
    ```

3.  Ha выбранном скриптовом языке напишите программу, которая выводит
    в консоль указанное число строк заданной длины, состоящих
    из латинских букв, цифр и печатных знаков, присутствующих
    на клавиатуре. Длину строки и число строк передавайте как аргументы
    командой строки. Для каких целей можно использовать такую программу?
    Оформите логику приложения в виде отдельной функции и поместите её
    в отдельный модуль.

    -   Простой генератор паролей на Raku

        ```python
        #!/usr/bin/env python3

        import argparse
        from random import choice
        from string import ascii_lowercase, digits, punctuation


        def random_string(*, len_str, number_of_str):
            elements_in_str = ascii_lowercase + digits + punctuation
            return [''.join(choice(elements_in_str)
                            for _ in range(len_str)) for _ in range(number_of_str)]


        def main():
            parser = argparse.ArgumentParser()
            parser.add_argument(
                'length_of_the_string',
                default=5,
                type=int,
                nargs='?'
            )
            parser.add_argument(
                'number_of_the_strings',
                default=5,
                type=int,
                nargs='?'
            )
            args = parser.parse_args()

            res = random_string(
                len_str=args.length_of_the_string,
                number_of_str=args.number_of_the_strings)
            print(res)


        if __name__ == "__main__":
            main()
        ```

4.  **Задание повышенной сложности.** Ha выбранном скриптовом языке
    напишите функцию, которая принимает произвольную чистую функцию
    с переменным числом аргументов и возвращает мемоизованную версию
    этой функции. Для запоминания результатов вычислений выберете
    подходящую структуру данных из числа встроенных классов выбранного
    языка.

    ```python
    #!/usr/bin/env python3

    import functools


    def memo(old_func):
        cash = {}

        @functools.wraps(old_func)
        def new_func(*args, **kwargs):
            key = args, frozenset(sorted(kwargs.items()))
            if key not in cash:
                cash[key] = old_func(*args, **kwargs)
            return cash[key]
        return new_func


    @memo
    def fib(n):
        if n < 2:
            return 1
        return fib(n - 1) + fib(n - 2)
    ```