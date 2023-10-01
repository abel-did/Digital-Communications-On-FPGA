// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.1 (lin64) Build 3526262 Mon Apr 18 15:47:01 MDT 2022
// Date        : Wed Sep 27 20:16:18 2023
// Host        : pc3401g running 64-bit Debian GNU/Linux 11 (bullseye)
// Command     : write_verilog -mode timesim -nolib -sdf_anno true -force -file
//               /user/didouha/E4/P1/SEI_4101A/TP_CRC/TP_CRC/TP_CRC_AVEC_AMELIORATION/impl/project_CRC/project_CRC.sim/sim_1/impl/timing/questa/tb_crc_8_time_impl.v
// Design      : crc_8
// Purpose     : This verilog netlist is a timing simulation representation of the design and should not be modified or
//               synthesized. Please ensure that this netlist is used with the corresponding SDF file.
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps
`define XIL_TIMING

(* ECO_CHECKSUM = "397f83a1" *) 
(* NotValidForBitStream *)
module crc_8
   (clk,
    resetn,
    data_in,
    init,
    crc_out);
  input clk;
  input resetn;
  input data_in;
  input init;
  output [7:0]crc_out;

  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire \crc_Q[7]_i_2_n_0 ;
  wire \crc_Q_reg[0]_lopt_replica_1 ;
  wire \crc_Q_reg[1]_lopt_replica_1 ;
  wire \crc_Q_reg[2]_lopt_replica_1 ;
  wire \crc_Q_reg[3]_lopt_replica_1 ;
  wire \crc_Q_reg[4]_lopt_replica_1 ;
  wire \crc_Q_reg[5]_lopt_replica_1 ;
  wire \crc_Q_reg[6]_lopt_replica_1 ;
  wire \crc_Q_reg[7]_lopt_replica_1 ;
  wire [7:0]crc_out;
  wire [7:0]crc_out_OBUF;
  wire data_in;
  wire data_in_IBUF;
  wire init;
  wire init_IBUF;
  wire [7:0]p_0_in;
  wire resetn;
  wire resetn_IBUF;

initial begin
 $sdf_annotate("tb_crc_8_time_impl.sdf",,,,"tool_control");
end
  BUFG clk_IBUF_BUFG_inst
       (.I(clk_IBUF),
        .O(clk_IBUF_BUFG));
  IBUF clk_IBUF_inst
       (.I(clk),
        .O(clk_IBUF));
  LUT3 #(
    .INIT(8'h06)) 
    \crc_Q[0]_i_1 
       (.I0(crc_out_OBUF[7]),
        .I1(data_in_IBUF),
        .I2(init_IBUF),
        .O(p_0_in[0]));
  LUT4 #(
    .INIT(16'h0096)) 
    \crc_Q[1]_i_1 
       (.I0(crc_out_OBUF[0]),
        .I1(data_in_IBUF),
        .I2(crc_out_OBUF[7]),
        .I3(init_IBUF),
        .O(p_0_in[1]));
  LUT4 #(
    .INIT(16'h0096)) 
    \crc_Q[2]_i_1 
       (.I0(crc_out_OBUF[1]),
        .I1(data_in_IBUF),
        .I2(crc_out_OBUF[7]),
        .I3(init_IBUF),
        .O(p_0_in[2]));
  LUT2 #(
    .INIT(4'h2)) 
    \crc_Q[3]_i_1 
       (.I0(crc_out_OBUF[2]),
        .I1(init_IBUF),
        .O(p_0_in[3]));
  LUT2 #(
    .INIT(4'h2)) 
    \crc_Q[4]_i_1 
       (.I0(crc_out_OBUF[3]),
        .I1(init_IBUF),
        .O(p_0_in[4]));
  (* \PinAttr:I0:HOLD_DETOUR  = "184" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \crc_Q[5]_i_1 
       (.I0(crc_out_OBUF[4]),
        .I1(init_IBUF),
        .O(p_0_in[5]));
  LUT2 #(
    .INIT(4'h2)) 
    \crc_Q[6]_i_1 
       (.I0(crc_out_OBUF[5]),
        .I1(init_IBUF),
        .O(p_0_in[6]));
  LUT2 #(
    .INIT(4'h2)) 
    \crc_Q[7]_i_1 
       (.I0(crc_out_OBUF[6]),
        .I1(init_IBUF),
        .O(p_0_in[7]));
  LUT1 #(
    .INIT(2'h1)) 
    \crc_Q[7]_i_2 
       (.I0(resetn_IBUF),
        .O(\crc_Q[7]_i_2_n_0 ));
  FDCE #(
    .INIT(1'b0)) 
    \crc_Q_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\crc_Q[7]_i_2_n_0 ),
        .D(p_0_in[0]),
        .Q(crc_out_OBUF[0]));
  (* OPT_INSERTED_REPDRIVER *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  FDCE #(
    .INIT(1'b0)) 
    \crc_Q_reg[0]_lopt_replica 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\crc_Q[7]_i_2_n_0 ),
        .D(p_0_in[0]),
        .Q(\crc_Q_reg[0]_lopt_replica_1 ));
  FDCE #(
    .INIT(1'b0)) 
    \crc_Q_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\crc_Q[7]_i_2_n_0 ),
        .D(p_0_in[1]),
        .Q(crc_out_OBUF[1]));
  (* OPT_INSERTED_REPDRIVER *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  FDCE #(
    .INIT(1'b0)) 
    \crc_Q_reg[1]_lopt_replica 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\crc_Q[7]_i_2_n_0 ),
        .D(p_0_in[1]),
        .Q(\crc_Q_reg[1]_lopt_replica_1 ));
  FDCE #(
    .INIT(1'b0)) 
    \crc_Q_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\crc_Q[7]_i_2_n_0 ),
        .D(p_0_in[2]),
        .Q(crc_out_OBUF[2]));
  (* OPT_INSERTED_REPDRIVER *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  FDCE #(
    .INIT(1'b0)) 
    \crc_Q_reg[2]_lopt_replica 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\crc_Q[7]_i_2_n_0 ),
        .D(p_0_in[2]),
        .Q(\crc_Q_reg[2]_lopt_replica_1 ));
  FDCE #(
    .INIT(1'b0)) 
    \crc_Q_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\crc_Q[7]_i_2_n_0 ),
        .D(p_0_in[3]),
        .Q(crc_out_OBUF[3]));
  (* OPT_INSERTED_REPDRIVER *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  FDCE #(
    .INIT(1'b0)) 
    \crc_Q_reg[3]_lopt_replica 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\crc_Q[7]_i_2_n_0 ),
        .D(p_0_in[3]),
        .Q(\crc_Q_reg[3]_lopt_replica_1 ));
  FDCE #(
    .INIT(1'b0)) 
    \crc_Q_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\crc_Q[7]_i_2_n_0 ),
        .D(p_0_in[4]),
        .Q(crc_out_OBUF[4]));
  (* OPT_INSERTED_REPDRIVER *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  FDCE #(
    .INIT(1'b0)) 
    \crc_Q_reg[4]_lopt_replica 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\crc_Q[7]_i_2_n_0 ),
        .D(p_0_in[4]),
        .Q(\crc_Q_reg[4]_lopt_replica_1 ));
  FDCE #(
    .INIT(1'b0)) 
    \crc_Q_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\crc_Q[7]_i_2_n_0 ),
        .D(p_0_in[5]),
        .Q(crc_out_OBUF[5]));
  (* OPT_INSERTED_REPDRIVER *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  FDCE #(
    .INIT(1'b0)) 
    \crc_Q_reg[5]_lopt_replica 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\crc_Q[7]_i_2_n_0 ),
        .D(p_0_in[5]),
        .Q(\crc_Q_reg[5]_lopt_replica_1 ));
  FDCE #(
    .INIT(1'b0)) 
    \crc_Q_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\crc_Q[7]_i_2_n_0 ),
        .D(p_0_in[6]),
        .Q(crc_out_OBUF[6]));
  (* OPT_INSERTED_REPDRIVER *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  FDCE #(
    .INIT(1'b0)) 
    \crc_Q_reg[6]_lopt_replica 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\crc_Q[7]_i_2_n_0 ),
        .D(p_0_in[6]),
        .Q(\crc_Q_reg[6]_lopt_replica_1 ));
  FDCE #(
    .INIT(1'b0)) 
    \crc_Q_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\crc_Q[7]_i_2_n_0 ),
        .D(p_0_in[7]),
        .Q(crc_out_OBUF[7]));
  (* OPT_INSERTED_REPDRIVER *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  FDCE #(
    .INIT(1'b0)) 
    \crc_Q_reg[7]_lopt_replica 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .CLR(\crc_Q[7]_i_2_n_0 ),
        .D(p_0_in[7]),
        .Q(\crc_Q_reg[7]_lopt_replica_1 ));
  (* OPT_MODIFIED = "SWEEP" *) 
  OBUF \crc_out_OBUF[0]_inst 
       (.I(\crc_Q_reg[0]_lopt_replica_1 ),
        .O(crc_out[0]));
  (* OPT_MODIFIED = "SWEEP" *) 
  OBUF \crc_out_OBUF[1]_inst 
       (.I(\crc_Q_reg[1]_lopt_replica_1 ),
        .O(crc_out[1]));
  (* OPT_MODIFIED = "SWEEP" *) 
  OBUF \crc_out_OBUF[2]_inst 
       (.I(\crc_Q_reg[2]_lopt_replica_1 ),
        .O(crc_out[2]));
  (* OPT_MODIFIED = "SWEEP" *) 
  OBUF \crc_out_OBUF[3]_inst 
       (.I(\crc_Q_reg[3]_lopt_replica_1 ),
        .O(crc_out[3]));
  (* OPT_MODIFIED = "SWEEP" *) 
  OBUF \crc_out_OBUF[4]_inst 
       (.I(\crc_Q_reg[4]_lopt_replica_1 ),
        .O(crc_out[4]));
  (* OPT_MODIFIED = "SWEEP" *) 
  OBUF \crc_out_OBUF[5]_inst 
       (.I(\crc_Q_reg[5]_lopt_replica_1 ),
        .O(crc_out[5]));
  (* OPT_MODIFIED = "SWEEP" *) 
  OBUF \crc_out_OBUF[6]_inst 
       (.I(\crc_Q_reg[6]_lopt_replica_1 ),
        .O(crc_out[6]));
  (* OPT_MODIFIED = "SWEEP" *) 
  OBUF \crc_out_OBUF[7]_inst 
       (.I(\crc_Q_reg[7]_lopt_replica_1 ),
        .O(crc_out[7]));
  IBUF data_in_IBUF_inst
       (.I(data_in),
        .O(data_in_IBUF));
  IBUF init_IBUF_inst
       (.I(init),
        .O(init_IBUF));
  IBUF resetn_IBUF_inst
       (.I(resetn),
        .O(resetn_IBUF));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
