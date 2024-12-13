#!/usr/bin/env pypy3

from aocd import get_data

from collections import *
import math
import re, parse,functools, heapq,itertools
from z3 import *
import z3

# re.findall(pattern, string, flags)   r'\s'
# re.sub(r'<b>(.*?)</b>', r'\1', str)
# parse.search("age: {:d}\n", "Name: foo\nage: 35\nColor: red")[0] -> 35
# have you considered: split('\n\n')?
# have you considered: the walrus operator?
# have you considered: a tactical nuke on an ant?
# have you considered: 

def extract(s):
    return [int(x) for x in re.findall(r'(-?\d+).?', s)]

d = get_data(year = 2024, day = 13)

apress = Int("apress")
bpress = Int("bpress")

tot_toks = 0
for game in d.split('\n\n'):
    ax, ay, bx, by, px, py = extract(game)
    s = Optimize()
    s.add(apress <= 100)
    s.add(bpress <= 100)
    s.add(ax * apress + bx * bpress == px)
    s.add(ay * apress + by * bpress == py)
    tokens = 3 * apress + bpress
    h = s.minimize(tokens)
    if s.check() == unsat:
        continue
    tot_toks += s.lower(h).as_long()

print(tot_toks)
        