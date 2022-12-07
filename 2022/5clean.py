#!/usr/bin/env python3

from aocd import get_data
from collections import *

def extract(s):
    return [int(x) for x in re.findall(r'(-?\d+).?', s)]

d = get_data(year = 2022, day = 5)
stacks = defaultdict(deque)
maxidx = 0
p1,p2 = d.split('\n\n')
for l in p1.split('\n'):
    cs = l[1::4]
    for (idx,c) in enumerate(cs):
        if c != ' ':
            stacks[idx+1].append(c)
        if idx > maxidx:
            maxidx = idx

for l in p2.split('\n'):
    n,fr,to = extract(l)
    for _ in range(n):
        stacks[to].appendleft(stacks[fr].popleft())

s = ""
for c in range(maxidx+1):
    s += stacks[c+1][0]

print(s)
