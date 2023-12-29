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
