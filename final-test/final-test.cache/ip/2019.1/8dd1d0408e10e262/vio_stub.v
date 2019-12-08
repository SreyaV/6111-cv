// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
// Date        : Sat Dec  7 20:23:14 2019
// Host        : DESKTOP-7EQCPG5 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ vio_stub.v
// Design      : vio
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a200tsbg484-3
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "vio,Vivado 2019.1" *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix(clk, probe_in0, probe_in1, probe_in2, probe_in3, 
  probe_in4, probe_in5, probe_out0, probe_out1, probe_out2, probe_out3, probe_out4, probe_out5, 
  probe_out6, probe_out7, probe_out8, probe_out9, probe_out10, probe_out11, probe_out12, 
  probe_out13)
/* synthesis syn_black_box black_box_pad_pin="clk,probe_in0[10:0],probe_in1[9:0],probe_in2[10:0],probe_in3[9:0],probe_in4[16:0],probe_in5[16:0],probe_out0[7:0],probe_out1[7:0],probe_out2[7:0],probe_out3[7:0],probe_out4[7:0],probe_out5[7:0],probe_out6[7:0],probe_out7[7:0],probe_out8[7:0],probe_out9[7:0],probe_out10[7:0],probe_out11[7:0],probe_out12[16:0],probe_out13[16:0]" */;
  input clk;
  input [10:0]probe_in0;
  input [9:0]probe_in1;
  input [10:0]probe_in2;
  input [9:0]probe_in3;
  input [16:0]probe_in4;
  input [16:0]probe_in5;
  output [7:0]probe_out0;
  output [7:0]probe_out1;
  output [7:0]probe_out2;
  output [7:0]probe_out3;
  output [7:0]probe_out4;
  output [7:0]probe_out5;
  output [7:0]probe_out6;
  output [7:0]probe_out7;
  output [7:0]probe_out8;
  output [7:0]probe_out9;
  output [7:0]probe_out10;
  output [7:0]probe_out11;
  output [16:0]probe_out12;
  output [16:0]probe_out13;
endmodule
