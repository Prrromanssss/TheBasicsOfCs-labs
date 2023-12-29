# Домашнее задание №7

Скриптовый язык, на котором будет выполняться лабораторная работа,
студентом выбирается самостоятельно. Примеры возможных скриптовых
языков: JavaScipt (Node.js), Python, Ruby, Lua, Perl, Racket и т.д.

## 1. Утилита `tree`

Реализуйте собственный вариант утилиты `tree`. Пусть ваша программа
поддерживает по меньшей мере ключи `-d` и =-o= так же, как реализация
утилиты `tree` в ОС Linux. Поддержку других ключей можно
не реализовывать.

Для «рисования» дерева в консоли используйте символы псевдографики.

Программа не должна аварийно завершаться, если права доступа запрещают
получение списка файлов какого-либо каталога.

```python
#!/usr/bin/env python3

import argparse
import os
import sys


def draw_tree(directory, output, indent=''):
    files = os.listdir(directory)
    count = 0
    for file in files:
        count += 1
        path = os.path.join(directory, file)
        if os.path.isdir(path):
            output.write(f'{indent}├── {file}\n')
            if count == len(files):
                draw_tree(path, output, indent + '    ')
            else:
                draw_tree(path, output, indent + '│   ')
        else:
            if count == len(files):
                output.write(f'{indent}└── {file}\n')
            else:
                output.write(f'{indent}├── {file}\n')


def tree(directory, output):
    with (open(output, 'w') if output is not None else sys.stdout) as file:
        file.write(f'{directory}\n')
        draw_tree(directory, file, indent='')


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-o', '--output_file')
    parser.add_argument('-d', '--directory')
    args = parser.parse_args()

    directory = args.directory if args.directory is not None else '.'
    output = args.output_file if args.output_file is not None else None
    tree(directory, output)


if __name__ == '__main__':
    main()

```

## 2. Утилита `grep`

Реализуйте собственный вариант утилиты `grep`. Допускается ограничиться
работой только с текстовыми файлами. Так же, как и стандартная утилита
`grep`, ваша программа должна обрабатывать как стандартный ввод, так
и файлы, пути к которым указаны в командной строке. Ключ `-e` должен
позволять передать программе регулярное выражение вместо строки для
поиска. Пусть ваша реализация также поддерживает ключи `-i`, `-m`, `-n`
так же, как это делает стандартная реализация утилиты `grep`. Поддержку
других ключей можно не реализовывать.

Программа не должна аварийно завершаться, если какой-либо из файлов,
перечисленных в аргументах командной строки, не может быть прочитан.

Сообщения об ошибках и предупреждения должны направляться в стандартный
поток вывода ошибок. **Направление таких сообщений в стандартный поток
вывода не допускается.**

```python
#!/usr/bin/env python3

import argparse
import re
import sys


def grep(pattern, files, ignore_case, max_count, line_number):
    count = 0
    for file in files:
        try:
            with (open(file, 'r') if file != sys.stdin else sys.stdin) as f:
                for i, line in enumerate(f, start=1):
                    if ignore_case:
                        if re.search(pattern, line, re.IGNORECASE):
                            count += 1
                            if line_number:
                                print(f'{i}:{line}', end='')
                            else:
                                print(f'{line}', end='')
                    else:
                        if re.search(pattern, line):
                            count += 1
                            if line_number:
                                print(f'{i}:{line}', end='')
                            else:
                                print(f'{line}', end='')

                    if max_count and count >= max_count:
                        return
        except IOError as e:
            print(f'Error: {e}', file=sys.stderr)


def main():
    parser = argparse.ArgumentParser(description='Personal grep utility')
    parser.add_argument('pattern')
    parser.add_argument('-e', dest='pattern_as_expression',
                        action='store_true')
    parser.add_argument('-i', dest='ignore_case', action='store_true')
    parser.add_argument('-m', dest='max_count', type=int)
    parser.add_argument('-n', dest='line_number', action='store_true')
    parser.add_argument('files', nargs='*')

    args = parser.parse_args()

    if args.pattern_as_expression:
        pattern = args.pattern
    else:
        pattern = re.escape(args.pattern)

    files = args.files if args.files else [sys.stdin]
    ignore_case = args.ignore_case
    max_count = args.max_count
    line_number = args.line_number

    grep(pattern, files, ignore_case, max_count, line_number)


if __name__ == '__main__':
    main()
```

## 3. Утилита `wc`

Реализуйте собственный вариант утилиты `wc`. Так же, как и стандартная
утилита `wc`, ваша программа должна обрабатывать как стандартный ввод,
так и файлы, пути к которым указаны в командной строке. Пусть ваша
реализация поддерживает ключи `-c`, `-m`, `-w`, `-l` так же, как это
делает стандартная реализация утилиты `wc`. Поддержку других ключей
можно не реализовывать.

