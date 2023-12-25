#!/usr/bin/env python3

import argparse
from random_string import random_string


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
