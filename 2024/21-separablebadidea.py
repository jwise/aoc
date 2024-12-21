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

d = get_data(year = 2024, day = 21)

#d="029A\n980A\n179A\n456A\n379A\n"

#d="029A"

vctr = 0
def genvar():
    global vctr
    vctr += 1
    return Int(f"gen{vctr}")

def genbool():
    global vctr
    vctr += 1
    return Bool(f"gen{vctr}")

@functools.cache
def cansolve(frompos, topos, isteps):
    s = Solver()
    
    k1x,k1y = 2,0
    k2x,k2y = 2,0
    k3y, k3x = frompos
    
    outpos = 0
    stepar = []
    
    # keys
    for n in range(isteps):
        #print(n)
        
        # keyboard 0: directional, direct input
        btn0 = genvar()
        stepar.append(btn0)
        
        IS_A = btn0 == 0
        IS_L = btn0 == 1
        IS_R = btn0 == 2
        IS_U = btn0 == 3
        IS_D = btn0 == 4
        IS_EOF = btn0 == 5
        
        s.add(Or(IS_A, IS_L, IS_R, IS_U, IS_D, IS_EOF))
        s.add(Implies(outpos == 1, IS_EOF))
        
        k1x_n, k1y_n = genvar(), genvar()
        s.add(Implies(IS_L, And(k1x != 0, Not(And(k1y == 0, k1x == 1)))))
        s.add(Implies(IS_R, k1x != 2))
        s.add(Implies(IS_U, And(k1y != 0, Not(And(k1y == 1, k1x == 0)))))
        s.add(Implies(IS_D, k1y != 1))
        s.add(k1x_n == If(IS_L, k1x - 1, If(IS_R, k1x + 1, k1x)))
        s.add(k1y_n == If(IS_U, k1y - 1, If(IS_D, k1y + 1, k1y)))
        
        # keyboard 1: dierctional, from kbd0
        
        K1_IS_A = And(IS_A, k1x == 2, k1y == 0)
        K1_IS_U = And(IS_A, k1x == 1, k1y == 0)
        K1_IS_L = And(IS_A, k1x == 0, k1y == 1)
        K1_IS_D = And(IS_A, k1x == 1, k1y == 1)
        K1_IS_R = And(IS_A, k1x == 2, k1y == 1)
        
        k2x_n, k2y_n = genvar(), genvar()
        s.add(Implies(K1_IS_L, And(k2x != 0, Not(And(k2y == 0, k2x == 1)))))
        s.add(Implies(K1_IS_R, k2x != 2))
        s.add(Implies(K1_IS_U, And(k2y != 0, Not(And(k2y == 1, k2x == 0)))))
        s.add(Implies(K1_IS_D, k2y != 1))
        s.add(k2x_n == If(K1_IS_L, k2x - 1, If(K1_IS_R, k2x + 1, k2x)))
        s.add(k2y_n == If(K1_IS_U, k2y - 1, If(K1_IS_D, k2y + 1, k2y)))

        # keyboard 2: directional, from kbd1
        
        K2_IS_A = And(K1_IS_A, k2x == 2, k2y == 0)
        K2_IS_U = And(K1_IS_A, k2x == 1, k2y == 0)
        K2_IS_L = And(K1_IS_A, k2x == 0, k2y == 1)
        K2_IS_D = And(K1_IS_A, k2x == 1, k2y == 1)
        K2_IS_R = And(K1_IS_A, k2x == 2, k2y == 1)
        
        k3x_n, k3y_n = genvar(), genvar()
        s.add(Implies(K2_IS_L, And(k3x != 0, Not(And(k3y == 3, k3x == 1)))))
        s.add(Implies(K2_IS_R, k3x != 2))
        s.add(Implies(K2_IS_U, k3y != 0))
        s.add(Implies(K2_IS_D, And(k3y != 3, Not(And(k3y == 2, k3x == 0)))))
        s.add(k3x_n == If(K2_IS_L, k3x - 1, If(K2_IS_R, k3x + 1, k3x)))
        s.add(k3y_n == If(K2_IS_U, k3y - 1, If(K2_IS_D, k3y + 1, k3y)))
        
        # keyboard 3: numpad, from kbd2
        outpos_n = genvar()
        s.add(outpos_n == If(K2_IS_A, 1, 0))
        s.add(Implies(K2_IS_A, And(k3x == topos[1], k3y == topos[0])))
        
        k1x,k1y = k1x_n,k1y_n
        k2x,k2y = k2x_n,k2y_n
        k3x,k3y = k3x_n,k3y_n
        outpos = outpos_n

    s.add(outpos == 1)
    return s.check() == sat

@functools.cache
def solvesteps(frompos, topos):
    print(f"looking for path from {frompos} to {topos}")
    nsteps = 1
    while not cansolve(frompos, topos, nsteps):
        nsteps *= 2
        print(nsteps)
    lb = nsteps // 2
    ub = nsteps
    while lb != ub:
        testval = (lb + ub) // 2
        print(testval)
        if cansolve(frompos, topos, testval):
            ub = testval
        else:
            lb = testval + 1
    return lb

kpos = {
"0":(3,1),"1":(2,0),"2":(2,1),"3":(2,2),"4":(1,0),"5":(1,1),"6":(1,2),"7":(0,0),"8":(0,1),"9":(0,2),"A":(3,2)
}

score = 0
for l in d.split('\n'):
    print(l)
    a0 = kpos["A"]
    tsteps = 0
    for c in l:
        tsteps += solvesteps(a0, kpos[c])
        a0 = kpos[c]
    print(tsteps)
    c = extract(l)[0]
    score += c * tsteps
print(score)