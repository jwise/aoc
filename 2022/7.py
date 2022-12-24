#!/usr/bin/env python3

from aocd import get_data
from collections import *
import re, parse

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
    l = ls.pop(0)
    if cmd := parse.parse('$ ls', l):
        while len(ls) > 0 and ls[0][0] != '$':
            sz,nam = ls.pop(0).split(' ')
            if sz == 'dir':
                cpath[-1][nam] = {}
            else:
                cpath[-1][nam] = int(sz)
    elif cmd := parse.parse('$ cd {}', l):
        if cmd[0] == '..':
            cpath.pop()
        else:
            cpath.append(cpath[-1][cmd[0]])

totsz = 0
def travers(dir):
    global totsz
    csz = 0
    for fn in dir:
        sz = dir[fn]
        if type(sz) == int:
            csz += sz
        else:
            csz += travers(sz)
    if csz <= 100000:
        totsz += csz
    return csz

print(root)
travers(root)
print(totsz)
