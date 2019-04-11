/*
PELA Parametric Block with LEGO-compatible technic connectors and air vents

PELA Parametric Blocks - 3D Printed LEGO-compatible parametric blocks

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
    include <style.scad>
    use <technic.scad>
    
All modules have sensible defaults derived from <style.scad>. 
You can ignore values you are not tampering with and only need to pass a
parameter if you are overriding.

All modules are setup for stateless functional-style reuse in other OpenSCAD files.
To this end, you can always pass in and override all parameters to create
a new effect. Doing this is not natural to OpenSCAD, so apologies for all
the boilerplate arguments which are passed in to each module or any errors
that may be hidden by the sensible default values. This is an evolving art.
*/

include <style.scad>
include <material.scad>
use <PELA-block.scad>



/* [Technic Block] */

// Show the inside structure [mm]
_cut_line = 0; // [0:1:100]

// Printing material (set to select calibrated knob, socket and axle hole fit)
_material = 0; // [0:PLA, 1:ABS, 2:PET, 3:Biofila Silk, 4:Pro1, 5:NGEN, 6:NGEN FLEX, 7:Bridge Nylon, 8:TPU95, 9:TPU85/NinjaFlex]

// Is the printer nozzle >= 0.5mm? If so, some features are enlarged to make printing easier
_large_nozzle = true;

// Model length [blocks]
_l = 4; // [1:1:30]

// Model width [blocks]
_w = 4; // [1:1:30]

// Model height [blocks]
_h = 2; // [1:1:30]


/* [Block Features] */

// Presence of bottom connector sockets
_sockets = true;

// Presence of top connector knobs
_knobs = true;

// How tall are top connectors [mm]
_knob_height = 2.9; // [1.8:traditional blocks, 2.9:PELA 3D print tall]

// Basic unit vertical size of each block
_block_height = 8; // [8:technic, 9.6:traditional blocks]

// Place holes in the corners for mountings screws (0=>no holes, 1=>holes)
_corner_bolt_holes = false;

// Size of corner holes for M3 mountings bolts
_bolt_hole_radius = 1.6; // [0.0:0.1:2.0]

// Add interior fill for upper layers
_solid_upper_layers = true;

// Add interior fill for the base layer
_solid_first_layer = false;


/* [Technic Features] */

// Add full width through holes spaced along the length for techic connectors
_side_holes = 2; // [0:disabled, 1:short air vents, 2:full width connectors, 3:short connectors]

// Add a wrapper around side holes (disable for extra ventilation but loose lock notches)
_side_sheaths = true;

// Add short end holes spaced along the width for techic connectors
_end_holes = 2; // [0:disabled, 1:short air vents, 2:full width connectors, 3:short connectors]

// Add a wrapper around end holes (disable for extra ventilation but loose lock notches)
_end_sheaths = true;

// Add holes in the top deck to improve airflow and reduce weight
_top_vents = false;

// Size of a hole in the top of each knob. 0 to disable or use for air circulation/aesthetics/drain resin from the cutout, but larger holes change flexture such that knobs may not hold as well
_knob_vent_radius = 0; // [0.0:0.1:3.9]



/////////////////////////////////////
// DISPLAY
/////////////////////////////////////

PELA_technic_block(material=_material, large_nozzle=_large_nozzle, cut_line=_cut_line, l=_l, w=_w, h=_h, knob_height=_knob_height, knob_flexture_height=_knob_flexture_height, sockets=_sockets, socket_insert_bevel=_socket_insert_bevel, knobs=_knobs, knob_vent_radius=_knob_vent_radius, skin=_skin, top_shell=_top_shell, bottom_stiffener_width=_bottom_stiffener_width, bottom_stiffener_height=_bottom_stiffener_height, corner_bolt_holes=_corner_bolt_holes, bolt_hole_radius=_bolt_hole_radius, ridge_width=_ridge_width, ridge_depth=_ridge_depth, ridge_z_offset=_ridge_z_offset, solid_upper_layers=_solid_upper_layers, top_vents=_top_vents, side_holes=_side_holes, side_sheaths=_side_sheaths, end_holes=_end_holes, end_sheaths=_end_sheaths, solid_first_layer=_solid_first_layer, block_height=_block_height, bottom_tweak=undef, top_tweak=undef, axle_hole_tweak=undef);


/////////////////////////////////////
// FUNCTIONS
/////////////////////////////////////

// Indicates a solid cylinder around side hole connectors
function is_side_sheaths(side_sheaths=undef, side_holes=undef) = side_sheaths && side_holes > 1;

