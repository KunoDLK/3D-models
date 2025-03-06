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

/* [Pliers Settings] */
Pliers_Length = 105;
Pliers_TopWidth = 40;
Pliers_BottomWidth = 50;
Pliers_Depth = 23;

/* [Funger Hole Settings] */
Finger_Total_Depth = 20;
Finger_Width = 30;
Finger_Stright_Depth = 9;
Finger_Thickness = 11;

difference() {
    union()
    {
        gridfinityInit(gridx, gridy, height(6), 0, Grid_Size);
        gridfinityBase([gridx, gridy]);
    }

    translate([0, 0, Grid_Size])
    {
        Plias();
    }
}

module Plias() {
    rotate([180,0,0])
    linear_extrude(height=Pliers_Depth)
    polygon(points=[[-Pliers_Length / 2,-Pliers_BottomWidth / 2], [-Pliers_Length / 2,Pliers_BottomWidth / 2], [Pliers_Length / 2,Pliers_TopWidth / 2], [Pliers_Length / 2,-Pliers_TopWidth / 2]]);    
}