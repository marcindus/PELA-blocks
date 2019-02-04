/*
PELA Blocks 3D Print Calibration Block Set

Published at https://PELAblocks.org

By Paul Houghton
Twitter: @mobile_rat
Email: paulirotta@gmail.com
Blog: https://medium.com/@paulhoughton

Creative Commons Attribution-ShareAlike 4.0 International License
    https://creativecommons.org/licenses/by-sa/4.0/legalcode

Open source design, Powered By Futurice. Come work with the best.
    https://www.futurice.com/
*/

include <../style.scad>
include <../print-parameters.scad>
use <../PELA-technic-block.scad>
use <../PELA-block.scad>
include <PELA-calibration-set.scad>


/* [PELA Calibration Set Options] */

flexible_material = true;

large_nozzle = false;


///////////////////////////////
// DISPLAY
///////////////////////////////

PELA_calibration_set(material=material, large_nozzle=large_nozzle, large_nozzle=large_nozzle);
