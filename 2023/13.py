#!/usr/bin/env pypy3

from aocd import get_data

from collections import *
import math
import re, parse,functools

# re.findall(pattern, string, flags)   r'\s'
# re.sub(r'<b>(.*?)</b>', r'\1', str)
# parse.search("age: {:d}\n", "Name: foo\nage: 35\nColor: red")[0] -> 35
# have you considered: split('\n\n')?
# have you considered: the walrus operator?
# have you considered: a tactical nuke on an ant?
# have you considered: 

def extract(s):
    return [int(x) for x in re.findall(r'(-?\d+).?', s)]

d = get_data(year = 2023, day = 13)
#d = open('13.x', 'r').read()

score = 0
for m in d.split('\n\n'): 
    rows = m.split('\n')
    h = len(rows)
    w = len(rows[0])
    
    print("---")
    foundone = False
    
    for xr in range(1, w):
        try:
            for x in range(0, xr):
                xrr = xr + (xr - x - 1)
                if xrr >= w:
                    continue
                for y in range(h):
                    if rows[y][xrr] != rows[y][x]:
                        raise ValueError("the nus")
            print(f"yes {xr}")
            score += xr
            foundone = True
        except ValueError:
            #print(f"not {xr}")
            continue
                
    for yr in range(1, h):
        try:
            for y in range(0, yr):
                yrr = yr + (yr - y - 1)
                if yrr >= h:
                    continue
                for x in range(w):
                    if rows[yrr][x] != rows[y][x]:
                        raise ValueError("the nus")
            print(f"yes y {yr}")
            score += yr * 100
            foundone = True
        except ValueError:
            #print(f"not {xr}")
            continue
    if not foundone:
        print(m)

print(score)