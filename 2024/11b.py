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

@functools.lru_cache(maxsize=None)
def stoneiters(val, iters):
    if iters == 0:
        return 1
    if val == 0:
        return stoneiters(1, iters - 1)
    else:
        ss = str(val)
        digits = len(ss)
        if digits % 2 == 0:
            return stoneiters(int(ss[:digits//2]), iters - 1) + stoneiters(int(ss[digits//2:]), iters - 1)
        return stoneiters(val * 2024, iters - 1)

totlen = 0
for s in stones:
    totlen += stoneiters(s, 75)
print(totlen)