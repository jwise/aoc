#!/usr/bin/env pypy3

from aocd import get_data

d = get_data(year = 2023, day = 2)
tot = 0
for l in d.split('\n'):
    a,b = l.split(':')
    id = int(a.split(' ')[1])
    pulls = b.split(';')
    minr = 0
    ming = 0
    minb = 0
    for p in pulls:
        p = p.strip()
        print(p)
        for onep in p.split(','):
            n,color = onep.strip().split(' ')
            n = int(n)
            if color == 'red' and n > minr:
                minr = n
            elif color == 'green' and n > ming:
                ming = n
            elif color == 'blue' and n > minb:
                minb = n
    tot += minr * ming * minb

print(tot)
