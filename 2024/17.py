#!/usr/bin/env pypy3

from aocd import get_data

from collections import *
import math
import re, parse,functools, heapq,itertools

# re.findall(pattern, string, flags)   r'\s'
# re.sub(r'<b>(.*?)</b>', r'\1', str)
# parse.search("age: {:d}\n", "Name: foo\nage: 35\nColor: red")[0] -> 35
# have you considered: split('\n\n')?
# have you considered: the walrus operator?
# have you considered: a tactical nuke on an ant?
# have you considered: 

def extract(s):
    return [int(x) for x in re.findall(r'(-?\d+).?', s)]

d = get_data(year = 2024, day = 17)

ls = d.split('\n')

rA = extract(ls[0])[0]
rB = extract(ls[1])[0]
rC = extract(ls[2])[0]
program = extract(ls[4])

ip = 0

def combo(oper):
    if oper <= 3:
        return oper
    elif oper == 4:
        return rA
    elif oper == 5:
        return rB
    elif oper == 6:
        return rC
    assert False

outs = []

while ip < len(program):
    opc,opr = program[ip:ip+2]
    print(opc,opr,rA,rB,rC)
    
    if opc == 0: # adv
        opr = combo(opr)
        opr = 1 << opr
        rA = int(rA / opr)
        ip += 2
    elif opc == 1: # bxl
        rB = rB ^ opr
        ip += 2
    elif opc == 2: # bst
        opr = combo(opr)
        rB = opr % 8
        ip += 2
    elif opc == 3: # jnz
        if rA == 0:
            ip += 2
        else:
            ip = opr
    elif opc == 4: # bxc
        rB = rB ^ rC
        ip += 2
    elif opc == 5: # out
        outs.append(combo(opr) % 8)
        ip += 2
    elif opc == 6: # bdv
        opr = combo(opr)
        opr = 1 << opr
        rB = int(rA / opr)
        ip += 2
    elif opc == 7: # cdv
        opr = combo(opr)
        opr = 1 << opr
        rC = int(rA / opr)
        ip += 2

print(",".join([str(s) for s in outs]))