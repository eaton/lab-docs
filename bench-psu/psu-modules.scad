/* Modular Bench PSU by Jeff Eaton - nerdhaus.net
 *
 * 0.1: 09-20-2021 Initial release.
 * 
 * This file (psu-modules.scad) includes designs for several components:
 *
 * - Fixed-voltage module (case and cover):
 * - Variable voltage module (case and cover):
 * - USB module (case and cover):
 * - Wire storage module
 * - No-Tip base
 * - Combined ATX / MeanWell 24V PSU box
 * 
 * The designs assume that your actual PSU bricks are housed elsewhere,
 * probably under a table, while these stackable modules just take power
 * from the PSU via vanilla 14AGW lamp wire with an XT60 connector.
 *
 * The heavy lifting for the shared geometry is in psu-common.scad; check
 * it out for dependencies and other fun.
 * 
 */
 
include <psu-common.scad>;

fixedVoltageModule();


module fixedVoltageModule(mode = "preview") {
    difference() {
        union() {
            translate([0,55]) binBody(binSize=[140,120,50], mountPoints = true);
            translate([10,85,1.2]) terminalBlock(mode=MOUNT);
        }
        translate([-65,65,15]) rotate([90,0,-90]) switch(mode=CUTOUT);
        translate([-65,40,15]) rotate([90,0,-90]) fuse(mode=CUTOUT);
        translate([-48,115,15]) rotate([90,0,180]) xt60(mode=CUTOUT);
    }

    /*
	union() {
        translate([10,85,1.2]) terminalBlock(mode=PLACEHOLDER);
        translate([7.5,3,30]) rotate([60,0]) examplePanel();
        translate([-65,65,15]) rotate([90,0,-90]) switch(mode=PLACEHOLDER);
        translate([-65,40,15]) rotate([90,0,-90]) fuse(mode=PLACEHOLDER);
        translate([-48,115,15]) rotate([90,0,180]) xt60(mode=PLACEHOLDER);
    }
	*/
}

module examplePanel() {
    translate([45,0]) {
        translate([-15,8]) dcJack(PLACEHOLDER);
        translate([-15,-8]) dcJack(PLACEHOLDER);
        translate([2.5,0,-1]) rotate([0,0,-90]) jstMale(mode=PLACEHOLDER);
    }
    
    translate([-0,0]) {
        translate([-45,0]) multiMeter(mode=PLACEHOLDER);
        translate([-0,9]) bananaPlugs(mode=PLACEHOLDER);
        translate([-0,-9]) bananaPlugs(mode=PLACEHOLDER);
    }
}
