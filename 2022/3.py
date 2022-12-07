#!/usr/bin/env python3

from aocd import get_data

d = get_data(year = 2022, day = 3)
#d ="""vJrwpWtwJgWrhcsFMMfFFhFp
#jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
#PmmdzqPrVvPwwTWBwg
#wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
#ttgJtRGJQctTZtZT
#CrZsJsPPZsGzwwsLwLmpwMDw"""
tot = 0
for l in d.split('\n'):
    p1 = l[:len(l)//2]
    p2 = l[len(l)//2:]
    its1 = {}
    its2 = {}
    for c in p1:
        its1[c] = True
    thing = None
    for c in p2:
        if c in p1:
            assert(thing is None or thing == c)
            thing = c
    assert(thing)
    print(p1, p2, thing)
    cx = ord(thing)
    if cx >= ord('a') and cx <= ord('z'):
        tot += cx - ord('a') + 1
    if cx >= ord('A') and cx <= ord('Z'):
        tot += cx - ord('A') + 27
print(tot)