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

d = get_data(year = 2023, day = 18)
y,x = (0,0)
miny = 0
minx = 0
maxy = 0
maxx = 0
map = {}
map[(y,x)] = True
for l in d.split('\n'):
    dir,n,col = l.split(' ')
    if dir == 'U':
        dy, dx = (-1, 0)
    elif dir == 'D':
        dy,dx = (1, 0)
    elif dir == 'L':
        dy,dx = (0,-1)
    elif dir == 'R':
        dy,dx = (0,1)
    else:
        crap()
    for _ in range(int(n)):
        y,x = (y+dy,x+dx)
        if y < miny:
            miny = y
        if x < minx:
            minx = x
        if y > maxy:
            maxy = y
        if x > maxx:
            maxx = x
        map[(y,x)] = True

floodq = []
def pushf(y,x):
    if (y,x) not in floodq:
        floodq.append((y,x))
def flood(y,x):
    if (y,x) in map:
        return
    map[(y,x)] = True
floodq.append((0,1))
while len(floodq) > 0:
    y,x = floodq.pop()
    if (y,x) in map:
        continue
    map[(y,x)] = True
    pushf(y-1,x)
    pushf(y+1,x)
    pushf(y,x-1)
    pushf(y,x+1)

print(miny,minx,maxy,maxx)
for y in range(miny,maxy+1):
    s = ""
    for x in range(miny,maxx+1):
        s = s + ("X" if (y,x) == (0,0) else ("#" if (y,x) in map else "."))
    print(s)

print(len(map))
