include<../tile.scad>;

screw_d = 2;

screw_coord_a = 58;
screw_coord_b = 49;
screw_coord_offset = -85 / 2 + 3.5 + 58 / 2;

dim = [ 85, 56, 22 ];
z_off = 4;
bot_col_h = 2;
col_d = 5;

pcb_t = 2;
col_h = 15;
h = 36;
top_col_h = h - col_h - pcb_t - bot_col_h - z_off;

t = 2;

module cutout_plate(dim, corner, center = false) hull() {
  cube(dim - [ 2 * corner, 0, 0 ], center);
  cube(dim - [ 0, 2 * corner, 0 ], center);
}

module rpi_screw_pos() {
  for (i = [ 0.5, -0.5 ], j = [ 0.5, -0.5 ])
    translate([ i * screw_coord_a + screw_coord_offset, j * screw_coord_b, 0 ])
	children();
}

module baseplate() {
  translate([ 0, 0, z_off / 2 ]) cutout_plate(
      [ Ta(T24) * 4, Ta(T24) * 3, z_off ], corner = 4, center = true);
}

module M3_hole(l) {
  cylinder(d = 3, h = l);
  cylinder(d = 6, h = 2);
}

module bot_rpi_holder() difference() {
  union() {
    baseplate();
    rpi_screw_pos() cylinder(d = col_d, h = z_off + bot_col_h);
  }
  rpi_screw_pos() M3_hole(20);
  for (i = [ -1.5, -0.5, 0.5, 1.5 ], j = [ -1, 0, 1 ])
    translate([ i * Ta(T24), j * Ta(T24), 0 ]) tile_screw_pos(T24){
	cylinder(d = screw_d, h = 100, center = true);
      translate([ 0, 0, z_off - 2 ]) cylinder(d = 6, h = 3);
	}
}

module top_rpi_holder() difference() {
  union() {
    translate([ 0, 0, h ]) rotate([ 180, 0, 0 ]) difference() {
      baseplate();
      cutout_plate([ Ta(T24) * 3, Ta(T24) * 2, 100 ], corner = 4,
		   center = true);
    }
    rpi_screw_pos() translate([ 0, 0, h ]) rotate([ 180, 0, 0 ])
	cylinder(d = col_d, h = top_col_h);
  }
  rpi_screw_pos() translate([ 0, 0, h ]) rotate([ 180, 0, 0 ]) M3_hole(20);
  for (i = [ -1.5, -0.5, 0.5, 1.5 ], j = [ -1, 0, 1 ])
    translate([ i * Ta(T24), j * Ta(T24), h - z_off/2 ]) tile_screw_pos(T24) {
		tile_screw_hole(T24, h=z_off, centered_hole=true);
    }
}

$fn = 128;

bot_rpi_holder();
top_rpi_holder();
