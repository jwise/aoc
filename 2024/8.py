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

d = get_data(year = 2024, day = 8)

antennas = {}
antinodes = set()

h = len(d.split('\n'))

for y,ln in enumerate(d.split('\n')):
    w = len(ln)
    for x,c in enumerate(ln):
        if c != '.':
            if c not in antennas:
                antennas[c] = []
            antennas[c].append((y,x))

for freq in antennas:
    for (a1y, a1x), (a2y, a2x) in itertools.permutations(antennas[freq], 2):
        dy = a1y - a2y
        dx = a1x - a2x
        any = a1y + dy
        anx = a1x + dx
        if any >= 0 and any < h and anx >= 0 and anx < w:
            antinodes.add((any, anx))

print(len(antinodes))
