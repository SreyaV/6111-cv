-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
-- Date        : Sat Dec  7 20:23:15 2019
-- Host        : DESKTOP-7EQCPG5 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub {C:/Users/Sreya
--               Vangara/Documents/MIT/6.111/6.111/Final/final-test/final-test.srcs/sources_1/ip/vio/vio_stub.vhdl}
-- Design      : vio
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a200tsbg484-3
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vio is
  Port ( 
    clk : in STD_LOGIC;
    probe_in0 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe_in1 : in STD_LOGIC_VECTOR ( 9 downto 0 );
    probe_in2 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe_in3 : in STD_LOGIC_VECTOR ( 9 downto 0 );
    probe_in4 : in STD_LOGIC_VECTOR ( 16 downto 0 );
    probe_in5 : in STD_LOGIC_VECTOR ( 16 downto 0 );
    probe_out0 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    probe_out1 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    probe_out2 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    probe_out3 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    probe_out4 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    probe_out5 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    probe_out6 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    probe_out7 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    probe_out8 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    probe_out9 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    probe_out10 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    probe_out11 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    probe_out12 : out STD_LOGIC_VECTOR ( 16 downto 0 );
    probe_out13 : out STD_LOGIC_VECTOR ( 16 downto 0 )
  );

end vio;

architecture stub of vio is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,probe_in0[10:0],probe_in1[9:0],probe_in2[10:0],probe_in3[9:0],probe_in4[16:0],probe_in5[16:0],probe_out0[7:0],probe_out1[7:0],probe_out2[7:0],probe_out3[7:0],probe_out4[7:0],probe_out5[7:0],probe_out6[7:0],probe_out7[7:0],probe_out8[7:0],probe_out9[7:0],probe_out10[7:0],probe_out11[7:0],probe_out12[16:0],probe_out13[16:0]";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "vio,Vivado 2019.1";
begin
end;
