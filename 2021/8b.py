import sys
import itertools
from z3 import *

a,b,c,d,e,f,g = Ints('a b c d e f g')
segs = { "a": a, "b": b, "c": c, "d": d, "e": e, "f": f, "g": g }
A,B,C,D,E,F,G = 0,1,2,3,4,5,6
segn = { "a": A, "b": B, "c": C, "d": D, "e": E, "f": F, "g": G }

all = 0

for line in sys.stdin.readlines():
    s = Solver()
    for seg1 in segs:
        for seg2 in segs:
            if seg1 != seg2:
                s.add(segs[seg1] != segs[seg2])
        s.add(segs[seg1] >= 0, segs[seg1] <= 6)

    def perms(observe, maybe):
        set0 = EmptySet(IntSort())
        for seg in observe:
            set0 = SetAdd(set0, segs[seg])
        set1 = EmptySet(IntSort())
        for seg in maybe:
            set1 = SetAdd(set1, segn[seg])
        return [set0 == set1]

    line = line.rstrip()
    for num in line.split():
        poss = []
        if len(num) == 2:
            poss += perms(num, "cf")
        elif len(num) == 3:
            poss += perms(num, "acf") # 7
        elif len(num) == 4:
            poss += perms(num, "bcdf") # 4
        elif len(num) == 5:
            poss += perms(num, "acdeg") # 2
            poss += perms(num, "acdfg") # 3
            poss += perms(num, "abdfg") # 5
        elif len(num) == 6:
            poss += perms(num, "abcefg") # 0
            poss += perms(num, "abdefg") # 6
            poss += perms(num, "abcdfg") # 9
        if len(poss) > 0:
            s.add(Or(*poss))
    s.check()
    m = s.model()
    
    nums = line.split()[-4:]
    val = 0
    demap = { "012456": 0, "25": 1, "02346": 2, "02356": 3, "1235": 4, "01356": 5, "013456": 6, "025": 7, "0123456": 8, "012356": 9 }
    for num in nums:
        val = val * 10
        l = [m[segs[seg]].as_long() for seg in num]
        l.sort()
        pat = "".join([str(c) for c in l])
        val = val + demap[pat]
    all = all + val
    print(val)

print("***")
print(all)