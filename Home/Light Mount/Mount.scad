/* [Render Parameters] */
$fa = 10;
$fs = 0.25;

/* [Light Settings] */
Light_Diameter = 70;

/* [Base Settings] */
Base_Depth = 10;
Base_Wall_Thickness = 3;
Base_Plate_Thickness = 3;

/* [Bolt Holes Settings] */
Bolt_Offset = 25;
Hole_Diameter = 3;
Width = 8.4;
Thickness = 1.2;
Bolt_Holder_Material_Thickness = 2;
Nut_Clearance = 0.1;
Bolt_Clearance = 0.2;

// Adjusting valves for Clearance
Bolt_Width = Width + Nut_Clearance;
Bolt_Thickness = Thickness + Nut_Clearance;
Bolt_Hole_Diameter = Hole_Diameter + Bolt_Clearance;

difference()
{
    union()
    {
        LightMounting();
        NutSupport();
    
        rotate([0,0,180])
        {
            NutSupport();    
        }
    }
    SquareNutHole();

    rotate([0,0,180])
    SquareNutHole();
}


module LightMounting()
{
    difference()
    {    
        Base();
        translate([0,0,Base_Plate_Thickness])
        {
            linear_extrude(Base_Depth - Base_Plate_Thickness)
            {
                circle(r = (Light_Diameter / 2) - Base_Wall_Thickness);
            }
        }
    }
}

module Base()
{
    linear_extrude(Base_Depth)
    {
        circle(r = Light_Diameter / 2);
    }
}

module SquareNutHole()
{
    translate([0,Bolt_Offset,0])
    {
        translate([-Bolt_Width / 2, -Bolt_Width / 2,(Base_Depth / 2) - (Bolt_Thickness / 2)])
        {
            #linear_extrude(Bolt_Thickness)
            {
                square([Bolt_Width, ((Light_Diameter/ 2) - Bolt_Offset) + (Bolt_Width / 2) ]);
            }
         }
        #linear_extrude((Base_Depth / 2))
        {
            circle(r = Bolt_Hole_Diameter / 2);
        }   
     }
}

module NutSupport()
{
    difference()
    {
        intersection()
        {
            Base();
            translate([0,Bolt_Offset,0])
            {
                linear_extrude(Base_Depth)
                {
                    radius = (Bolt_Width / 2) + Bolt_Holder_Material_Thickness;
                    circle(r = radius);
                    translate([-radius,0,0])
                    square([radius * 2, (Light_Diameter/ 2) - Bolt_Offset]);
                }
            }
        }
    }
}