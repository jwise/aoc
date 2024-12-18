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

d = get_data(year = 2024, day = 17)

ls = d.split('\n')

rA0 = extract(ls[0])[0]
rB0 = extract(ls[1])[0]
rC0 = extract(ls[2])[0]
program = extract(ls[4])

print(program)

s = Optimize()
#s = Solver()

# the program alwyas ends in an out and a jnz; we know in the success case
# that it runs 16 times

BLEN = 56

bctr = 0
def ArghInt(n):
    global bctr
    bctr += 1
    return BitVec(f"{n}{bctr}", BLEN)
    
nouts = len(program)
outs = [ArghInt(f"out{o}") for o in range(nouts)]
#outs = IntVector('outs', 16)
#rA0 = ArghInt('rA0')

rA = ArghInt('rA')
rA0 = rA
#s.add(rA == rA0)
rB = ArghInt('rB')
s.add(rB == rB0)
rC = ArghInt('rC')
s.add(rC == rC0)

def combo(oper):
    if oper <= 3:
        return BitVecVal(oper, BLEN)
    elif oper == 4:
        return rA
    elif oper == 5:
        return rB
    elif oper == 6:
        return rC
    assert False

steps = []

for out in range(nouts):
    for ip in range(0, len(program), 2):
        opc,opr = program[ip:ip+2]
        #print(ip,opc,opr)
        print((opc, opr, rA, rB, rC))
        steps.append((opc, opr, rA, rB, rC))
    
        if opc == 0: # adv
            opr = combo(opr)
            opr = 1 << opr
            rA1 = ArghInt('rA')
            s.add(rA1 == rA / opr)
            rA = rA1
        elif opc == 1: # bxl
            opr = BitVecVal(opr, BLEN)
            rB1 = ArghInt('rB')
            s.add(rB1 == rB ^ opr)
            print(rB, rB1)
            rB = rB1
        elif opc == 2: # bst
            opr = combo(opr)
            rB1 = ArghInt('rB')
            s.add(rB1 == opr % 8)
            rB = rB1
        elif opc == 3: # jnz
            assert(opr == 0)
            if out == nouts - 1:
                s.add(rA == 0)
                break
            else:
                s.add(rA != 0)
        elif opc == 4: # bxc
            rB1 = ArghInt('rB')
            s.add(rB1 == rB ^ rC)
            rB = rB1
        elif opc == 5: # out
            s.add(outs[out] == combo(opr) % 8)
            s.add(outs[out] == program[out])
        elif opc == 6: # bdv
            opr = combo(opr)
            opr = 1 << opr
            rB = ArghInt('rB')
            s.add(rB == rA / opr)
        elif opc == 7: # cdv
            opr = combo(opr)
            opr = 1 << opr
            rC = ArghInt('rC')
            s.add(rC == rA / opr)

while s.check() == sat:
    m = s.model()
    print (m[rA0])
    s.add(rA0 < m[rA0].as_long())
#s.add(rA0 < 202641903725103)
#s.add(rA0 < 202367025818154)
#s.add(rA0 & 0x000000000000 == 0)

#print("minimize")
#h = s.minimize(rA0)
#print("check")
#print(s.check())
#for opc, opr, rA, rB, rC in steps:
#    print(opc, opr, [m[o].as_long() for o in [rA, rB, rC]], rA, rB, rC)
#print(",".join([str(m[o].as_long()) for o in outs]))
#print(m[h] for o in outs)
