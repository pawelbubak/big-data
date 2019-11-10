#!/usr/bin/env python

import sys

for line in sys.stdin:
        line = line.strip()
        columns = line.split("\t")

        if columns[3] == "actor" or columns[3] == "actress":
                print("%s\t%d\t%d" % (columns[2], 1, 0))
        elif columns[3] == "director":
                print("%s\t%d\t%d" % (columns[2], 0, 1))
        elif columns[3]:
                print("%s\t%d\t%d" % (columns[2], 0, 0))
