/*
Parametric PELA Box Enclosure Generator

Create a bottom and 4 walls of a rectangle for enclosing objects


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
use <../socket-panel/PELA-socket-panel.scad>
use <../knob-panel/PELA-knob-panel.scad>
use <PELA-box-enclosure.scad>


/* [PELA Box Option] */

// Length of the enclosure including two for walls (PELA knob count)
l = 12;

// Width of the enclosure including two for walls (PELA knob count)
w = 8;

// Height of the enclosure including one for floor (PELA block layer count)
h = 3;

// Board length, including some extra
board_l = 97.3;

// Board width, including some extra
board_w = 66.3;

// Distance from box bottom to mount the board
board_h = 12;

// Thickness, including some extra for insertion
board_thickness=1.8;

// Add full width through holes spaced along the length for PELA Techics connectors
side_holes = 2;  // [0:disabled, 1:short air vents, 2:short connectors, 3:full width connectors]

// Add a sheath around side holes (disable for extra ventilation, enable for connector lock notches)
side_sheaths = 1; // [0:disabled, 1:enabled]

// Add short end holes spaced along the width for PELA Techics connectors
end_holes = 0;  // [0:disabled, 1:short air vents, 2:short connectors, 3:full length connectors]

// Add a sheath around end holes  (disable for extra ventilation, enable for connector lock notches)
end_sheaths = 1; // [0:disabled, 1:enabled]

// Add holes in the top deck to improve airflow and reduce weight
top_vents = 0; // [0:disabled, 1:enabled]

// Add holes in the bottom deck to improve airflow and reduce weight (only used with bottom_type==2, knob panel)
bottom_vents = 0; // [0:disabled, 1:enabled]

// Size of a hole in the top of each knob to keep the cutout as part of the outside surface (slicer-friendly if knob_slice_count=0). Use a larger number for air circulation or to drain resin from the cutout, or 0 to disable.
knob_vent_radius = 0;

// There is usually no need or room for corner mounting M3 bolt holes
bolt_holes = 0;

// Bottom of enclosure
bottom_type = 2; // [0:open bottom, 1:solid bottom, 2:socket-panel bottom, 3:knob-panel bottom]

// Height of the bottom to the enclosure (by default this is shorter then a normal panel so there is room on the enclosure sides for technic holes)
bottom_height = 2.5;

// Size of the small flexture cavity inside each knob (set to 0 for flexible materials, if the knobs delaminate and detach, or to avoid holes if the knobs are removed)
knob_flexture_radius = 0;

// Horizontal clearance space around the outer surface of the set of blocks to allow two parts to be placed next to one another
skin = 0.1;

// Create the left wall
left_wall_enabled = false;

// Create the right wall
right_wall_enabled = true;

// Create the front wall
front_wall_enabled = true;

// Create the back wall
back_wall_enabled = true;

/////////////////////////////////////
// PELA Box Enclosure Display

PELA_stmf4discovery_box_enclosure();


///////////////////////////////////
// Modules
///////////////////////////////////

module PELA_stmf4discovery_box_enclosure(l=l, w=w, h=h, bottom_type=bottom_type, bottom_height=bottom_height, top_vents=top_vents, side_holes=side_holes, side_sheaths=side_sheaths, end_holes=end_holes, end_sheaths=end_sheaths, skin=skin, left_wall_enabled=left_wall_enabled, right_wall_enabled=right_wall_enabled, front_wall_enabled=front_wall_enabled, back_wall_enabled=back_wall_enabled) {

    PELA_box_enclosure(l=l, w=w, h=h, bottom_type=bottom_type, bottom_height=bottom_height, top_vents=top_vents, side_holes=side_holes, side_sheaths=side_sheaths, end_holes=end_holes, end_sheaths=end_sheaths, skin=skin, left_wall_enabled=left_wall_enabled, right_wall_enabled=right_wall_enabled, front_wall_enabled=front_wall_enabled, back_wall_enabled=back_wall_enabled);
}