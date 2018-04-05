/*
Parametric PELA End Cap Enclosure Generator

Create 2 symmetric end pieces which can support a solid object with PELA-compatible attachment points on top and bottom. The print can be minimized by printing only smaller end caps instead of a complele enclosure.

By Paul Houghton
Twitter: @mobile_rat
Email: paulirotta@gmail.com
Blog: https://medium.com/@paulhoughton

Creative Commons Attribution-ShareAlike 4.0 International License
    https://creativecommons.org/licenses/by-sa/4.0/legalcode

Open source design, Powered By Futurice. Come work with the best.
    http://futurice.com

Import this into other design files:
    use <PELA-endcap-enclosure.scad>
*/

include <../PELA-parameters.scad>
include <../PELA-print-parameters.scad>
use <../PELA-block.scad>
use <../PELA-technic-block.scad>
use <../support/support.scad>


/* [PELA Options plus Plastic and Printer Variance Adjustments] */

// Type of print to generate- 1=>left cap, 2=>right cap, 3=>both caps, 4=>preview a single object that can not be opened
mode = 1;

// Length of the enclosure (PELA knob count)
l = 4;

// Length of the left side of the enclosure (PELA knob count, for example l/2 or less)
left_cap = 2;

// Size of the left cap vertical support structure near the cut point (PELA knob count, 0 to disable)
left_cap_support_width = 0.5;

// Size of the right cap vertical support structure near the cut point (PELA knob count, 0 to disable)
right_cap_support_width = 0.5;

// Length of the right side of the enclosure (PELA knob count, for example l/2 or less)
right_cap = l - left_cap;

// Width of the enclosure (PELA knob count)
w = 2;

// Height of the enclosure (PELA block layer count)
h = 2;

// Length of the object to be enclosed (mm)
enclosed_l = 8*3;

// Width of the object to be enclosed (mm)
enclosed_w = 8*1;

// Height of the object to be enclosed (mm)
enclosed_height = 10;

// Distance up from baselane for the hollowed space
vertical_offset = 0;

// The size of the step which supports the enclosed part at the edges and corners in case ventilation openings would allow the enclosed part to slip out of place (mm)
shoulder = 1;

// Slide all side openings up (-down) 
side_opening_vertical_offset = 0;

// Rounding for side air hole corners
corner_radius = 2;

// Solid interior is assumed for this model before carving away from that block
solid_upper_layers = true;

// Add full width through holes spaced along the length for PELA Techics connectors
side_holes = 3;  // [0:disabled, 1:short air vents, 2:short connectors, 3:full width connectors]

// Add a sheath around side holes (disable for extra ventilation, enable for connector lock notches)
side_sheaths = true;

// Add short end holes spaced along the width for PELA Techics connectors
end_holes = 3;  // [0:disabled, 1:short air vents, 2:short connectors, 3:full length connectors]

// Add a sheath around end holes  (disable for extra ventilation, enable for connector lock notches)
end_sheaths = true;

// Add holes in the top deck to improve airflow and reduce weight
top_vents = true;

// Size of a hole in the top of each knob to keep the cutout as part of the outside surface (slicer-friendly if knob_slice_count=0). Use a larger number for air circulation or to drain resin from the cutout, or 0 to disable.
knob_vent_radius = 0;

// There is usually no need or room for corner mounting M3 bolt holes
bolt_holes = false;

// Cut an opening in the front for access and ventilation
front_side_airhole = true;

// Cut an opening in the back for access and ventilation
back_side_airhole = true;

// Cut an opening in the left for access and ventilation
left_end_airhole = true;

// Cut an opening in the right for access and ventilation
right_end_airhole = true;

/////////////////////////////////////
// PELA End Cap Enclosure Display

if (mode==1) {
    left_endcap_with_supports();
} else if (mode==2) {
    right_endcap_with_supports();
} else if (mode==3) {
    translate([0, block_width(w+0.5)]) {
        left_endcap_with_supports();
    }
    right_endcap_with_supports();
} else if (mode==4) {
    endcap_enclosure(print_supports=false);
} else {
    echo("<b>Unsupported: please check <i>mode</i> variable is 1-3</b>");
}