// Indicates a solid cylinder around end hole connectors
function is_end_sheaths(end_sheaths=undef, end_holes=undef) = end_holes > 1 && end_sheaths;

// Find the optimum enclosing horizontal dimension in block units
function fit_mm_to_blocks(i=undef, padding=undef) = ceil((i + block_width(padding+1))/block_width);

// Find the optimum enclosing vertical dimension in block units
function fit_mm_to_height_blocks(i=undef, padding=undef, block_height=undef) = ceil((i + block_height(padding+1, block_height=block_height))/block_height);




///////////////////////////////////
// MODULES
///////////////////////////////////

module PELA_technic_block(material=undef, large_nozzle=undef, cut_line=undef, l=undef, w=undef, h=undef, knob_height=undef, knob_flexture_height=_knob_flexture_height, sockets=undef, socket_insert_bevel=_socket_insert_bevel, knobs=undef, knob_vent_radius=undef, skin=_skin, top_shell=_top_shell, bottom_stiffener_width=_bottom_stiffener_width, bottom_stiffener_height=_bottom_stiffener_height, corner_bolt_holes=_corner_bolt_holes, bolt_hole_radius=_bolt_hole_radius, ridge_width=_ridge_width, ridge_depth=_ridge_depth, ridge_z_offset=_ridge_z_offset, top_vents=undef, side_holes=undef, side_sheaths=undef, end_holes=undef, end_sheaths=undef, solid_first_layer=_solid_first_layer, solid_upper_layers=_solid_upper_layers, block_height=undef, bottom_tweak=undef, top_tweak=undef, axle_hole_tweak=undef) {

    assert(material != undef);
    assert(large_nozzle != undef);
    assert(cut_line != undef);
    assert(l != undef);
    assert(w != undef);
    assert(h != undef);
    assert(knobs != undef);
    if (knobs) {
        assert(knob_height != undef);
        assert(knob_vent_radius != undef);
    }
//    assert(knob_flexture_height != undef);
    assert(sockets != undef);
//    assert(socket_insert_bevel!=undef);
//    assert(skin != undef);
//    assert(top_shell != undef);
    assert(bottom_stiffener_width != undef);
    assert(bottom_stiffener_height != undef);
    assert(corner_bolt_holes != undef);
    if (corner_bolt_holes) {
        assert(bolt_hole_radius != undef);
    }
//    assert(ridge_width != undef);
//    assert(ridge_depth != undef);
//    assert(ridge_z_offset != undef);
    assert(top_vents != undef);
    assert(side_holes != undef);
    if (side_holes > 0) {
        assert(side_sheaths != undef);
    }
    assert(end_holes != undef);
    if (end_holes > 0) {
        assert(end_sheaths != undef);
    }
//    assert(solid_first_layer != undef);
//    assert(solid_upper_layers != undef);
    assert(block_height != undef);

    difference() {
        visual_cut_technic_block(material=material, large_nozzle=large_nozzle, cut_line=cut_line, l=l, w=w, h=h, knob_height=knob_height, knob_flexture_height=knob_flexture_height, sockets=sockets, socket_insert_bevel=socket_insert_bevel, knobs=knobs, knob_vent_radius=knob_vent_radius, skin=skin, top_shell=top_shell, bottom_stiffener_width=bottom_stiffener_width, bottom_stiffener_height=bottom_stiffener_height, corner_bolt_holes=corner_bolt_holes, bolt_hole_radius=bolt_hole_radius, ridge_width=ridge_width, ridge_depth=ridge_depth, ridge_z_offset=ridge_z_offset, solid_upper_layers=solid_upper_layers, top_vents=top_vents, side_holes=side_holes, side_sheaths=side_sheaths, end_holes=end_holes, end_sheaths=end_sheaths, solid_first_layer=solid_first_layer, block_height=block_height, bottom_tweak=bottom_tweak, top_tweak=top_tweak, axle_hole_tweak=axle_hole_tweak);

        cut_space(material=material, large_nozzle=large_nozzle, l=l, w=w, cut_line=cut_line, h=h, block_height=block_height, knob_height=knob_height);
    }
}


module visual_cut_technic_block(material=undef, large_nozzle=undef, cut_line=undef, l=undef, w=undef, h=undef, knob_height=undef, knob_flexture_height=undef, sockets=undef, socket_insert_bevel=undef, knobs=undef, knob_vent_radius=undef, skin=undef, top_shell=undef, bottom_stiffener_width=undef, bottom_stiffener_height=undef, corner_bolt_holes=undef, bolt_hole_radius=undef, ridge_width=undef, ridge_depth=undef, ridge_z_offset=undef, solid_upper_layers=undef, top_vents=undef, side_holes=undef, side_sheaths=undef, end_holes=undef, end_sheaths=undef, solid_first_layer=undef, block_height=undef, bottom_tweak=undef, top_tweak=undef, axle_hole_tweak=undef) {

