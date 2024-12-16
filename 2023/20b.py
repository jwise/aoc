#!/usr/bin/env pypy3

from aocd import get_data

from collections import *
import math
import re, parse,functools, heapq
import vcd.writer

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

vcdf = vcd.writer.VCDWriter(open("lol.vcd", "w"))

for mod in mods:
    for out in mods[mod]["out"]:
        if out in mods and mods[out]["t"] == "&":
            mods[out]["st"][mod] = LOW
    print(f"{mod} -> {{ {' '.join(mods[mod]['out'])} }}")
    mods[mod]["var"] = vcdf.register_var("", mod, 'reg', 1)

pulseq = [ ]
hicnt = 0
locnt = 0
pulsecnt = 0


def run():
    global hicnt
    global locnt
    hirx = 0
    lorx = 0

    # broadcaster
    pulseq.append(("broadcaster", LOW, None))
    while len(pulseq) > 0:
        dest, level, src = pulseq.pop(0)
        
        if level == HIGH:
            hicnt += 1
        else:
            locnt += 1
        
        if src == "mk":
            print(src, tick, level)
        
        if dest == 'rx':
            if level == HIGH:
                hirx += 1
            else:
                lorx += 1
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

    for mod in mods:
        if mods[mod]["t"] == "%":
            vcdf.change(mods[mod]["var"], tick, 1 if mods[mod]["st"] else 0)
        elif mods[mod]["t"] == "&":
            vcdf.change(mods[mod]["var"], tick, 1 if all([mods[mod]["st"][i] == HIGH for i in mods[mod]["st"]]) else 0)
    
    print(hirx, lorx)

for tick in range(1,10000000):
    run()
print(hicnt, locnt, hicnt * locnt)
vcdf.close()