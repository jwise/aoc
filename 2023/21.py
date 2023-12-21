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

d = get_data(year = 2023, day = 21)
map = [[c for c in s] for s in d.split('\n')]
W = len(map[0])
H = len(map)

for y in range(H):
    for x in range(W):
        if map[y][x] == 'S':
            sy,sx = y,x
            map[y][x] = '.'

def stepset(s0):
    s1 = set()
    for y,x in s0:
        if y > 0 and map[y-1][x] == '.':
            s1.add((y-1, x))
        if y < (H-1) and map[y+1][x] == '.':
            s1.add((y+1, x))
        if x > 0 and map[y][x-1] == '.':
            s1.add((y, x-1))
        if x < (W-1) and map[y][x+1] == '.':
            s1.add((y, x+1))
    return s1

ss = set([(sy,sx)])
for i in range(64):
    ss = stepset(ss)
    print(len(ss))