    difference() {
        union() {
            PELA_block(material=material, large_nozzle=large_nozzle, cut_line=cut_line, l=l, w=w, h=h, knob_height=knob_height, knob_flexture_height=knob_flexture_height, sockets=sockets, socket_insert_bevel=socket_insert_bevel, knobs=knobs, knob_vent_radius=knob_vent_radius, skin=skin, top_shell=top_shell, bottom_stiffener_width=bottom_stiffener_width, bottom_stiffener_height=bottom_stiffener_height, corner_bolt_holes=corner_bolt_holes, bolt_hole_radius=bolt_hole_radius, ridge_width=ridge_width, ridge_depth=ridge_depth, ridge_z_offset=ridge_z_offset, solid_upper_layers=solid_upper_layers, solid_first_layer=solid_first_layer, block_height=block_height, bottom_tweak=bottom_tweak, top_tweak=top_tweak);
            
            for (i = [0:h-1]) {
                translate([0, 0, block_height(i, block_height=block_height)]) {
                    if (is_side_sheaths(side_sheaths=side_sheaths, side_holes=side_holes)) {

                        double_side_connector_sheath_set(material=material, large_nozzle=large_nozzle, l=l, w=w, side_holes=side_holes, skin=skin, block_height=block_height);
                    }
                    
                    if (is_end_sheaths(end_sheaths=end_sheaths, end_holes=end_holes)) {

                        double_end_connector_sheath_set(material=material, large_nozzle=large_nozzle, l=l, w=w, end_holes=end_holes, skin=skin, block_height=block_height, axle_hole_tweak=axle_hole_tweak);
                    }
                }
            }
        }
        
        union() {
            if (side_holes || end_holes || top_vents) {
                length = knob_height + skin;
                
                alternate_length = top_vents ? block_height(h+
                _defeather, block_height=block_height) + _defeather : block_height(h-0.5, block_height=block_height);

                bt = override_bottom_tweak(material=material, large_nozzle=large_nozzle, bottom_tweak=bottom_tweak);

                double_socket_hole_set(material=material, large_nozzle=large_nozzle, l=l, w=w, sockets=sockets, length=length, alternate_length=alternate_length, bevel_socket=true, socket_insert_bevel=_socket_insert_bevel, bottom_tweak=bt);
            }

            ahr = override_axle_hole_radius(material=material, large_nozzle=large_nozzle, axle_hole_tweak=axle_hole_tweak);

            bottom_connector_negative_space(material=material, large_nozzle=large_nozzle, l=l, w=w, h=h, side_holes=side_holes, end_holes=end_holes, hole_type=side_holes, corner_bolt_holes=corner_bolt_holes, bolt_hole_radius=bolt_hole_radius, sockets=sockets, skin=skin, block_height=block_height, axle_hole_radius=ahr);
            
            skin(material=material, large_nozzle=large_nozzle, l=l, w=w, h=h, skin=skin, ridge_width=ridge_width, ridge_depth=ridge_depth, block_height=block_height);
        }
    }
}


// Holes cut into the sides for the block on layer 1 to allow technic pins and axles to be inserted
module bottom_connector_negative_space(material=undef, large_nozzle=undef, l=undef, w=undef, h=undef, side_holes=undef, end_holes=undef, hole_type=undef, corner_bolt_holes=undef, bolt_hole_radius=undef, sockets=undef, skin=undef, block_height=undef, axle_hole_radius=undef) {
    
    assert(material!=undef);
    assert(large_nozzle!=undef);
    assert(l!=undef);
    assert(w!=undef);
    assert(h!=undef);
    assert(side_holes!=undef);
    assert(end_holes!=undef);
    assert(hole_type!=undef);
    assert(corner_bolt_holes!=undef);
    assert(bolt_hole_radius!=undef);
    assert(sockets!=undef);
    assert(skin!=undef);
    assert(block_height!=undef);
    assert(axle_hole_radius!=undef);

    for (i = [1:h]) {
        translate([0, 0, block_height(i-1)]) {
            if (side_holes > 0) {
                double_side_connector_hole_set(material=material, large_nozzle=large_nozzle, l=l, w=w, hole_type=side_holes, block_height=block_height, axle_hole_radius=axle_hole_radius);
            }
            
            if (end_holes > 0) {
                double_end_connector_hole_set(material=material, large_nozzle=large_nozzle, l=l, w=w, hole_type=end_holes, axle_hole_radius=axle_hole_radius, block_height=block_height);
            }
        }
    }
    