///////////////////////////////////
// Functions
///////////////////////////////////

// Height of the bottom of the cutout space (not including vertical_offset)
function enclosed_z(h, enclosed_height, vertical_offset) = block_height(h) - enclosed_height - top_shell + vertical_offset;


///////////////////////////////////
// Modules
///////////////////////////////////


// Left side shell (object is inserted from the right)
module left_endcap(enclosed_l=enclosed_l, enclosed_w=enclosed_w, enclosed_height=enclosed_height, shoulder=shoulder, l=l, w=w, h=h, left_cap=left_cap, right_cap=right_cap, left_cap_support_width=left_cap_support_width, right_cap_support_width=right_cap_support_width, corner_radius=corner_radius, vertical_offset=vertical_offset, top_vents=top_vents, side_holes=side_holes, side_sheaths=side_sheaths, end_holes=end_holes, end_sheaths=end_sheaths, solid_upper_layers=solid_upper_layers) {
    
    intersection() {
        endcap_enclosure(enclosed_l=enclosed_l, enclosed_w=enclosed_w, enclosed_height=enclosed_height, shoulder=shoulder, l=l, w=w, h=h, left_cap=left_cap, right_cap=right_cap, left_cap_support_width=left_cap_support_width, right_cap_support_width=right_cap_support_width, side_opening_vertical_offset=side_opening_vertical_offset, corner_radius=corner_radius, vertical_offset=vertical_offset, top_vents=top_vents, side_holes=side_holes, side_sheaths=side_sheaths, end_holes=end_holes, end_sheaths=end_sheaths, solid_upper_layers=solid_upper_layers);
        
        cube([block_width(left_cap), block_width(w), block_height(h+1)]);
    }
}

// Left side shell including optional supports
module left_endcap_with_supports(enclosed_l=enclosed_l, enclosed_w=enclosed_w, enclosed_height=enclosed_height, shoulder=shoulder, l=l, w=w, h=h, left_cap=left_cap, right_cap=right_cap, left_cap_support_width=left_cap_support_width, right_cap_support_width=right_cap_support_width, corner_radius=corner_radius, vertical_offset=vertical_offset, top_vents=top_vents, side_holes=side_holes, side_sheaths=side_sheaths, end_holes=end_holes, end_sheaths=end_sheaths, print_supports=print_supports, solid_upper_layers=solid_upper_layers, support_offset_from_part=support_offset_from_part) {

    left_endcap(enclosed_l=enclosed_l, enclosed_w=enclosed_w, enclosed_height=enclosed_height, shoulder=shoulder, l=l, w=w, h=h, left_cap=left_cap, right_cap=right_cap, left_cap_support_width=left_cap_support_width, right_cap_support_width=right_cap_support_width, corner_radius=corner_radius, vertical_offset=vertical_offset, top_vents=top_vents, side_holes=side_holes, side_sheaths=side_sheaths, end_holes=end_holes, end_sheaths=end_sheaths, print_supports=print_supports, solid_upper_layers=solid_upper_layers);

    if (print_supports) {
        enclosed_z = enclosed_z(h=h, enclosed_height=enclosed_height, vertical_offset=vertical_offset);

        difference() {
            translate([0, 0, enclosed_z]) {
                support_set(corner_supports=true, l=left_cap, w=w, height=enclosed_height);
            }

            minkowski() {
                left_endcap(enclosed_l=enclosed_l, enclosed_w=enclosed_w, enclosed_height=enclosed_height, shoulder=shoulder, l=l, w=w, h=h, left_cap=left_cap, right_cap=right_cap, left_cap_support_width=left_cap_support_width, right_cap_support_width=right_cap_support_width, corner_radius=corner_radius, vertical_offset=vertical_offset, top_vents=top_vents, side_holes=side_holes, side_sheaths=side_sheaths, end_holes=end_holes, end_sheaths=end_sheaths, print_supports=print_supports, solid_upper_layers=solid_upper_layers);

                cube([2*support_offset_from_part, 2*support_offset_from_part, 2*support_offset_from_part], center=true);
            }
        }
    }
}


