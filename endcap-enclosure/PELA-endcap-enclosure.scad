/*
Parametric PELA End Cap Enclosure Generator

Create 2 symmetric end pieces which can support a solid object with PELA-compatible attachment points on top and bottom. The print can be minimized by printing only smaller end caps instead of a complele enclosure.


    https://www.thingiverse.com/thing:2544197
Based on
    https://www.thingiverse.com/thing:2303714



By Paul Houghton
Twitter: @mobile_rat
Email: paulirotta@gmail.com
Blog: https://medium.com/@paulhoughton

Creative Commons Attribution-ShareAlike 4.0 International License
    https://creativecommons.org/licenses/by-sa/4.0/legalcode

Open source design, Powered By Futurice. Come work with the best.
    http://futurice.com

Import this into other design files:
    use <anker-usb-PELA-enclosure.scad>
*/

include <../PELA-parameters.scad>
include <../PELA-print-parameters.scad>
use <../PELA-block.scad>
use <../PELA-technic-block.scad>
use <../support/support.scad>


/* [PELA Options plus Plastic and Printer Variance Adjustments] */

// Type of print to generate- 1=>left cap, 2=>right cap, 3=>both caps, 4=>preview a single object that can not be opened
mode=3;

// Generate print-time support aid structures
print_supports = true;

// Length of the enclosure (PELA knob count)
//l = 23;
l = 7;

// Length of the left side of the enclosure (PELA knob count, for example l/2 or less)
l_cap = 4;

// Size of the left cap vertical support structure near the cut point (PELA knob count, 0 to disable)
l_cap_support_width = 0.5;

// Size of the right cap vertical support structure near the cut point (PELA knob count, 0 to disable)
r_cap_support_width = 0.5;

// Length of the right side of the enclosure (PELA knob count, for example l/2 or less)
r_cap = l - l_cap;

// Width of the enclosure (PELA knob count)
//w = 10;
w = 3;

// Height of the enclosure (PELA block layer count)
//h = 4;
h = 3;

// Length of the object to be enclosed (mm)
//el = 173;
el = 8*5.5;

// Width of the object to be enclosed (mm)
//ew = 68;
ew = 8*2.5;

// Height of the object to be enclosed (mm)
//eh = 28;
eh = 15;

// Distance up from baselane for the hollowed space
vertical_offset = -1;

// The size of the step which supports the enclosed part at the edges and corners in case ventilation openings would allow the enclosed part to slip out of place (mm)
shoulder = 3;

// Slide all side openings up (-down) 
side_opening_vertical_offset = -3;

// Depth which connectors may press into part bottom
socket_height=8.2;

// Rounding for side air hole corners
corner_radius=3.25;

// Solid interior is assumed for this model before carving away from that block
solid_upper_layers=1;

// Add full width through holes spaced along the length for PELA Techics connectors
side_holes = 3;  // [0:disabled, 1:short air vents, 2:short connectors, 3:full width connectors]

// Add a sheath around side holes (disable for extra ventilation, enable for connector lock notches)
side_sheaths = 1; // [0:disabled, 1:enabled]

// Add short end holes spaced along the width for PELA Techics connectors
end_holes = 3;  // [0:disabled, 1:short air vents, 2:short connectors, 3:full length connectors]

// Add a sheath around end holes  (disable for extra ventilation, enable for connector lock notches)
end_sheaths = 1; // [0:disabled, 1:enabled]

// Add holes in the top deck to improve airflow and reduce weight
top_vents = 1; // [0:disabled, 1:enabled]

// Size of a hole in the top of each knob to keep the cutout as part of the outside surface (slicer-friendly if knob_slice_count=0). Use a larger number for air circulation or to drain resin from the cutout, or 0 to disable.
knob_vent_radius = 0;

// There is usually no need or room for corner mounting M3 bolt holes
bolt_holes=0;

/////////////////////////////////////
// PELA End Cap Enclosure Display

if (mode==1) {
    left_endcap();
} else if (mode==2) {
    right_endcap();
} else if (mode==3) {
    translate([0, block_width(w+0.5)])
        left_endcap();
    right_endcap();
} else if (mode==4) {
    PELA_enclosure(print_supports=false);
} else {
    echo("<b>Unsupported: please check <i>mode</i> variable is 1-3</b>");
}

