#!/usr/bin/env pypy3

from aocd import get_data

from collections import *
import math
import re, parse,functools, heapq,itertools

from z3 import *

# re.findall(pattern, string, flags)   r'\s'
# re.sub(r'<b>(.*?)</b>', r'\1', str)
# parse.search("age: {:d}\n", "Name: foo\nage: 35\nColor: red")[0] -> 35
# have you considered: split('\n\n')?
# have you considered: the walrus operator?
# have you considered: a tactical nuke on an ant?
# have you considered: 

def extract(s):
    return [int(x) for x in re.findall(r'(-?\d+).?', s)]

d = get_data(year = 2024, day = 23)
#d = open('23.x').read()

nodes = {}
for l in d.split('\n'):
    a,b = l[0:2],l[3:]
    if a not in nodes:
        nodes[a] = set()
    nodes[a].add(b)
    if b not in nodes:
        nodes[b] = set()
    nodes[b].add(a)

res = set()
for n0 in nodes:
    if n0[0] != 't':
        continue
    
    for n1 in nodes[n0]:
        for n2 in nodes[n0]:
            if n1 >= n2:
                continue
            if n1 in nodes[n2]:
                nval = [n0, n1, n2]
                nval.sort()
                res.add(tuple(nval))


print(len(res))