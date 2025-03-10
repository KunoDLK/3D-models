/* [Setup Parameters] */
$fa = 8;
$fs = 0.25;

use <libraries/gridfinity-rebuilt-openscad/src/core/gridfinity-rebuilt-holes.scad>
use <libraries/gridfinity-rebuilt-openscad/src/core/gridfinity-rebuilt-utility.scad>

/* [General Settings] */
// number of bases along x-axis
gridx = 3;
// number of bases along y-axis
gridy = 2; 
// number of bases along z-axis
gridz = 3; 
// Size of grid
Grid_Size = 42; 

/* [Knife Settings] */
knife_depth = 25;



difference() {
    union()
    {
        gridfinityInit(gridx, gridy, height(6), 0, Grid_Size);
        gridfinityBase([gridx, gridy]);
    }

    translate([100, 0, Grid_Size])
    {
        #Knife();
    }
}

module Knife() {
    rotate([180,0,0])
    linear_extrude(height=knife_depth)
    import("kinfe path.svg", center=true);
    
// points = bezier_curve([0, 0], [10, 30], [30, 30], [40, 0], 20);
// polygon(concat(points, [[0,0]])); // Closing the shape
}


function bezier(p0, p1, p2, p3, t) = 
    let (u = 1 - t)
    u*u*u * p0 + 3*u*u*t * p1 + 3*u*t*t * p2 + t*t*t * p3;

function bezier_curve(p0, p1, p2, p3, steps) =
    [for (i = [0 : steps]) bezier(p0, p1, p2, p3, i / steps)];
