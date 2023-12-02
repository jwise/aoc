#!/usr/bin/env python3

from aocd import get_data

d = get_data(year = 2023, day = 1)
ctr = 0
for l in d.split('\n'):
    ds = []
    l = l.replace('zero', '0')
    l = l.replace('one', '1')
    l = l.replace('two', '2')
    l = l.replace('three', '3')
    l = l.replace('four', '4')
    l = l.replace('five', '5')
    l = l.replace('six', '6')
    l = l.replace('seven', '7')
    l = l.replace('eight', '8')
    l = l.replace('nine', '9')
    
    for c in l:
        if c >= '0' and c <= '9':
            ds.append(int(c))
    cv = ds[0] * 10 + ds[-1]
    ctr += cv

print(ctr)