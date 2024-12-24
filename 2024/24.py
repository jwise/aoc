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

d = get_data(year = 2024, day = 24)

nodes = {}
for l in d.split('\n\n')[0].split('\n'):
    n,v = l.split(': ')
    nodes[n] = int(v)

for l in d.split('\n\n')[1].split('\n'):
    n1,op,n2,arrow,out = l.split(' ')
    nodes[out] = { 'in': [n1, n2], 'op': op }


@functools.cache
def getv(n):
    if type(nodes[n]) == int:
        return nodes[n]
    v1,v2 = (getv(x) for x in nodes[n]['in'])
    if nodes[n]['op'] == "OR":
        return v1 | v2
    elif nodes[n]['op'] == "AND":
        return v1 & v2
    elif nodes[n]['op'] == "XOR":
        return v1 ^ v2
    abort()

n = 0
v = 0
while f"z{v:02d}" in nodes:
    n |= getv(f"z{v:02d}") << v
    v += 1

print(n)