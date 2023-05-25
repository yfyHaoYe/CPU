vlib work
vlib activehdl

vlib activehdl/xil_defaultlib

vmap xil_defaultlib activehdl/xil_defaultlib

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../ipstatic" "+incdir+../../../ipstatic" \
"../../../../../cpuclk/cpuclk_clk_wiz.v" \
"../../../../../cpuclk/cpuclk.v" \


vlog -work xil_defaultlib \
"glbl.v"

