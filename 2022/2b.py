#!/usr/bin/env python3

from aocd import get_data

ss = {
'X': 1,
'Y': 2,
'Z': 3}

tt = {
'AX': 'Z',
'AY': 'X',
'AZ': 'Y',
'BX': 'X',
'BY': 'Y',
'BZ': 'Z',
'CX': 'Y',
'CY': 'Z',
'CZ': 'X'
}

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
#d = """A Y
#B X
#C Z"""
ts = 0
for l in d.split('\n'):
    print(l)
    ms = l.split(' ')
    ms[1] = tt[ms[0] + ms[1]]
    print(ms[1])
    s = ss[ms[1]] + rs[ms[0] + ms[1]]
    print(s)
    ts += s
print(ts)
