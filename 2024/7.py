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

d = get_data(year = 2024, day = 7)

eqs = d.split('\n')
s = 0
for eq in eqs:
    tv,ns = eq.split(': ')
    ns = extract(ns)
    tv = int(tv)
    istrue = False
    
    for ops in itertools.product([True, False], repeat = len(ns)-1):
        val = ns[0]
        nns = list(ns[1:])
        for op in ops:
            if op:
                val = val * nns[0]
            else:
                val = val + nns[0]
            nns = nns[1:]
        if val == tv: 
            istrue = True
            break
    
    if istrue:
        s += tv

print(s)
