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

d = get_data(year = 2024, day = 18)

map = set()

H=71
W=71

for l in d.split('\n')[:1024]:
    x,y = extract(l)
    map.add((y, x))

print(map)

sq = []
sts = {}
stmin = {}


def dotry(y, x, cost):
    st = (y, x)
    if (y, x) in map:
        return
    if y < 0 or x < 0 or y >= H or x >= W:
        return
    if st not in stmin:
        stmin[st] = 99999999
    if cost < stmin[st]:
        stmin[st] = cost
        sts[st] = True
        heapq.heappush(sq, (cost, y, x))


ey,ex = 70,70

for l in d.split('\n')[1024:]:
    newx,newy = extract(l)
    map.add((newy, newx))

    sq = []
    sts = {}
    stmin = {}

    dotry(0, 0, 0)

    while len(sq) > 0:
        (cost, y, x) = heapq.heappop(sq)
        if (y,x) == (ey, ex):
            print(cost)
            break
        dotry(y-1, x, cost+1)
        dotry(y+1, x, cost+1)
        dotry(y  , x-1, cost+1)
        dotry(y  , x+1, cost+1)
    if len(sq) == 0:
        print(newx,newy)
        break
