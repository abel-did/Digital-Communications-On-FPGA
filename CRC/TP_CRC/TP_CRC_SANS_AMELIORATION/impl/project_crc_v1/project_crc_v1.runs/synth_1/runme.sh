#!/bin/sh

# 
# Vivado(TM)
# runme.sh: a Vivado-generated Runs Script for UNIX
# Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
# 

if [ -z "$PATH" ]; then
  PATH=/nfs/opt/eda/tools/amd/vitis-2022.1/Vitis/2022.1/bin:/nfs/opt/eda/tools/amd/vitis-2022.1/Vivado/2022.1/ids_lite/ISE/bin/lin64:/nfs/opt/eda/tools/amd/vitis-2022.1/Vivado/2022.1/bin
else
  PATH=/nfs/opt/eda/tools/amd/vitis-2022.1/Vitis/2022.1/bin:/nfs/opt/eda/tools/amd/vitis-2022.1/Vivado/2022.1/ids_lite/ISE/bin/lin64:/nfs/opt/eda/tools/amd/vitis-2022.1/Vivado/2022.1/bin:$PATH
fi
export PATH

if [ -z "$LD_LIBRARY_PATH" ]; then
  LD_LIBRARY_PATH=
else
  LD_LIBRARY_PATH=:$LD_LIBRARY_PATH
fi
export LD_LIBRARY_PATH

HD_PWD='/user/didouha/E4/P1/SEI_4101A/TP_CRC/TP_CRC/TP_CRC_SANS_AMELIORATION/impl/project_crc_v1/project_crc_v1.runs/synth_1'
cd "$HD_PWD"

HD_LOG=runme.log
/bin/touch $HD_LOG

ISEStep="./ISEWrap.sh"
EAStep()
{
     $ISEStep $HD_LOG "$@" >> $HD_LOG 2>&1
     if [ $? -ne 0 ]
     then
         exit
     fi
}

EAStep vivado -log crc_8.vds -m64 -product Vivado -mode batch -messageDb vivado.pb -notrace -source crc_8.tcl
