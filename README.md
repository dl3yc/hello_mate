Hello Mate
==========

This repository is an example vhdl project for ChipCologne(TM) GateMate(TM) FPGAs.

Prerequirements
---------------

 * Simulation: [ghdl](https://github.com/ghdl/ghdl) and [gtkwave](https://github.com/gtkwave/gtkwave)
 * Synthesis: [yosys](https://github.com/YosysHQ/yosys) and [ghdl-yosys-plugin](https://github.com/ghdl/ghdl-yosys-plugin)
 * Place & Route: proprietary ChipCologne(TM) tool from [CologneChip (account required)](https://colognechip.com/mygatemate/)
 * Programmer: [openFPGAloader](https://github.com/trabucayre/openFPGALoader)

As Arch Linux user simply install the required AURs:
```
# yay -Syu ghdl-gcc-git gtkwave ghdl-yosys-plugin openfpgaloader-git
```

Building
--------

The Makefile provides these commands:
 * **make sim_blinky**: start simulation
 * **make syn_blinky**: synthesize, place and route the design
 * **make pgm_blinky**: programm fpga
 * **make pgm-flash_blinky**: make programming of fpga consist
