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

d = get_data(year = 2023, day = 12)
#d = open('12.x', 'r').read()

@functools.lru_cache
def configs(c,counts,remticks):
    if c == "":
        return 1 if (len(counts) == 0 and (remticks == 0 or remticks == None)) else 0

    if remticks is not None and remticks > 0:
        if c[0] == '?' or c[0] == '#':
            return configs(c[1:], counts, remticks-1)
        else:
            return 0
    
    if remticks == 0:
        if c[0] == '?' or c[0] == '.':
            return configs(c[1:], counts, None)
        else:
            return 0
    
    if c[0] == '#':
        if len(counts) == 0:
            return 0
        return configs(c[1:], counts[1:], counts[0] - 1)
    
    if c[0] == '?':
        poss = 0
        poss += configs(c[1:], counts, None)
        if len(counts) != 0:
            poss += configs(c[1:], counts[1:], counts[0] - 1)
        return poss
    
    if c[0] == '.':
        return configs(c[1:], counts, None)
    
    abort()

ntot = 0
for l in d.split('\n'):
    c,counts = l.split(' ')
    counts = tuple(extract(counts))
    val = configs(c,counts,None)
    print(c,counts,val)
    ntot += val

print(ntot)