///////////////////////////////////
// Functions
///////////////////////////////////

// Height of the bottom of the cutout space (not including vertical_offset)
function dh(socket_height, h, eh)=socket_height+(block_height(h)-(eh + 2*skin)-socket_height)/2;


///////////////////////////////////
// Modules
///////////////////////////////////

module left_endcap(print_supports=print_supports, el=el, ew=ew, eh=eh, shoulder=shoulder, l=l, w=w, h=h, l_cap=l_cap, r_cap=r_cap, l_cap_support_width=l_cap_support_width, r_cap_support_width=r_cap_support_width, socket_height=socket_height, corner_radius=corner_radius, vertical_offset=vertical_offset, top_vents=top_vents, side_holes=side_holes, side_sheaths=side_sheaths, end_holes=end_holes, end_sheaths=end_sheaths, print_supports=print_supports) {
    
    intersection() {
        PELA_enclosure(el=el, ew=ew, eh=eh, shoulder=shoulder, l=l, w=w, h=h, l_cap=l_cap, r_cap=r_cap, l_cap_support_width=l_cap_support_width, r_cap_support_width=r_cap_support_width, side_opening_vertical_offset=side_opening_vertical_offset, socket_height=socket_height, corner_radius=corner_radius, vertical_offset=vertical_offset, top_vents=top_vents, side_holes=side_holes, side_sheaths=side_sheaths, end_holes=end_holes, end_sheaths=end_sheaths);
        
        cube([block_width(l_cap), block_width(w), block_height(h+1)]);
    }

    print_supports(print_supports=print_supports, cap=l_cap, w=w, h=h, socket_height=socket_height, eh=eh, vertical_offset=vertical_offset);
}


// Add support columns to hold up the roof of one clamshell end
module print_supports(print_supports=print_supports, cap, w=w, h=h, socket_height=socket_height, eh=eh, vertical_offset=vertical_offset) {
    
    if (print_supports && cap>2 && w>2) {
        dh = dh(socket_height=socket_height, h=h, eh=eh) + vertical_offset + skin;
        support_side_length=ring_radius*1.5;
        for (x=[1:1:cap-1]) {
            for (y=[1:1:w-2]) {
                support_max_rotation = x== 0 || y==0 || y==w-1 ? 0.1 : 0;
                support_initial_rotation = y!=0 && y!=w-1 ? 0 : x==0 ? -90 : y==0 ? -90-support_max_rotation/2 : -30-support_max_rotation/2;
                if (!((x==0 || x==cap-1) && (y==0 || y==w-1))) {
                    translate([block_width(x+0.5), block_width(y+0.5), dh])
                        rotate([0, 0, support_initial_rotation])
                            support(support_max_rotation=support_max_rotation, height=eh, support_side_length=support_side_length);
                    }
                }
            }
        }
}


module right_endcap(print_supports=print_supports, el=el, ew=ew, eh=eh, shoulder=shoulder, l=l, w=w, h=h, l_cap=l_cap, r_cap=r_cap, l_cap_support_width=l_cap_support_width, r_cap_support_width=r_cap_support_width, corner_radius=corner_radius, vertical_offset=vertical_offset, top_vents=top_vents, side_holes=side_holes, end_holes=end_holes, print_supports=print_supports) {
    
    intersection() {
        PELA_enclosure(el=el, ew=ew, eh=eh, shoulder=shoulder, l=l, w=w, h=h, l_cap=l_cap, r_cap=r_cap, l_cap_support_width=l_cap_support_width, r_cap_support_width=r_cap_support_width, side_opening_vertical_offset=side_opening_vertical_offset, socket_height=socket_height, corner_radius=corner_radius, vertical_offset=vertical_offset, top_vents=top_vents, side_holes=side_holes, side_sheaths=side_sheaths, end_holes=end_holes, end_sheaths=end_sheaths);
        
        translate([block_width(l-r_cap), 0, 0])
            cube([block_width(r_cap), block_width(w), block_height(h+1)]);
    }

