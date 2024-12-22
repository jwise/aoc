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

d = get_data(year = 2024, day = 21)

outermap = [[None, "^", "A"], ["<", "v", ">"]]
innermap = [["7", "8", "9"], ["4", "5", "6"], ["1", "2", "3"], [None, "0", "A"]]

kpos = {
    "0": (3,1),
    "1": (2,0),
    "2": (2,1),
    "3": (2,2),
    "4": (1,0),
    "5": (1,1),
    "6": (1,2),
    "7": (0,0),
    "8": (0,1),
    "9": (0,2),
    "A": (3,2)
}

PARTB = True

MAXLAYER = 2 + 1
if PARTB:
    MAXLAYER = 25 + 1

APOS = (0, 2)
UPOS = (0, 1)
LPOS = (1, 0)
DPOS = (1, 1)
RPOS = (1, 2)

# cost to make following operations on layer:
#   start at src
#   navigate to dst
#   press dst
# layer -1 is always on "A" at entry
@functools.cache
def movecost(src, dst, layer):
    if layer == 0:
        # the movement is "free", we just do the "press"
        return 1, outermap[dst[0]][dst[1]]
    # print(f"compute {src} {dst} {layer}")
    y,x = src
    visited = set()
    if layer == MAXLAYER:
        map = innermap
    else:
        map = outermap
    
    if src == dst:
        return 1, "A"
    
    def canmove(y, x):
        return y >= 0 and y < len(map) and x >= 0 and x < len(map[0]) and (map[y][x] is not None)
    
    #state vector: cost, layer position, layer-1 position, outermost move list, inner move list
    q = []
    heapq.heappush(q, (0, src, APOS, "", ""))
    while len(q):
        cost, pos, m1pos, mlist, imlist = heapq.heappop(q)
        if pos == dst:
            if m1pos == APOS:
                #print(f"{layer}: {src} \"{map[src[0]][src[1]]}\" {dst} \"{map[dst[0]][dst[1]]}\" -> {cost} (\"{mlist}\" to make \"{imlist}\")")
                if PARTB:
                    mlist = ""
                return cost, mlist
            else:
                mcost, mstr = movecost(m1pos, APOS, layer-1)
                heapq.heappush(q, (cost + mcost, pos, APOS, mlist + mstr, imlist + "A"))
        else:
            posy,posx = pos
            def trypos(dy, dx, key):
                if canmove(posy+dy, posx+dx):
                    mcost, mstr = movecost(m1pos, key, layer-1)
                    heapq.heappush(q, (cost + mcost, (posy + dy, posx + dx), key, mlist + mstr, imlist + outermap[key[0]][key[1]]))
            trypos(-1, 0, UPOS)
            trypos(1, 0, DPOS)
            trypos(0, -1, LPOS)
            trypos(0, 1, RPOS)
    print("did not find?", src, dst, layer)
                
score = 0
for l in d.split('\n'):
    print(l)
    a0 = kpos["A"]
    tsteps = 0
    tstr = ""
    for c in l:
        mcost, mstr = movecost(a0, kpos[c], MAXLAYER)
        tsteps += mcost
        tstr += mstr
        a0 = kpos[c]
    print(tsteps, tstr)
    c = extract(l)[0]
    score += c * tsteps
print(score)

print(movecost.cache_info())