    if (corner_bolt_holes) {
        corner_corner_bolt_holes(material=material, large_nozzle=large_nozzle, l=l, w=w, h=h, bolt_hole_radius=bolt_hole_radius, block_height=block_height);
    }
}


module double_side_connector_sheath_set(material=undef, large_nozzle=undef, l=undef, w=undef, side_holes=undef, peg_length=_peg_length, bearing_sheath_thickness=_bearing_sheath_thickness, skin=undef, block_height=undef) {

    side_connector_sheath_set(material=material, large_nozzle=large_nozzle, l=l, w=w, side_holes=side_holes, peg_length=peg_length, bearing_sheath_thickness=bearing_sheath_thickness, skin=skin, block_height=block_height);

    translate([block_width(l), block_width(w)]) {
        rotate([0, 0, 180]) {
            side_connector_sheath_set(material=material, large_nozzle=large_nozzle, l=l, w=w, side_holes=side_holes, peg_length=peg_length, bearing_sheath_thickness=bearing_sheath_thickness, skin=skin, block_height=block_height);
        }
    }
}


// A row of sheaths surrounding holes along the length
module side_connector_sheath_set(material=undef, large_nozzle=undef, l=undef, w=undef, side_holes=undef, peg_length=_peg_length, bearing_sheath_thickness=undef, skin=undef, block_height=undef, axle_hole_tweak=undef) {
    
    sheath_radius = bearing_sheath_thickness + override_axle_hole_radius(material=material, large_nozzle=large_nozzle, axle_hole_tweak=axle_hole_tweak);

    sheath_length = side_holes == 2 ? block_width(w) : block_width(1);
    
    if (l == 1) {
        translate([block_width(0.5), 0, block_height(1, block_height=block_height)-block_width(0.5)]) {
            rotate([-90, 0, 0]) {
                sheath(material=material, large_nozzle=large_nozzle, sheath_radius=sheath_radius, sheath_length=sheath_length, skin=skin);
            }
        }
    } else {
        for (i = [1:l-1]) {
            translate([block_width(i), 0, block_height(1, block_height=block_height)-block_width(0.5)]) {
                rotate([-90, 0, 0]) {
                    sheath(material=material, large_nozzle=large_nozzle, sheath_radius=sheath_radius, sheath_length=sheath_length, skin=skin);
                }
            }
        }
    }
}


// Two rows of end connector enclosing cylinders
module double_end_connector_sheath_set(material=undef, large_nozzle=undef, l=undef, w=undef, end_holes=undef, peg_length=undef, bearing_sheath_thickness=undef, skin=undef, block_height=undef, axle_hole_tweak=undef) {

    end_connector_sheath_set(material=material, large_nozzle=large_nozzle, l=l, w=w, end_holes=end_holes, peg_length=peg_length, bearing_sheath_thickness=bearing_sheath_thickness, skin=skin, block_height=block_height, axle_hole_tweak=axle_hole_tweak);

    translate([block_width(l), block_width(w)]) {
        rotate([0, 0, 180]) {
            end_connector_sheath_set(material=material, large_nozzle=large_nozzle, l=l, w=w, end_holes=end_holes, peg_length=peg_length, bearing_sheath_thickness=bearing_sheath_thickness, skin=skin, block_height=block_height, axle_hole_tweak=axle_hole_tweak);
        }
    }
}


// A row of sheaths surrounding holes along the width
module end_connector_sheath_set(material=undef, large_nozzle=undef, l=undef, w=undef, end_holes=undef, peg_length=_peg_length, bearing_sheath_thickness=_bearing_sheath_thickness, skin=undef, block_height=undef, axle_hole_tweak=undef) {
    
    sheath_radius = bearing_sheath_thickness + override_axle_hole_radius(material=material, large_nozzle=large_nozzle, axle_hole_tweak=axle_hole_tweak);

    sheath_length = end_holes == 2 ? block_width(l) : block_width(1);

    if (w == 1) {
        translate([0, block_width(0.5), block_height(1)-block_width(0.5)]) {

            rotate([0, 90, 0]) {
                sheath(material=material, large_nozzle=large_nozzle, sheath_radius=sheath_radius, sheath_length=sheath_length, skin=skin);
            }
        }
    } else {
        for (j = [1:w-1]) {
            translate([0, block_width(j), block_height(1, block_height=block_height)-block_width(0.5)]) {
                rotate([0, 90, 0]) {
                    sheath(material=material, large_nozzle=large_nozzle, sheath_radius=sheath_radius, sheath_length=sheath_length, skin=skin);
                }
            }
        }
    }
}


