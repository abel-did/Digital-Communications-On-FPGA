onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_crc_8/clk
add wave -noupdate /tb_crc_8/resetn
add wave -noupdate /tb_crc_8/init
add wave -noupdate /tb_crc_8/data_in
add wave -noupdate -radix hexadecimal -radixshowbase 0 /tb_crc_8/crc_out
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
