#!/usr/bin/env pypy3

from aocd import get_data

from collections import *
import re#, parse

# re.findall(pattern, string, flags)   r'\s'
# re.sub(r'<b>(.*?)</b>', r'\1', str)
# parse.search("age: {:d}\n", "Name: foo\nage: 35\nColor: red")[0] -> 35
# have you considered: split('\n\n')?
# have you considered: the walrus operator?
# have you considered: 

def extract(s):
    return [int(x) for x in re.findall(r'(-?\d+).?', s)]

d = get_data(year = 2023, day = 4)
tot = 0
for l in d.split('\n'):
    called,have = l.split(':')[1].split('|')
    called = extract(called)
    have = extract(have)
    val = 0
    for n in called:
        if n in have:
            if val == 0:
                val = 1
            else:
                val *= 2
    tot += val
print(tot)
