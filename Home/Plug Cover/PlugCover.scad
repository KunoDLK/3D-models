// [UK double gang socket width in mm]
socket_width = 146;   
// [UK double gang socket height in mm]
socket_height = 86;   
// [Border width around the socket]
border_width = 10;  
// [Number of circles along width]
num_circles_x = 6;    
// [Thickness of cover]
thickness = 3;
// [Edge style selection]
edge_style = "scalloped"; // ["scalloped", "wave", "none"]

// Wave Settings:
// [Circle Multiplier]
circleness = 0.75;

// Derived dimensions
total_width = socket_width + 1.5 * border_width;
min_height = socket_height + 1.5 * border_width;
circle_diameter_x = total_width / (num_circles_x - 1);

num_circles_y = ceil((min_height + (0.7 * circle_diameter_x)) / circle_diameter_x);
total_height = circle_diameter_x * (num_circles_y - 1);
circle_diameter_y = circle_diameter_x;

// Function to place circles along an edge
module place_circles(start, end, count) {
    for (i = [0 : count - 1]) {
        pos = start + (end - start) * i / (count - 1);
        translate([pos.x, pos.y]) circle(d=circle_diameter_x);
    }
}


// Generate filled rectangle with selected edge style
linear_extrude(height=thickness) {
    difference() {
        union() {
            // Filled rectangle
            square([total_width, total_height], center=true);
            
            // Apply selected edge style
            if (edge_style == "scalloped") {
                scalloped_rectangle();
            } else if (edge_style == "wave") {
                wave_rectangle(false);
            }
            else {
                // None
            }
                
        }
        
        // Cutout for the socket
        square([socket_width, socket_height], center=true);
        
        if (edge_style == "wave") {
            #wave_rectangle(true);
        }
    }
}

// Generate circles around the rectangle for scalloped effect
module scalloped_rectangle() {
    // Top edge
    place_circles([ -total_width / 2, total_height / 2 ], 
                  [ total_width / 2, total_height / 2 ], num_circles_x);
    
    // Bottom edge
    place_circles([ -total_width / 2, -total_height / 2 ], 
                  [ total_width / 2, -total_height / 2 ], num_circles_x);
    
    // Left edge
    place_circles([ -total_width / 2, -total_height / 2 ], 
                  [ -total_width / 2, total_height / 2 ], num_circles_y);
    
    // Right edge
    place_circles([ total_width / 2, -total_height / 2 ], 
                  [ total_width / 2, total_height / 2 ], num_circles_y);
}

// Generate a wave pattern around the rectangle
module wave_rectangle(inverse) {
    // Top edge
    wave_circles([ -total_width / 2, total_height / 2 ], 
                 [ total_width / 2, total_height / 2 ], num_circles_x , true, inverse);
    
    // Bottom edge
    wave_circles([ -total_width / 2, -total_height / 2 ], 
                 [ total_width / 2, -total_height / 2 ], num_circles_x , true, inverse);
    
    // Left edge
    wave_circles([ -total_width / 2, -total_height / 2 ], 
                 [ -total_width / 2, total_height / 2 ], num_circles_y, false, inverse);
    
    // Right edge
    wave_circles([ total_width / 2, -total_height / 2 ], 
                 [ total_width / 2, total_height / 2 ], num_circles_y , false, inverse);
}

// Function to place alternating circles along an edge for wave effect
module wave_circles(start, end, count, horizontal, inverse) {
    for (i = [0 : count - 1]) {
        pos = start + (end - start) * i / (count - 1);
        
        check = inverse ? 1 : 0;  // Set check dynamically based on inverse

        scalex = !horizontal ? circleness : 1;
        scaley = horizontal ? circleness : 1;
           
        if ((i % 2) == check) {
            translate([pos.x, pos.y])
                scale([scalex,scaley])
                   circle(d=circle_diameter_x);
        }
    }
}