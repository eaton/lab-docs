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

/***** MODIFIED BINS *****/



/***** INDIVIDUAL COMPONENTS *****/

// 5.5mm x 2.1mm DC jacks. https://www.amazon.com/gp/product/B091PS6XQ4
module dcJack(mode = CUTOUT) {
}

// Case-mountable XT60 connectors. https://www.amazon.com/gp/product/B08HTR7BKZ
module xt60(mode = CUTOUT) {
}

// Screw-in fuse. https://www.amazon.com/gp/product/B07BVP8W16
module fuse(mode = CUTOUT) {
}

// Heavy toggle switch. https://www.amazon.com/gp/product/B09232WFXS
module fuse(mode = CUTOUT) {
}

// Digital volt/amp meter. https://www.amazon.com/gp/product/B08HQM1RMF
module multiMeter(mode = CUTOUT) {
}

// Banana plug connectors. https://www.amazon.com/gp/product/B07VFRBRBT
module bananaPlugs(mode = CUTOUT) {
}

// Male JST connectors. https://www.amazon.com/gp/product/B00UBUSR5Y
module jstMale(mode = CUTOUT) {
}

// Programmable bench PSU converter. https://www.amazon.com/gp/product/B07PV6FJSL
module benchPSU(mode = CUTOUT) {
}

// Quickcharge compatible USB converters. https://www.amazon.com/gp/product/B087RHWTJW
module usbPort(mode = CUTOUT) {
}

// ATX breakout board. https://www.amazon.com/gp/product/B08MC389FQ
module atxBreakout(mode = CUTOUT) {
}

// DC screw terminal block. https://www.amazon.com/gp/product/B08TBXQ7H6
module terminalBlock(mode = CUTOUT) {
}