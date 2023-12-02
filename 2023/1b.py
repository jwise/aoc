#!/usr/bin/env python3

from aocd import get_data

d = get_data(year = 2023, day = 1)
ctr = 0
for l in d.split('\n'):
    ds = []
    
    while l != '':
        if l[:4] == 'zero':
            ds.append(0)
        if l[:3] == 'one':
            ds.append(1)
        if l[:3] == 'two':
            ds.append(2)
        if l[:5] == 'three':
            ds.append(3)
        if l[:4] == 'four':
            ds.append(4)
        if l[:4] == 'five':
            ds.append(5)
        if l[:3] == 'six':
            ds.append(6)
        if l[:5] == 'seven':
            ds.append(7)
        if l[:5] == 'eight':
            ds.append(8)
        if l[:4] == 'nine':
            ds.append(9)
        if l[:1] >= '0' and l[:1] <= '9':
            ds.append(int(l[:1]))
        l = l[1:]
    cv = ds[0] * 10 + ds[-1]
    ctr += cv

print(ctr)