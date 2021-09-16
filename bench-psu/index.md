# Workbench PSU

The goal: Make a reasonably safe and exceptionally flexible bench PSU for workshop use. I'm currently the old 750W ATX power supply from a gaming PC, with a cheap ATX transfer board (https://www.amazon.com/gp/product/B07T4GLWF8) that breaks out screw terminals for 12V, 5V, and 3.3V power. A 3D printed case for the breakout terminals (https://www.thingiverse.com/thing:2440640) with some magnets glued to the bottom makes it easy to tuck things out of the way (the board sticks to the PSU case, natch).

While the existing setup works, I'd like to get the PSU box itself out of the way and make things a bit more robust — monitor power usage, provide more flexible connection options than the screw terminals on the PSU breakout board, and add a 24V option.

With that in mind, the current goal is to build out a series of stackable, self-contained modules with dedicated lines to the PSU(s).

- **Fixed-Voltage module**: One each for the 3.3, 5.1, and 12V rails coming from the ATX PSU. Each one features:
  - [XT60 connector](https://www.amazon.com/gp/product/B08HTR7BKZ/) for PSU hookup
  - [Fuse](https://www.amazon.com/gp/product/B07BVP8W16) and [power switch](https://www.amazon.com/gp/product/B09232WFXS)
  - Digital [Voltmeter/Ammeter](https://www.amazon.com/gp/product/B08HQM1RMF)
  - Internal [terminal block](https://www.amazon.com/gp/product/B08TBXQ7H6) to supply all power jacks
  - Two sets of [banana plug](https://www.amazon.com/gp/product/B07VFRBRBT) connectors
  - Dual [5.5mm x 2.1mm DC connectors](https://www.amazon.com/gp/product/B091PS6XQ4)
  - Dual [2.54mm JST connectors](https://www.amazon.com/gp/product/B00UBUSR5Y) for quick testing of fans and other small components
- **Variable Voltage module**:
  - All the fixings from the fixed-voltage module, with a [USB-programmable bench power supply](https://www.amazon.com/gp/product/B07PV6FJSL) in place of the voltmeter/ammeter.
- **USB module**
  - Just a fused, switched module with [four quickcharge-compatible USB ports](https://www.amazon.com/gp/product/B087RHWTJW).
- **No-Tip module** (weighted for use in the bottom of a stack)
- **Plugs and wires module** (just a storage box for banana clips etc that fits inline with the other modules)
- For the floor box that holds the PSUs proper, an [ATX breakout board](https://www.amazon.com/gp/product/B08MC389FQ) to separate the different voltage lines.

The general approach is based on https://www.thingiverse.com/thing:3084935 by flash24; its BOM informed a bunch of decisions about the wiring and safety features. The stackable modules, though, are built around a modified version of https://www.thingiverse.com/thing:3434161 by yukiusagi3. It's a sturdy design and the OpenSCAD code for it was mighty clean; modifying it for the needs of this project was cake, and it means remixes of his box can be easily integrated with the PSU stack.

Is this an incredibly, ridiculously over-engineered monstrosity? Yes, obviously, but why use an excellent third-party bench PSU when you can bash together a Frankenstein monster yourself?