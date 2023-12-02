#!/usr/bin/env pypy3

from aocd import get_data

d = get_data(year = 2023, day = 2)
tot = 0
for l in d.split('\n'):
    a,b = l.split(':')
    id = int(a.split(' ')[1])
    pulls = b.split(';')
    ok = True
    for p in pulls:
        p = p.strip()
        print(p)
        for onep in p.split(','):
            n,color = onep.strip().split(' ')
            n = int(n)
            if color == 'red' and n > 12:
                ok = False
            elif color == 'green' and n > 13:
                ok = False
            elif color == 'blue' and n > 14:
                ok = False
    if ok:
        tot += id
    print(id,ok)

print(tot)
