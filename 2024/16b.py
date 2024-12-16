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

d = get_data(year = 2024, day = 16)
#d = open('16.x1', 'r').read()

map = [[c for c in r] for r in d.split('\n')]
H = len(map)
W = len(map[0])

for y in range(H):
    for x in range(W):
        if map[y][x] == 'S':
            sy,sx = y,x
            map[y][x] = '.'
        if map[y][x] == 'E':
            ey,ex = y,x
            map[y][x] = '.'

TURNL = { (-1, 0): (0, 1), (0, 1): (1, 0), (1, 0): (0, -1), (0, -1): (-1, 0) }
TURNR = { (-1, 0): (0, -1), (0, -1): (1, 0), (1, 0): (0, 1), (0, 1): (-1, 0) }

def search(y,x, dir):
    pass

sq = []
stmin = {}
sts = {}

def dotry(pred, y, x, dir, cost):
    st = (y, x, dir)
    if st not in stmin:
        stmin[st] = 99999999
    if cost == stmin[st]:
        sts[st].append(pred)
    if cost < stmin[st]:
        stmin[st] = cost
        sts[st] = [pred]
        heapq.heappush(sq, (cost, y, x, dir))

dotry(None, sy, sx, (0, 1), 0)

fincost = None
enddirs = set()
while len(sq) > 0:
    (cost, y, x, dir) = heapq.heappop(sq)
    print(y, x, dir, cost)
    dy, dx = dir
    if fincost and cost > fincost:
        break
    if (y,x) == (ey, ex):
        print(cost)
        fincost = cost
        enddirs.add(dir)
        continue
    if map[y + dy][x + dx] == '.':
        dotry((y, x, dir), y + dy, x + dx, dir, cost + 1)
    dotry((y, x, dir), y, x, TURNL[dir], cost + 1000)
    dotry((y, x, dir), y, x, TURNR[dir], cost + 1000)

allsqs = set()
def backtrack(y, x, dir):
    allsqs.add((y, x))
    print(f"{y}, {x}, {dir}: {sts[(y, x, dir)]}")
    for pred in sts[(y, x, dir)]:
        if pred == None:
            continue
        py, px, pdir = pred
        backtrack(py, px, pdir)
for dir in enddirs:
    print(dir)
    backtrack(ey, ex, dir)
print(len(allsqs))

for y in range(H):
    cc = ""
    for x in range(W):
        if (sy, sx) == (y, x):
            cc += "S"
        elif (ey, ex) == (y, x):
            cc += "E"
        elif (y, x) in allsqs:
            cc += "\033[1;32mo\033[0m"
        else:
            cc += map[y][x]
    print(cc)
