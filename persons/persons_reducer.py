#!/usr/bin/env python

import sys

last_id = None
actor_sum = 0
director_sum = 0

for line in sys.stdin:
        line = line.strip()
        id, actor, director = line.split("\t", 2)

        if id == last_id:
                actor_sum += int(actor)
                director_sum += int(director)
        else:
                if last_id:
                        print("%s\t%d\t%d" % (last_id, actor_sum, director_sum))
                last_id = id
                actor_sum = int(actor)
                director_sum = int(director)

if last_id == id:
        print("%s\t%d\t%d" % (last_id, actor_sum, director_sum))