// Right half of the object shell
module right_endcap(enclosed_l=enclosed_l, enclosed_w=enclosed_w, enclosed_height=enclosed_height, shoulder=shoulder, l=l, w=w, h=h, left_cap=left_cap, right_cap=right_cap, left_cap_support_width=left_cap_support_width, right_cap_support_width=right_cap_support_width, corner_radius=corner_radius, vertical_offset=vertical_offset, top_vents=top_vents, side_holes=side_holes, end_holes=end_holes, solid_upper_layers=solid_upper_layers) {
    
    intersection() {
        translate([l-right_cap, 0, 0]) {
            endcap_enclosure(enclosed_l=enclosed_l, enclosed_w=enclosed_w, enclosed_height=enclosed_height, shoulder=shoulder, l=l, w=w, h=h, left_cap=left_cap, right_cap=right_cap, left_cap_support_width=left_cap_support_width, right_cap_support_width=right_cap_support_width, side_opening_vertical_offset=side_opening_vertical_offset, corner_radius=corner_radius, vertical_offset=vertical_offset, top_vents=top_vents, side_holes=side_holes, side_sheaths=side_sheaths, end_holes=end_holes, end_sheaths=end_sheaths, solid_upper_layers=solid_upper_layers);
        }

        translate([block_width(l-right_cap), 0, 0]) {
            cube([block_width(right_cap), block_width(w), block_height(h+1)]);
        }
    }
}


// Right half of the object shell including optional supports
module right_endcap_with_supports(enclosed_l=enclosed_l, enclosed_w=enclosed_w, enclosed_height=enclosed_height, shoulder=shoulder, l=l, w=w, h=h, left_cap=left_cap, right_cap=right_cap, left_cap_support_width=left_cap_support_width, right_cap_support_width=right_cap_support_width, corner_radius=corner_radius, vertical_offset=vertical_offset, top_vents=top_vents, side_holes=side_holes, end_holes=end_holes, print_supports=print_supports, solid_upper_layers=solid_upper_layers, support_offset_from_part=support_offset_from_part) {
    
    right_endcap(enclosed_l=enclosed_l, enclosed_w=enclosed_w, enclosed_height=enclosed_height, shoulder=shoulder, l=l, w=w, h=h, left_cap=left_cap, right_cap=right_cap, left_cap_support_width=left_cap_support_width, right_cap_support_width=right_cap_support_width, corner_radius=corner_radius, vertical_offset=vertical_offset, top_vents=top_vents, side_holes=side_holes, end_holes=end_holes, solid_upper_layers=solid_upper_layers);

    if (print_supports) {
        support_z = enclosed_z(h=h, enclosed_height=enclosed_height, vertical_offset=vertical_offset);

        difference() {
            translate([block_width(l), block_width(w), support_z]) {
                rotate([0, 0, 180]) {
                    support_set(corner_supports=true, l=right_cap, w=w, height=enclosed_height);
                }
            }

            minkowski() {
                right_endcap(enclosed_l=enclosed_l, enclosed_w=enclosed_w, enclosed_height=enclosed_height, shoulder=shoulder, l=l, w=w, h=h, left_cap=left_cap, right_cap=right_cap, left_cap_support_width=left_cap_support_width, right_cap_support_width=right_cap_support_width, corner_radius=corner_radius, vertical_offset=vertical_offset, top_vents=top_vents, side_holes=0, end_holes=0, solid_upper_layers=solid_upper_layers);
                
                cube([2*support_offset_from_part, 2*support_offset_from_part, 2*support_offset_from_part], center=true);
            }
        }
    }
}


