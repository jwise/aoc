#!/usr/bin/env pypy3

from aocd import get_data

from collections import *
import math
import re#, parse

from z3 import *

# this is still running on my Mac, so who knows if it works

# re.findall(pattern, string, flags)   r'\s'
# re.sub(r'<b>(.*?)</b>', r'\1', str)
# parse.search("age: {:d}\n", "Name: foo\nage: 35\nColor: red")[0] -> 35
# have you considered: split('\n\n')?
# have you considered: the walrus operator?
# have you considered: 

def extract(s):
    return [int(x) for x in re.findall(r'(-?\d+).?', s)]

d = get_data(year = 2023, day = 5)
d = open('5.x', 'r').read()

sections = d.split('\n\n')

seeds = extract(sections[0])

s = Optimize()
seed = Int('seed')
possibilities = []
for start,n in zip(seeds[::2], seeds[1::2]):
    possibilities.append(And(seed >= start, seed < (start + n)))
s.add(Or(*possibilities))

curvar = seed
for sec in sections[1:]:
    nextvar = curvar
    for l in sec.split('\n')[1:]:
        dstart, sstart, rlen = extract(l)
        nextvar = If(And(curvar >= sstart, curvar < (sstart + rlen)),
                     curvar + (dstart - sstart),
                     nextvar)
    curvar = nextvar

print(s)
print(curvar)
h = s.minimize(curvar)
print(s.check())
print(s.lower(h))
print(s.model)