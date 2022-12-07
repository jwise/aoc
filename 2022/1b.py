#!/usr/bin/env python3

from aocd import get_data

d = get_data(year = 2022, day = 1)
cs = 0
csl = []
for l in d.split('\n'):
    if len(l) == 0:
        csl.append(cs)
        cs = 0
        continue
    cs += int(l)
csl.sort()
print(csl[-3] + csl[-2] + csl[-1])
