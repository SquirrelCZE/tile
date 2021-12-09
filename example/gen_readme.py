#!/usr/bin/env python3
import sys

args = sys.argv[1:]

print("# Gallery of tile examples")

for arg in args:
    print("## " + arg + ".scad")
    print("![" + arg + "](../" + arg + ".png)")
