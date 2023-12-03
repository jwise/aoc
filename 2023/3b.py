#!/usr/bin/env pypy3

from aocd import get_data

from collections import *
import re#, parse

# re.findall(pattern, string, flags)   r'\s'
# re.sub(r'<b>(.*?)</b>', r'\1', str)
# parse.search("age: {:d}\n", "Name: foo\nage: 35\nColor: red")[0] -> 35
# have you considered: split('\n\n')?
# have you considered: the walrus operator?
# have you considered: 

def extract(s):
    return [int(x) for x in re.findall(r'(-?\d+).?', s)]

d = get_data(year = 2023, day = 3)
#d = open('3.x','r').read()
lines = d.split('\n')

syms = []
nums = [] # y, xstart, xend, num

y = 0
for l in lines:
    l += "." # lolol
    x = 0
    num = 0
    xstart = None
    for c in l:
        if c >= '0' and c <= '9':
            if xstart is None:
                num = 0
                xstart = x
            num = num * 10 + int(c)
        else:
            if xstart is not None:
                nums.append((y, xstart, x-1, num))
                xstart = None
        if c != '.' and not (c >= '0' and c <= '9'):
            syms.append((y,x,c,))
        x += 1
    y += 1 

print(syms)
print(nums)

# check diagonals for each symbol
def check(y,x, gotnums):
    for num in nums:
        (ynum, xstart, xend, val) = num
        if y == ynum and x >= xstart and x <= xend:
            if num not in gotnums:
                gotnums.append(num)

tot = 0
for (y,x, c) in syms:
    if c != '*':
        continue
    gotnums = []
    check(y-1,x-1, gotnums)
    check(y-1,x  , gotnums)
    check(y-1,x+1, gotnums)
    check(y  ,x-1, gotnums)
    check(y  ,x+1, gotnums)
    check(y+1,x-1, gotnums)
    check(y+1,x  , gotnums)
    check(y+1,x+1, gotnums)
    if len(gotnums) == 2:
        print(gotnums)
        tot += gotnums[0][3] * gotnums[1][3]
print(tot)