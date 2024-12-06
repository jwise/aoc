#!/usr/bin/env pypy3

from aocd import get_data

from collections import *
import math
import re, parse,functools, heapq

# re.findall(pattern, string, flags)   r'\s'
# re.sub(r'<b>(.*?)</b>', r'\1', str)
# parse.search("age: {:d}\n", "Name: foo\nage: 35\nColor: red")[0] -> 35
# have you considered: split('\n\n')?
# have you considered: the walrus operator?
# have you considered: a tactical nuke on an ant?
# have you considered: 

def extract(s):
    return [int(x) for x in re.findall(r'(-?\d+).?', s)]

d = get_data(year = 2024, day = 3)
#d = open(1.x', 'r').read()

on = True
s = 0
while len(d) > 0:
    if d[:4] == 'do()':
        on = True
    if d[:7] == 'don\'t()':
        on = False
    a = re.findall(r'^mul\((\d+),(\d+)\)', d)
    if len(a) > 0:
        a,b = a[0]
        if on:
            s += int(a) * int(b)
    d = d[1:]
print(s)
