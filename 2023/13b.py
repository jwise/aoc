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

def tryfixed(rows, notscore):
    h = len(rows)
    w = len(rows[0])
    
    print("--- FIXED")
    foundone = []
    
    for xr in range(1, w):
        try:
            for x in range(0, xr):
                xrr = xr + (xr - x - 1)
                if xrr >= w:
                    continue
                for y in range(h):
                    if rows[y][xrr] != rows[y][x]:
                        raise ValueError("the nus")
            if xr != notscore:
                print(f"yesyes {xr}")
                foundone.append(xr)
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
            if yr * 100 != notscore:
                print(f"yesyes y {yr}")
                foundone.append(yr * 100)
        except ValueError:
            #print(f"not {xr}")
            continue
    if len(foundone) != 1:
        print(foundone)
        print('\n'.join([str(r) for r in rows]))
        return None
    return foundone[0]


score = 0
for m in d.split('\n\n'): 
    rows = m.split('\n')
    h = len(rows)
    w = len(rows[0])
    
    print("---")
    foundone = False
    
    for xr in range(1, w):
        wrong = []
        for x in range(0, xr):
            xrr = xr + (xr - x - 1)
            if xrr >= w:
                continue
            for y in range(h):
                if rows[y][xrr] != rows[y][x]:
                    wrong.append((y, xrr,))
                    wrong.append((y, x, ))
        if len(wrong) == 2:
            print(f"yes {xr}")
            foundone = wrong
            notscore = xr
                
    for yr in range(1, h):
        wrong = []
        for y in range(0, yr):
            yrr = yr + (yr - y - 1)
            if yrr >= h:
                continue
            for x in range(w):
                if rows[yrr][x] != rows[y][x]:
                    wrong.append((yrr, x,))
                    wrong.append((y, x, ))
        if len(wrong) == 2:
            print(f"yes y {yr}")
            foundone = wrong
            notscore = yr * 100
    if not foundone:
        print(m)
        abort()
# jesus fucking christ joshua have you tried reading the fucking problem?
    score += notscore
#    for (y, x) in foundone:
#        print(y,x)
#        nrows = [bytearray(r, 'utf-8') for r in rows]
#        nrows[y][x] = 35 if nrows[y][x] == 46 else 46 # .
#        tryfixed(nrows, notscore)

print(score)