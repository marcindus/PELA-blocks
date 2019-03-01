/*
PELA HTC Vive Tracker Mount Screw

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

include <../style.scad>
include <../material.scad>
use <../PELA-block.scad>
use <../PELA-technic-block.scad>
use <../threads/threads.scad>



/* [Camera Mount Screw] */

// Show the inside structure [mm]
cut_line = 0; // [0:1:100]

// Printing material (set to select calibrated knob, socket and axle hole fit)
material = 0; // [0:PLA, 1:ABS, 2:PET, 3:Biofila Silk, 4:Pro1, 5:NGEN, 6:NGEN FLEX, 7:Bridge Nylon, 8:TPU95, 9:TPU85/NinjaFlex]

// Is the printer nozzle >= 0.5mm? If so, some features are enlarged to make printing easier
large_nozzle = true;

// Screwhole border
thumbscrew_border_d=11;

// Thumbscrew cut for finger tension [mm]
cut = 0.8;

// Thumbscrew turns per inch
tpi = 20;

// Thumbscrew head height [mm]
height = 0.5*panel_height(block_height=block_height) - skin;

// Thumscrew diameter of shaft [inches]
dInch=1/4;

// Thumbscrew total height [inches]
hInch=1/4;



///////////////////////////////
// DISPLAY
///////////////////////////////

thumbscrew(material=material, large_nozzle=large_nozzle, cut_line=cut_line,thumbscrew_border_d=thumbscrew_border_d, cut=cut, tpi=tpi, height=height, dInch=dInch, hInch=hInch);



///////////////////////////////////
// MODULES
///////////////////////////////////

module thumbscrew(material=material, large_nozzle=large_nozzle, cut_line=cut_line,thumbscrew_border_d=thumbscrew_border_d, cut=cut, tpi=tpi, height=height, dInch=dInch, hInch=hInch) {

    difference() {
        union() {
            translate([0, 0, height]) {
                us_bolt_thread(dInch=dInch, hInch=hInch, tpi=tpi);
            }

            thumbscrew_head(material=material, large_nozzle=large_nozzle, height=height);
        }

        translate([-thumbscrew_border_d/2, -thumbscrew_border_d/2, 0]) {
            cut_space(material=material, large_nozzle=large_nozzle, l=2, cut_line=cut_line, h=2, block_height=block_height, knob_height=knob_height);
        }
    }
}


module thumbscrew_head(material=material, large_nozzle=large_nozzle, height=height) {
    cylinder(d=thumbscrew_border_d/2, h=height);

    difference() {
        difference() {
            cylinder(d=thumbscrew_border_d-0.2, h=height);
            translate([-cut/2, 0, 0]) {
                cube([cut, thumbscrew_border_d, cut]);
            }            
        }

        union() {
            for (i = [30:30:360]) {
                rotate([0, 0, i]) {
                    translate([-cut/2, 0, -defeather]) {
                        cube([cut, thumbscrew_border_d, cut]);
                    }
                }
            }
        }
    }
}
