#!/usr/bin/env python3

from aocd import get_data
from collections import *
import re, parse

# re.findall(pattern, string, flags)   r'\s'
# re.sub(r'<b>(.*?)</b>', r'\1', str)
# parse.search("age: {:d}\n", "Name: foo\nage: 35\nColor: red")[0] -> 35
# have you considered: split('\n\n')?
# have you considered: the walrus operator?
# have you considered: 

def extract(s):
    return [int(x) for x in re.findall(r'(-?\d+).?', s)]

d = get_data(year = 2022, day = 6)
#d="mjqjpqmgbljsphdztnvjfqwrcgsmlb"
cs = deque()
n = 0
NCS = 14
for c in d:
    if len(cs) == NCS:
        cs.popleft()
    cs.append(c)
    print(c, cs)
    n += 1
    if len(cs) == NCS:
        ok = True
        for i in range(NCS):
            for j in range(i+1, NCS):
                if cs[i] == cs[j]:
                    ok = False
        if ok:
            break

print(n)
