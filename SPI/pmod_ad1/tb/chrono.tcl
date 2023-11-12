onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_spi_pmod_ad1/clk
add wave -noupdate /tb_spi_pmod_ad1/resetn
add wave -noupdate /tb_spi_pmod_ad1/start
add wave -noupdate /tb_spi_pmod_ad1/sclk
add wave -noupdate /tb_spi_pmod_ad1/cs
add wave -noupdate /tb_spi_pmod_ad1/ready
add wave -noupdate /tb_spi_pmod_ad1/sdata1
add wave -noupdate /tb_spi_pmod_ad1/sdata2
add wave -noupdate -radix hexadecimal -radixshowbase 0 /tb_spi_pmod_ad1/data1
add wave -noupdate -radix hexadecimal -radixshowbase 0 /tb_spi_pmod_ad1/data2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 198
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {0 ns} {8094 ns}
