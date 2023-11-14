if [file exists work] {vdel -all -lib work  }
vlib work
vmap work work




set liste {
uart_rx
uart_tx
uart
}

foreach el $liste {
vcom ../../uart/rtl/$el.vhd
}

set liste {
rom_message
emission
reception
}

foreach el $liste {
vcom -2008 ../rtl/$el.vhd
}

vcom tb_emission.vhd
vsim -voptargs=+acc tb_emission
source chrono.tcl
run  80000 us