// A PELA block with a hole inside to contain something of the specified dimensions
module endcap_enclosure(enclosed_l=enclosed_l, enclosed_w=enclosed_w, enclosed_height=enclosed_height, shoulder=shoulder, l=l, w=w, h=h, left_cap=left_cap, right_cap=right_cap, left_cap_support_width=left_cap_support_width, right_cap_support_width=right_cap_support_width, side_opening_vertical_offset=side_opening_vertical_offset, corner_radius=corner_radius, vertical_offset=vertical_offset, top_vents=top_vents, side_holes=side_holes, side_sheaths=side_sheaths, end_holes=end_holes, end_sheaths=end_sheaths, solid_upper_layers=solid_upper_layers) {
    
    difference() {        
        PELA_technic_block(l=l, w=w, h=h, top_vents=top_vents, side_holes=side_holes, side_sheaths=side_sheaths, end_holes=end_holes, end_sheaths=end_sheaths, solid_upper_layers=solid_upper_layers);
        
        translate([0, 0, vertical_offset]) {
            enclosure_negative_space(l=l, w=w, h=h, enclosed_l=enclosed_l, enclosed_w=enclosed_w, enclosed_height=enclosed_height, left_cap=left_cap, right_cap=right_cap, left_cap_support_width=left_cap_support_width, right_cap_support_width=right_cap_support_width, shoulder=shoulder, side_opening_vertical_offset=side_opening_vertical_offset, corner_radius=corner_radius);
        }
    }
}


// Where to remove material to provide side and end access for attachments and air ventilation
module enclosure_negative_space(l=l, w=w, h=h, enclosed_l=enclosed_l, enclosed_w=enclosed_w, enclosed_height=enclosed_height, left_cap=left_cap, right_cap=right_cap, left_cap_support_width=left_cap_support_width, right_cap_support_width=right_cap_support_width, shoulder=shoulder, side_opening_vertical_offset=side_opening_vertical_offset, corner_radius=corner_radius) {

    // Add some margin around the enclosed space to give space to fit the part
    margin_l = enclosed_l;
    margin_w = enclosed_w;
    margin_h = enclosed_height;    
    
    ls = margin_l - 2*shoulder;
    ws = margin_w - 2*shoulder;
    hs = margin_h - 2*shoulder;
    
    dl = (block_width(l)-margin_l)/2;
    dw = (block_width(w)-margin_w)/2;

    enclosed_z = enclosed_z(h=h, enclosed_height=enclosed_height, vertical_offset=vertical_offset);

    // Primary enclosure hole
    translate([dl, dw, enclosed_z]) {
        cube([margin_l, margin_w, margin_h]);
    }
    
    if (left_end_airhole) {
        translate([-corner_radius, dw+shoulder, enclosed_z+shoulder+side_opening_vertical_offset]) {
            rounded_cube(x=ls, y=ws, z=hs, corner_radius=corner_radius);
        }
    }

    if (right_end_airhole) {
        translate([corner_radius+block_width(l)-ls, dw+shoulder, enclosed_z+shoulder+side_opening_vertical_offset]) {
            rounded_cube(x=ls, y=ws, z=hs, corner_radius=corner_radius);
        }
    }
    
    difference() {
        union() {
            if (back_side_airhole) {
                translate([dl+shoulder, -corner_radius+dw+margin_w, enclosed_z+shoulder+side_opening_vertical_offset]) {
                    rounded_cube(x=ls, y=ws, z=hs, corner_radius=corner_radius);
                }
            }
                
            if (front_side_airhole) {
                translate([dl+shoulder, -corner_radius, enclosed_z+shoulder+side_opening_vertical_offset]) {
                    rounded_cube(x=ls, y=ws, z=hs, corner_radius=corner_radius);
                }
            }
        }

        // Vertical support bars near the enclosure cut point(s)
        translate([block_width(left_cap-left_cap_support_width), 0, 0]) {
            cube([block_width(right_cap_support_width+left_cap_support_width), block_width(w), block_height(h)]);
        }
    }
 }

// A cube with rounded corners which fits in the space [x,y,z]
module rounded_cube(x, y, z, corner_radius=corner_radius) {
    translate([corner_radius, corner_radius, corner_radius]) {
        minkowski() {
            cube([x-2*corner_radius, y-2*corner_radius, z-2*corner_radius]);
            sphere(r=corner_radius);
        }
    }
}
