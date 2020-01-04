# inspired based on https://github.com/olikraus/scad/blob/master/train_tube_track/Makefile

SCAD=$(wildcard example/*.scad)
STL=$(addprefix example/, $(notdir $(SCAD:.scad=.stl)))
PNG=$(addprefix example/, $(notdir $(SCAD:.scad=.png)))

example/%.stl: example/%.scad
	openscad $< -o $@

example/%.png: example/%.scad
	openscad $< --autocenter --viewall --imgsize=640,480 -o $@

.PHONY: all example/Readme.md
all: $(STL) $(PNG)

example/Readme.md: $(PNG)
	python3 example/gen_readme.py $(SCAD:.scad=) > example/README.md
