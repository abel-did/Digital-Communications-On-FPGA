######################################################################
#
# File name : tb_crc_8_simulate.do
# Created on: Sat Sep 23 17:25:57 CEST 2023
#
# Auto generated by Vivado for 'behavioral' simulation
#
######################################################################
vsim -lib xil_defaultlib tb_crc_8_opt

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {tb_crc_8_wave.do}

view wave
view structure
view signals

do {tb_crc_8.udo}

run 1000ns