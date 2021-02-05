include <../tile.scad>;


screw_d = 3;
screw_a = 45;

t = 5;

$fn = 64;

module screw_holes(){
    for(i=[-1,1]) translate([i*screw_a/2, 0, 0]) cylinder(d=screw_d,h=10,center=true);
}

difference(){hull(){
for(i=[1,-1])
{
    translate([i*screw_a/2,0,0])
    cylinder(d=screw_d+t*2,h=t);
}

translate([0,0,t/2])
cube([Ta(T24), Ta(T24), t], center=true);
}
screw_holes();
translate([0,0,t/2])
tile_neg(T24, t, center=true);
}
