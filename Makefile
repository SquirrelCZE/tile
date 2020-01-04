# inspired based on https://github.com/olikraus/scad/blob/master/train_tube_track/Makefile

SCAD=$(wildcard example/*.scad)
STL=$(addprefix example/, $(notdir $(SCAD:.scad=.stl)))
PNG=$(addprefix example/, $(notdir $(SCAD:.scad=.png)))

example/%.stl: example/%.scad
	openscad $< -D \$$fn=64 -o $@

example/%.png: example/%.scad
	openscad $< --autocenter --viewall --imgsize=640,480 -D \$$fn=64 -o $@

example/README.md: $(PNG)
	python3 example/gen_readme.py $(SCAD:.scad=) > example/README.md

shape.png: dxf.scad tile.scad
	openscad dxf.scad --autocenter --viewall --render --camera=0,0,10,0,0,0,10 -D \$$fn=64 -o $@

.PHONY: all 
all: $(STL) $(PNG) example/README.md shape.png
