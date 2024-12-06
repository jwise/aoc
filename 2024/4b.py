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

d = get_data(year = 2024, day = 4)
#d = open(1.x', 'r').read()

lines = d.split('\n')
def lookup(y, x):
    if y < 0 or y >= len(lines):
        return None
    if x < 0 or x >= len(lines[0]):
        return None
    return lines[y][x]

counts = 0
for y in range(len(lines)):
    for x in range(len(lines[0])):
        if lookup(y, x) == 'A' and\
            ((lookup(y-1, x-1) == "M" and lookup(y+1, x+1) == "S") or (lookup(y-1, x-1) == "S" and lookup(y+1, x+1) == "M")) and \
            ((lookup(y-1, x+1) == "M" and lookup(y+1, x-1) == "S") or (lookup(y-1, x+1) == "S" and lookup(y+1, x-1) == "M")):
            counts += 1

print(counts)