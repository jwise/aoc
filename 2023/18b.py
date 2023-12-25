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
#d = open('18.x','r').read()
y,x = (0,0)
miny = 0
minx = 0
maxy = 0
maxx = 0
map = {}
map[(y,x)] = True
lines = {}
ps = []
yedge = 0
xedge = 0
edgelen = 0
ps.append((0, 0))
for l in d.split('\n'):
    dir,n,col = l.split(' ')
    n = int(n)
    dir = col[7]
    n = int(col[2:7],16)
    if dir == '3' or dir == 'U':
        dy, dx = (-1, 0)
        yedge = 0
        sty = y - n
        eny = y
        for yy in range(sty, eny+1):
            if yy not in lines:
                lines[yy] = []
            lines[yy].append(x + xedge)
    elif dir == '1' or dir == 'D':
        dy,dx = (1, 0)
        yedge = 1
        sty = y
        eny = y + n
        for yy in range(sty, eny+1):
            if yy not in lines:
                lines[yy] = []
            lines[yy].append(x + xedge)
    elif dir == '2' or dir == 'L': # L
        xedge = 0
        dy,dx = (0,-1)
        # ACTUALLY THESE DO NOT MATTER
    elif dir == '0' or dir == 'R': # R
        xedge = 1
        dy,dx = (0,1)
    else:
        crap()
    print(dy, dx, y, x, n, xedge, yedge)
    y += dy * n
    x += dx * n
    if y < miny:
        miny = y
    if y > maxy:
        maxy = y
    if x < minx:
        minx = x
    if x > maxx:
        maxx = x
    ps.append((y, x))
    edgelen += n
    #ps.append((y + yedge, x + xedge))

segs = zip(ps, ps[1:] + [ps[0]])
a = abs(sum([x0*y1-x1*y0 for ((y0, x0), (y1, x1)) in segs])) // 2
print(a, edgelen, a + edgelen // 2 + 1)
fuq()
cells = 0
for l in range(miny,maxy+1):
    ll = lines[l]
    ll.sort()
    print(ll)
    lastpos = miny
    stpos = None
    s = ""
    for xx in ll:
        if stpos is not None:
            cells += xx - stpos + 1
            stpos = None
            s = s + "#" * (xx - lastpos)
        else:
            stpos = xx
            s = s + "." * (xx - lastpos)
        lastpos = xx
    print(s)
print(cells)
#    for _ in range(int(n)):
#        y,x = (y+dy,x+dx)
#        if y < miny:
#            miny = y
#        if x < minx:
#            minx = x
#        if y > maxy:
#            maxy = y
#        if x > maxx:
#            maxx = x
#        map[(y,x)] = True
