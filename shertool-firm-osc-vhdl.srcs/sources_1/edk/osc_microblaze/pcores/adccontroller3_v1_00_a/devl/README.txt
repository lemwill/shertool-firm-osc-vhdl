TABLE OF CONTENTS
  1) Peripheral Summary
  2) Description of Generated Files
  3) Location to documentation of dependent libraries
================================================================================
*                             1) Peripheral Summary                            *
================================================================================
Peripheral Summary:

  XPS project / EDK repository               : C:\Users\Administrateur\Documents\shertool-firm-osc-vhdl\shertool-firm-osc-vhdl.srcs\sources_1\edk\osc_microblaze
  logical library name                       : adccontroller3_v1_00_a
  top name                                   : adccontroller3
  version                                    : 1.00.a
  type                                       : AXI4LITE slave
  features                                   : slave attachment
                                               mir/rst register
                                               user s/w registers

Address Block for User Logic and IPIF Predefined Services

  user logic slave space                     : C_BASEADDR + 0x00000000
                                             : C_BASEADDR + 0x000000FF
  software reset space                       : C_BASEADDR + 0x00000100
                                             : C_BASEADDR + 0x000001FF


================================================================================
*                          2) Description of Generated Files                   *
================================================================================
- HDL source file(s)

  hdl/vhdl/adccontroller3.vhd

    This is the template file for your peripheral's top design entity. It
    configures and instantiates the corresponding design units in the way you
    indicated in the wizard GUI and hooks it up to the stub user logic where
    the actual functionalites should get implemented. You are not expected to
    modify this template file except certain marked places for adding user
    specific generics and ports.

  vhdl/user_logic.vhd

    This is the template file for the stub user logic design entity, either in
    VHDL or Verilog, where the actual functionalities should get implemented.
    Some sample code snippet may be provided for demonstration purpose.

- XPS interface file(s)

  data/adccontroller3_v2_1_0.mpd

    This Microprocessor Peripheral Description file contains information of the
    interface of your peripheral, so that other EDK tools can recognize your
    peripheral.

  data/adccontroller3_v2_1_0.pao

    This Peripheral Analysis Order file defines the analysis order of all the HDL
    source files that are used to compile your peripheral.

- ISE project file(s)

  devl/projnav/adccontroller3.xise

    This is the ProjNavigator project file. It sets up the needed logical
    libraries and dependent library files for you to help you develop your
    peripheral using ProjNavigator.

  devl/projnav/adccontroller3.tcl

    This is the TCL command line file used to generate the .xise file.

- XST synthesis file(s)

  devl/synthesis/adccontroller3_xst.scr

    This is the XST synthesis script file to compile your peripheral.
    Note: you may want to modify the device part option for your target.

  devl/synthesis/adccontroller3_xst.prj

    This is the XST synthesis project file used by the above script file to
    compile your peripheral.

- BFM simulation project file(s)

  devl/bfmsim/README.txt

    This is the BFM simulation guide file.

  devl/bfmsim/bfm_system.mhs

    This is the BFM simulation platform description file, read by SimGen to
    generate the BFM behavioral simulation files.

  devl/bfmsim/scripts/bfm_system_tb.v

    This is the BFM simulation testbench which covers basic read and write operations.
    It should be manually copied to the simulaiton working directory. 

    Documentation on verilog stimulus generation : http://www.xilinx.com/support/documentation/sw_manuals/<<release name>>/ug783_axi_bfm.pdf
    Example release name is xilinx13_1

  devl/bfmsim/bfm_system.xmp

    This is the XPS project file for this BFM simulation project.

- Driver source file(s)

  src/adccontroller3.h

    This is the software driver header template file, which contains address offset of
    software addressable registers in your peripheral, as well as some common masks and
    simple register access macros or function declaration.

  src/adccontroller3.c

    This is the software driver source template file, to define all applicable driver
    functions.

  src/adccontroller3_selftest.c

    This is the software driver self test example file, which contain self test example
    code to test various hardware features of your peripheral.

  src/Makefile

    This is the software driver makefile to compile drivers.

- Driver interface file(s)
-user needs to add these to repositories path in SDK (Xilinx Tools-->Repositories)

  data/adccontroller3_v2_1_0.mdd

    This is the Microprocessor Driver Definition file.

  data/adccontroller3_v2_1_0.tcl

    This is the Microprocessor Driver Command file.

- Other misc file(s)

  devl/ipwiz.opt

    This is the option setting file for the wizard batch mode, which should
    generate the same result as the wizard GUI mode.

  devl/README.txt

    This README file for your peripheral.

  devl/ipwiz.log

    This is the log file by operating on this wizard.


================================================================================
*          3) Location to documentation of dependent libraries                 *
*                                                                              *
*   In general, the documentation is located under:                            *
*   $XILINX_EDK/hw/XilinxProcessorIPLib/pcores/$libName/doc                    *
*                                                                              *
================================================================================
proc_common_v3_00_a
	No documentation for this library

axi_lite_ipif_v1_01_a
	C:\Users\Administrateur\Documents\shertool-firm-osc-vhdl\shertool-firm-osc-vhdl.srcs\sources_1\edk\osc_microblaze\C:\Xilinx\14.7\ISE_DS\EDK\hw\XilinxProcessorIPLib\pcores\axi_lite_ipif_v1_01_a\doc\axi_lite_ipif_ds765.pdf

