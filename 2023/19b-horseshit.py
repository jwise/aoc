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

d = get_data(year = 2023, day = 19)
d = open('19.x', 'r').read()

wls,pls = d.split('\n\n')
ws = {}
for wl in wls.split('\n'):
    wf = []
    name,rules = wl.split('{')
    rules = rules[:-1]
    for r in rules.split(','):
        cond = None
        dest = r
        if ':' in r:
            cond,dest = r.split(':')
            cond = (cond[0], cond[1], int(cond[2:]))
        wf.append((cond, dest))
    ws[name] = wf

def tryit(x,m,a,s):
    w = 'in'
    while w != 'A' and w != 'R':
        for cond,dest in ws[w]:
            if cond == None:
                w = dest
                break
            var,cond,val = cond
            if var == 'x':
                var = x
            elif var == 'm':
                var = m
            elif var == 'a':
                var = a
            elif var == 's':
                var = s
            else:
                ass()
            if (cond == '<' and var < val) or (cond == '>' and var > val):
                w = dest
                break
    return w == 'A'

# we are building a k-d tree, where each element is:

accepts = []

def mk_accepts_rule(rule, st):
    cond,dest = rule
    nst = { k: st[k] for k in st }
    
    var,param,val = cond
    if param == '<':
        nst[var] = (nst[var][0], min(nst[var][1], val-1))
    elif param == '>':
        nst[var] = (max(nst[var][0], val+1), nst[var][1])
    else:
        ass()
    
    mk_accepts_wf(dest, nst)

def mk_accepts_wf(wf, st):
    if wf == 'A':
        accepts.append(st)
        return
    if wf == 'R':
        return
    
    for rule in ws[wf]:
        if rule[0] == None:
            return mk_accepts_wf(rule[1], st)
        mk_accepts_rule(rule, st)

st0 = { "x": (1, 4000), "m": (1, 4000), "a": (1, 4000), "s": (1, 4000) }

mk_accepts_wf('in', st0)

tot = 0
bps = { "x": [], "m": [], "a": [], "s": [] }

for a in accepts:
    for var in a:
        vmin,vmax = a[var]
        if vmin-1 not in bps[var]:
            bps[var].append(vmin-1)
        if vmin not in bps[var]:
            bps[var].append(vmin)
        if vmax not in bps[var]:
            bps[var].append(vmax)
        if vmax+1 not in bps[var]:
            bps[var].append(vmax+1)


combs = 1
for var in "xmas":
    bps[var].sort()
    combs *= len(bps[var])

print(bps)
print(combs)

rns = 0
for pl in pls.split('\n'):
    x,m,a,s = extract(pl)
    if tryit(x,m,a,s):
        print(x,m,a,s)
        rns += x+m+a+s
print("rns", rns)

nsofar = 0
ntot = 0
x0 = bps['x'][0]
for x in bps['x'][1:]:
    m0 = bps['m'][0]
    for m in bps['m'][1:]:
        a0 = bps['a'][0]
        for a in bps['a'][1:]:
            s0 = bps['s'][0]
            for s in bps['s'][1:]:
                nsofar += 1
                if nsofar % 1000000 == 0:
                    print(nsofar, combs)
                print(f"({x0},{x}) ({m0},{m}) ({a0},{a}) ({s0},{s})")
                if tryit(x,m,a,s0):
                    ntot += (x-x0) * (m-m0) * (a-a0) * (s-s0)
                s0 = s
            a0 = a
        m0 = m
    x0 = x

print(ntot)
print(167409079868000)
print(ntot/167409079868000)
ass()

for a in accepts:
    choices = 1
    for k in a:
        vmin,vmax = a[k]
        if vmax < vmin:
            choices = 0
        else:
            choices = choices * (vmax-vmin + 1)
    tot += choices
print(accepts,tot)