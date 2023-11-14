onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_emission/retour/clk
add wave -noupdate /tb_emission/retour/btnc
add wave -noupdate /tb_emission/retour/led
add wave -noupdate /tb_emission/retour/tx
add wave -noupdate /tb_emission/retour/rxd
add wave -noupdate /tb_emission/retour/txd
add wave -noupdate /tb_emission/retour/rts
add wave -noupdate /tb_emission/retour/cts
add wave -noupdate /tb_emission/retour/status
add wave -noupdate /tb_emission/retour/rst
add wave -noupdate /tb_emission/retour/resetn
add wave -noupdate /tb_emission/retour/start_tx
add wave -noupdate /tb_emission/retour/ready_tx
add wave -noupdate /tb_emission/retour/ready_rx
add wave -noupdate /tb_emission/retour/data_tx
add wave -noupdate /tb_emission/retour/data_rx
add wave -noupdate /tb_emission/retour/update_rx
add wave -noupdate /tb_emission/retour/reg_crc
add wave -noupdate /tb_emission/retour/cmd_crc
add wave -noupdate /tb_emission/retour/data_rx_old_1
add wave -noupdate /tb_emission/retour/start_tx_pc
add wave -noupdate /tb_emission/retour/update_rx_pc
add wave -noupdate /tb_emission/retour/ready_tx_pc
add wave -noupdate /tb_emission/retour/data_rx_old_2
add wave -noupdate /tb_emission/retour/cmd_data_rx_old_2
add wave -noupdate /tb_emission/retour/tx_old
add wave -noupdate /tb_emission/retour/ready_rx_1
add wave -noupdate /tb_emission/retour/ready_rx_2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {14999999449 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {37809 ns}
