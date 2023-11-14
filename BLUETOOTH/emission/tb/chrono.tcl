onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_emission/btnu
add wave -noupdate /tb_emission/dut/start_e
add wave -noupdate /tb_emission/dut/start_tx
add wave -noupdate /tb_emission/dut/front_ready_tx
add wave -noupdate -radix hexadecimal /tb_emission/led
add wave -noupdate -radix unsigned /tb_emission/dut/addr
add wave -noupdate -radix ascii -childformat {{/tb_emission/dut/data_mem(7) -radix ascii} {/tb_emission/dut/data_mem(6) -radix ascii} {/tb_emission/dut/data_mem(5) -radix ascii} {/tb_emission/dut/data_mem(4) -radix ascii} {/tb_emission/dut/data_mem(3) -radix ascii} {/tb_emission/dut/data_mem(2) -radix ascii} {/tb_emission/dut/data_mem(1) -radix ascii} {/tb_emission/dut/data_mem(0) -radix ascii}} -subitemconfig {/tb_emission/dut/data_mem(7) {-height 15 -radix ascii} /tb_emission/dut/data_mem(6) {-height 15 -radix ascii} /tb_emission/dut/data_mem(5) {-height 15 -radix ascii} /tb_emission/dut/data_mem(4) {-height 15 -radix ascii} /tb_emission/dut/data_mem(3) {-height 15 -radix ascii} /tb_emission/dut/data_mem(2) {-height 15 -radix ascii} /tb_emission/dut/data_mem(1) {-height 15 -radix ascii} /tb_emission/dut/data_mem(0) {-height 15 -radix ascii}} /tb_emission/dut/data_mem
add wave -noupdate -radix hexadecimal -childformat {{/tb_emission/dut/data_mem(7) -radix ascii} {/tb_emission/dut/data_mem(6) -radix ascii} {/tb_emission/dut/data_mem(5) -radix ascii} {/tb_emission/dut/data_mem(4) -radix ascii} {/tb_emission/dut/data_mem(3) -radix ascii} {/tb_emission/dut/data_mem(2) -radix ascii} {/tb_emission/dut/data_mem(1) -radix ascii} {/tb_emission/dut/data_mem(0) -radix ascii}} -subitemconfig {/tb_emission/dut/data_mem(7) {-height 15 -radix ascii} /tb_emission/dut/data_mem(6) {-height 15 -radix ascii} /tb_emission/dut/data_mem(5) {-height 15 -radix ascii} /tb_emission/dut/data_mem(4) {-height 15 -radix ascii} /tb_emission/dut/data_mem(3) {-height 15 -radix ascii} /tb_emission/dut/data_mem(2) {-height 15 -radix ascii} /tb_emission/dut/data_mem(1) {-height 15 -radix ascii} /tb_emission/dut/data_mem(0) {-height 15 -radix ascii}} /tb_emission/dut/data_mem
add wave -noupdate -radix hexadecimal /tb_emission/dut/reg_crc
add wave -noupdate /tb_emission/dut/current_state
add wave -noupdate -radix hexadecimal /tb_emission/dut/data_tx
add wave -noupdate -divider {RX RECEPTION}
add wave -noupdate /tb_emission/retour/ready_rx
add wave -noupdate -radix hexadecimal /tb_emission/retour/data_rx
add wave -noupdate -divider Memoire
add wave -noupdate -radix ascii -childformat {{/tb_emission/dut/mem/my_memory(0) -radix ascii} {/tb_emission/dut/mem/my_memory(1) -radix ascii} {/tb_emission/dut/mem/my_memory(2) -radix ascii} {/tb_emission/dut/mem/my_memory(3) -radix ascii} {/tb_emission/dut/mem/my_memory(4) -radix ascii} {/tb_emission/dut/mem/my_memory(5) -radix ascii} {/tb_emission/dut/mem/my_memory(6) -radix ascii} {/tb_emission/dut/mem/my_memory(7) -radix ascii}} -subitemconfig {/tb_emission/dut/mem/my_memory(0) {-height 15 -radix ascii} /tb_emission/dut/mem/my_memory(1) {-height 15 -radix ascii} /tb_emission/dut/mem/my_memory(2) {-height 15 -radix ascii} /tb_emission/dut/mem/my_memory(3) {-height 15 -radix ascii} /tb_emission/dut/mem/my_memory(4) {-height 15 -radix ascii} /tb_emission/dut/mem/my_memory(5) {-height 15 -radix ascii} /tb_emission/dut/mem/my_memory(6) {-height 15 -radix ascii} /tb_emission/dut/mem/my_memory(7) {-height 15 -radix ascii}} /tb_emission/dut/mem/my_memory
add wave -noupdate -radix ascii /tb_emission/dut/mem/data
add wave -noupdate -divider {uart tx}
add wave -noupdate /tb_emission/dut/l/trans/current_state
add wave -noupdate /tb_emission/dut/rxd
add wave -noupdate /tb_emission/dut/txd
add wave -noupdate -divider reception
add wave -noupdate /tb_emission/retour/tx
add wave -noupdate /tb_emission/retour/rxd
add wave -noupdate /tb_emission/retour/txd
add wave -noupdate -radix hexadecimal /tb_emission/retour/data_rx
add wave -noupdate -radix hexadecimal /tb_emission/retour/reg_crc
add wave -noupdate /tb_emission/retour/update_rx
add wave -noupdate /tb_emission/retour/start_tx
add wave -noupdate -radix hexadecimal /tb_emission/retour/data_tx
add wave -noupdate -divider tx
add wave -noupdate /tb_emission/retour/l/trans/current_state
add wave -noupdate -divider rx
add wave -noupdate /tb_emission/retour/l/recept/current_state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1041357 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 152
configure wave -valuecolwidth 96
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
WaveRestoreZoom {0 ps} {186823 ps}
