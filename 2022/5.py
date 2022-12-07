#!/usr/bin/env python3

from aocd import get_data
import re, parse

d = get_data(year = 2022, day = 5)
#d = """    [D]    
#[N] [C]    
#[Z] [M] [P]
# 1   2   3 
#
#move 1 from 2 to 1
#move 3 from 1 to 3
#move 2 from 2 to 1
#move 1 from 1 to 2"""

# re.findall(pattern, string, flags)   r'\s'
# re.sub(r'<b>(.*?)</b>', r'\1', str)
# parse.search("age: {:d}\n", "Name: foo\nage: 35\nColor: red")[0] -> 35
# have you considered: split('\n\n')?
# have you considered: the walrus operator?
# have you considered: 
def extract(s):
    return [int(x) for x in re.findall(r'(-?\d+).?', s)]

stacks = {}
maxidx = 0
ls = d.split('\n')
while len(ls) > 0:
    l = ls[0]
    ls = ls[1:]
    if l == '':
        break
    cs = l[1::4]
    for (idx,c) in enumerate(cs):
        stacks[idx+1] = stacks.get(idx+1,[])
        if c != ' ':
            stacks[idx+1].append(c)
        if idx > maxidx:
            maxidx = idx

while len(ls) > 0:
    l = ls[0]
    ls = ls[1:]
    n,fr,to = extract(l)
    print(n, fr, to)
    for _ in range(n):
        stacks[to].insert(0, stacks[fr][0])
        stacks[fr] = stacks[fr][1:]

print(stacks)
s = ""
for c in range(maxidx+1):
    s += stacks[c+1][0]

print(s)
