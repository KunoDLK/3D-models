/* [Setup Parameters] */
$fa = 8;
$fs = 0.25;

use <libraries/gridfinity-rebuilt-openscad/src/core/gridfinity-rebuilt-holes.scad>
use <libraries/gridfinity-rebuilt-openscad/src/core/gridfinity-rebuilt-utility.scad>

/* [General Settings] */
// number of bases along x-axis
gridx = 2;
// number of bases along y-axis
gridy = 1; 
// Size of grid
Grid_Size = 42; 

/* [Light Settings] */
Light_Length = 70;
Light_Width = 35;
Light_Depth = 15;

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

    translate([0, 0, Grid_Size - (Light_Width / 2)])
    {
        rotate([90,0,0])
        {
            Light();
        }
    }
    translate([-Finger_Width / 2, Light_Depth / 2 , Grid_Size]) 
    {
        rotate([0,90,0])
        {
            FingerHoles();
        }
    }
    translate([Finger_Width / 2, -Light_Depth / 2, Grid_Size]) 
    {
        rotate([180,90,0])
        {
            FingerHoles();
        }
    }
}

module Light() {
    cube([Light_Length, Light_Width, Light_Depth], center = true);
}

module FingerHoles() {
    union() 
    {
        translate([Finger_Stright_Depth, 0])
        {
            linear_extrude(height = Finger_Width) 
            {
                polygon(points=[[0,0],[0,Finger_Thickness],[Finger_Total_Depth - Finger_Stright_Depth,0]]);
            }
        }
        linear_extrude(height = Finger_Width) 
        { 
            square([Finger_Stright_Depth, Finger_Thickness]); // Base square size
        }
    }
}