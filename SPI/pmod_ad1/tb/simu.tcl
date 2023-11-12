if [file exists work] {vdel -all -lib work  }
vlib work
vmap work work


vcom ../rtl/spi_pmod_ad1.vhd

vcom -2008 tb_spi_pmod_ad1.vhd
vsim -voptargs=+acc tb_spi_pmod_ad1
source chrono1.tcl

run 30 us
