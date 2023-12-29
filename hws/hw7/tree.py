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
