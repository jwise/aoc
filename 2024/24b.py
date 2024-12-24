#!/usr/bin/env pypy3

from aocd import get_data

from collections import *
import math
import re, parse,functools, heapq,itertools

from z3 import *

# re.findall(pattern, string, flags)   r'\s'
# re.sub(r'<b>(.*?)</b>', r'\1', str)
# parse.search("age: {:d}\n", "Name: foo\nage: 35\nColor: red")[0] -> 35
# have you considered: split('\n\n')?
# have you considered: the walrus operator?
# have you considered: a tactical nuke on an ant?
# have you considered: 

def extract(s):
    return [int(x) for x in re.findall(r'(-?\d+).?', s)]

d = get_data(year = 2024, day = 24)

BITS = 45

nodes = {}
for l in d.split('\n\n')[0].split('\n'):
    n,v = l.split(': ')
    #nodes[n] = int(v)

for l in d.split('\n\n')[1].split('\n'):
    n1,op,n2,arrow,out = l.split(' ')
    nodes[out] = { 'in': [n1, n2], 'op': op }
    nodes[out]['in'].sort()

# look for carry gen nodes
a_and_b = {}
a_xor_b = {}
for b in range(BITS):
    found_direct_carry = False
    found_direct_sum2 = False
    for n in nodes:
        if nodes[n]['in'][0] == f"x{b:02d}" and nodes[n]['in'][1] == f"y{b:02d}":
            if nodes[n]['op'] == "AND":
                found_direct_carry = True
                a_and_b[b] = n
            if nodes[n]['op'] == "XOR":
                found_direct_sum2 = True
                a_xor_b[b] = n
            if nodes[n]['op'] == "OR":
                print(f"WTF {n} {nodes[n]}")
    if not found_direct_carry:
        print(f"carry missing {b}")
    if not found_direct_sum2:
        print(f"sum2 missing {b}")

def rename(k, nn):
    nodes[nn] = nodes[k]
    for n in nodes:
        for vv in range(len(nodes[n]['in'])):
            if nodes[n]['in'][vv] == k:
                nodes[n]['in'][vv] = nn
for i,k in a_and_b.items():
    nn = f"{k}=a&b{i:02d}"
    rename(k, nn)
    a_and_b[i] = nn
for i,k in a_xor_b.items():
    nn = f"{k}=a^b{i:02d}"
    rename(k, nn)
    a_xor_b[i] = nn

# merge same-type nodes
"""
tokill = []
for n1 in nodes:
    ty1 = nodes[n1]['op']
    for n2 in nodes:
        ty2 = nodes[n2]['op']
        if ty1 == ty2 and n1 in nodes[n2]['in']:
            # n1 can be subsumed into n2 iff n1 is not in any third node n3
            cankill = True
            for n3 in nodes:
                ty3 = nodes[n1]['op']
                if n3 == n2:
                    continue
                if n1 in nodes[n3]['in']:
                    print(f"cannot subsume {n1} -> {n2} because it is also in {n3}")
                    cankill = False
            if cankill:
                print(f"subsume {n1} -> {n2}")
"""

c1_out = {}
c1_out[0] = a_and_b[0]
c1_intermediate = {}
involved = set()
for b in range(1,BITS):
    # now look for missing carry nodes
    found_result_sum = False
    found_c_intermediate = False
    found_c1_out = False
    c1_in = c1_out[b-1]
    for n in nodes:
        ins = nodes[n]['in']
        op = nodes[n]['op']
        if c1_out[b-1] in ins and a_xor_b[b] in ins and op == "XOR":
            found_result_sum = True
            if n != f"z{b:02d}":
                print(f"output node {n} was not z{b:02d}")
                involved.add(n)
                involved.add(f"z{b:02d}")
        elif op == "OR" and a_and_b[b] in ins:
            found_c1_out = True
            # inputs should be c_intermediate, a_and_b
            c1_out[b] = n
            if a_and_b[b] == ins[0]:
                if b in c1_intermediate:
                    if c1_intermediate[b] != ins[1]:
                        print(f"bit {b} OR should have intermediate {c1_intermediate[b]}, has inputs {ins}")
                else:
                    c1_intermediate[b] = ins[1]
            if a_and_b[b] == ins[1]:
                if b in c1_intermediate:
                    if c1_intermediate[b] != ins[0]:
                        print(f"bit {b} OR should have intermediate {c1_intermediate[b]}, has inputs {ins}")
                else:
                    c1_intermediate[b] = ins[0]
        elif op == "AND" and a_xor_b[b] in ins:
            # inputs should be c1_in, a_xor_b
            found_c_intermediate = True
            if b in c1_intermediate and c1_intermediate[b] != n:
                print(f"bit {b} AND shoudl be intermediate {c1_intermediate[b]} but is {n}")
            else:
                c1_intermediate[b] = n
    if not found_c1_out:
        print(f"c1_out was missing for bit {b}, a_and_b[b] = {a_and_b[b]}")
        involved.add(a_and_b[b])
        c1_out[b] = None
    if not found_c_intermediate:
        print(f"c_intermediate was missing for bit {b}, a_xor_b[b] = {a_xor_b[b]}")
        involved.add(a_xor_b[b])

ilist = list(involved)
ilist.sort()
print(",".join(i.split('=')[0] for i in ilist))