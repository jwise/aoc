#!/usr/bin/env pypy3

from aocd import get_data

from collections import *
import math
import re, parse,functools, heapq,itertools

# re.findall(pattern, string, flags)   r'\s'
# re.sub(r'<b>(.*?)</b>', r'\1', str)
# parse.search("age: {:d}\n", "Name: foo\nage: 35\nColor: red")[0] -> 35
# have you considered: split('\n\n')?
# have you considered: the walrus operator?
# have you considered: a tactical nuke on an ant?
# have you considered: 

def extract(s):
    return [int(x) for x in re.findall(r'(-?\d+).?', s)]

d = get_data(year = 2024, day = 11)

stones = extract(d)

for _ in range(25):
    nstones = []
    for s in stones:
        ss = str(s)
        if s == 0:
            nstones.append(1)
        elif len(ss) % 2 == 0:
            digits = len(ss)
            print("x",digits,ss)
            nstones.append(int(ss[:digits//2]))
            nstones.append(int(ss[digits//2:]))
        else:
            nstones.append(s * 2024)
    stones = nstones
    print(len(nstones))
