from z3 import *
import math

s = Optimize()

class Base:
    def add(self, rhs):
        if isinstance(rhs, Lit) and rhs.lit == 0:
            return self
        return Add(self, rhs)
    def mul(self, rhs):
        if isinstance(rhs, Lit) and rhs.lit == 0:
            return Lit(0)
        if isinstance(rhs, Lit) and rhs.lit == 1:
            return self
        return Mul(self, rhs)
    def div(self, rhs):
        if isinstance(rhs, Lit) and rhs.lit == 1:
            return self
        return Div(self, rhs)
    def mod(self, rhs):
        return Mod(self, rhs)
    def eql(self, rhs):
        lbl,lbr,ubl,ubr = self.lbound(), rhs.lbound(), self.ubound(), rhs.ubound()
        if lbl > ubr or ubl < lbr:
            return Lit(0)
        if lbl == ubl and lbl == ubl and lbl == ubr:
            return Lit(1)
        return Eql(self, rhs)
            
class Lit(Base):
    def __init__(self, lit):
        self.lit = lit
        self.z3v = lit
    def __str__(self):
        return f"{self.lit}"
    def eql(self, rhs):
        if isinstance(rhs, Lit):
            return Lit(1 if self.lit == rhs.lit else 0)
        return super().eql(rhs)
    def add(self, rhs):
        if self.lit == 0:
            return rhs
        if isinstance(rhs, Lit):
            return Lit(self.lit + rhs.lit)
        return super().add(rhs)
    def mul(self, rhs):
        if self.lit == 0:
            return Lit(0)
        if self.lit == 1:
            return rhs
        if isinstance(rhs, Lit):
            return Lit(self.lit * rhs.lit)
        return super().mul(rhs)
    def div(self, rhs):
        if isinstance(rhs, Lit):
            return Lit(self.lit // rhs.lit)
        return super().div(rhs)
    def mod(self, rhs):
        if isinstance(rhs, Lit):
            return Lit(self.lit % rhs.lit)
        return super().mul(rhs)
    def lbound(self):
        return self.lit
    def ubound(self):
        return self.lit

class Inp(Base):
    def __init__(self):
        self.inpn = len(inps)
        self.z3v = Int(f"inp{len(inps)}")
        s.add(self.z3v >= 1, self.z3v <= 9)
        inps.append(self.z3v)
    def eql(self, rhs):
        if isinstance(rhs, Lit) and (rhs.lit < 1 or rhs.lit > 9):
            return Lit(0)
        return super().eql(rhs)
    def __str__(self):
        return f"inp{self.inpn}"
    def lbound(self):
        return 1
    def ubound(self):
        return 9

class Add(Base):
    def __init__(self, lhs, rhs):
        self.lhs = lhs
        self.rhs = rhs
        self.z3v = simplify(lhs.z3v + rhs.z3v)
    def __str__(self):
        return f"({self.lhs} + {self.rhs})"
    def lbound(self):
        return self.lhs.lbound() + self.rhs.lbound()
    def ubound(self):
        return self.lhs.ubound() + self.rhs.ubound()

class Mul(Base):
    def __init__(self, lhs, rhs):
        self.lhs = lhs
        self.rhs = rhs
        self.z3v = simplify(lhs.z3v * rhs.z3v)
    def __str__(self):
        return f"({self.lhs} * {self.rhs})"
    def lbound(self):
        lbl,lbr,ubl,ubr = self.lhs.lbound(), self.rhs.lbound(), self.lhs.ubound(), self.rhs.ubound()
        return min(lbl*lbr, lbl*ubr, ubl*lbr, ubl*ubr)
    def ubound(self):
        lbl,lbr,ubl,ubr = self.lhs.lbound(), self.rhs.lbound(), self.lhs.ubound(), self.rhs.ubound()
        return max(lbl*lbr, lbl*ubr, ubl*lbr, ubl*ubr)

class Div(Base):
    def __init__(self, lhs, rhs):
        self.lhs = lhs
        self.rhs = rhs
        # these assertions make this MUCH slower
        #s.add(self.rhs.z3v > 0)
        self.z3v = simplify(lhs.z3v / rhs.z3v)
    def __str__(self):
        return f"({self.lhs} / {self.rhs})"
    def lbound(self):
        return -math.inf
    def ubound(self):
        return math.inf

class Mod(Base):
    def __init__(self, lhs, rhs):
        self.lhs = lhs
        self.rhs = rhs
        #s.add(self.lhs.z3v >= 0)
        #s.add(self.rhs.z3v > 0)
        self.z3v = simplify(lhs.z3v % rhs.z3v)
    def __str__(self):
        return f"({self.lhs} % {self.rhs})"
    def lbound(self):
        return 0
    def ubound(self):
        return min(self.lhs.ubound(), self.rhs.ubound())

class Eql(Base):
    def __init__(self, lhs, rhs):
        self.lhs = lhs
        self.rhs = rhs
        self.z3v = If(lhs.z3v == rhs.z3v, 1, 0)
    def __str__(self):
        return f"({self.lhs} == {self.rhs})"
    def lbound(self):
        return 0
    def ubound(self):
        return 1

vars = { 'w': Lit(0), 'x': Lit(0), 'y': Lit(0), 'z': Lit(0) }
inps = []

def valfrom(s):
    try:
        return Lit(int(s))
    except:
        return vars[s]

for line in sys.stdin.readlines():
    line = line.rstrip().split()
    if line[0] == "inp":
        vars[line[1]] = Inp()
    else:
        vars[line[1]] = getattr(vars[line[1]], line[0])(valfrom(line[2]))

s.add(vars['z'].z3v == 0)

res = 0
for inp in inps:
    res = res * 10 + inp

# print(s.sexpr())

print("MAXIMIZING...")
s.push()
s.maximize(res)
print(s.check())
model = s.model()
print("".join([str(model[n]) for n in inps]))
s.pop()

print("MINIMIZING...")
s.push()
s.minimize(res)
print(s.check())
model = s.model()
print("".join([str(model[n]) for n in inps]))
s.pop()

