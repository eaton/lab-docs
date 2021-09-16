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
 */