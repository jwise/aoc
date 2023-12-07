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

d = get_data(year = 2023, day = 7)
#d = """32T3K 765
#T55J5 684
#KK677 28
#KTJJT 220
#QQQJA 483"""

def mapc(c):
    if c == 'T':
        return 10
    elif c == 'J':
        return 11
    elif c == 'Q':
        return 12
    elif c == 'K':
        return 13
    elif c == 'A':
        return 14
    else:
        return int(c)

FIVE_OF_A_KIND = 6
FOUR_OF_A_KIND = 5
FULL_HOUSE = 4
THREE_OF_A_KIND = 3
TWO_PAIR = 2
ONE_PAIR = 1
HIGH_CARD = 0

def handtype(hand):
    handhist = {}
    for c in hand:
        handhist[c] = handhist.get(c, 0) + 1
    twos = 0
    for c in handhist:
        if handhist[c] == 5:
            return FIVE_OF_A_KIND
        elif handhist[c] == 4:
            return FOUR_OF_A_KIND
        elif handhist[c] == 3:
            for c2 in handhist:
                if handhist[c2] == 2:
                    return FULL_HOUSE
            return THREE_OF_A_KIND
        elif handhist[c] == 2:
            twos += 1
    if twos == 2:
        return TWO_PAIR
    if twos == 1:
        return ONE_PAIR
    return HIGH_CARD

hands = []
for l in d.split('\n'):
    hand,bid = l.split(' ')
    hand = [mapc(c) for c in hand]
    bid = int(bid)
    hands.append((handtype(hand), hand, bid, ))
hands.sort()

tot = 0
for n, (tipo, hand, bid, ) in enumerate(hands):
    print(n, tipo, hand, bid)
    tot += (n+1) * bid
print(tot)