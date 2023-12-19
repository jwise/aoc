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
#d = open('19.x', 'r').read()

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

accepts = []

def mk_accepts_rule(rule, st):
    cond,dest = rule
    nst = { k: st[k] for k in st }
    
    var,param,val = cond
    if param == '<':
        nst[var] = (nst[var][0], min(nst[var][1], val-1))
        st[var] = (max(st[var][0], val), st[var][1]) # these lines were not in here half an hour ago
    elif param == '>':
        nst[var] = (max(nst[var][0], val+1), nst[var][1])
        st[var] = (st[var][0], min(st[var][1], val)) # these lines were not in here half an hour ago
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