Сообщения об ошибках и предупреждения должны направляться в стандартный
поток вывода ошибок. **Направление таких сообщений в стандартный поток
вывода не допускается.**

```python
#!/usr/bin/env python3

import argparse
import sys


def count_characters(data):
    return len(data)


def count_words(data):
    words = data.split()
    return len(words)


def count_lines(data):
    lines = data.split('n')
    return len(lines)


def count_bytes(data):
    return len(data.encode('utf-8'))


def wc(file):
    with (open(file, 'r') if file != sys.stdin else sys.stdin) as f:
        data = f.read()

    count = {
        'c': count_characters(data),
        'w': count_words(data),
        'l': count_lines(data),
        'm': count_bytes(data)
    }

    return count


def main():
    parser = argparse.ArgumentParser(
        description='Word, character, line, byte count.'
    )
    parser.add_argument('file', nargs='*', help='input file(s)')

    group = parser.add_mutually_exclusive_group()
    group.add_argument('-c', action='store_true', help='print character count')
    group.add_argument('-w', action='store_true', help='print word count')
    group.add_argument('-l', action='store_true', help='print line count')
    group.add_argument('-m', action='store_true', help='print byte count')

    args = parser.parse_args()

    if not any(vars(args).values()):
        parser.error('At least one of -c, -w, -l, -m is required.')

    if not args.file:
        count = wc(sys.stdin)
        print_count(count, args)
    else:
        for file in args.file:
            try:
                count = wc(file)
                print_count(count, args)
            except FileNotFoundError:
                print(f'wc: {file}: No such file or directory',
                      file=sys.stderr)


def print_count(count, args):
    if args.c:
        print(count['c'], end=' ')
    if args.w:
        print(count['w'], end=' ')
    if args.l:
        print(count['l'], end=' ')
    if args.m:
        print(count['m'], end=' ')
    print()


if __name__ == '__main__':
    main()
```

## 4. Поиск опечаток

Реализуйте простейшую программу проверки орфографии. Пусть программа
принимает на вход словарь и текст на естественном языке и выводит список
и координаты слов (строка, колонка), которые не встречаются в словаре.

Например, пусть =dictionary.txt= — словарь, а =example-missprint.txt= —
текст, где в строке 1 допущена опечатка в слове `general`, во 2 строке —
в слове `emphasizes` и в 7 строке — в слове `supports` (1-е буквы этих
слов находятся в 25, 23 и 8 колонках соответственно). Тогда вызов
и результат работы вашей программы `speller.py` должен выглядеть так:

``` example
> ./speller.py dictionary.txt example-missprint.txt
1,  25    gneral
2,  23    emphasises
7,   8    suports
```

Считайте, что в проверяемом тексте переносы слов отсутствуют. Различные
формы одного слова рассматривайте как разные слова. Апостроф считайте
частью слова.

### Рекомендации

В виде отдельного модуля реализуйте сканер, преобразующий текст
в токены — слова и знаки пунктуации. Для каждого токена храните его
координаты в исходном тексте — позицию от начала текста, номер строки,
номер колонки.

Тестирование программы выполните на примерах коротких английских
текстов.

Словарь получите из текста, в котором, как вы считаете, отсутствуют
опечатки. Для получения отдельных слов из этого текста используйте
разработанный вами сканер. Напишите вспомогательную программу, которая
будет строить словарь по тексту, поданному на вход этой программы.

```python
#!/usr/bin/env python3

import argparse


def load_dictionary(file):
    with open(file, 'r', encoding='utf-8') as f:
        dictionary = set(word for line in f for word in line.split())
    return dictionary


def detect_misspelled_words(dictionary, text):
    misspelled_words = []
    lines = text.split('\n')
    for i, line in enumerate(lines):
        words = line.strip().split()
        for j, word in enumerate(words):
            if word.lower() not in dictionary:
                misspelled_words.append((i+1, j+1, word))
    return misspelled_words


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('dictionary', help='dictionary file')
    parser.add_argument('text', help='text file')
    args = parser.parse_args()

    dictionary = load_dictionary(args.dictionary)

    with open(args.text, 'r', encoding='utf-8') as f:
        text = f.read()

    misspelled_words = detect_misspelled_words(dictionary, text)

    for line, col, word in misspelled_words:
        print(f'{line}, {col}\t{word}')


if __name__ == '__main__':
    main()
```

# Ачивка

В качестве скриптового языка выбрать какой-нибудь редкий или необычный язык:
- язык, отличный от Python — **(1 балл)**,
- язык, отличный от Python и NodeJS — **(2 балла)**