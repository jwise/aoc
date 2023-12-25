#!/usr/bin/env pypy3

from aocd import get_data

from collections import *
import math
import re, parse,functools, heapq
from itertools import combinations

# re.findall(pattern, string, flags)   r'\s'
# re.sub(r'<b>(.*?)</b>', r'\1', str)
# parse.search("age: {:d}\n", "Name: foo\nage: 35\nColor: red")[0] -> 35
# have you considered: split('\n\n')?
# have you considered: the walrus operator?
# have you considered: a tactical nuke on an ant?
# have you considered: 
def extract(s):
    return [int(x) for x in re.findall(r'(-?\d+).?', s)]

d = get_data(year = 2023, day = 24)
MINBOX = 200000000000000
MAXBOX = 400000000000000

hs = [ extract(s) for s in d.split('\n') ]

n = 0

if False:
  d = open('24.x', 'r').read()
  MINBOX = 7
  MAXBOX = 27

for h0, h1 in combinations(hs, 2):
    px0, py0, _, vx0, vy0, _ = h0
    px1, py1, _, vx1, vy1, _ = h1
    
    #if (vx0 == vx1 and px0 != px1) or (vy0 == vy1 and py0 != py1):
    #    continue
    
    # px0 + vx0 * t = px1 + vx1 * t
    # px0 - px1 + vx0 * t = vx1 * t
    # px0 - px1 = vx1 * t - vx0 * t
    # px0 - px1 = (vx1 - vx0) * t
    # t = (px0 - px1) / (vx1 - vx0)
    
    # cy0 = py0 + vy0 * t
    # cy1 = py1 + vy1 * t

    # cx0 = px0 + vx0 * t
    # cx1 = px1 + vx1 * t
    
    #y0 = py0 + vy0 / vx0 * (x0 - px0)
    #y1 = py1 + vy1 / vx1 * (x1 - px1)
    #y0 = y1
    #x0 = x1
    
    #py1 - py0 + vy1 / vx1 * x - vy1 / vx1 * px1 = vy0 / vx0 * x - vy0 / vx0 * px0
    #py1 - py0 + vy0 / vx0 * px0 - vy1 / vx1 * px1 = vy0 / vx0 * x - vy1 / vx1 * x
    #py1 - py0 + vy0 / vx0 * px0 - vy1 / vx1 * px1 = (vy0 / vx0 - vy1 / vx1) * x
    try:
        x0 = (py1 - py0 + vy0 / vx0 * px0 - vy1 / vx1 * px1) / (vy0 / vx0 - vy1 / vx1)
        x1 = x0
        y0 = py0 + vy0 / vx0 * (x0 - px0)
        y1 = py1 + vy1 / vx1 * (x0 - px1)
    except:
        print(f"({px0}, {py0}, {vx0}, {vy0}), ({px1}, {py1}, {vx0}, {vy0}), ")
        continue
    t0 = (x0 - px0) / vx0
    t1 = (x1 - px1) / vx1
    
    print(f"({px0}, {py0}, {vx0}, {vy0}), ({px1}, {py1}, {vx0}, {vy0}), ", x0,y0,t0 > 0,t1 > 0)
    
    if t0 > 0 and t1 > 0 and x0 >= MINBOX and x0 <= MAXBOX and y0 >= MINBOX and y0 <= MAXBOX:
        n += 1

print(n)