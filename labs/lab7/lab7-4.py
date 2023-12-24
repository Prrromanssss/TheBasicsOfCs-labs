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