    translate([block_width(l), block_width(w), 0])
        rotate([0, 0, 180])
            print_supports(print_supports=print_supports, cap=r_cap, w=w, h=h, socket_height=socket_height, eh=eh, vertical_offset=vertical_offset);
}


// A PELA block with a hole inside to contain something of the specified dimensions
module PELA_enclosure(el=el, ew=ew, eh=eh, shoulder=shoulder, l=l, w=w, h=h, l_cap=l_cap, r_cap=r_cap, l_cap_support_width=l_cap_support_width, r_cap_support_width=r_cap_support_width, side_opening_vertical_offset=side_opening_vertical_offset, socket_height=socket_height, corner_radius=corner_radius, vertical_offset=vertical_offset, top_vents=top_vents, side_holes=side_holes, side_sheaths=side_sheaths, end_holes=end_holes, end_sheaths=end_sheaths, print_supports=print_supports) {
    
    difference() {        
        PELA_technic_block(l=l, w=w, h=h, socket_height=socket_height, top_vents=top_vents, side_holes=side_holes, side_sheaths=side_sheaths, end_holes=end_holes, end_sheaths=end_sheaths, solid_upper_layers=solid_upper_layers);
        
        translate([0, 0, vertical_offset])
            enclosure_negative_space(l=l, w=w, h=h, el=el, ew=ew, eh=eh, l_cap=l_cap, r_cap=r_cap, l_cap_support_width=l_cap_support_width, r_cap_support_width=r_cap_support_width, shoulder=shoulder, side_opening_vertical_offset=side_opening_vertical_offset, socket_height=socket_height, corner_radius=corner_radius);
    }
}


// Where to remove material to provide side and end access for attachments and air ventilation
module enclosure_negative_space(l=l, w=w, h=h, el=el, ew=ew, eh=eh, l_cap=l_cap, r_cap=r_cap, l_cap_support_width=l_cap_support_width, r_cap_support_width=r_cap_support_width, shoulder=shoulder, side_opening_vertical_offset=side_opening_vertical_offset, socket_height=socket_height, corner_radius=corner_radius) {

    // Add some margin around the enclosed space to give space to fit the part
    ml = el + 2*skin;
    mw = ew + 2*skin;
    mh = eh + 2*skin;    
    
    ls = ml - 2*shoulder;
    ws = mw - 2*shoulder;
    hs = mh - 2*shoulder;
    
    dl = (block_width(l)-ml)/2;
    dw = (block_width(w)-mw)/2;
    dh = dh(socket_height=socket_height, h=h, eh=eh);

    // Primary enclosure hole
    translate([dl, dw, dh]) 
        cube([ml, mw, mh]);
    
    // Left end air hole
    translate([-corner_radius, dw+shoulder, dh+shoulder+side_opening_vertical_offset])
        rounded_cube(x=ls, y=ws, z=hs, corner_radius=corner_radius);
    
    // Right end air hole
    translate([corner_radius+block_width(l)-ls, dw+shoulder, dh+shoulder+side_opening_vertical_offset])
        rounded_cube(x=ls, y=ws, z=hs, corner_radius=corner_radius);           
    
    difference() {
        union() {
            // Back side air hole
            translate([dl+shoulder, -corner_radius+dw+mw, dh+shoulder+side_opening_vertical_offset])
                rounded_cube(x=ls, y=ws, z=hs, corner_radius=corner_radius);
                
            // Front side air hole
            translate([dl+shoulder, -corner_radius, dh+shoulder+side_opening_vertical_offset])
                rounded_cube(x=ls, y=ws, z=hs, corner_radius=corner_radius);
        }

        // Vertical support bars near the enclosure cut point(s)
        translate([block_width(l_cap-l_cap_support_width), 0, 0])
            cube([block_width(r_cap_support_width+l_cap_support_width), block_width(w), block_height(h)]);
    }
 }

module rounded_cube(x=5, y=5, z=5, corner_radius=corner_radius) {
    translate([corner_radius, corner_radius, corner_radius])
        minkowski() {
            cube([x-2*corner_radius, y-2*corner_radius, z-2*corner_radius]);
            sphere(r=corner_radius);
        }
}
