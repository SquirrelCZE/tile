include<../tile.scad>;

t = 2;

$fn = 64;
// for (i = [ -1, 0, 1 ]) translate([ i * Ta(T24), 0, 0 ]) tile(T24, 4);

module bracket_base() difference() {
  union() {
    for (rot = [ [ 0, 90, 0 ], [ 180, 0, 0 ] ])
      rotate(rot) translate([ Ta(T24) / 2, 0, 0 ]) tile_raw_plate(T24, 1, 1, 4);
  }

  for (rot = [ [ 0, 90, 0 ], [ 180, 0, 0 ] ])
    rotate(rot) translate([ Ta(T24) / 2, 0, 0 ]) {
      tile_center_hole(T24, h = 100, center = true);
      tile_screw_pos(T24){
	  cylinder(d = Tscrew_d(T24), h = 100, center = true);
		translate([0,0,t])
		cylinder(d= Tnut_d(T24), h=Ta(T24)/2 - t, $fn=6);
		}
    }
}

module bracket_support(i) {
  hull() intersection() {
    bracket_base();
    translate([ 0, i * Ta(T24), 0 ]) cube([ 100, t, 100 ], center = true);
  }
}

module bracket() {
  bracket_base();
  for (i = [ -0.5, 0.5 ]) difference() {
      bracket_support(i);
      scale([ 0.7, 1, 0.7 ]) bracket_support(i);
    }
}

bracket();
