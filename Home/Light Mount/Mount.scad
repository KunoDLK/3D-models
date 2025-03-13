/* [Render Parameters] */
$fs = $preview ? 2 : 0.1;
$fa = $preview ? 5 : 0.1;

/* [Light Settings] */
Light_Diameter = 80;

/* [Base Settings] */
Base_Depth = 10;
Base_Wall_Thickness = 5;
Base_Plate_Thickness = 3;

/* [Bolt Holes Settings] */
Bolt_Offset = 30;
Hole_Diameter = 3;
Width = 8.4;
Thickness = 1.2;
Bolt_Holder_Material_Thickness = 2;
Nut_Clearance = 0.1;
Bolt_Clearance = 0.25;

// Adjusting valves for Clearance
Bolt_Width = Width + Nut_Clearance;
Bolt_Thickness = Thickness + Nut_Clearance;
Bolt_Hole_Diameter = Hole_Diameter + Bolt_Clearance;

/* [Hook Settings] */
Hook_Reach = 20;
Hook_Finger_Length = 40;
Hook_Finger_Thickness = 40;
Hook_Finger_Width = 10;
Hook_Finger_Seperation = 30;
Hook_Thickness = 5; 

/* [Nub Settings] */
Nub_Depth = 5;
Nub_Offset = 1;
Nub_Width = 20;


rotate([0,90,0])
difference()
{
    union()
    {
        Hooks();
        HookStrcuture();
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


module HookStrcuture()
{
    difference()
        {
            HookArcSeperator();
            HookExternalFingerSubtraction();
            rotate([0,0,180])
            {
                HookExternalFingerSubtraction();
            }
        }
}


module Hooks()
{
    difference()
    {    
        translate([0,0,Base_Depth + Nub_Depth + Hook_Reach - Nub_Offset])
        linear_extrude(Hook_Thickness)
        {
            circle(r = Light_Diameter / 2);
        }        
            
        HookExternalFingerSubtraction();
        HookInternalFingerSubtraction();
        rotate([0,0,180])
        {
            HookExternalFingerSubtraction();
            HookInternalFingerSubtraction();
        }
        
        translate([0,0,Base_Depth])
        EndOfHookFingersSubtraction();
    }
    
    HookNubs();
    rotate([0,0,180])
        HookNubs();
}

module HookArcSeperator()
{
    translate([0,0,Base_Depth])
    {
        difference()
        {    
            linear_extrude(Hook_Reach + Nub_Depth + Hook_Thickness - Nub_Offset)
            {
                circle(r = Light_Diameter / 2);
            }        
            linear_extrude(Hook_Reach + Nub_Depth + Hook_Thickness - Nub_Offset)
            {
                circle(r = (Light_Diameter / 2) - Base_Wall_Thickness);
            }
            EndOfHookFingersSubtraction();
        }
    }
}

module EndOfHookFingersSubtraction()
{
    translate([Nub_Width / 2,-Light_Diameter / 2,0])
            {
                cube([(Light_Diameter / 2) - (Nub_Width / 2), Light_Diameter , Hook_Reach + Nub_Depth+ Hook_Thickness]);
            }
}

module HookInternalFingerSubtraction()
{
    translate([-Light_Diameter / 2,0,Base_Depth])
    {
        cube([Light_Diameter,Hook_Finger_Seperation / 2,Hook_Reach + Nub_Depth+ Hook_Thickness - Nub_Offset]);
    }
}

module HookExternalFingerSubtraction()
{
    translate([-Light_Diameter / 2,(Hook_Finger_Seperation / 2) + Hook_Finger_Width,Base_Depth])
    {
        cube([Light_Diameter,Hook_Finger_Seperation / 2,Hook_Reach + Nub_Depth+ Hook_Thickness - Nub_Offset]);
    }
}

module HookNubs()
{
    translate([-Nub_Width / 2,Hook_Finger_Seperation / 2,Hook_Reach + Base_Depth - Nub_Offset])
    {
        intersection()
        {
            cube([Nub_Width,Hook_Finger_Width, Nub_Depth]);
            translate([Nub_Width / 2, 0, Nub_Depth])
            rotate([-90,0,0])
            linear_extrude(Hook_Finger_Width)
            resize([Nub_Width, Nub_Depth * 2])
            circle(d=Nub_Depth * 2);
        }
    }
}


module LightMounting()
{
    difference()
    {    
        Base();
        
        linear_extrude(Base_Depth)
        {
            circle(r = (Light_Diameter / 2) - Base_Wall_Thickness);
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
            linear_extrude(Bolt_Thickness)
            {
                square([Bolt_Width, ((Light_Diameter/ 2) - Bolt_Offset) + (Bolt_Width / 2) ]);
            }
         }
        linear_extrude((Base_Depth))
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