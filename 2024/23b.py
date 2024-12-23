#!/usr/bin/env pypy3

from aocd import get_data

from collections import *
import math
import re, parse,functools, heapq,itertools

import networkx as nx
from networkx.algorithms.approximation import max_clique

# re.findall(pattern, string, flags)   r'\s'
# re.sub(r'<b>(.*?)</b>', r'\1', str)
# parse.search("age: {:d}\n", "Name: foo\nage: 35\nColor: red")[0] -> 35
# have you considered: split('\n\n')?
# have you considered: the walrus operator?
# have you considered: a tactical nuke on an ant?
# have you considered: 

def extract(s):
    return [int(x) for x in re.findall(r'(-?\d+).?', s)]

d = get_data(year = 2024, day = 23)

G = nx.Graph()

for l in d.split('\n'):
    a,b = l[0:2],l[3:]
    print(a,b)
    G.add_edge(a, b)

print(G)
C = list(max_clique(G))
C.sort()
print(",".join(C))
