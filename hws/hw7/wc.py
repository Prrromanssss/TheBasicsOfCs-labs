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
