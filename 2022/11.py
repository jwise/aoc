#!/usr/bin/env python3

from aocd import get_data
from collections import *
import re, parse

def extract(s):
    return [int(x) for x in re.findall(r'(-?\d+).?', s)]

d = """Monkey 0:
  Starting items: 79, 98
  Operation: new = old * 19
  Test: divisible by 23
    If true: throw to monkey 2
    If false: throw to monkey 3

Monkey 1:
  Starting items: 54, 65, 75, 74
  Operation: new = old + 6
  Test: divisible by 19
    If true: throw to monkey 2
    If false: throw to monkey 0

Monkey 2:
  Starting items: 79, 60, 97
  Operation: new = old * old
  Test: divisible by 13
    If true: throw to monkey 1
    If false: throw to monkey 3

Monkey 3:
  Starting items: 74
  Operation: new = old + 3
  Test: divisible by 17
    If true: throw to monkey 0
    If false: throw to monkey 1"""
d = get_data(year = 2022, day = 11)

ms = []
for m in d.split('\n\n'):
    mls = m.split('\n')
    # ignore line 0
    its = extract(mls[1])
    op,n = parse.parse('  Operation: new = old {} {}', mls[2])
    divis = extract(mls[3])[0]
    mtrue = extract(mls[4])[0]
    mfalse = extract(mls[5])[0]
    
    ms.append({'its': its, 'op': op, 'n': n, 'divis': divis, 'mtrue': mtrue, 'mfalse': mfalse, 'inspects': 0})

for _ in range(20):
    for m in ms:
        for it in m['its']:
            m['inspects'] += 1
            if m['n'] == 'old':
                v = it
            else:
                v = int(m['n'])
            if m['op'] == '+':
                it += v
            elif m['op'] == '*':
                it *= v
            else:
                barf()
            it = it // 3
            if it % m['divis'] == 0:
                ms[m['mtrue']]['its'].append(it)
            else:
                ms[m['mfalse']]['its'].append(it)
        m['its'] = []

maxins = []
for m in ms:
    maxins.append(m['inspects'])
maxins.sort()

print(ms)
print(maxins[-1] * maxins[-2])
