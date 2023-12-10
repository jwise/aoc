#!/usr/bin/env pypy3

from aocd import get_data

from collections import *
import math
import re, parse

# re.findall(pattern, string, flags)   r'\s'
# re.sub(r'<b>(.*?)</b>', r'\1', str)
# parse.search("age: {:d}\n", "Name: foo\nage: 35\nColor: red")[0] -> 35
# have you considered: split('\n\n')?
# have you considered: the walrus operator?
# have you considered: a tactical nuke on an ant?
# have you considered: 

def extract(s):
    return [int(x) for x in re.findall(r'(-?\d+).?', s)]

d = get_data(year = 2023, day = 10)
# d = open('10x.inp', 'r').read()
map = []
sum = 0
startpos = None # y,x

for line in d.split('\n'):
    lcs = []
    for c in line:
        if c == 'S':
            startpos = (len(map), len(lcs), )
        lcs.append(c)
    map.append(lcs)

def get(y,x):
    if y < 0 or x < 0 or y >= len(map) or x >= len(map[0]):
        return '.'
    return map[y][x]

def traverse(pos, dir, dist): # dir in (-1, 0), (1, 0), (0, -1), (0, 1)
    print(pos, startpos, get(*pos))
    if pos == startpos:
        return dist
    
    c = get(*pos)
    if c == '|' or c == '-':
        ndir = dir
    elif c == 'L':
        if dir == (1, 0):
            ndir = (0, 1)
        elif dir == (0, -1):
            ndir = (-1, 0)
        else:
            bail()
    elif c == 'J':
        if dir == (1, 0):
            ndir = (0, -1)
        elif dir == (0, 1):
            ndir = (-1, 0)
        else:
            bail()
    elif c == '7':
        if dir == (-1, 0):
            ndir = (0, -1)
        elif dir == (0, 1):
            ndir = (1, 0)
        else:
            bail()
    elif c == 'F':
        if dir == (-1, 0):
            ndir = (0, 1)
        elif dir == (0, -1):
            ndir = (1, 0)
        else:
            bail()
    else:
        print(pos, startpos, c)
        bail()
    npos = (pos[0] + ndir[0], pos[1] + ndir[1])
    return traverse(npos, ndir, dist+1)

# look for a start position that is valid
print("START", startpos, get(*startpos))
if get(startpos[0]+1,startpos[1]) == '|':
    sdir = (1, 0)
    spos = (startpos[0] + 1, startpos[1])
else:
    bail()

pos = spos
dir = sdir
dist = 0

looppts = [[False for c in l] for l in map]
inpts = [[False for c in l] for l in map]

looppts[startpos[0]][startpos[1]] = True
while pos != startpos:
    print(pos, startpos, get(*pos))
    looppts[pos[0]][pos[1]] = True
    c = get(*pos)
    if c == '|' or c == '-':
        ndir = dir
    elif c == 'L':
        if dir == (1, 0):
            ndir = (0, 1)
        elif dir == (0, -1):
            ndir = (-1, 0)
        else:
            bail()
    elif c == 'J':
        if dir == (1, 0):
            ndir = (0, -1)
        elif dir == (0, 1):
            ndir = (-1, 0)
        else:
            bail()
    elif c == '7':
        if dir == (-1, 0):
            ndir = (0, -1)
        elif dir == (0, 1):
            ndir = (1, 0)
        else:
            bail()
    elif c == 'F':
        if dir == (-1, 0):
            ndir = (0, 1)
        elif dir == (0, -1):
            ndir = (1, 0)
        else:
            bail()
    else:
        print(pos, startpos, c)
        bail()
    npos = (pos[0] + ndir[0], pos[1] + ndir[1])
    
    dir = ndir
    pos = npos
    
    dist += 1

print((dist+1)//2)

# use an even-odd fill rule from the left (any direction is fine tho)
area = 0
for y,l in enumerate(map):
    walls = 0
    s = ""
    for x,c in enumerate(l):
        if looppts[y][x]:
            s += map[y][x] + '#' + str(walls)
            # as long as we creep around a consistent side it is ok -- in
            # this case, if we can creep around the top then it is not a
            # wall crossed
            if map[y][x] == '|' or map[y][x] == 'L' or map[y][x] == 'J': # in my case and in the sample input, map[startpos] is 7, so we're fine
                walls += 1
        else:
            s += map[y][x] + ' ' + str(walls)
            if (walls % 2) == 1:
 #               print(y,x,get(y,x))
                area += 1
                inpts[y][x] = True
#    print(s)
print(area)