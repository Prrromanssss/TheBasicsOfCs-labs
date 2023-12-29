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
