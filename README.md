shertool-firm-osc-vhdl
======================

VHDL Code for the oscilloscope
# Compilation
- Create a new PlanAhead project
- Import the ucf from <repo>/oscilloscope.srcs/constrs_1/imports/new/atlys.ucf
- Import the xmp (microblaze) from <repo>/oscilloscope.srcs/sources_1/edk/osc/osc.xmp
- In project settings, change the top level to VHDL
- Left click on osc.xmp, and create top HDL
- Run Synthesis
- Run Implementation
- Generate bitstream
