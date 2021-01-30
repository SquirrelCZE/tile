
//      0   1             2         3  4      5      6
//    [ a,  screw_coord,  corner_r, t, nut_d, nut_h, screw_d]
T36 = [ 36, [ 13, 8, 0 ], 6.000000, 3, 6.000, 2.500, 3 ];
T24 = [ 24, [ 08, 4, 0 ], 4.000000, 2, 4.600, 1.800, 2 ];

function Ta(class) = class[0];
function Tscrew_coord(class) = class[1];
function Tcorner(class) = class[2];
function Tt(class) = class[3];
function Tnut_d(class) = class[4];
function Tnut_h(class) = class[5];
function Tscrew_d(class) = class[6];

module tile(class, h, center = false, centered_hole = false) difference() {
	tile_pos(class = class, h = h, center = center);
	tile_neg(class = class, h = h, center = center,
		 centered_hole = centered_hole);
}

module tile_neg(class, h, center = false, centered_hole = false) {
	translate([ 0, 0, center ? 0 : h / 2 ]) for (alpha = [ 0, 180 ])
	    rotate([ alpha, 0, 0 ]) tile_screw_pos(class = class)
		tile_screw_hole(class = class, h = h,
				centered_hole = centered_hole);
	tile_center_hole(class, h + 2, center = center);
}

module tile_pos(class, h, center = false)
    linear_extrude(height = h, center = center, convexity = 10)
	tile_relief(class = class);

module tile_H(class, h, n = 1, center_t = undef) render()
    difference() {
	top_offset = n * Ta(class) + h;
	z_center = n * Ta(class) / 2 + h;
	center_t =
	    (center_t == undef) ? Tt(class) + 2 * Tnut_h(class) : center_t;

	union() {
		translate([ 0, 0, z_center ])
		    cube([ Ta(class), center_t, n * Ta(class) + 2 * h ],
			 center = true);
		for (z = [ 0, top_offset ])
			translate([ 0, 0, z ]) linear_extrude(height = h)
			    tile_base_shape(l = Ta(class),
					    corner_r = Tcorner(class));
	}

	for (i = [0.5:n])
		translate([ 0, 0, h + i * Ta(class) ]) rotate([ 90, 0, 0 ]) {
			tile_neg(class, h = center_t, center = true,
				 centered_hole = true);
			tile_center_hole(class, h = center_t, center = true);
		}

	for (z = [ 0, top_offset ])
		translate([ 0, 0, z ]) tile_center_hole(class, h = h);

	mirror([ 1, 0, 0 ]) tile_screw_pos(class = class)
	    translate([ 0, 0, h / 2 ]) tile_screw_hole(class = class, h = h);

	tile_screw_pos(class = class)
	    translate([ 0, 0, top_offset + Tt(class) ]) rotate([ 180, 0, 0 ])
		tile_screw_hole(class = class, h = h);
}

module tile_box_side_pos() {
	children();
	for (alpha = [0:90:360]) rotate([ 90, 0, alpha ]) children();
	rotate([ 180, 0, 0 ]) children();
}

module tile_box(class) difference() {
	hull() {
		r = Tt(class);
		cube([ Ta(class) - r, Ta(class) - r, Ta(class) ],
		     center = true);
		cube([ Ta(class), Ta(class) - r, Ta(class) - r ],
		     center = true);
		cube([ Ta(class) - r, Ta(class), Ta(class) - r ],
		     center = true);
	}

	tile_box_side_pos() cylinder(d = Ta(class) / 2, h = Ta(class));

	tile_box_side_pos() tile_screw_pos(class = class)
	    translate([ 0, 0, Ta(class) / 2 - Tnut_h(class) - 1.5 * Tt(class) ])
		Mnut_sidehole(M2N, 10);
	tile_box_side_pos() tile_screw_pos(class = class)
	    cylinder(d = Tscrew_d(class), h = 20);
}

module tile_raw_plate(class, x, y, t) {
	for (i = [0:x - 1])
		for (j = [0:y - 1])
			translate([ i * Ta(class), j * Ta(class), 0 ])
			    difference() {
				tile_pos(class, h = t, center = false);
				tile_screw_pos(class = class)
				    cylinder(d = Tscrew_d(class), h = 100,
					     center = true);
			}
}

//          Implementation
// ------------------------------------

module tile_center_hole(class, h, center = false) {
	cylinder(d = Ta(class) / 2, h = h, center = center, $fn = 8);
}

module tile_base_shape(l, corner_r) {
	hull() {
		square([ l - corner_r * 2, l ], center = true);
		square([ l, l - corner_r * 2 ], center = true);
	}
}

module tile_relief(class, a, corner_r, t, nut_d) {
	tile_base_shape(Ta(class), Tcorner(class));
}

module tile_screw_pos(class) {
	for (alpha = [0:90:360])
		rotate([ 0, 0, alpha ]) translate(Tscrew_coord(class))
		    children();
}

module tile_plate(class, t) difference() {
	linear_extrude(height = t) tile_base_shape(Ta(class), Tcorner(class));

	mirror([ 1, 0, 0 ]) tile_screw_pos(class)
	    cylinder(d = Tscrew_d(class), h = t * 3, center = true);
}

module tile_screw_hole(class, h, centered_hole = false) {
	layer_t = 0.3;
	nut_e = sqrt(pow(Tnut_d(class), 2) - pow(Tnut_d(class) / 2, 2));

	cylinder(d = Tscrew_d(class), h = h + 2, center = true);
	if (centered_hole) {
		for (alpha = [ 0, 180 ])
			rotate([ alpha, 0, 0 ])
			    translate([ 0, 0, Tt(class) / 2 ]) {
				cube([ nut_e, Tscrew_d(class), layer_t * 2 ],
				     center = true);
				rotate([ 0, 0, 30 ])
				    cylinder(d = Tnut_d(class), h = h, $fn = 6);
			}
	} else {
		rotate([180,0,0])
		translate([ 0, 0, Tt(class) - h / 2 ]) {
			cube([ nut_e, Tscrew_d(class), layer_t * 2 ],
			     center = true);
			rotate([ 0, 0, 30 ]) cylinder(
			    d = Tnut_d(class),
			    h = h - Tt(class) + Tnut_h(class), $fn = 6);
		}
	}
}

module tile_tube_hole(d) {
	rotate([ 90, 0, 0 ]) cylinder(d = d, h = 100, center = true);
}
