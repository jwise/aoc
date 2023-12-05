#!/usr/bin/env pypy3

from aocd import get_data

from collections import *
import math
import re#, parse

# re.findall(pattern, string, flags)   r'\s'
# re.sub(r'<b>(.*?)</b>', r'\1', str)
# parse.search("age: {:d}\n", "Name: foo\nage: 35\nColor: red")[0] -> 35
# have you considered: split('\n\n')?
# have you considered: the walrus operator?
# have you considered: 

def extract(s):
    return [int(x) for x in re.findall(r'(-?\d+).?', s)]

d = get_data(year = 2023, day = 5)
#d = open('5.x', 'r').read()

sections = d.split('\n\n')

seeds = extract(sections[0])

smaps = []
for s in sections[1:]:
    sec = []
    for l in s.split('\n')[1:]:
        print(l)
        dstart, sstart, rlen = extract(l)
        sec.append((sstart, dstart, rlen, ))
    sec.sort()
    smaps.append(sec)

def map(snum, val):
    print(snum, val)
    if snum >= len(smaps):
        print("DONE")
        return val
    for dstart, sstart, rlen in smaps[snum]:
        if val >= sstart and val < (sstart + rlen):
            print("MATCH")
            return map(snum+1, dstart + val - sstart)
    print("NO MATCH")
    return map(snum+1, val)

# seed with ranges
ranges = []
for start,rlen in zip(seeds[::2], seeds[1::2]):
    ranges.append((start, rlen, ))

for smap in smaps:
    #smap is sorted, ranges is sorted
    print(ranges)
    nranges = []
    while len(ranges) > 0:
        if len(smap) == 0:
            nranges += ranges # and we are done
            ranges = []
            break
        rstart, rlen = ranges[0]
        sstart, dstart, convlen = smap[0]
        if rstart < sstart:
            # crack this range: the part that is before the mapping, and the part that is at the mapping
            # part before:
            r0start = rstart
            r0len = min(rlen, sstart - rstart)
            
            r1start = r0start + r0len
            r1len = rlen - r0len
            
            if r1len > 0:
                ranges[0] = (r1start, r1len, )
            else:
                ranges = ranges[1:]
            nranges.append((r0start, r0len, ))
        else:
            # rstart >= sstart, so crack to the part that is within and the part that is outside
            r0start = rstart
            #   sstart        rstart         convlen                  rlen
            r0len = min(sstart + convlen - rstart, rlen)
            if r0len < 0:
                r0len = 0
            
            r1start = r0start + r0len
            r1len = rlen - r0len
            
            if r0len == 0:
                smap = smap[1:]
            else:
                nranges.append((r0start - sstart + dstart, r0len, ))
                if r1len > 0:
                    ranges[0] = (r1start, r1len, )
                else:
                    ranges = ranges[1:]
    nranges.sort()
    ranges = nranges

print(ranges)