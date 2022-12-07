#!/usr/bin/env python3

from aocd import get_data
import re

d = get_data(year = 2022, day = 4)

ns = 0
for l in d.split('\n'):
    a,b = l.split(',')
    a0,a1 = a.split('-')
    b0,b1 = b.split('-')
    a0 = int(a0)
    a1 = int(a1)
    b0 = int(b0)
    b1 = int(b1)
    print(a0,a1,b0,b1)
    if (a0 >= b0 and a0 <= b1) or \
       (a1 >= b0 and a1 <= b1) or \
       (b0 >= a0 and b0 <= a1) or \
       (b1 >= a0 and b1 <= a1):
        print("hit")
        ns += 1
print(ns)