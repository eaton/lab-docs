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

handleModule();

module handleModule(buildHandles = false, addFan = false) {
	difference() {
		union() {
			binCap(binSize=[140,120,7.5]);
			if (addFan) {
			}
			
			if (buildHandles) {
			}
		}
		
		if (addFan) {
		}
		
		if (buildHandles) {
		}
	}
}

module footModule() {
	translate([0,55]) binBody(binSize=[140,120,25], frontStyle=[[0,50],[0,0]], mountPoints = true);
}

module holderModule() {
	translate([0,55]) binBody(binSize=[140,120,40], frontStyle=[[0,10],[30,30]], mountPoints = true);
	for (x=[-45,-15,15,45]) {
		hull() {
			translate([x,55]) linear_extrude(10) square([1.2,120], center=true);
			translate([x,80]) linear_extrude(30) square([1.2,60], center=true);
		}
	}
}

module usbModule() {
    difference() {
        union() {
            translate([0,55]) binBody(binSize=[140,120,45], frontStyle=[[0,45],[0,0]], mountPoints = true, floorGrating = true);
            translate([10,95]) rotate([0,0,0]) { terminalBlock(mode=MOUNT); } // terminalBlock(mode=PLACEHOLDER); }

			translate([7.5,-3.25,20]) rotate([90,0,0]) {
				translate([7.5,-1]) {
					for (x=[-1,1]) for (y=[-1,1]) {
						translate([10*x,8.5*y]) usbPort(mode=MOUNT);
					}
				}
				translate([-45,0]) multiMeter(mode=MOUNT);
				
				translate([42,7.5,-.75]) usbMicroPort(mode=MOUNT);
				translate([42,-9.5,0]) usbCPort(mode=MOUNT);
			}

			translate([66,55,20]) rotate([270,0,90]) { dcConverter(mode=MOUNT); } // translate([0,0,5]) dcConverter(mode=PLACEHOLDER); }
        }
        standardHoles();
		
		translate([7.5,-5,20]) rotate([90,0,0]) {
			translate([7.5,-1]) {
				for (x=[-1,1]) for (y=[-1,1]) {
					translate([10*x,8.5*y]) usbPort(mode=CUTOUT);
				}
			}
			translate([-45,0]) multiMeter(mode=CUTOUT);

			translate([42,7.5,0]) usbMicroPort(mode=CUTOUT);
			translate([42,-9.5,0])usbCPort(mode=CUTOUT);
		}
		translate([0,0,-5]) linear_extrude(5) square([400,400], center=true);
		translate([0,-5,0]) rotate([90,0,0]) linear_extrude(2) square([200,40], center=true);
    }
}



module variableModule() {
    difference() {
        union() {
            translate([0,55]) binBody(binSize=[140,120,60], frontStyle=[[0,60],[0,0]], mountPoints = true, floorGrating=true);
			translate([0,70,0]) benchPSU();
            translate([70,60,30]) rotate([90,0,-90]) terminalBlock(mode=MOUNT, draftDirection=4);
			translate([7.5,-5,20]) rotate([90,0,0]) {
				translate([49.5,5,-1]) rotate([0,0,-90]) jstMale(mode=MOUNT);
			}
			translate([-67,55,40]) benchPSUPort(mode=MOUNT);
        }
		// Nuke the fuse from this one, we'll put it on the PSU side since it's single-source.
		// translate([-65,40,35]) rotate([90,0,-90]) fuse(mode=CUTOUT);
		translate([-48,115,40]) rotate([90,0,180]) xt60(mode=CUTOUT);
		translate([-66,55,40]) benchPSUPort(mode=CUTOUT);
	
		translate([7.5,-5,20]) rotate([90,0,0]) {
			translate([45,0]) {
				translate([-12,14]) dcJack(CUTOUT);
				translate([-12,-2]) dcJack(CUTOUT);
				translate([4.5,5,-1]) rotate([0,0,-90]) jstMale(mode=CUTOUT);
			}
			translate([-35,8]) benchPSUControl(mode=CUTOUT);
			translate([15,6]) rotate([0,0,90]) bananaPlugs(mode=CUTOUT);
		}
    }
}

module fixedModule() {
    difference() {
        union() {
            translate([0,55]) binBody(binSize=[140,120,52], frontStyle=[[0,52],[0,0]], mountPoints = true, floorGrating=true);
            translate([15,65]) rotate([0,0,-45]) terminalBlock(mode=MOUNT);

			translate([7.5,-5,20]) rotate([90,0,0]) {
				translate([48.5,2,-1]) rotate([0,0,-90]) jstMale(mode=MOUNT);
			}
        }
        translate([0,0,2]) standardHoles();
		
		translate([7.5,-5,20]) rotate([90,0,0]) {
			translate([45,0]) {
				translate([-15,10]) dcJack(mode=CUTOUT);
				translate([-15,-6]) dcJack(mode=CUTOUT);
				translate([3.5,2,-1]) rotate([0,0,-90]) jstMale(mode=CUTOUT);
			}
			translate([-45,2]) multiMeter(mode=CUTOUT);
			translate([2,10]) bananaPlugs(mode=CUTOUT);
			translate([2,-6]) bananaPlugs(mode=CUTOUT);
		}
    }
}

module standardHoles() {
	translate([-65,65,20]) rotate([90,180,-90]) switch(mode=CUTOUT);
	translate([-65,40,20]) rotate([90,0,-90]) fuse(mode=CUTOUT);
	translate([-48,115,20]) rotate([90,0,180]) xt60(mode=CUTOUT);
}