#!/usr/bin/env pypy3

from aocd import get_data

from collections import *
import math
import re, parse,functools, heapq
from itertools import combinations

# re.findall(pattern, string, flags)   r'\s'
# re.sub(r'<b>(.*?)</b>', r'\1', str)
# parse.search("age: {:d}\n", "Name: foo\nage: 35\nColor: red")[0] -> 35
# have you considered: split('\n\n')?
# have you considered: the walrus operator?
# have you considered: a tactical nuke on an ant?
# have you considered: 
def extract(s):
    return [int(x) for x in re.findall(r'(-?\d+).?', s)]

d = get_data(year = 2023, day = 25)

nodes = {}
for l in d.split('\n'):
    n0,ns = l.split(': ')
    nodes[n0] = set(ns.split(' '))

#print("digraph G {")
#for n in nodes:
#    for ns in nodes[n]:
#        print(f"{n} -> {ns};")
#print("}")

allnodes = set()
for n in nodes:
    for ns in nodes[n]:
        allnodes.add(ns)

for n in allnodes:
    if n not in nodes:
        nodes[n] = set()

for n in nodes:
    for ns in nodes[n]:
        nodes[ns].add(n)

nodes['cvx'].remove('dph')
nodes['sgc'].remove('xvk')
nodes['pzc'].remove('vps')

print(len(nodes))
seta = set(['cvx'])
lastl = 0
while lastl != len(seta):
    lastl = len(seta)
    for n in list(seta):
        for nn in nodes[n]:
            seta.add(nn)
print(len(seta) * (len(nodes) - len(seta)))