# Workbench PSU

The goal: Make a reasonably safe and exceptionally flexible bench PSU for workshop use. I'm currently the old 750W ATX power supply from a gaming PC, with a cheap ATX transfer board (https://www.amazon.com/gp/product/B07T4GLWF8) that breaks out screw terminals for 12V, 5V, and 3.3V power. A 3D printed case for the breakout terminals (https://www.thingiverse.com/thing:2440640) with some magnets glued to the bottom makes it easy to tuck things out of the way (the board sticks to the PSU case, natch).

While the existing setup works, I'd like to get the PSU box itself out of the way and make things a bit more robust — monitor power usage, provide more flexible connection options than the screw terminals on the PSU breakout board, and add a 24V option.

With that in mind, the current goal is to build out a series of stackable, self-contained modules with dedicated lines to the PSU(s).

- Fixed-Voltage module: One each for the 3.3, 5.1, and 12V rails coming from the ATX PSU. Each one features:
  - XT60 connector for PSU hookup
  - Fuse and power switch
  - Volt/Amp meter
  - Banana Plug connectors
  - Dual 5.5mm x 2.1mm DC connectors
  - Dual 2.54mm JST connectors for quick testing of fans etc
- Variable Voltage module:
  - All the fixings from the fixed-voltage module, with a USB-programmable bench power supply controller replacing the Volt/Amp meter.
- USB module
  - Just a fused, switched module with four quickcharge-compatible USB ports.
- No-Tip module (weighted for use in the bottom of a stack)
- Plugs and wires module (just a storage box for banana clips etc that fits inline with the other modules)