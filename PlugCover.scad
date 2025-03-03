// Parameters
socket_width = 146;   // UK double gang socket width in mm
socket_height = 86;   // UK double gang socket height in mm
border_width = 10;    // Border width around the socket
num_circles_x = 6;    // Number of circles along width
thickness = 3;

// Derived dimensions
total_width = socket_width + 1.5 * border_width;
min_height = socket_height + 1.5 * border_width;
circle_diameter_x = total_width / (num_circles_x - 1);

num_circles_y = ceil(min_height / circle_diameter_x);
total_height = circle_diameter_x * (num_circles_y - 1);
circle_diameter_y = circle_diameter_x;

// Function to place circles along an edge
module place_circles(start, end, count) {
    for (i = [0 : count - 1]) {
        pos = start + (end - start) * i / (count - 1);
        translate([pos.x, pos.y]) circle(d=circle_diameter_x);
    }
}

// Generate filled scalloped rectangle with cutout
linear_extrude(height=thickness) {
difference() {
    union() {
        // Filled rectangle
        square([total_width, total_height], center=true);
        
        // Add external scallops
        scalloped_rectangle();
    }
    
    // Cutout for the socket
    square([socket_width, socket_height], center=true);
}
}
// Generate circles around the rectangle
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