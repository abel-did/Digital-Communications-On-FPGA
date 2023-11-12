onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_spi_pmod_ad1/dut/clk
add wave -noupdate /tb_spi_pmod_ad1/dut/resetn
add wave -noupdate /tb_spi_pmod_ad1/dut/start
add wave -noupdate /tb_spi_pmod_ad1/dut/data1
add wave -noupdate /tb_spi_pmod_ad1/dut/data2
add wave -noupdate /tb_spi_pmod_ad1/dut/ready
add wave -noupdate /tb_spi_pmod_ad1/dut/sdata1
add wave -noupdate /tb_spi_pmod_ad1/dut/sdata2
add wave -noupdate /tb_spi_pmod_ad1/dut/sclk
add wave -noupdate /tb_spi_pmod_ad1/dut/cs
add wave -noupdate /tb_spi_pmod_ad1/dut/sclk_wire
add wave -noupdate /tb_spi_pmod_ad1/dut/cmd_SCLK
add wave -noupdate /tb_spi_pmod_ad1/dut/end_data
add wave -noupdate /tb_spi_pmod_ad1/dut/cmd_cptr
add wave -noupdate /tb_spi_pmod_ad1/dut/ctr_data
add wave -noupdate /tb_spi_pmod_ad1/dut/data_out
add wave -noupdate /tb_spi_pmod_ad1/dut/data_out_2
add wave -noupdate /tb_spi_pmod_ad1/dut/cmd_MISO
add wave -noupdate /tb_spi_pmod_ad1/dut/end_tempo
add wave -noupdate /tb_spi_pmod_ad1/dut/cmd_tempo
add wave -noupdate /tb_spi_pmod_ad1/dut/ctr_tempo
add wave -noupdate /tb_spi_pmod_ad1/dut/current_state
add wave -noupdate /tb_spi_pmod_ad1/dut/next_state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 198
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {8094 ns}
