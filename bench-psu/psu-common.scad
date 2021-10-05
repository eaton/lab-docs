/* Modular Bench PSU by Jeff Eaton - nerdhaus.net
 *
 * 0.1: 09-20-2021 Initial release.
 * 
 * The outer cases are based on yukiusagi3's parametric stackable box
 * (https://www.thingiverse.com/thing:3434161), which means it also
 * requires Oskar Linde's scad-utils library (available on github at
 * https://github.com/OskarLinde/scad-utils). It's a bit of a pain but
 * simplifies new module variants — actual parts bins, weighted bottom
 * components to prevent tipping, etc.
 *
 * This file includes shared geometry that's common across multiple
 * PSU modules, and helper code to generate placeholders and cutouts
 * for components like various jacks, boards, and so on. Actual layout
 * of each module is handled in the psu-modules.scad file; if you're
 * looking to make something custom its code is a good place to start.
 *
 * FYI, all parts and components from this file are assumed to be
 * "face up", centered on the X/Y axis. The zero point of each
 * object's Z axis should be "flush" with the surface of the case it
 * will be used with. That ensures alignment and boolean operations
 * don't need lots of special-casing.
 * 
 * The modules to generate components accept a "mode" parameter;
 * supported modes are 'cutout' for boolean operations with cases,
 * and 'placeholder' for generating previews of an assembled object.
 * Some objects also support 'mount' as a mode; it will spit out
 * screw stands or attatchment tabs, and should be added after the 
 * cutout version is subtracted from the surrounding case. 
 * 
 */
 
// Modes
CUTOUT = -1;
PLACEHOLDER = 0;
MOUNT = 1;
INCH = 25.4;

FUDGE_DISTANCE = .2;

/***** CORE BIN SHAPE *****/

include <scad-utils/mirror.scad>
include <scad-utils/morphology.scad>

$fn=30;

module binBase(binSize, style="slope", r=1) {
  basePoints = [
    [binSize.x/2, 0],
    [0, 0],
    [0, binSize.y/4],
    [3, binSize.y/4 + 3],
    [3, binSize.y/4 * 3 - 3],
    [0, binSize.y/4 * 3],
    [0, binSize.y/4 * 4],
    [0 + binSize.x/3 - 3, binSize.y/4 * 4],
    [0 + binSize.x/3, binSize.y/4 * 4 - 3],
    [binSize.x/2, binSize.y/4 * 4 - 3],
  ];

  pointsCentered = [for (p=basePoints)
    [
      p[0] - binSize.x/2,
      p[1] - binSize.y/2
    ]
  ];

  points = concat(
    pointsCentered,
    [for (p=pointsCentered) [p[0]*-1, p[1]] ]
  );

  rounding(r=r)
  polygon(points=points);
}

/* Parameters 2 */
WALL_THICK = 0.4*4;

HOLDER_Z_TOTAL = 10;
HOLDER_Z_JOINT = 3;
HOLDER_Z = HOLDER_Z_TOTAL - HOLDER_Z_JOINT;
HOLDER_DELTA = 0.8+0.4*4;
HOLDER_CLEARANCE = 0.4*2;

EDGE_BOTTOM = 0;
EDGE_TOP = 1;
DEG = 0;
LEN = 1;


