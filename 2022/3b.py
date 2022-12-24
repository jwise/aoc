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
ls = d.split('\n')
while len(ls) > 0:
    p1,p2,p3 = ls[0:3]
    ls = ls[3:]
    for c in p3:
        if c in p2 and c in p1:
            thing = c
    assert(thing)
    cx = ord(thing)
    if cx >= ord('a') and cx <= ord('z'):
        tot += cx - ord('a') + 1
    if cx >= ord('A') and cx <= ord('Z'):
        tot += cx - ord('A') + 27
print(tot)