#!/usr/bin/env pypy3

from aocd import get_data

from collections import *
import math
import re, parse,functools

# re.findall(pattern, string, flags)   r'\s'
# re.sub(r'<b>(.*?)</b>', r'\1', str)
# parse.search("age: {:d}\n", "Name: foo\nage: 35\nColor: red")[0] -> 35
# have you considered: split('\n\n')?
# have you considered: the walrus operator?
# have you considered: a tactical nuke on an ant?
# have you considered: 

def extract(s):
    return [int(x) for x in re.findall(r'(-?\d+).?', s)]

d = get_data(year = 2023, day = 15)

def dohash(s):
    cv = 0
    for c in s:
        cv += ord(c)
        cv *= 17
        cv %= 256
    return cv

boxes = {}

su = 0
for s in d.split(','):
    if s[-1] == '-':
        lbl = s[:-1]
    else:
        lbl,f = s.split('=')
        f = int(f)

    bin = dohash(lbl)
    if bin not in boxes:
        boxes[bin] = []
    box = boxes[bin]

    if s[-1] == '-':
        boxes[bin] = [(lbl_, f) for (lbl_, f) in box if lbl != lbl_]
    else:
        didrepl = False
        for i,(lbl_,f_) in enumerate(box):
            if lbl_ == lbl:
                box[i] = (lbl, f)
                didrepl = True
                break
        if not didrepl:
            box.append((lbl, f))

tfp = 0
for boxno in boxes:
    for i,(lbl,f) in enumerate(boxes[boxno]):
        tfp += (boxno + 1) * (i + 1) * f
print(tfp)
