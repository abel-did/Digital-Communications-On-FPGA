if [file exists work] {vdel -all -lib work  }
vlib work
vmap work work


vcom ../rtl/crc_8.vhd

vcom -2008 tb_crc_8.vhd
vsim -voptargs=+acc tb_crc_8
source chrono.tcl

run 7 us