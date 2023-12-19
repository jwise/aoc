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



d = get_data(year = 2023, day = 19)

wls,pls = d.split('\n\n')
ws = {}
for wl in wls.split('\n'):
    wf = []
    name,rules = wl.split('{')
    rules = rules[:-1]
    for r in rules.split(','):
        cond = 'True'
        dest = r
        if ':' in r:
            cond,dest = r.split(':')
        wf.append((cond, dest))
    ws[name] = wf
print(ws)

rns = 0
for pl in pls.split('\n'):
    x,m,a,s = extract(pl)
    w = 'in'
    while w != 'A' and w != 'R':
        for cond,dest in ws[w]:
            if eval(cond):
                w = dest
                break
    if w == 'A':
        rns += x + m + a + s

print(rns)