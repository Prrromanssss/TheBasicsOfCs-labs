from random import choice
from string import ascii_lowercase, digits, punctuation


def random_string(*, len_str, number_of_str):
    elements_in_str = ascii_lowercase + digits + punctuation
    return [''.join(choice(elements_in_str)
                    for _ in range(len_str)) for _ in range(number_of_str)]
