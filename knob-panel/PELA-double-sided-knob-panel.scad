/*
PELA Parametric Block

Published at https://PELAblocks.org

By Paul Houghton
Twitter: @mobile_rat
Email: paulirotta@gmail.com
Blog: https://medium.com/@paulhoughton

Creative Commons Attribution-ShareAlike 4.0 International License
    https://creativecommons.org/licenses/by-sa/4.0/legalcode

Open source design, Powered By Futurice. Come work with the best.
    https://www.futurice.com/

Import this into other design files:
    use <PELA-block.scad>
*/

include <../PELA-print-parameters.scad>
include <../PELA-parameters.scad>
use <../PELA-block.scad>
use <../PELA-technic-block.scad>
use <PELA-knob-panel.scad>

/* [PELA Panel Options] */

// Length of the block (PELA unit count)
l = 4; 

// Width of the block (PELA unit count)
w = 4;

top_vents = true;

// Interior fill for layers above the bottom
solid_bottom_layer = false;

// Place holes in the corners for mountings screws (0=>no holes, 1=>holes)
bolt_holes = true;

// Presence of top connector knobs (vs flat)
knobs = true;

// Presence of bottom socket connectors (vs flat)
sockets = true;

// Height of horizontal surface strengthening slats (appears between the bottom rings)
bottom_stiffener_height = 0;

// How many outside rows and columns on all edges to omit before adding knobs
skip_edge_knobs = 0;


/////////////////////////////////////
// PELA panel display
/////////////////////////////////////

PELA_double_sided_knob_panel();

/////////////////////////////////////
// PELA PANEL modules
/////////////////////////////////////

module PELA_double_sided_knob_panel(l=l, w=w, top_vents=top_vents, solid_bottom_layer=solid_bottom_layer, bolt_holes=bolt_holes, bolt_hole_radius=bolt_hole_radius, knobs=knobs, skip_edge_knobs=skip_edge_knobs, block_height=block_height) {

PELA_knob_panel(l=l, w=w, top_vents=top_vents, solid_bottom_layer=solid_bottom_layer, bolt_holes=bolt_holes, bolt_hole_radius=bolt_hole_radius, knobs=knobs, sockets=false, skip_edge_knobs=skip_edge_knobs, block_height=block_height);
    
    translate([0, block_width(w), panel_height(block_height=block_height)]) {
        rotate([180, 0, 0]) {
            PELA_knob_panel(l=l, w=w, top_vents=top_vents, solid_bottom_layer=solid_bottom_layer, bolt_holes=bolt_holes, bolt_hole_radius=bolt_hole_radius, knobs=knobs, sockets=false, skip_edge_knobs=skip_edge_knobs, block_height=block_height);
        }
    }
}

