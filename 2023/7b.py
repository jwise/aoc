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

d = """32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483"""
d = get_data(year = 2023, day = 7)

J = 1

def mapc(c):
    if c == 'T':
        return 10
    elif c == 'J':
        return J
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

what = ['highcard', 'onepair', 'twopair', 'threeofakind', 'fullhouse', 'fourofakind', 'fiveofakind']

def handtype(hand):
    handhist = {}
    for c in hand:
        handhist[c] = handhist.get(c, 0) + 1
    twos = 0
    handhist[J] = handhist.get(J, 0)
    for c in handhist:
        if handhist[c] == 5 or ((c != J) and (handhist[c] + handhist[J]) == 5):
            return FIVE_OF_A_KIND
    for c in handhist:
        if handhist[c] == 4 or ((c != J) and (handhist[c] + handhist[J]) == 4):
            return FOUR_OF_A_KIND
    for c in handhist:
        if handhist[c] == 3 or ((c != J) and (handhist[c] + handhist[J]) >= 3):
            if c != J:
                jrem = handhist[J] - (3 - handhist[c])
                print('jrem', jrem)
            else:
                jrem = 0
            for c2 in handhist:
                if c2 == J:
                    if c != c2 and jrem >= 2:
                        return FULL_HOUSE
                else:
                    if c != c2 and (handhist[c2] == 2 or ((c != J) and (handhist[c2] + jrem) >= 2)):
                        return FULL_HOUSE
            return THREE_OF_A_KIND
        elif handhist[c] == 2:
            twos += 1
    if twos == 2 or handhist[J] >= 2:
        return TWO_PAIR
    if twos == 1 or handhist[J] >= 1:
        return ONE_PAIR
    return HIGH_CARD

hands = []
for l in d.split('\n'):
    hand,bid = l.split(' ')
    hand = [mapc(c) for c in hand]
    bid = int(bid)
    hands.append((handtype(hand), hand, bid, ))
    if 1 in hand:
        print(what[handtype(hand)], hand)
hands.sort()

tot = 0
for n, (tipo, hand, bid, ) in enumerate(hands):
#    print(n, tipo, hand, bid)
    tot += (n+1) * bid
print(tot)
