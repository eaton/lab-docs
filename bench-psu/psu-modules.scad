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