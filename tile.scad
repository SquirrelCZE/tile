
tile_a = 36;
tile_screw_y = 8;
tile_screw_x = 13;
tile_screw_d = 3;
tile_nut_d = 6;
tile_nut_h = 3;
tile_t = 2;
tile_corner = 6;
show_basic_tile = false;

module tile_base_shape(l) {
    hull() {
        square([ l - tile_corner * 2, l ], center = true);
        square([ l, l - tile_corner * 2 ], center = true);
    }
}

module tile_relief() {
    for (m = [ 0, 1 ]) mirror([ m, 0, 0 ]) tile_screw_pos() {
            rotate([ 0, 0, 30 ]) circle(d = tile_nut_d + tile_t * 2, $fn = 6);
        }
    difference() {
        tile_base_shape(tile_a);
        tile_base_shape(tile_a - tile_t * 2);
    }
}

module tile_screw_pos() {
    for (alpha = [0:90:360])
        rotate([ 0, 0, alpha ]) translate([ tile_screw_x, tile_screw_y, 0 ])
            children();
}

module tile_screw_hole(h) {
    cylinder(d = tile_screw_d, h = h + 2, center = true);

    rotate([ 0, 0, 30 ]) translate([ 0, 0, tile_t ])
        cylinder(d = tile_nut_d, h = h, center = true, $fn = 6);
}

module tile_tube_hole(tube_d) {
    rotate([ 90, 0, 0 ]) cylinder(d = tube_d, h = 100, center = true);
}

module tile_base(h, tube_d) difference() {
    union() {
        linear_extrude(height = h, center = true, convexity = 10) tile_relief();
    }
    for (alpha = [ 0, 180 ])
        rotate([ alpha, 0, 0 ]) tile_screw_pos() tile_screw_hole(h);

    if (tube_d != 0) tile_tube_hole(tube_d);
}

module basic_tile() {
    tube_d = 5;
    h = tube_d + tile_t * 2;
    tile_base(h, tube_d);
}

if (show_basic_tile) basic_tile();