module binBody(binSize=[80,110,47], frontStyle=[[30,20],[30,30]], mountPoints = false, floorGrating = false) {
  difference() {
    union() {
      // inner
      linear_extrude(height=binSize.z-HOLDER_Z_TOTAL, center=!true, convexity=10, twist=0)
      binBase(binSize=binSize);

      // joint
      translate([0, 0, binSize.z-HOLDER_Z])
      minkowski() {
        hull() {
          linear_extrude(height=0.01, center=!true)
          rounding(r=2-0.01)
          square(size=[HOLDER_DELTA*2, HOLDER_DELTA*2], center=true);
          translate([0, 0, -HOLDER_Z_JOINT])
          sphere(r=0.01);
        }

        linear_extrude(
          height=0.01,
          center=!true,
          convexity=10
        )
        binBase(binSize=binSize);
      }

      // holder
      translate([0, 0, binSize.z-HOLDER_Z])
      linear_extrude(height=HOLDER_Z, center=!true, convexity=10, twist=0)
      offset(r=HOLDER_DELTA)
      binBase(binSize=binSize);
    }

    // inner space
    difference() {
      translate([0, 0, 1])
      linear_extrude(height=binSize.z, center=!true, convexity=10, twist=0)
      offset(r=-WALL_THICK)
      binBase(binSize=binSize);

      // frontEdge
      frontEdge(binSize = binSize, frontStyle = frontStyle);
    }

    // holder inner space
    translate([0, 0, binSize.z-HOLDER_Z+1])
    linear_extrude(height=HOLDER_Z, center=!true, convexity=10, twist=0)
    offset(r=HOLDER_CLEARANCE)
    binBase(binSize=binSize);

    // front space
    translate([0, -binSize.y/2, binSize.z/2 + frontStyle[EDGE_BOTTOM][LEN] + 1])
    cube(size=[binSize.x-WALL_THICK*2, 10, binSize.z+1], center=true);

    // frontEdge
    translate([0, -1*sin(frontStyle[EDGE_BOTTOM][DEG]), -1*cos(frontStyle[EDGE_BOTTOM][DEG])])
    frontEdge(binSize = binSize, frontStyle = frontStyle);

    // frontEdgeTop
    translate([0, -1*sin(frontStyle[EDGE_TOP][DEG]), -1*cos(frontStyle[EDGE_TOP][DEG])])
    frontEdgeTop(binSize = binSize, frontStyle = frontStyle);
	
	// ventilation
	if (floorGrating) {
		linear_extrude(5, center=true) fillShadow() linear_extrude(3) binBase(binSize=binSize);
	}
	
	if (mountPoints) {
		for (y=[binSize.y/4 + 3, -binSize.y/4 - 3]) for (z=[binSize.z - WALL_THICK - 1.5, WALL_THICK + 1.25]) {
			translate([0,y,z]) rotate([0,90]) cylinder(d=3, h=binSize.x + 10, center=true);
			
			translate([0,binSize.y/2,z]) rotate([0,90,90]) cylinder(d=3, h=binSize.x + 10, center=true);
			
			// Screw notches for the lower holes
			for (x=[-binSize.x/2 + WALL_THICK*1.6, binSize.x/2 - WALL_THICK*1.6]) translate([x,y,0]) cube([2,4.5,4.5], center=true);
			translate([0,binSize.y/2 - 3 - WALL_THICK*1.6,0]) rotate([0,0,90]) cube([2,4.5,4.5], center=true);
		}
	}
  }
}


module binCap(binSize) {
  difference() {
    union() {
      // inner
      linear_extrude(height=binSize.z, center=!true, convexity=10, twist=0)
      binBase(binSize=binSize);
    }

    // inner space
    difference() {
      translate([0, 0, 1])
      linear_extrude(height=binSize.z, center=!true, convexity=10, twist=0)
      offset(r=-WALL_THICK)
      binBase(binSize=binSize);
    }
	
	z = WALL_THICK + 1.25;
	for (y=[binSize.y/4 + 3, -binSize.y/4 - 3]) {
		translate([0,y,z]) rotate([0,90]) cylinder(d=3, h=binSize.x + 10, center=true);

		translate([0,binSize.y/2,z]) rotate([0,90,90]) cylinder(d=3, h=binSize.x + 10, center=true);
		
		// Screw notches for the lower holes
		for (x=[-binSize.x/2 + WALL_THICK*1.6, binSize.x/2 - WALL_THICK*1.6]) translate([x,y,0]) cube([2,4.5,4.5], center=true);
		translate([0,binSize.y/2 - 3 - WALL_THICK*1.6,0]) rotate([0,0,90]) cube([2,4.5,4.5], center=true);
	}
	}
}

module frontEdge(binSize, frontStyle) {
        translate([0, -binSize.y/2, 0])
        rotate([frontStyle[EDGE_BOTTOM][DEG], 0, 0])
        cube(
            size=[
                binSize.x+10,
                frontStyle[EDGE_BOTTOM][LEN]*2*sin(frontStyle[EDGE_BOTTOM][DEG]),
                frontStyle[EDGE_BOTTOM][LEN]*2*cos(frontStyle[EDGE_BOTTOM][DEG])
            ],
            center=true
        );
}

