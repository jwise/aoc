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

d = get_data(year = 2023, day = 20)
#d = open('20.x', 'r').read()

mods = {}
for l in d.split('\n'):
    modn = l.split(' -> ')[0]
    outs = l.split(' -> ')[1].split(', ')
    
    if modn == 'broadcaster':
        mods[modn] = { "t": "broadcaster", "out": outs }
    else:
        if modn[0] == "&":
            initst = {}
        elif modn[0] == "%":
            initst = False
        else:
            print(modn)
            ass()
        mods[modn[1:]] = { "t": modn[0], "out": outs, "st": initst }

HIGH = True
LOW = False

for mod in mods:
    for out in mods[mod]["out"]:
        if out in mods and mods[out]["t"] == "&":
            mods[out]["st"][mod] = LOW

pulseq = [ ]
hicnt = 0
locnt = 0
pulsecnt = 0

def run():
    global hicnt
    global locnt
#    print("***")
    pulseq.append(("broadcaster", LOW, None))
    while len(pulseq) > 0:
        dest, level, src = pulseq.pop(0)
#        print(f"{src} -{'high' if level else 'low'}-> {dest}")
        if level == HIGH:
            hicnt += 1
        else:
            locnt += 1
        if dest not in mods:
            continue

        mod = mods[dest]
        if mod["t"] == "broadcaster":
            for mm in mod["out"]:
                pulseq.append((mm, level, dest))
        elif mod["t"] == "&":
            mod["st"][src] = level
            nlevel = LOW if all([mod["st"][i] == HIGH for i in mod["st"]]) else HIGH
            for mm in mod["out"]:
                pulseq.append((mm, nlevel, dest))
        elif mod["t"] == "%":
            if level == LOW:
                mod["st"] = not mod["st"]
                nlevel = HIGH if mod["st"] else LOW
                for mm in mod["out"]:
                    pulseq.append((mm, nlevel, dest))
        else:
            print(dest, mod)
            ass()
    print(hicnt, locnt, hicnt + locnt)

for i in range(1000):
    run()
print(hicnt, locnt, hicnt * locnt)