// The solid cylinder around a bearing hole
module sheath(material=undef, large_nozzle=undef, sheath_radius=undef, sheath_length=undef, skin=undef) {

    translate([0, 0, skin]) {  
        cylinder(r=sheath_radius, h=sheath_length - 2*skin);
    }
}


// For use by extension routines
module double_end_connector_hole_set(material=undef, large_nozzle=undef, l=undef, w=undef, hole_type=undef, axle_hole_radius=undef, block_height=undef) {
 
    translate([block_width(l), 0, 0]) {
        rotate([0, 0, 90]) {
            double_side_connector_hole_set(material=material, large_nozzle=large_nozzle, l=w, w=l, hole_type=hole_type, block_height=block_height, axle_hole_radius=axle_hole_radius);
        }
    }
}


// For use by extension routines
module double_side_connector_hole_set(material=undef, large_nozzle=undef, l=undef, w=undef, hole_type=undef, block_height=undef, axle_hole_radius=undef) {
    
    side_connector_hole_set(material=material, large_nozzle=large_nozzle, l=l, w=w, hole_type=hole_type, block_height=block_height, axle_hole_radius=axle_hole_radius);
    
    translate([block_width(l), block_width(w)]) {

        rotate([0, 0, 180]) {
            side_connector_hole_set(material=material, large_nozzle=large_nozzle, l=l, w=w, hole_type=hole_type, block_height=block_height, axle_hole_radius=axle_hole_radius);
        }
    }
}


// A row of knob-size holes around the sides of row 1
module side_connector_hole_set(material=undef, large_nozzle=undef, l=undef, w=undef, hole_type=undef, block_height=undef, axle_hole_radius=undef) {
    
    length = hole_type == 2 ? block_width(w) : block_width(1);

    if (l == 1) {
        translate([block_width(0.5) - _defeather, 0, block_height(1, block_height=block_height)-block_width(0.5)]) {
            rotate([-90, 0, 0]) {
                axle_hole(material=material, large_nozzle=large_nozzle, hole_type=hole_type, radius=axle_hole_radius, length=length);
            }
        }        
    } else {
        for (i = [1:l-1]) {
            translate([block_width(i), -_defeather, block_height(1, block_height=block_height)-block_width(0.5)]) {
                rotate([-90, 0, 0]) {
                    axle_hole(material=material, large_nozzle=large_nozzle, hole_type=hole_type, radius=axle_hole_radius, length=length);
                }
            }
        }
    }
}


// Hole for an axle
module rotation_hole(material=undef, large_nozzle=undef, radius=undef, length=undef) {
    
    cylinder(r=radius, h=length, $fn=_axle_hole_fn);
}


// The rotation and connector hole for a technic connector
module axle_hole(material=undef, large_nozzle=undef, hole_type=undef, radius=undef, length=_counterbore_inset_depth+_peg_length) {
    
    rotation_hole(material=material, large_nozzle=large_nozzle, radius=radius, length=length);

    if (hole_type>1) {
        counterbore_inset(material=material, large_nozzle=large_nozzle, counterbore_inset_depth=_counterbore_inset_depth, counterbore_inset_radius=_counterbore_inset_radius);

        depth=2*(block_width()-length);
        inset_radius=_counterbore_inset_radius-_bearing_sheath_thickness/2;
            
        translate([0, 0, length]) {
            counterbore_inset(material=material, large_nozzle=large_nozzle, counterbore_inset_depth=depth, counterbore_inset_radius=inset_radius);
        }
    }
}


// The connector inset for a technic side connector
module counterbore_inset(material=undef, large_nozzle=undef, counterbore_inset_depth=_counterbore_inset_depth, counterbore_inset_radius=_counterbore_inset_radius) {
    
    translate([0, 0, -_defeather]) {
        cylinder(r=counterbore_inset_radius, h=counterbore_inset_depth + 2*_defeather);
    }
}


// A rectangle with optional 45 degree sloped roof for use as negative space with printable overhangs
module dome(dome=undef, length=undef, width=undef, thickness=undef) {
    assert(dome != undef);
    assert(length != undef);
    assert(width != undef);
    assert(thickness != undef);

    if (dome) {
        hull() {
            cube([length, width, thickness]);

            i = block_width(0.5);
            translate([i, i, 0]) {
                cube([length-2*i, width-2*i, 1.5*i]);
            }
        }
    } else {
        cube([length, width, thickness]);
    }
}