module frontEdgeTop(binSize, frontStyle) {
    translate([0, -binSize.y/2, binSize.z])
    rotate([180-frontStyle[EDGE_TOP][DEG], 0, 0])
    cube(
        size=[
          binSize.x+10,
          frontStyle[EDGE_TOP][LEN]*2*sin(frontStyle[EDGE_TOP][DEG]),
          frontStyle[EDGE_TOP][LEN]*2*cos(frontStyle[EDGE_TOP][DEG])
        ],
        center=true
    );
}





/***** INDIVIDUAL COMPONENTS *****/

// 5.5mm x 2.1mm DC jacks. https://www.amazon.com/gp/product/B091PS6XQ4
module dcJack(mode = PLACEHOLDER) {
    if (mode == CUTOUT) {
        cylinder(d=10.6 + FUDGE_DISTANCE*2, h=10, center=true);
    } else if (mode == PLACEHOLDER) {
        color("silver") {
            rotate([0,180]) cylinder(d=10.6, h=14.85);
            difference() {
                cylinder(d=12.34, h=2.2);
                cylinder(d=5.5, h=10, center=true);
            }
            translate([0,0,-4]) cylinder(d=15, h=2, $fn=6);
        }
    }
}

// Case-mountable XT60 connectors. https://www.amazon.com/gp/product/B08HTR7BKZ
module xt60(mode = CUTOUT) {
    if (mode == CUTOUT) {
        linear_extrude(10, center=true) {
			offset(FUDGE_DISTANCE) {
				translate([2,0]) square([11.6, 8], center=true);
				translate([-4,0]) circle(d=8 + FUDGE_DISTANCE);
				for (x=[-.5,.5]) translate([20.46*x, 0]) circle(d=2.8);
			}
        }
    } else if (mode == PLACEHOLDER) {
        difference() {
            color("yellow") {
                translate([0,0,-11.75+3.25]) linear_extrude(11.75) {
                    translate([2,0]) square([11.6, 8], center=true);
                    translate([-4,0]) circle(d=8);
                }
                
                translate([0,0,-4]) linear_extrude(4) {
                    offset(2) offset(-2) square([27.2,8], center=true);
                }

                translate([0,0,-1]) linear_extrude(1) {
                    offset(2, $fn=6) offset(-2) square([20.84,12], center=true);
                }
            }
            
            for (x=[-.5,.5]) translate([20.46*x, 0]) cylinder(d=2.8, h=10, center=true); // screw holes

        }
    }
}

// Screw-in fuse. https://www.amazon.com/gp/product/B07BVP8W16
module fuse(mode = CUTOUT) {
    if (mode == CUTOUT) {
        cylinder(d=11.6 + FUDGE_DISTANCE*2, h=10, center=true);
    } else if (mode == PLACEHOLDER) {
        color("black") {
            rotate([0,180]) {
                cylinder(d=11.6, h=8.5);
                cylinder(d=8, h=20.5);
            }
            
            cylinder(d=14.85, h=4.25);
            translate([0,0,4.25]) cylinder(d1=11.75, d2=10.75, h=7);
        }
        color("lightgrey") translate([0,0,-2]) cylinder(d=15.6, h=2);
        color("silver") translate([0,0,-4]) cylinder(d=15.6, h=2, $fn=6);

    }
}

// Heavy toggle switch. https://www.amazon.com/gp/product/B09232WFXS
module switch(mode = CUTOUT) {
    if (mode == CUTOUT) {
        cylinder(d=20 + FUDGE_DISTANCE*2, h=10, center=true);
        translate([10,0,0]) cube([2 + FUDGE_DISTANCE*2,2 + FUDGE_DISTANCE*2,10], center=true);
    } else if (mode == PLACEHOLDER) {
        color("black") {
            rotate([0,180]) {
                cylinder(d=20, h=5);
                linear_extrude(15.2) offset(3) offset(-3) square([12,18.2], center=true);
            }
            cylinder(d=23, h=2);
            cylinder(d=21, h=10);

            translate([0,0,3]) {
                cylinder(d=25, h=3.5);
                translate([0,0,4.5]) {
                    cylinder(d=24, h=1);
                    translate([0,0,2]) {
                        cylinder(d=23, h=1);
                    }
                }
            }
        }
        color("red") cylinder(d=20, h=11.1);
    }
}

