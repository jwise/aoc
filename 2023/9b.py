#!/usr/bin/env pypy3

from aocd import get_data

from collections import *
import math
import re, parse

# re.findall(pattern, string, flags)   r'\s'
# re.sub(r'<b>(.*?)</b>', r'\1', str)
# parse.search("age: {:d}\n", "Name: foo\nage: 35\nColor: red")[0] -> 35
# have you considered: split('\n\n')?
# have you considered: the walrus operator?
# have you considered: a tactical nuke on an ant?
# have you considered: 

def extract(s):
    return [int(x) for x in re.findall(r'(-?\d+).?', s)]

d = get_data(year = 2023, day = 9)

def extrap(seq):
    derivs = []
    for a,b in zip(seq[0:-1], seq[1:]):
        derivs.append(b-a)
    if all([d == 0 for d in derivs]):
        return seq[-1]
    exderiv = extrap(derivs)
    return seq[-1] + exderiv

sum = 0
for l in d.split('\n'):
    seq = extract(l)
    e = extrap(seq[::-1])
    print(e)
    sum += e
print(sum)