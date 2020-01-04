# inspired based on https://github.com/olikraus/scad/blob/master/train_tube_track/Makefile

SCAD=$(wildcard example/*.scad)
STL=$(addprefix example/, $(notdir $(SCAD:.scad=.stl)))
PNG=$(addprefix example/, $(notdir $(SCAD:.scad=.png)))

example/%.stl: example/%.scad
	openscad $< -o $@

example/%.png: example/%.scad
	openscad $< --render --autocenter --viewall --imgsize=640,480 -o $@

.PHONY: all
all: $(STL) $(PNG)