// Digital volt/amp meter. https://www.amazon.com/gp/product/B08HQM1RMF
module multiMeter(mode = CUTOUT) {
    if (mode == CUTOUT) {
        cube([45.5 + FUDGE_DISTANCE*2,26 + FUDGE_DISTANCE*2,15 + FUDGE_DISTANCE*2], center=true);
        cube([22 + FUDGE_DISTANCE*2, 28 + FUDGE_DISTANCE*2, 15 + FUDGE_DISTANCE*2], center=true);
    } else if (mode == PLACEHOLDER) {
        color("black") {
            translate([0,0,-15]) linear_extrude(15) square([45.5,26], center=true);
            linear_extrude(2.6) square([47.8,28.8], center=true);
        }
        color("silver") linear_extrude(2.7) square([35.8,18], center=true);

    }
}

// Banana plug connectors. https://www.amazon.com/gp/product/B07VFRBRBT
module bananaPlugs(mode = CUTOUT) {
    if (mode == CUTOUT) {
        for (x=[-1,1]) 
            translate([(4.8 + 14.6)/2 * x,0])
                cylinder(d=5 + FUDGE_DISTANCE*2, h=10, center=true);
    } else if (mode == PLACEHOLDER) {
        for (x=[-1,1]) translate([(4.8 + 14.6)/2 * x, 0]) {
            color("silver") {
                translate([0,0, -19.5]) cylinder(d=4, h=29.5); // Screws
                translate([0,0,-7.8]) cylinder(h=2.8, d=9, $fn=6); // Hex nuts
                translate([0,0,-10.8]) rotate(15) cylinder(h=2.8, d=9, $fn=6); // Hex nuts
            }
            color(c = x==1 ? "red" : "black") {
                translate([0,0,5]) cylinder(d=14.9, h=6.4);
                difference() {
                    translate([0,0,5]) cylinder(d=14.9, h=15.5, $fn=6);
                    translate([0,0,15]) cylinder(d=4, h=6);
                }
            }
        }
        color("black") for (z=[.2, -5]) translate([0,0,z]) {
            linear_extrude(4.9) offset(7.49) offset(-7.49) square([34,15], center=true);
        }

   }
}

// Male JST connectors. https://www.amazon.com/gp/product/B00UBUSR5Y
module jstMale(mode = MOUNT) {
    if (mode == MOUNT) {
        for (x=[-.5, .5]) {
            translate([22.25 * x, 2.54/2, -2.2]) cylinder(d=6, h=5, center=true);
        }
		hull() {
			translate([0,0,-2.2]) cube([25.4,12,5], center=true);
			translate([5,0,.2]) cube([30.4,12,.2], center=true);
		}
    } else if (mode == CUTOUT) {
        for (x=[-.5, .5]) {
            translate([22.25 * x, 2.54/2]) cylinder(d=2.8, h=15, center=true);
            translate([10.25*x,0,-2.2]) cube([8.35, 9.95,10], center=true);
        }
    } else if (mode == PLACEHOLDER) {
        translate([0,0,-10])  {
            color("darkgreen") difference() {
                translate([0,0,4]) linear_extrude(1.2) square([30, 12], center=true);
                for (x=[-.5, .5]) {
                    translate([22.25 * x, 2.54/2]) cylinder(d=2.8, h=10);
                }
            }
            color("white") translate([0,0,9]) {
                for (x = [-.5,.5]) {
                    translate([10.5*x, 0]) {
                        difference() {
                            cube([5.75, 7.55, 7], center=true);
                            translate([2,0,3]) cube([.8, 10, 7], center=true);
                            translate([2,0,3]) cube([2, 3.65, 7], center=true);
                            translate([0,0,1]) cube([5, 6.85, 7], center=true);
                        }
                        color("silver") for (y=[-.5,.5]) {
                            translate([0, 2.54*y, -3]) cylinder(d=.6, h=9, center=true);
                        }
                    }
                }
            }
        }
    }
}

