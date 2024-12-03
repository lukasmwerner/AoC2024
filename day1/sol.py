filename = "pt1.txt"

left = []
right = []

with open(filename) as f:
    for line in f:
        (l, r) = line.split()
        left.append(int(l))
        right.append(int(r))

lefts = sorted(left)
rights = sorted(right)

diff = []

print(len(left), len(right))
for (l, r) in zip(lefts, rights):
    diff.append(abs(l - r))

print('pt1:', sum(diff))

import collections

counts = collections.Counter()
for i in right:
    counts[i] += 1

similarities = []
for l in left:
    similarities.append(
        l * counts[l]
    )

print('pt2:', sum(similarities))

