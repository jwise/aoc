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

def extract(s):
    return [int(x) for x in re.findall(r'(-?\d+).?', s)]

d = get_data(year = 2024, day = 5)
#d = open(1.x', 'r').read()

rules,pages = d.split('\n\n')
rules = [extract(s) for s in rules.split('\n')]
pages = [extract(s) for s in pages.split('\n')]

ngood = 0
val = 0
for p in pages:
    good = True
    for p1,p2 in rules:
        if p1 in p and p2 in p:
            if p.index(p1) > p.index(p2):
                good = False
    if not good:
        while not good:
            good = True
            for p1,p2 in rules:
                if p1 in p and p2 in p:
                    if p.index(p1) > p.index(p2):
                        p[p.index(p1)], p[p.index(p2)] = p2,p1
                        good = False

        ngood += 1
        val += p[(len(p)-1)//2]

print(ngood,val, len(pages))