// Programmable bench PSU converter. https://www.amazon.com/gp/product/B07PV6FJSL
module benchPSU(mode = MOUNT) {
    if (mode == MOUNT) {
        for (x=[-.5, .5]) for (y=[-.5,.5]) {
            translate([86.25 * x, 63.8 * y]) screwRiser(d=3, h=6.5);
        }
    } else if (mode == PLACEHOLDER) {
        color("darkgreen") difference() {
            translate([0,0,7.5]) linear_extrude(1.6) square([93.5, 73.25], center=true);
            for (x=[-.5, .5]) for (y=[-.5,.5]) {
                translate([86.25 * x, 63.8 * y]) cylinder(d=3.2, h=20);
            }
        }
        color("white") translate([0,0,7.5]) linear_extrude(7.5) {
            translate([24,32]) square([22.5, 5.7], center=true);
            translate([-24,32]) square([22.5, 5.7], center=true);
        }
        color("black") translate([-0, -20, 12.5 + 7.5]) cube([30,30,25], center=true);
    }
}

// Programmable bench PSU converter. https://www.amazon.com/gp/product/B07PV6FJSL
module benchPSUPort(mode = CUTOUT) {
    if (mode == MOUNT) {
        difference() {
			translate([10,0,-5]) cube([20,25,16], center=true);
			translate([6,0,2]) cube([8,19.5,4.2], center=true);
			translate([18,0,0]) linear_extrude(5) square([30, 19], center=true);
			for (y=[-7,7]) translate([4.5,y,-3]) cylinder(d=2.6, h=20, center=true);
			translate([15,0,-16]) rotate([0,-30]) cube([30,26,20], center=true);
		}

    } else if (mode == CUTOUT) {
		translate([0,0,3]) cube([10,10,6], center=true);
    } else if (mode == PLACEHOLDER) {
		translate([18,0]) {
			difference() {
				color("darkgreen") linear_extrude(1.6) square([30, 19], center=true);
				for (y=[-7,7]) translate([-12.5,y]) cylinder(d=2.6, h=10, center=true);
			}
			color("white") translate([9,-5,3.25]) cube([3.5, 6.5, 6.5], center=true);
			color("silver") translate([-12, 0, 3]) cube([7.5,5.5,2.5], center=true);
		}
    }
}

// Programmable bench PSU converter. https://www.amazon.com/gp/product/B07PV6FJSL
module benchPSUControl(mode = CUTOUT) {
    if (mode == CUTOUT) {
        cube([71.6 + FUDGE_DISTANCE*2,39.5 + FUDGE_DISTANCE*2,25.5 + FUDGE_DISTANCE*2], center=true);
        cube([76 + FUDGE_DISTANCE*2,12 + FUDGE_DISTANCE*2,25.5 + FUDGE_DISTANCE*2], center=true);
    } else if (mode == PLACEHOLDER) {
        color("darkgrey") {
            translate([0,0,-25.5]) linear_extrude(25.5) square([71.6,39.5], center=true);
            linear_extrude(2.1) square([79.38,43.2], center=true);
        }
        color("silver") {
            translate([-5,0]) linear_extrude(2.2) square([27.6,27.2], center=true);
            translate([25,3]) cylinder(d=13,h=11);
        }

    }
}




// Quickcharge compatible USB converters. https://www.amazon.com/gp/product/B087RHWTJW
module usbPort(mode = CUTOUT) {
    if (mode == CUTOUT) {
        cube([13.2 + FUDGE_DISTANCE,5.8 + FUDGE_DISTANCE,10 + FUDGE_DISTANCE], center=true);
    } else if (mode == MOUNT) {
        // Something that wraps around the port? Slide rails for the boards?
		difference() {
			union() {
				hull() {
					translate([0,-13,0]) linear_extrude(1) square([10,1.6], center=true);
					translate([0,-4.6,-12]) linear_extrude(12) square([20,3], center=true);
				}
				hull() {
					translate([0,-13,0]) linear_extrude(1) square([4,1.6], center=true);
					translate([0,-4.6,-36.5]) linear_extrude(34.5) square([4,6], center=true);
				}
			}
			translate([0,-3.25,-34.5]) linear_extrude(35) square([17.2,3.8], center=true);
		}
		translate([0,-1.5,-35]) rotate([0,90,0]) cylinder(h=4, d=2.75, center=true, $fn=6);
    } else if (mode == PLACEHOLDER) {
        color("silver") translate([0,0,-9]) linear_extrude(10) offset(.5) offset(-.5) square([13.2,5.8], center=true);
        color("darkgreen") translate([0,-4,-34]) linear_extrude(34) square([17,1.6], center=true);
    }
}

