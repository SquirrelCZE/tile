
# Tile

For our robotics project, we made a universal mount for our parts.
This is just a shape with screw coordinates, that is used on most of our parts.

This makes it possible to use the parts as lego, where you can move things around the robot, because they all shere the same mount.
Apart from the shape itself, the source file `tile.scad` also contains SCAD modules that are parts itself. 

We prepared two sets of tile dimensions - T24 and T36. We however solely rely on the T24 for one. Which is guaranteed to not to change.
The T36 size is subject to change in the future.

## DXF

dxf/ folder contains .dxf renders of various tile configurations, these should be importable by other CADs and software.

## example

example/ folder contains example of included modules in SCAD that you can use.

## PCB

We also have a set of various PCBs using this shape as their PCB shape, these are in various stage of development.

## drawings

All dimensions are in `mm`.

<img src="tile_1x1_dims_I.png">
<img src="tile_1x1_dims_II.png">
