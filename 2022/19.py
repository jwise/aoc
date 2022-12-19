#!/usr/bin/env python3

from aocd import get_data
from collections import *
import re, parse, itertools, os, functools

if 'TEST' not in os.environ:
    d = get_data(year = 2022, day = 19)
else:
    d = """Blueprint 1: Each ore robot costs 4 ore. Each clay robot costs 2 ore. Each obsidian robot costs 3 ore and 14 clay. Each geode robot costs 2 ore and 7 obsidian.
Blueprint 2: Each ore robot costs 2 ore. Each clay robot costs 3 ore. Each obsidian robot costs 3 ore and 8 clay. Each geode robot costs 3 ore and 12 obsidian."""

bps = []
for l in d.split('\n'):
    l = re.sub("Blueprint .*: ", "", l)
    l = re.sub("\\. ", ".", l)
    bp = {}
    for rob in l.split('.'):
        if rob == '':
            continue
        words = rob.split(' ')
        outp = words[1]
        costns = words[4::3]
        targs = words[5::3]
        cts = {}
        for c,t in zip(costns, targs):
            cts[t] = int(c)
        bp[outp] = cts
    bps.append(bp)

print(bps)

iters = 0
@functools.lru_cache(None)
def dfs(trem, ore, clay, obs, orer, clayr, obsr, geor):
    if trem == 0:
        return 0
    
    global bp
    global iters
    
    iters += 1
    if iters % 100000 == 0:
        print(iters)
    
    best = 0

    too_much_obs = (obs + obsr * trem * 0.2) > trem * bp['geode']['obsidian']
    too_much_clay = (clay + clayr * trem * 0.2) > trem * bp['obsidian']['clay'] or too_much_obs
    too_much_ore = (ore + orer * trem * 0.2) > trem * max(bp['ore']['ore'], 0 if too_much_clay else bp['clay']['ore'], 0 if too_much_obs else bp['obsidian']['ore'], bp['geode']['ore'])

    can_build_geode = False
    if ore >= bp['geode']['ore'] and obs >= bp['geode']['obsidian']:
        can_build_geode = True
        best = max(best, dfs(trem - 1, ore + orer - bp['geode']['ore'], clay + clayr, obs + obsr - bp['geode']['obsidian'], orer, clayr, obsr, geor + 1))
    if ore >= bp['ore']['ore'] and not too_much_ore and not can_build_geode:
        best = max(best, dfs(trem - 1, ore + orer - bp['ore']['ore'], clay + clayr, obs + obsr, orer + 1, clayr, obsr, geor))
    if ore >= bp['clay']['ore'] and not too_much_clay and not too_much_obs and not can_build_geode:
        best = max(best, dfs(trem - 1, ore + orer - bp['clay']['ore'], clay + clayr, obs + obsr, orer, clayr + 1, obsr, geor))
    if ore >= bp['obsidian']['ore'] and clay >= bp['obsidian']['clay'] and not too_much_obs and not can_build_geode:
        best = max(best, dfs(trem - 1, ore + orer - bp['obsidian']['ore'], clay + clayr - bp['obsidian']['clay'], obs + obsr, orer, clayr, obsr + 1, geor))
    if not can_build_geode:
        best = max(best, dfs(trem - 1, ore + orer, clay + clayr, obs + obsr, orer, clayr, obsr, geor))
    
    return best + geor

TIME=24
acc = 0
for n,bp in enumerate(bps):
    print(n, bp)
    res = dfs(TIME, 0, 0, 0, 1, 0, 0, 0)
    print(res)
    acc += (n + 1) * res
    dfs.cache_clear()
    iters = 0
print(acc)
