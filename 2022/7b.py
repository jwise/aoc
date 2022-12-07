#!/usr/bin/env python3

from aocd import get_data
from collections import *
import re, parse, math

# re.findall(pattern, string, flags)   r'\s'
# re.sub(r'<b>(.*?)</b>', r'\1', str)
# parse.search("age: {:d}\n", "Name: foo\nage: 35\nColor: red")[0] -> 35
# have you considered: split('\n\n')?
# have you considered: the walrus operator?
# have you considered: 

def extract(s):
    return [int(x) for x in re.findall(r'(-?\d+).?', s)]

root = {}

d="""$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k"""
d = get_data(year = 2022, day = 7)
ls = d.split('\n')
ls = ls[1:] # cd /
cpath = [root]
while len(ls) > 0:
    cmd = ls[0].split(' ')
    ls = ls[1:]
    if cmd[1] == 'ls':
        while len(ls) > 0 and ls[0][0] != '$':
            sz,nam = ls[0].split(' ')
            ls = ls[1:]
            if sz == 'dir':
                cpath[-1][nam] = {}
            else:
                cpath[-1][nam] = int(sz)
    elif cmd[1] == 'cd':
        if cmd[2] == '..':
            cpath.pop()
        else:
            cpath.append(cpath[-1][cmd[2]])

totsz = 0

def travers(dir):
    csz = 0
    for fn in dir:
        sz = dir[fn]
        if type(sz) == int:
            csz += sz
        else:
            csz += travers(sz)
    return csz
travers(root)

need = 30000000 - (70000000 - travers(root))

smallest = math.inf
def travers2(dir):
    global smallest
    csz = 0
    for fn in dir:
        sz = dir[fn]
        if type(sz) == int:
            csz += sz
        else:
            csz += travers2(sz)
    if csz > need:
        smallest = min(smallest,csz)
    return csz

print(travers2(root))
print(smallest)
