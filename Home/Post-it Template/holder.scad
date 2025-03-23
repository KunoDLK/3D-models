// All values in mm unless a quanity or states otherwise

/* [Render Parameters] */
$fs = 1;
$fa = 5;

/* [Fitment] */
Global_Clearance = 0.2;

/* [Post-It] */
PostIt_Length = 76.2;
PostIt_Width = 76.2;
PostIt_Height = 10.0;

/* [Holder] */
Base_Thickness = 1.0;
Base_Padding = 2.0;
Wall_Thickness = 1.0;
Finger_Hole_Ratio = 0.3;
Finger_Hole_Radius = 4.0;

/* [Template Holder] */
Number_Of_Holders = 3;
Holder_thickness = 1.0;

Total_Perimeter = Base_Padding + Wall_Thickness + Global_Clearance;
echo(Total_Perimeter);
Holder_Length = Number_Of_Holders > 0 ? (Number_Of_Holders * (Holder_thickness + (2 * Global_Clearance) + Wall_Thickness)) : 0; 
echo(Holder_Length);
Total_Width = ((Total_Perimeter) * 2) + PostIt_Width;
echo(Total_Width);
Total_Length = ((Total_Perimeter) * 2) + PostIt_Length + Holder_Length;
echo(Total_Length);


// Model

Base();
PostItHolder();
if (Number_Of_Holders > 0)
{
    TemplateHolders();
}


// Design Modules
module Base()
{
    cube([Total_Width, Total_Length, Base_Thickness]);
}

module PostItHolder()
{
    noteOffset = Wall_Thickness + Global_Clearance;
    
    translate([Base_Padding, Base_Padding, Base_Thickness])
    {
        difference()
        {
            cube([(noteOffset * 2) + PostIt_Width, (noteOffset * 2) + PostIt_Length, PostIt_Height]);
            
            translate([noteOffset, noteOffset, 0])
            cube([PostIt_Width, PostIt_Length, PostIt_Height]);
            
            #FingerHole();
        }
    }
}

module FingerHole()
{
    holeWidth = PostIt_Width * Finger_Hole_Ratio;
    
    translate([holeWidth,Wall_Thickness,0])
    rotate([90,0,0])
    linear_extrude(Wall_Thickness)
    {
        union()
        {
            //top rectangle
            translate([0,Finger_Hole_Radius])
            square([holeWidth, PostIt_Height - Finger_Hole_Radius]);
            
            translate([Finger_Hole_Radius,0])
            square([holeWidth - (2 * Finger_Hole_Radius), Finger_Hole_Radius]);
            
            //bottom rectangle with radius
            intersection()
            {
                square([holeWidth, Finger_Hole_Radius]);
                translate([Finger_Hole_Radius,Finger_Hole_Radius])
                circle(r = Finger_Hole_Radius);
            }
            
            intersection()
            {
                square([holeWidth, Finger_Hole_Radius]);
                translate([holeWidth - Finger_Hole_Radius,Finger_Hole_Radius])
                circle(r = Finger_Hole_Radius);    
            }
        }
    }
}

module TemplateHolders()
{
    
}