#!/usr/bin/env python3

from aocd import get_data

ss = {
'X': 1,
'Y': 2,
'Z': 3}

rs = {
'AX': 3,
'AY': 6,
'AZ': 0,
'BX': 0,
'BY': 3,
'BZ': 6,
'CX': 6,
'CY': 0,
'CZ': 3
}

d = get_data(year = 2022, day = 2)
ts = 0
for l in d.split('\n'):
    ms = l.split(' ')
    s = ss[ms[1]] + rs[ms[0] + ms[1]]
    ts += s
print(ts)
