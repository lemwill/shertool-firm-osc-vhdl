######################################################
#
# XPS Tcl API script generated by PlanAhead
#
######################################################

proc _main_ {} {
  cd "C:/Users/SI/osc/osc.srcs/sources_1/edk/osc"
  if { [ catch {xload xmp osc.xmp} result ] } {
    exit 10
  }
  # Set host application type
  xset intstyle PA

  # Set design flow type
  xset flow ise

  # Set language type
  xset hdl vhdl

  if { [catch {run netlist} result] } {
    return -1
  }
  return $result
}

# Generate Synthesized Netlists
if { [catch {_main_} result] } {
  exit -1
}

# Check return status and exit
if { [string length $result] == 0 } {
  exit 0
} else {
  exit $result
}
