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