// testShape();

// Micro USB breakout board. https://www.amazon.com/gp/product/B07W6T97HZ
module usbMicroPort(mode = CUTOUT) {
    if (mode == CUTOUT) {
        cube([10 + FUDGE_DISTANCE,5 + FUDGE_DISTANCE,10 + FUDGE_DISTANCE], center=true);
    } else if (mode == MOUNT) {
        // Something that wraps around the port? Slide rails for the boards?
		difference() {
			hull() {
				translate([0,-12,0]) linear_extrude(2) square([12.8,1.6], center=true);
				translate([0,-3.9,-14.2]) linear_extrude(14.2) square([12.8,1.6], center=true);
			}
			translate([-4.7, -4, -6.2]) rotate([90,0]) cylinder(d=3, h=12, center=true);
			translate([4.7, -4, -6.2]) rotate([90,0]) cylinder(d=3, h=12, center=true);
		}
    } else if (mode == PLACEHOLDER) {
        color("silver") translate([0,0,-4.7]) linear_extrude(5.7) offset(.5) offset(-.5) square([7.5,2.75], center=true);
        color("darkgreen") difference() {
			translate([0,-2.3,-14.2]) linear_extrude(14.2) square([12.8,1.6], center=true);
			translate([-4.7, -4, -6.2]) rotate([90,0]) cylinder(d=3, h=6, center=true);
			translate([4.7, -4, -6.2]) rotate([90,0]) cylinder(d=3, h=6, center=true);
		}
    }
}

// USB-C breakout board. https://www.amazon.com/gp/product/B096M2HQLK
module usbCPort(mode = CUTOUT) {
    if (mode == CUTOUT) {
        cube([10 + FUDGE_DISTANCE,5 + FUDGE_DISTANCE,10 + FUDGE_DISTANCE], center=true);
    } else if (mode == MOUNT) {
        // Something that wraps around the port? Slide rails for the boards?
		difference() {
			hull() {
				translate([0,-12,0]) linear_extrude(2) square([INCH * .85,1.6], center=true);
				translate([0,-3.9,-INCH * .5]) linear_extrude(INCH * .5) square([INCH * .85,1.6], center=true);
			}
			translate([-INCH * .325, -5, -2.3]) rotate([90,0]) cylinder(d=3, h=20, center=true);
			translate([INCH * .325, -5, -2.3]) rotate([90,0]) cylinder(d=3, h=20, center=true);
		}
    } else if (mode == PLACEHOLDER) {
        color("silver") translate([0,0,-6.5]) linear_extrude(7.5) offset(.5) offset(-.5) square([8.9,3.27], center=true);
        color("darkgreen") difference() {
			translate([0,-2.5,-(INCH * .5)]) linear_extrude(INCH * .5) square([INCH * .85,1.6], center=true);
			translate([-INCH * .325, -5, -2.3]) rotate([90,0]) cylinder(d=3, h=10, center=true);
			translate([INCH * .325, -5, -2.3]) rotate([90,0]) cylinder(d=3, h=10, center=true);
		}
    }
}


// ATX breakout board. https://www.amazon.com/gp/product/B08MC389FQ
module atxBreakout(mode = MOUNT) {
    if (mode == MOUNT) {
        for (x=[-.5, .5]) for (y=[-.5, .5]) {
            translate([81.25 * x, 62.34 * y]) screwRiser(d=3.2, h=6);
        }
    } else if (mode == PLACEHOLDER) {
        color("darkgreen") difference() {
            translate([0,0,6]) linear_extrude(1.6) offset(2) offset(-2) square([87.75, 68.84], center=true);
            for (x=[-.5, .5]) for (y=[-.5, .5]) {
                translate([81.25 * x, 62.34 * y]) cylinder(d=3.2, h=10);
            }
        }
        
        color("skyblue") translate([0,0,6]) linear_extrude(13) {
            translate([-6.5,21]) square([61, 12.1], center=true);
            translate([-6.5,-21]) square([61, 12.1], center=true);
        }
        
        color("white") translate([0,0,6]) linear_extrude(10.7) {
            translate([-5.5,0]) square([51.2, 10], center=true);
        }
    }
}

