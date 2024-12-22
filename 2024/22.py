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

d = get_data(year = 2024, day = 22)
#d="1\n2\n3\n2024"

def itersecret(d):
    pass

wins = {}

tot = 0
for l in d.split('\n'):
    n0 = extract(l)[0]
    
    seen = set()
    changes = (None, None, None, None)
    
    for _ in range(2000):
        #print(n0)
        plast = n0 % 10

        n1 = n0 * 64
        n0 ^= n1
        n0 &= 16777215
        
        n1 = n0 // 32
        n0 ^= n1
        n0 &= 16777215
        
        n1 = n0 * 2048
        n0 ^= n1
        n0 &= 16777215
        
        p = n0 % 10
        changes = (*changes[1:4], p - plast)
        if None not in changes:
            #print(n0, p, changes)
            if changes not in seen:
                if changes not in wins:
                    wins[changes] = 0
                wins[changes] += p
                if changes == (-2,1,-1,3):
                    print(p)
            seen.add(changes)
    tot += n0
print(tot)

wmax = 0
for i in wins:
    if wins[i] > wmax:
        wmax = wins[i]
print(wmax)