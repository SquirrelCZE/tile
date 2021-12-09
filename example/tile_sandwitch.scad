include<../tile.scad>

color("yellow") tile(T24, h = 5);

for(m=[0,1]) mirror([0,0,m])
translate([ 0, 0, 12 ]) {
    color("blue") tile_raw_plate(T24, 1, 1, 2);
    translate([ 0, 0, 8 ]) color("red") tile_screw_pos(T24)
        cylinder(d = Tscrew_d(T24), h = 8);
}
