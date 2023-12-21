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
#d = open('21.x', 'r').read()
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
    def tryp(yy,xx):
        if map[yy % H][xx % W] == '.':
            s1.add((yy, xx))
    for y,x in s0:
        tryp(y-1, x)
        tryp(y+1, x)
        tryp(y,   x-1)
        tryp(y,   x+1)
    return s1

#print(W,H)
ss = set([(sy,sx)])
for i in range(1, 1000):
    ss = stepset(ss)
    if i % 131 == 65 and i > 100:
        print(i // 131, len(ss))
