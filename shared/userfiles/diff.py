#!/usr/bin/python

import sys

v1 = sys.argv[1]
v2 = sys.argv[2]

if v2.endswith("%"):
    n1 = float(v1)
    n2 = float(v2[:-1]) / 100
    print(round(n1 + n1 * n2, 3))
else:
    n1 = float(v1)
    n2 = float(v2)
    print(round((n2 - n1) / n1 * 100, 3), "%")
