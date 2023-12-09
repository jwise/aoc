#!/usr/bin/env pypy3

from aocd import get_data

from collections import *
import math
import re, parse

# re.findall(pattern, string, flags)   r'\s'
# re.sub(r'<b>(.*?)</b>', r'\1', str)
# parse.search("age: {:d}\n", "Name: foo\nage: 35\nColor: red")[0] -> 35
# have you considered: split('\n\n')?
# have you considered: the walrus operator?
# have you considered: a tactical nuke on an ant?
# have you considered: 

def extract(s):
    return [int(x) for x in re.findall(r'(-?\d+).?', s)]

d = get_data(year = 2023, day = 8)

directions = d.split('\n')[0]

nodes = {}
for line in d.split('\n')[2:]:
    n,l,r = parse.search("{} = ({}, {})", line)
    nodes[n] = (l,r)

step = 0
curnode = 'AAA'
while curnode != 'ZZZ':
    dir = directions[step % len(directions)]
    if dir == 'L':
        curnode = nodes[curnode][0]
    else:
        curnode = nodes[curnode][1]
    step += 1

print(step)