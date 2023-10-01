#!/bin/bash -f
# ****************************************************************************
# Vivado (TM) v2022.1 (64-bit)
#
# Filename    : compile.sh
# Simulator   : Mentor Graphics Questa Advanced Simulator
# Description : Script for compiling the simulation design source files
#
# Generated by Vivado on Sat Sep 23 17:25:49 CEST 2023
# SW Build 3526262 on Mon Apr 18 15:47:01 MDT 2022
#
# IP Build 3524634 on Mon Apr 18 20:55:01 MDT 2022
#
# usage: compile.sh
#
# ****************************************************************************
bin_path="/nfs/opt/eda/tools/siemens/questa-2022.2/questasim/bin"
set -Eeuo pipefail
source tb_crc_8_compile.do 2>&1 | tee compile.log

