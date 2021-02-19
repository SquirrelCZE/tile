# inspired based on https://github.com/olikraus/scad/blob/master/train_tube_track/Makefile

EXAMPLE_SCAD=$(wildcard example/*.scad)
EXAMPLE_STL=$(EXAMPLE_SCAD:.scad=.stl)
EXAMPLE_PNG=$(EXAMPLE_SCAD:.scad=.png)

example/%.stl: example/%.scad
	openscad $< -D \$$fn=64 -o $@

example/%.png: example/%.scad
	openscad $< --autocenter --viewall --imgsize=640,480 -D \$$fn=64 -o $@

example/README.md: $(EXAMPLE_PNG)
	python3 example/gen_readme.py $(EXAMPLE_SCAD:.scad=) > example/README.md

DXF_SCAD=$(wildcard dxf/*.scad)
DXF_DXF=$(addprefix dxf/, $(notdir $(DXF_SCAD:.scad=.dxf)))

dxf/%.dxf: dxf/%.scad
	openscad $< -D \$$fn=128  -o $@


.PHONY: all 
all: $(EXAMPLE_STL) $(EXAMPLE_PNG) $(DXF_DXF) example/README.md