// DC screw terminal block. https://www.amazon.com/gp/product/B08TBXQ7H6
module terminalBlock(mode = MOUNT, draftDirection = 0) {
    if (mode == MOUNT) {
        for (x=[-.5, .5]) {
            translate([89.6 * x, 0]) screwRiser(d=2.8, h=10, draftDirection=draftDirection);
        }
    } else if (mode == PLACEHOLDER) {
        color("darkgreen") difference() {
            translate([0,0,10]) linear_extrude(1.6) square([97, 22.12], center=true);
            for (x=[-.5,.5]) translate([89.6 * x, 0]) cylinder(d=3.2, h=15);
        }
        color("lightgreen") translate([0,0,10]) linear_extrude(15.5) {
            translate([0,6]) square([60.3, 10.11], center=true);
            translate([0,-6]) square([60.3, 10.11], center=true);
            translate([-36.8,0]) square([10.11, 15.6], center=true);
            translate([36.8,0]) square([10.11, 15.6], center=true);
        }
    }
}

module dcConverter(mode=MOUNT, draftDirection = 0) {
    if (mode == MOUNT) {
		translate([53.5/2 - 10,-12+2.7]) screwRiser(h=5, draftDirection = draftDirection);
		translate([-53.5/2 + 10,12-2.7]) screwRiser(h=5, draftDirection = draftDirection);
    } else if (mode == PLACEHOLDER) {
		color("darkblue")  difference() {
			linear_extrude(1.6) square([53.5, 24], center=true);
			translate([53.5/2 - 10,-12+2.7]) cylinder(d=3.6, h=5, center=true);
			translate([-53.5/2 + 10,12-2.7]) cylinder(d=3.6, h=5, center=true);
		}
		color("silver") for (x=[-53.5/2 + 6,53.5/2 - 6]) translate([x,0,1.6]) cylinder(d=10, h=10);
		color("blue") translate([3,-12+3,9.5/2 + 1.6]) cube([9.5, 4.5, 9.5], center=true);
		color("gold") translate([-9,-1,8]) rotate([-90,0,0]) cylinder(d=12, h=5.75, center=true);
	}
}

module screwRiser(d=3.2, h=5, draftDirection = 0) {
    difference() {
		hull() {
			cylinder(d1=d+8, d2=d+4, h=h);
			
			if (draftDirection==1) translate([h,0,0]) cylinder(d=2, h=1);
			else if (draftDirection==2) translate([0,h,0]) cylinder(d=2, h=1);
			else if (draftDirection==3) translate([-h,0,0]) cylinder(d=2, h=1);
			else if (draftDirection==4) translate([0,-h,0]) cylinder(d=2, h=1);
		}
        cylinder(d=d, h=h*2+20, center=true);
    }
}

module studRiser(d=3, h=10) {
	cylinder(d=d, h=h);
	cylinder(d1=d*4, h=d*2);
}

/* Takes a 3D object, casts a shadow of it, and cuts vent lines in the shadow. */
module fillShadow() {
    minkowski() {
        difference() {
            offset(-10) projection() children();
            for (x = [-200 : 10 : 200]) {
                translate([x,0,0]) rotate(45) square([5 ,2000], center=true);
            }
        }
        circle(d=2, $fn = 5*6);
    }
}



/* Scratchpad function for testing sub-modules */

module testShape() {
	difference() {
		translate([0,-1,0]) cube([60,2,60], center=true);
		rotate([90,0,0]) {
			translate([-20,0]) usbPort(mode=CUTOUT);
			translate([0,0]) usbMicroPort(mode=CUTOUT);
			translate([20,0]) usbCPort(mode=CUTOUT);
		}
	}

	rotate([90,0,0]) {
		translate([-20,0]) usbPort(mode=MOUNT);
		translate([0,0]) usbMicroPort(mode=MOUNT);
		translate([20,0]) usbCPort(mode=MOUNT);
	}

	rotate([90,0,0]) {
		translate([-20,0]) usbPort(mode=PLACEHOLDER);
		translate([0,0]) usbMicroPort(mode=PLACEHOLDER);
		translate([20,0]) usbCPort(mode=PLACEHOLDER);
	}
}