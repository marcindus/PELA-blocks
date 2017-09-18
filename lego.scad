/*
Parametric LEGO Block

Published at
    http://www.thingiverse.com/thing:2303714
Maintained at
    https://github.com/paulirotta/parametric_lego

By Paul Houghton
Twitter: @mobile_rat
Email: paulirotta@gmail.com
Blog: https://medium.com/@paulhoughton

Creative Commons Attribution ShareAlike NonCommercial License
https://creativecommons.org/licenses/by-sa/4.0/legalcode

Import this into other design files:
    use <lego.scad>
*/

/* [LEGO Options plus Plastic and Printer Variance Adjustments] */

// How many Lego units wide the brick is
blocks_x = 2;

// How many Lego units long the brick is
blocks_y = 4;

// How many Lego units high the brick is
blocks_z = 1;

// Top connector size tweak => 0 for ABS, 0.04 for tighter, -0.04 for PLA/NGEN/less tight
top_connector_tweak = -0.04;

// Bottom connector size tweak => 0 for ABS, -0.04 for tighter, 0.04 for bigger/PLA/NGEN/less tight
bottom_connector_tweak = 0.04;

// Number of facets to form a circle (big numbers are more round which affects fit, but may take a long time to render)
$fn=64;

// Clearance space on the outer surface of bricks
skin = 0.1;

// Size of the connectors
knob_radius=2.4;

// Total height of the connectors (1.8 is Lego standard, longer gives a stronger hold which helps since 3D prints are less precise)
knob_height=2.4;

// Height of the easy connect slope near connector top (0 to disable, helps if you adjust a tight fit)
knob_bevel=0.3;

// Depth which connectors may press into part bottom
socket_height=6;

// Bottom connector assistance ring size
ring_radius=3.25;

// Bottom connector assistance ring thickness
ring_thickness=0.8;

// Basic unit horizonal size of LEGO
block_width=8;

// Basic unit vertial size of LEGO
block_height=9.6;

// Thickness of the solid outside surface of LEGO
block_shell=1.3; // thickness

// Lego panel height (flat back panel with screw holes in corners
cut_line_height=7.6;

// Font for calibration block text labels
font = "Arial";

// Text size on calibration blocks
font_size = 4;

// Depth of text labels on calibration blocks
text_extrusion_height = 0.7;

// Inset from block edge for text (vertical and horizontal)
text_margin = 1;

// Size between calibration block tweak test steps
increment = 0.02;

/////////////////////////////////////

// Test display, uncomment only one of the following lines at a time
lego(x=blocks_x, y=blocks_y, z=blocks_z, bottom_size_tweak=bottom_connector_tweak, top_size_tweak=top_connector_tweak); // A single block

//lego_calibration_set(); // A set of blocks for testing which tweak parameters to use on your printer and plastic

//lego_panel(x=blocks_x, y=blocks_y, top_size_tweak=top_connector_tweak);

/////////////////////////////////////

module lego_panel(x=3,y=3, top_size_tweak=0) {
    difference() {
        intersection() {
            lego(x,y,1,bottom_connector_tweak,top_connector_tweak);
            translate([0,0,cut_line_height])
                cube([10000,10000,10000]);
        }
        union() {
            screw_hole(1,1);
            screw_hole(1,y);
            screw_hole(x,1);
            screw_hole(x,y);
        }
    }
}

// A set of blocks with different tweak parameters written on the side
module lego_calibration_set(x=2,y=4) {
    lego_calibration_block(x,y,0,0);
    
    translate([block_width*3, 0,0])
        lego_calibration_block(x,y,increment,-increment);
    
    translate([block_width*6, 0,0])
        lego_calibration_block(x,y,2*increment,-2*increment);
    
    translate([block_width*9, 0,0])
        lego_calibration_block(x,y,3*increment,-3*increment);
    
    translate([block_width*12, 0,0])
        lego_calibration_block(x,y,4*increment,-4*increment);
    
    translate([block_width*3, block_width*5, 0])
        lego_calibration_block(x,y,-increment,increment);
    
    translate([block_width*6, block_width*5, 0])
        lego_calibration_block(x,y,-2*increment,2*increment);
    
    translate([block_width*9, block_width*5, 0])
        lego_calibration_block(x,y,-3*increment,3*increment);
    
    translate([block_width*12, block_width*5, 0])
        lego_calibration_block(x,y,-4*increment,4*increment);
}

