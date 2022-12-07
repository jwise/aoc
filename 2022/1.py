#!/usr/bin/env python3

from aocd import get_data

d = get_data(year = 2022, day = 1)
cs = 0
mcs = 0
for l in d.split('\n'):
    if len(l) == 0:
        if cs > mcs:
            mcs = cs
        cs = 0
        continue
    cs += int(l)

print(mcs)