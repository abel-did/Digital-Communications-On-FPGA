#!/bin/bash -f
# ****************************************************************************
# Vivado (TM) v2022.1 (64-bit)
#
# Filename    : simulate.sh
# Simulator   : Mentor Graphics Questa Advanced Simulator
# Description : Script for simulating the design by launching the simulator
#
# Generated by Vivado on Sat Sep 23 17:25:57 CEST 2023
# SW Build 3526262 on Mon Apr 18 15:47:01 MDT 2022
#
# IP Build 3524634 on Mon Apr 18 20:55:01 MDT 2022
#
# usage: simulate.sh
#
# ****************************************************************************
bin_path="/nfs/opt/eda/tools/siemens/questa-2022.2/questasim/bin"
set -Eeuo pipefail
$bin_path/vsim -64  -do "do {tb_crc_8_simulate.do}" -l simulate.log
