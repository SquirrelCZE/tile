include<../tile.scad>

translate([ 0, 0, -6 ]) {
    color("blue") tile_raw_plate(T24, 1, 1, 2);
    translate([ 0, 0, -12 ]) color("red") tile_screw_pos(T24)
        cylinder(d = Tscrew_d(T24), h = 8);
}

color("yellow") tile(T24, h = 5);

translate([ 0, 0, 12 ]) rotate([ 0, 180, 0 ]) {
    color("blue") tile_raw_plate(T24, 1, 1, 2);
    translate([ 0, 0, -12 ]) color("red") tile_screw_pos(T24)
        cylinder(d = Tscrew_d(T24), h = 8);
}
