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

d = get_data(year = 2023, day = 6)
#d = """Time:      7  15   30
#Distance:  9  40  200"""

ts = extract(d.split('\n')[0].replace(' ',''))
ds = extract(d.split('\n')[1].replace(' ',''))

prod = 1
for t,d in zip(ts,ds):
    ways = 0
    for btime in range(t):
        dist = btime * (t - btime)
        if dist > d:
            ways += 1
    prod *= ways
print(prod)