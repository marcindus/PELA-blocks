/*
PELA Parametric Knob Panel

Published at http://PELAblocks.org

By Paul Houghton
Twitter: @mobile_rat
Email: paulirotta@gmail.com
Blog: https://medium.com/@paulhoughton

Creative Commons Attribution-ShareAlike 4.0 International License
    https://creativecommons.org/licenses/by-sa/4.0/legalcode

Open source design, Powered By Futurice. Come work with the best.
    http://futurice.com

Import this into other design files:
    use <PELA-block.scad>
*/

include <../PELA-parameters.scad>
include <../PELA-print-parameters.scad>
use <../PELA-block.scad>
use <../PELA-technic-block.scad>

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

//PELA_knob_panel();
PELA_technic_block(l=l, w=w, h=1/2, top_vents=top_vents, solid_bottom_layer=solid_bottom_layer, bolt_holes=bolt_holes, side_holes=0, end_holes=0, bottom_stiffener_height=bottom_stiffener_height, knobs=knobs, sockets=sockets);

/////////////////////////////////////
// PELA PANEL modules
/////////////////////////////////////

module PELA_knob_panel(l=l, w=w, top_vents=top_vents, solid_bottom_layer=solid_bottom_layer, bolt_holes=bolt_holes, bolt_hole_radius=bolt_hole_radius, knobs=knobs, sockets=sockets, skip_edge_knobs=skip_edge_knobs) {

    hr=panel_height_ratio();

    if (skip_edge_knobs > 0) {
        PELA_technic_block(l=l, w=w, h=hr, top_vents=top_vents, solid_bottom_layer=solid_bottom_layer, bolt_holes=bolt_holes, side_holes=0, end_holes=0, bottom_stiffener_height=bottom_stiffener_height, knobs=false, sockets=sockets);

        echo("knob l", l);
        echo("knob w", w);
        if (l>2 && w>2) {
            translate([block_width(skip_edge_knobs), block_width(skip_edge_knobs), 0]) {
                top_knob_set(l=l-2*skip_edge_knobs, w=w-2*skip_edge_knobs, h=hr, knob_radius=knob_radius, bolt_holes=false);
            }
        }
    } else {
        PELA_technic_block(l=l, w=w, h=hr, top_vents=top_vents, solid_bottom_layer=solid_bottom_layer, bolt_holes=bolt_holes, side_holes=0, end_holes=0, bottom_stiffener_height=bottom_stiffener_height, knobs=knobs, sockets=sockets);
    }
}
