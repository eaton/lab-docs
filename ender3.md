# Ender 3 Mods

Nothing particularly fancy here, just an ongoing record of the various mods I make to a stock [Creality Ender 3](https://www.amazon.com/gp/product/B07BR3F9N6) originally purchased in 2018. It's a workhorse that's pretty easy to mod, and I'd give it a big thumbs up for anyone interested in getting involved in 3D printing. Anything marked with an asterisk is a standard part of subsequent releases of the printer — the Ender 3 Pro, V2, etc.

## Current Status:

Running smoothly with a Pi4 and the HeroMe Gen5 twin-duct 5020 parts fans. The Pi controls power to the Ender with a relay, but it's currently a tangle of wires and a propped-up 40mm fan to keep the pi cool; coming up with a good consolidated case for the Ender's mainboard, the pi, and other fixings is probably the next project. A cable chain is probably secondl; it wouldn't hurt to integrate the two projects.

## Current mods:

- [x] [Silicone bed spring replacements](https://www.aliexpress.com/item/4001034984008.html)
- [x] [Glass print bed](https://www.amazon.com/B07F16WPR5)*
- [x] [Alumnium extruder](https://www.amazon.com/gp/product/B07G2ZM919)*
- [x] [Silicone hot end sleeve](https://www.amazon.com/dp/B083GXQ7L8)
- [x] [Hero Me Gen5 cooling ducts](https://www.thingiverse.com/thing:4460970) with dual 5020 parts cooling fans
- [x] 808 bearing [filament guide](https://www.thingiverse.com/thing:3052488)
- [x] [Meanwell power supply](https://www.amazon.com/gp/product/B013ETVO12) w/[Noctua 80mm fan](https://www.amazon.com/gp/product/B00KF7T9MI)
- [x] [X belt](https://www.thingiverse.com/thing:3270228) and [Y belt](https://www.thingiverse.com/thing:3264177) tensioners*
- [x] Upgraded 1.1.5 Mainboard (Replaced by [32-bit 4.2.7 mainboard](https://creality3d.shop/products/creality3d-upgrade-silent-4-2-7-1-1-5-mainboard-for-ender-3-ender-3-pro-ender-5-3d-printer?variant=36836286038166))*
- [x] 60mm mainboard fan and [boosted cover](https://www.thingiverse.com/thing:4478891)
- [x] 24v-to-USB buck converter to power Pi4 from main power supply (https://www.amazon.com/gp/product/B01HM0OT6G + https://www.thingiverse.com/thing:4810393 + https://www.amazon.com/gp/product/B07RDDTQ6T)
- [x] Control printer power from Pi (https://www.amazon.com/gp/product/B07TWH7DZ1)
- [x] Rewire mainboard fan and hot end fan for always-on operation; add JST connectors for easier fan swapping.
- [x] Rewire parts cooling fans to use separate mainboard connections (second JST connector freed by mainbord fan change)
- [x] Remove control box and LCD panel, I do everything via Octoprint anyways
- [x] Filament drybox (https://www.thingiverse.com/thing:2929701)

## Octoprint controller
- [ ] Status and controller ([OctoDash](https://github.com/UnchartedBull/OctoDash) is a good candidate)

## In Progress
- [ ] Move mainboard and Pi to rear of printer
- [ ] Replace LCD + Control Box with small OLED status panel
- [ ] More durable cable for PiCam (https://www.amazon.com/gp/product/B06XDNBM63)

## Aspirational
- [ ] Cable chain for tidier cable crap
- [ ] Build and flash firmware with less annoying PWM settings - see https://github.com/MarlinFirmware/Marlin/issues/16115
- [ ] Filament [runout sensor](https://www.thingiverse.com/thing:3357097)
- [ ] Filtered, temperature controlled enclosure
- [ ] What the hell, buy a [CR-10 v3](https://www.creality3dofficial.com/products/creality-cr-10-v3-3d-printer-with-genuine-e3d-direct-drive-extruder-2020-latest-version) or an [Ender 3 Max](https://www.creality3dofficial.com/products/ender-3-max-3d-printer)
