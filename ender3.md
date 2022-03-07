# 3D Printer Setup
Currently running an [Ender 3](https://www.creality3dofficial.com/products/official-creality-ender-3-3d-printer) and an [Ender 3 Max](https://www.creality3dofficial.com/products/ender-3-max-3d-printer) with a variety of mods and firmware changes. The tweaks never end.

## Standardized Mods
- [Silicone hot end sleeve](https://www.amazon.com/dp/B083GXQ7L8) (Standard for the Ender 3 Max, aftermarket for the Ender 3.)
- [Glass print bed](https://www.amazon.com/gp/product/B07FSM8DK9) (Standard for the Ender 3 Max, aftermarket for the Ender 3.)
- [Aluminium extruder](https://www.amazon.com/gp/product/B07G2ZM919) (Standard for the Ender 3 Max, aftermarket for the Ender 3.)
- [Silicone bed spring replacements](https://www.aliexpress.com/item/4001034984008.html) make leveling a bit less fussy. May replace them with solid spacers eventually.
- X and Y [belt tensioners](https://www.amazon.com/gp/product/B087YWMHM2)
- Three point leveling carriage ([Ender 3](https://www.amazon.com/gp/product/B082ZZ9LSV), [Ender 3 Max](https://www.amazon.com/gp/product/B082ZZK3T8))
- HICTOP Dual Z-Axis upgrade ([Ender 3](https://www.amazon.com/gp/product/B08T1VJ9ZT), [Ender 3 Max](https://www.amazon.com/gp/product/B07529LXTQ))
- [CR Touch](https://www.creality3dofficial.com/products/creality-cr-touch) bed leveling probe
- [Filament runout sensor](https://www.amazon.com/gp/product/B099ZT1KNY) (Standard for the Ender 3 Max, aftermarket for the Ender 3.)
- [32-bit 4.2.7 mainboard](https://creality3d.shop/products/creality3d-upgrade-silent-4-2-7-1-1-5-mainboard-for-ender-3-ender-3-pro-ender-5-3d-printer?variant=36836286038166); this is the one with silent steppers and a bootloader to make flashing new versions of the firmware much simpler. Both have the 512k ARM STM32F103-RET6 chip, newer revs of the board may be switching to a cheaper 256k version of the chip.
- [Meanwell power supply](https://www.amazon.com/gp/product/B013ETVO12) w/[Noctua 80mm fan](https://www.amazon.com/gp/product/B00KF7T9MI)

## Octoprint Controller
- Dual 60mm fans to cool Pi and printer board
- Relay to control printer power from Pi (https://www.amazon.com/gp/product/B07TWH7DZ1)
- IR PiCam for print monitoring (even when the lights in the basement are off)

## [Customized Firmware](https://github.com/nerdhaus/Marlin)
I try to keep both printers in sync with the bugfix branch of Marlin, and have branched config files for the two models that keeps their features in sync while accounting for bed size and other differences. ([Ender 3](https://github.com/nerdhaus/Marlin/commits/nerdhaus-ender-3/Marlin), [Ender 3 Max](https://github.com/nerdhaus/Marlin/commits/nerdhaus-ender-3-max/Marlin)). 
- Noteworthy features that have been enabled:
  - [G2/G3 Arc support](https://marlinfw.org/docs/gcode/G002-G003.html) for smoother curves
  - [Filament runout detection](https://marlinfw.org/docs/gcode/M412.html) to support Creality's standard filament sensor
  - [Probe offset wizard](https://marlinfw.org/docs/gcode/M851.html) to configure the CR Touch
  - [Unified bed leveling](https://marlinfw.org/docs/gcode/G029-ubl.html) for the Ender 3 Max, and [three point leveling](https://marlinfw.org/docs/gcode/G029-abl-3point.html) for the Ender 3. Working on figuring out why the E3 [chokes when building a full mesh](https://github.com/MarlinFirmware/Marlin/issues/23842).
  - [Assisted tramming](https://marlinfw.org/docs/gcode/G035.html)
  - [Babystepping](https://marlinfw.org/docs/gcode/M290.html)
  - [Binary File Transfer](https://marlinfw.org/docs/configuration/configuration.html#binary-file-transfer) enabled and [SD Card](https://marlinfw.org/docs/configuration/configuration.html#sd-card-connection) set to `ONBOARD` to allow firmware updates from OctoPrint.
- General tweaks:
  - Three rather than four leveling points for the Tramming assistant. They're positioned as closely as possible to the bed screws, making adjustments more accurate.
  - 460mm MAX_EXTRUSION for both printers, making automatic filament changes simpler
  - 210°/60° PLA preheat temperature for better defaults
  - QUICK_HOME turned on, to match Creality's defaults
  - Custom [boot](https://github.com/nerdhaus/Marlin/blob/nerdhaus-ender-3/Marlin/nerdhaus.boot.png) and [status](https://github.com/nerdhaus/Marlin/blob/nerdhaus-ender-3/Marlin/nerdhaus.e3.statuslogo.png) logos, because _duh._
- Several features that are usually active on Creality machines have been *disabled*:
  - [Power loss recovery](https://marlinfw.org/docs/gcode/M413.html) is fussy, thrashes the SD card, and doesn't play well with Octoprint.
  - [Linear advance](https://marlinfw.org/docs/features/lin_advance.html) is incompatible with the 4.2.7 board's TMC2208 stepper drivers.


## The To-Do List
- [ ] External case for Octoprint/PSUs
- [ ] Cast aluminum heated beds
- [ ] Relay-controlled AC heated beds to reduce PSU strain
- [ ] Standardized print heads & parts fans. (Easy to buy an Ender 3 Max hot end shroud and fans, not so easy to get the carriage plate.)
- [ ] All-metal extruders
- [ ] Direct drive
- [ ] Heated enclosure
- [ ] Better [LCD controller](https://www.amazon.com/gp/product/B09292H22C), or Octoprint-based display

## Past Mods:
- [Hero Me Gen5 cooling ducts](https://www.thingiverse.com/thing:4460970) with dual 5020 parts cooling fans. The reduced the printable area, made attaching the CR Touch a pain, and were overkill for the printing I was doing so I rolled back to the original shroud and fans for the time being.
- 60mm mainboard fan and [boosted cover](https://www.thingiverse.com/thing:4478891)
- 24v-to-USB buck converter to power Pi4 from main power supply (https://www.amazon.com/gp/product/B01HM0OT6G + https://www.thingiverse.com/thing:4810393 + https://www.amazon.com/gp/product/B07RDDTQ6T). New standardized Octoprint box draws power from a single PSU connection.
