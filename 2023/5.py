#!/usr/bin/env pypy3

from aocd import get_data

from collections import *
import math
import re#, parse

# re.findall(pattern, string, flags)   r'\s'
# re.sub(r'<b>(.*?)</b>', r'\1', str)
# parse.search("age: {:d}\n", "Name: foo\nage: 35\nColor: red")[0] -> 35
# have you considered: split('\n\n')?
# have you considered: the walrus operator?
# have you considered: 

def extract(s):
    return [int(x) for x in re.findall(r'(-?\d+).?', s)]

d = get_data(year = 2023, day = 5)

sections = d.split('\n\n')

seeds = extract(sections[0])

smaps = []
for s in sections[1:]:
    sec = []
    for l in s.split('\n')[1:]:
        print(l)
        dstart, sstart, rlen = extract(l)
        sec.append((dstart, sstart, rlen, ))
    smaps.append(sec)

def map(snum, val):
    print(snum, val)
    if snum >= len(smaps):
        print("DONE")
        return val
    for dstart, sstart, rlen in smaps[snum]:
        if val >= sstart and val < (sstart + rlen):
            print("MATCH")
            return map(snum+1, dstart + val - sstart)
    print("NO MATCH")
    return map(snum+1, val)

lloc = math.inf
for seed in seeds:
    loc = map(0, seed)
    if loc < lloc:
        lloc = loc

print(lloc)

