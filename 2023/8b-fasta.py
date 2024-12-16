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
#d = open('8.x', 'r').read()

directions = d.split('\n')[0]

nodes = {}
for line in d.split('\n')[2:]:
    n,l,r = parse.search("{} = ({}, {})", line)
    nodes[n] = (l,r)

step = 0
curnodes = [ { 'cur': node, 'hist': [ (node, 0,) ], 'cycle': False } for node in nodes if node[2] == 'A' ]
while not all([node['cycle'] for node in curnodes]):
    dir = directions[step % len(directions)]
    step += 1
    for n in curnodes:
        if not n['cycle']:
            nextn = nodes[n['cur']][0] if dir == 'L' else nodes[n['cur']][1]
            n['cur'] = nextn
            hist = (nextn, step % len(directions), )
            if hist in n['hist']:
                n['cycle'] = True
            n['hist'].append(hist)

cycles = []
for n in curnodes:
    # print the salient parameters of the cycle:
    #   ticks to the start of the cycle
    #   length of the cycle
    #   number of 'Z's in the cycle I guess??
#    print(n['hist'])
    for i,tick in enumerate(n['hist']):
        if tick == n['hist'][-1]:
            break
    cycstart = i
    nzs = 0
    zpos = None
    for i,(where,_) in enumerate(n['hist']):
        if where[2] == 'Z':
            if zpos is None:
                zpos = i
            nzs += 1
    n['cycstart'] = cycstart
    n['cyclen'] = len(n['hist']) - cycstart - 1
    n['zpos'] = zpos
    print(f"cycle starts at {cycstart}, cycle is {n['cyclen']} ticks long, z ({nzs}) is at {zpos}")
#    print(n['hist'])

#curnodes[1]['cyclen'] = 3

step = curnodes[0]['zpos'] + curnodes[0]['cyclen'] * 58
while not all([ ((step - n['cycstart']) % n['cyclen']) == (n['zpos'] - n['cycstart']) for n in curnodes ]):
    print(step, [((step - n['cycstart']) % n['cyclen'], n['zpos'] - n['cycstart']) for n in curnodes ])
    step += curnodes[0]['cyclen'] * 59

print(step)
