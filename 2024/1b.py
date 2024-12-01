#!/usr/bin/env pypy3

from aocd import get_data

from collections import *
import math
import re, parse,functools, heapq

# re.findall(pattern, string, flags)   r'\s'
# re.sub(r'<b>(.*?)</b>', r'\1', str)
# parse.search("age: {:d}\n", "Name: foo\nage: 35\nColor: red")[0] -> 35
# have you considered: split('\n\n')?
# have you considered: the walrus operator?
# have you considered: a tactical nuke on an ant?
# have you considered: 

def extract(s):
    return [int(x) for x in re.findall(r'(-?\d+).?', s)]

d = get_data(year = 2024, day = 1)
#d = open(1.x', 'r').read()

# or d.split('\n\n')
# or l.split(' ')
# or d.strip()
l0 = []
l1 = []
for l in d.split('\n'):
    v0,v1 = extract(l)
    l0.append(v0)
    l1.append(v1)

tot = 0
for v0 in l0:
    n = 0
    for v1 in l1:
        if v0 == v1:
            n += 1
    tot += n * v0
print(tot)
