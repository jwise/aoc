#!/usr/bin/env python3

from aocd import get_data
from collections import *
import re, parse, itertools, os, functools
from dataclasses import *

if 'TEST' not in os.environ:
    d = get_data(year = 2022, day = 21)
else:
    d = """root: pppw + sjmn
dbpl: 5
cczh: sllz + lgvd
zczc: 2
ptdq: humn - dvpt
dvpt: 3
lfqf: 4
humn: 5
ljgn: 2
sjmn: drzm * dbpl
sllz: 4
pppw: cczh / lfqf
lgvd: ljgn * ptdq
drzm: hmdt - zczc
hmdt: 32"""

mks = {}

for l in d.split('\n'):
    m,v = l.split(': ')
    try:
        mks[m] = { 'op': 'raw', 'v': int(v) }
    except:
        m1,op,m2 = v.split(' ')
        mks[m] = { 'op': op, 'in1': m1, 'in2': m2 }
print(mks)

def eval(m):
    if mks[m]['op'] == 'raw':
        return mks[m]['v']
    else:
        m1 = eval(mks[m]['in1'])
        m2 = eval(mks[m]['in2'])
        if mks[m]['op'] == '+':
            v = m1 + m2
        elif mks[m]['op'] == '-':
            v = m1 - m2
        elif mks[m]['op'] == '*':
            v = m1 * m2
        elif mks[m]['op'] == '/':
            v = m1 // m2
        return v

print(eval('root'))