// A block with the tweak parameters written on the side
module lego_calibration_block(x=2,y=4,bottom_size_tweak=0,top_size_tweak=0) {
    difference() {
        lego(x,y,1,bottom_size_tweak,top_size_tweak);

        union() {
            translate([text_extrusion_height,y*block_width-text_margin,block_height-text_margin])
                lego_calibration_label_top_text(str("^",top_size_tweak));
            
            translate([text_extrusion_height,text_margin,text_margin])
                lego_calibration_label_bottom_text(str("v",bottom_size_tweak));
        }
    }
}

// Text for the side of calibration block prints
module lego_calibration_label_top_text(txt="Text",x=2,y=4) {
    rotate([90,0,-90]) 
        linear_extrude(height=text_extrusion_height) {
       text(text=txt, font=font, size=font_size, halign="left", valign="top");
     }
}

// Text for the side of calibration block prints
module lego_calibration_label_bottom_text(txt="Text",x=2,y=4) {
    rotate([90,0,-90]) 
        linear_extrude(height=text_extrusion_height) {
       text(text=txt, font=font, size=font_size, halign="right");
     }
}

module screw_hole(x=1,y=1) {
    translate([x*block_width - block_width/2,y*block_width - block_width/2, 0])
        cylinder(r=knob_radius,h=10000);
}


// The round bit on top of a lego block
module knob(top_size_tweak=0) {
    cylinder(r=knob_radius+top_size_tweak,h=knob_height-knob_bevel);
    translate([0,0,knob_height-knob_bevel]) 
        intersection() {
            cylinder(r=knob_radius+top_size_tweak,h=knob_bevel);
            cylinder(r1=knob_radius+top_size_tweak,r2=0,h=knob_radius+top_size_tweak);
        }
}

// The rectangular part of the the lego plus the knob
module block(z=1,top_size_tweak=0) {
    cube([block_width,block_width,z*block_height]);
    translate([block_width/2,block_width/2,z*block_height])
        knob(top_size_tweak);
}

// Several blocks in a grid, one knob per block
module block_set(x=2,y=2,z=2,top_size_tweak=0) {
    for (i = [0:1:x-1]) {
        for (j = [0:1:y-1]) {
            translate([i*block_width,j*block_width,0])
                block(z,top_size_tweak);
        }
    }
}

// That solid outer skin of the block set
module block_shell(x=2,y=2,z=2) {
    cube([block_shell,y*block_width,z*block_height]);
    translate([x*block_width-block_shell,0,0]) 
        cube([block_shell,y*block_width,z*block_height]);
    
    cube([x*block_width,block_shell,z*block_height]);
    translate([0,y*block_width-block_shell,0])
        cube([x*block_width,block_shell,z*block_height]);
    
    translate([0,0,z*block_height-block_shell])
        cube([x*block_width,y*block_width,block_shell]);
}

// Bottom connector- negative space for one block
module socket(bottom_size_tweak=0) {
    difference() {
        cube([block_width,block_width,socket_height]);
        union() {
            translate([0,0,0])
                socket_ring(bottom_size_tweak);
            translate([block_width,0,0])
                socket_ring(bottom_size_tweak);
            translate([0,block_width,0]) 
                socket_ring(bottom_size_tweak);
            translate([block_width,block_width,0])
                socket_ring(bottom_size_tweak);
        }
    }
}

// The circular bottom insert for attaching knobs
module socket_ring(bottom_size_tweak=0) {
    difference() {
        cylinder(r=ring_radius+bottom_size_tweak,h=socket_height);
        cylinder(r=ring_radius+bottom_size_tweak-ring_thickness,h=socket_height);
    }
}

// Bottom connector- negative space for multiple blocks
module socket_set(x=2,y=2,bottom_size_tweak=0) {
    for (i = [0:1:x-1]) {
        for (j = [0:1:y-1]) {
            translate([i*block_width,j*block_width,0])
                socket(bottom_size_tweak);
        }
    }
}

module skin(x=2,y=2,z=2) {
    difference() {
        cube([block_width*x,block_width*y,z*block_height]);
        translate([skin,skin,0])
            cube([block_width*x - 2*skin,block_width*y - 2*skin,z*block_height]);
    }
}

// A complete LEGO block, standard size, specify number of layers in X Y and Z
module lego(x=2,y=2,z=2,bottom_size_tweak=0,top_size_tweak=0) {
    difference() {
        union() {
            block_shell(x,y,z);
            difference() {
                block_set(x,y,z,top_size_tweak);
                socket_set(x,y,bottom_size_tweak);
            }
        }
        skin(x,y,z);
    }
}

// Function for access to horizontal size from other modules
function lego_width(x=1) = x*block_width;

// Function for access to vertical size from other modules
function lego_height(z=1) = z*block_height + knob_height;

// Function for access to outside shell size from other modules
function lego_shell_width() = block_shell;

// Function for access to clearance space from other modules
function lego_skin_width() = skin;
