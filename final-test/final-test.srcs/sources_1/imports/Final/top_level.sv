`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Updated 8/10/2019 Lab 3
// Updated 8/12/2018 V2.lab5c
// Create Date: 10/1/2015 V1.0
// Design Name:
// Module Name: labkit
//
//////////////////////////////////////////////////////////////////////////////////

module top_level(

    input clk,
   input [7:0] sw,
   input btnc, btnu, btnl, btnr, btnd,
   input [7:0] jb,
   input [2:0] jc,
   output jcclk,
   output logic [7:0] led,
   output logic hdmi_tx_clk_n,
    output logic hdmi_tx_clk_p,
    output logic [2:0] hdmi_tx_n,
    output logic [2:0] hdmi_tx_p
   );
    logic clk_65mhz;
    // create 65mhz system clock, happens to match 1024 x 768 XVGA timing
    //clk_wiz_0 clkdivider(.clk_in1(clk_100mhz), .clk_out1(clk_65mhz));
    clk_wiz_lab3 clkdivider(.clk_in1(clk), .clk_out1(clk_65mhz));

    wire [31:0] data;      //  instantiate 7-segment display; display (8) 4-bit hex
    wire [6:0] segments;
    assign led = sw;                        // turn leds on
    assign data = {28'h0123456, sw[3:0]};   // display 0123456 + sw[3:0]

    wire [10:0] hcount;    // pixel on current line
    wire [9:0] vcount;     // line number
    wire hsync, vsync, blank;
    wire [11:0] pixel;
    reg [11:0] rgb;    
    xvga xvga1(.vclock_in(clk_65mhz),.hcount_out(hcount),.vcount_out(vcount),
          .hsync_out(hsync),.vsync_out(vsync),.blank_out(blank));


    // btnc button is user reset
    wire reset;
    debounce db1(.reset_in(reset),.clock_in(clk_65mhz),.noisy_in(btnc),.clean_out(reset));
   
   
    logic xclk;
    logic[1:0] xclk_count;
    
    logic pclk_buff, pclk_in;
    logic vsync_buff, vsync_in;
    logic href_buff, href_in;
    logic[7:0] pixel_buff, pixel_in;
    
    logic [11:0] cam;
    logic [11:0] frame_buff_out;
    logic [15:0] output_pixels;
    logic [15:0] old_output_pixels;
    logic [11:0] processed_pixels; //changed from 12:0
    logic [3:0] red_diff;
    logic [3:0] green_diff;
    logic [3:0] blue_diff;
    logic valid_pixel;
    logic frame_done_out;
    
    logic [16:0] pixel_addr_in;
    logic [16:0] pixel_addr_out;
    
    logic [10:0] centroid_x_green;
    logic [9:0] centroid_y_green;
    logic [10:0] centroid_x_red;
    logic [9:0] centroid_y_red;
    wire green;
    wire red;
    logic frame_done;
    
    logic [15:0] averaging;
    assign averaging = sw;
    
    logic [7:0] h_upper_green;
    logic [7:0] h_lower_green;
    logic [7:0] h_upper_red;
    logic [7:0] h_lower_red;
    logic [7:0] v_upper_green;
    logic [7:0] v_lower_green;
    logic [7:0] v_upper_red;
    logic [7:0] v_lower_red;
    logic [7:0] s_upper_green;
    logic [7:0] s_lower_green;
    logic [7:0] s_upper_red;
    logic [7:0] s_lower_red;
    
    
    logic [10:0] hcount_camera;
    logic [9:0] vcount_camera;
    logic [10:0] hcount_fifo;
    logic [9:0] vcount_fifo;
    
    
    
    assign xclk = (xclk_count >2'b01);
    assign jcclk = xclk;
    assign jdclk = xclk;
    
//    assign red_diff = (output_pixels[15:12]>old_output_pixels[15:12])?output_pixels[15:12]-old_output_pixels[15:12]:old_output_pixels[15:12]-output_pixels[15:12];
//    assign green_diff = (output_pixels[10:7]>old_output_pixels[10:7])?output_pixels[10:7]-old_output_pixels[10:7]:old_output_pixels[10:7]-output_pixels[10:7];
//    assign blue_diff = (output_pixels[4:1]>old_output_pixels[4:1])?output_pixels[4:1]-old_output_pixels[4:1]:old_output_pixels[4:1]-output_pixels[4:1];

    
    
    /*blk_mem_gen_0 jojos_bram(.addra(pixel_addr_in), 
                             .clka(pclk_in),
                             .dina(processed_pixels),
                             .wea(valid_pixel),
                             .addrb(pixel_addr_out),
                             .clkb(clk_65mhz),
                             .doutb(frame_buff_out));*/
                             
                             //delete all
                             //make 2 fifos, one for address and one for pixel
                             //add in processed pixel and pixel addr
                             //add in on wea = valid pixel
                             //write out on 65mhz clock
                             //write out framebuffout and pixel addr out
                             //make fifos from ip catalog
                             
    assign frame_done = (hcount_fifo==319 && vcount_fifo==239) ? 1 : 0;
    
    always_ff @(posedge pclk_in)begin
        if (frame_done_out)begin
            vcount_camera <= 0;
            hcount_camera<=0;
           // pixel_addr_in <= 17'b0;  
        end else if (valid_pixel)begin
            if (hcount_camera == 319) begin
                hcount_camera <= 0;
                vcount_camera <= vcount_camera+1;
            end else begin
                hcount_camera <= hcount_camera+1;
            end
            //pixel_addr_in <= pixel_addr_in +1;  
        end
    end

    
                             
    logic full;
    logic empty;
    logic [32:0] fifo_temp;
  
                                 
     fifo_33 fifo(
     .wr_clk(pclk_in),  // input wire wr_clk
  .rd_clk(clk_65mhz),  // input wire rd_clk
  //.clk(clk_65mhz),      // input wire clk
  .rst(0),    // input wire srst
  .din({processed_pixels, hcount_camera, vcount_camera}),      // input wire [32 : 0] din
  .wr_en(valid_pixel),  // input wire wr_en
  .rd_en(!empty),  // input wire rd_en
  .dout(fifo_temp),    // output wire [32 : 0] dout
  .full(full),    // output wire full
  .empty(empty)  // output wire empty
); 



    assign frame_buff_out = fifo_temp[32:21];
    assign hcount_fifo = fifo_temp[20:10];
    assign vcount_fifo = fifo_temp[9:0];

    assign pixel_addr_in = hcount_fifo+vcount_fifo*32'd320;
    
    always_ff @(posedge clk_65mhz) begin
        pclk_buff <= jc[0];//WAS JB
        vsync_buff <= jc[1]; //WAS JB
        href_buff <= jc[2]; //WAS JB
        pixel_buff <= jb;
        pclk_in <= pclk_buff;
        vsync_in <= vsync_buff;
        href_in <= href_buff;
        pixel_in <= pixel_buff;
        old_output_pixels <= output_pixels;
        xclk_count <= xclk_count + 2'b01;
        processed_pixels = {output_pixels[15:12],output_pixels[10:7],output_pixels[4:1]};    
    end
    
    logic [7:0] h;
    logic [7:0] out_v;
//    assign h_upper_green = 96;
//    assign h_lower_green = 30;
    
//    assign h_upper_green = 211; //150
//    assign h_lower_green = 63; //110
    
//    assign h_upper_red = 10; //150
//    assign h_lower_red = 0; //110
    
    
//    assign h_upper = sw[15:9]; //96
//    assign h_lower = sw[6:0]; //48
//    assign v_upper = 224;
//    assign v_lower = 127; //240
//    assign v_upper = sw[15:8];
//    assign v_lower = sw[7:0];

    logic empty_p;
    
     pipeline #(.N_BITS(1), .N_REGISTERS(22)) pipeline_x(
        .clk_in(clk_65mhz), 
        .rst_in(reset),
        .data_in(empty),
        .data_out(empty_p));

    assign cam = frame_buff_out;
    
    wire temp;
    logic [7:0] out_h;
    
    rgb2hsv rgb2hsv_red (.clock(clk_65mhz), .reset(reset), .r(cam[11:8]<<4), .g(cam[7:4]<<4), .b(cam[3:0]<<4), .color(red), .h_upper(h_upper_red), .h_lower(h_lower_red), .v_upper(v_upper_red), .v_lower(v_lower_red), .s_upper(s_upper_red), .s_lower(s_lower_red));
    
    rgb2hsv rgb2hsv_green (.clock(clk_65mhz), .reset(reset), .r(cam[11:8]<<4), .g(cam[7:4]<<4), .b(cam[3:0]<<4), .color(green), .h_upper(h_upper_green), .h_lower(h_lower_green), .v_upper(v_upper_green), .v_lower(v_lower_green), .s_upper(s_upper_green), .s_lower(s_lower_green));
   
   logic [16:0] count_green_threshold;
    logic [16:0] count_red_threshold;
    
    logic [16:0] count_green;
    logic [16:0] count_red;
    
    logic red_detected;
    logic green_detected;
    
    centroid centroid_red (.clock(clk_65mhz), .reset(reset), .x(hcount_fifo), .y(vcount_fifo), .color(!empty_p ? red : 0), .frame_done(frame_done), .centroid_x(centroid_x_red), .centroid_y(centroid_y_red), .count_out(count_red), .detected(red_detected), .count_threshold(count_red_threshold));
   
    centroid centroid_green (.clock(clk_65mhz), .reset(reset), .x(hcount_fifo), .y(vcount_fifo), .color(!empty_p ? green : 0), .frame_done(frame_done), .centroid_x(centroid_x_green), .centroid_y(centroid_y_green), .count_out(count_green), .detected(green_detected), .count_threshold(count_green_threshold));
    
    
    
    //assign pixel_addr_out = hcount+vcount*32'd320;
    //assign pixel_addr_out = sw[2]?((hcount>>1)+(vcount>>1)*32'd320):hcount+vcount*32'd320;
    //assign cam = sw[2]&&((hcount<640) &&  (vcount<480))?frame_buff_out:~sw[2]&&((hcount<320) &&  (vcount<240))?frame_buff_out:12'h000;
    
    //assign frame_buff_out = 
    
    //assign cam = 0&&((hcount<640) &&  (vcount<480))?frame_buff_out:1&&((hcount<320) &&  (vcount<240))?frame_buff_out:12'h000;
    
/*    always_ff @(posedge clk_65mhz) begin
        
    end*/
    
    logic [11:0] vga_frame_buff_out;
    logic [16:0] vga_pixel_addr_out;
    assign vga_pixel_addr_out = hcount+vcount*32'd320;
    
    logic delayed_empty;
    
    always_ff @(posedge clk_65mhz) begin
        delayed_empty <= empty;
    end
    
       logic [11:0] temp_rgb;
       logic [11:0] dina_temp;
       //assign dina_temp = (hcount_fifo==centroid_x_red || vcount_fifo==centroid_y_red) ? 12'h00F : red ? 12'h700 :  cam;
       assign dina_temp = (hcount_fifo==centroid_x_green || vcount_fifo==centroid_y_green) ? 12'h00F : (hcount_fifo==centroid_x_red || vcount_fifo==centroid_y_red) ? 12'hF0F : green ? 12'h062 : red ? 12'h700 :  cam;

       
       blk_mem_gen_0 jojos_bram(.addra(pixel_addr_in), 
                             .clka(clk_65mhz),
                             .dina(dina_temp),
                             .wea(!delayed_empty),
                             .addrb(vga_pixel_addr_out),
                             .clkb(clk_65mhz),
                             .doutb(temp_rgb));
                             
    assign rgb = (hcount<320 && vcount<240) ? temp_rgb : 0;


    vio vio (
      .clk(clk_65mhz),                  // input wire clk
      .probe_in0(centroid_x_red),      // input wire [10 : 0] probe_in0
      .probe_in1(centroid_y_red),      // input wire [9 : 0] probe_in1
      .probe_in2(centroid_x_green),      // input wire [10 : 0] probe_in2
      .probe_in3(centroid_y_green),      // input wire [9 : 0] probe_in3
      .probe_in4(count_green),      // input wire [16 : 0] probe_in4
      .probe_in5(count_red),      // input wire [16 : 0] probe_in5
      .probe_out0(h_upper_green),    // output wire [7 : 0] probe_out0
      .probe_out1(h_lower_green),    // output wire [7 : 0] probe_out1
      .probe_out2(h_upper_red),    // output wire [7 : 0] probe_out2
      .probe_out3(h_lower_red),    // output wire [7 : 0] probe_out3
      .probe_out4(s_upper_green),    // output wire [7 : 0] probe_out4
      .probe_out5(s_lower_green),    // output wire [7 : 0] probe_out5
      .probe_out6(s_upper_red),    // output wire [7 : 0] probe_out6
      .probe_out7(s_lower_red),    // output wire [7 : 0] probe_out7
      .probe_out8(v_upper_green),    // output wire [7 : 0] probe_out8
      .probe_out9(v_lower_green),    // output wire [7 : 0] probe_out9
      .probe_out10(v_upper_red),  // output wire [7 : 0] probe_out10
      .probe_out11(v_lower_red),  // output wire [7 : 0] probe_out11
      .probe_out12(count_green_threshold),
      .probe_out13(count_red_threshold)
    );

                                        
   camera_read  my_camera(.p_clock_in(pclk_in),
                          .vsync_in(vsync_in),
                          .href_in(href_in),
                          .p_data_in(pixel_in),
                          .pixel_data_out(output_pixels),
                          .pixel_valid_out(valid_pixel),
                          .frame_done_out(frame_done_out));
   
    // UP and DOWN buttons for pong paddle
    wire up,down;
    debounce db2(.reset_in(reset),.clock_in(clk_65mhz),.noisy_in(btnu),.clean_out(up));
    debounce db3(.reset_in(reset),.clock_in(clk_65mhz),.noisy_in(btnd),.clean_out(down));


    reg b,hs,vs;
    always_ff @(posedge clk_65mhz) begin
         // default: pong
         hs <= hsync;
         vs <= vsync;
         b <= blank;
//         if (pixel > 0 && hcount<320 && vcount<240) begin
//            rgb <= pixel;
            
         /*if (hcount <320 && vcount<240 && (vcount==centroid_y || hcount==centroid_x)) begin
            rgb <= 12'hF00;
         //end else if (green && hcount<320 && vcount<240) begin
           // rgb <= 12'h062;
         end else begin
            rgb <= cam; 
            //rgb <= 12'h000;
         end*/
    end

    logic [23:0] rgb24;

    hdmi hdmi (
      .TMDS_Clk_p(hdmi_tx_clk_p),    // output wire TMDS_Clk_p
      .TMDS_Clk_n(hdmi_tx_clk_n),    // output wire TMDS_Clk_n
      .TMDS_Data_p(hdmi_tx_p),  // output wire [2 : 0] TMDS_Data_p
      .TMDS_Data_n(hdmi_tx_n),  // output wire [2 : 0] TMDS_Data_n
      .aRst(1'b0),                // input wire aRst
      .vid_pData(rgb24),      // input wire [23 : 0] vid_pData
      .vid_pVDE(~b),        // input wire vid_pVDE
      .vid_pHSync(~hs),    // input wire vid_pHSync
      .vid_pVSync(~vs),    // input wire vid_pVSync
      .PixelClk(clk_65mhz)        // input wire PixelClk
    );
    
    assign rgb24 = {rgb[11:8], 4'hF, rgb[3:0], 4'hF, rgb[7:4], 4'hF};
    
    logic [21:0] hsync_shift_reg;
    logic [21:0] vsync_shift_reg;
    logic [4:0] sync_dly;
    assign sync_dly = 22;
    
//    assign hs = hsync_shift_reg[sync_dly-1];
//    assign vs = vsync_shift_reg[sync_dly-1];

    //assign hsync_out = hsync_shift_reg[sync_dly-1];
    //for hs, vs, and b (blank_out)
    //dwofk virtual passport
    //assign v_sync = vsync_out;

endmodule

////////////////////////////////////////////////////////////////////////////////
//
// pong_game: the game itself!
//
////////////////////////////////////////////////////////////////////////////////

module pong_game (
   input vclock_in,        // 65MHz clock
   input reset_in,         // 1 to initialize module
   input up_in,            // 1 when paddle should move up
   input down_in,          // 1 when paddle should move down
   input [3:0] pspeed_in,  // puck speed in pixels/tick 
   input [10:0] hcount_in, // horizontal index of current pixel (0..1023)
   input [9:0]  vcount_in, // vertical index of current pixel (0..767)
   input hsync_in,         // XVGA horizontal sync signal (active low)
   input vsync_in,         // XVGA vertical sync signal (active low)
   input blank_in,         // XVGA blanking (1 means output black pixel)
   input [10:0] centroid_x,
   input [9:0] centroid_y,
        
   output phsync_out,       // pong game's horizontal sync
   output pvsync_out,       // pong game's vertical sync
   output pblank_out,       // pong game's blanking
   output [11:0] pixel_out  // pong game's pixel  // r=23:16, g=15:8, b=7:0 
   );

   //wire [2:0] checkerboard;
        
   // REPLACE ME! The code below just generates a color checkerboard
   // using 64 pixel by 64 pixel squares.
   
   assign phsync_out = hsync_in;
   assign pvsync_out = vsync_in;
   assign pblank_out = blank_in;
   //assign checkerboard = hcount_in[8:6] + vcount_in[8:6];

   // here we use three bits from hcount and vcount to generate the
   // checkerboard

   //assign pixel_out = {{4{checkerboard[2]}}, {4{checkerboard[1]}}, {4{checkerboard[0]}}} ;
         blob #(.WIDTH(10),.HEIGHT(6),.COLOR(12'h0F0))   // green
        square(.x_in(centroid_x),.y_in(centroid_y),.hcount_in(hcount_in),.vcount_in(vcount_in),
             .pixel_out(pixel_out));
endmodule

module synchronize #(parameter NSYNC = 3)  // number of sync flops.  must be >= 2
                   (input clk,in,
                    output reg out);

  reg [NSYNC-2:0] sync;

  always_ff @ (posedge clk)
  begin
    {out,sync} <= {sync[NSYNC-2:0],in};
  end
endmodule

///////////////////////////////////////////////////////////////////////////////
//
// Pushbutton Debounce Module (video version - 24 bits)  
//
///////////////////////////////////////////////////////////////////////////////

module debounce (input reset_in, clock_in, noisy_in,
                 output reg clean_out);

   reg [19:0] count;
   reg new_input;

//   always_ff @(posedge clock_in)
//     if (reset_in) begin new <= noisy_in; clean_out <= noisy_in; count <= 0; end
//     else if (noisy_in != new) begin new <= noisy_in; count <= 0; end
//     else if (count == 650000) clean_out <= new;
//     else count <= count+1;

   always_ff @(posedge clock_in)
     if (reset_in) begin 
        new_input <= noisy_in; 
        clean_out <= noisy_in; 
        count <= 0; end
     else if (noisy_in != new_input) begin new_input<=noisy_in; count <= 0; end
     else if (count == 650000) clean_out <= new_input;
     else count <= count+1;


endmodule

//////////////////////////////////////////////////////////////////////////////////
// Engineer:   g.p.hom
// 
// Create Date:    18:18:59 04/21/2013 
// Module Name:    display_8hex 
// Description:  Display 8 hex numbers on 7 segment display
//
//////////////////////////////////////////////////////////////////////////////////

module display_8hex(
    input clk_in,                 // system clock
    input [31:0] data_in,         // 8 hex numbers, msb first
    output reg [6:0] seg_out,     // seven segment display output
    output reg [7:0] strobe_out   // digit strobe
    );

    localparam bits = 13;
     
    reg [bits:0] counter = 0;  // clear on power up
     
    wire [6:0] segments[15:0]; // 16 7 bit memorys
    assign segments[0]  = 7'b100_0000;  // inverted logic
    assign segments[1]  = 7'b111_1001;  // gfedcba
    assign segments[2]  = 7'b010_0100;
    assign segments[3]  = 7'b011_0000;
    assign segments[4]  = 7'b001_1001;
    assign segments[5]  = 7'b001_0010;
    assign segments[6]  = 7'b000_0010;
    assign segments[7]  = 7'b111_1000;
    assign segments[8]  = 7'b000_0000;
    assign segments[9]  = 7'b001_1000;
    assign segments[10] = 7'b000_1000;
    assign segments[11] = 7'b000_0011;
    assign segments[12] = 7'b010_0111;
    assign segments[13] = 7'b010_0001;
    assign segments[14] = 7'b000_0110;
    assign segments[15] = 7'b000_1110;
     
    always_ff @(posedge clk_in) begin
      // Here I am using a counter and select 3 bits which provides
      // a reasonable refresh rate starting the left most digit
      // and moving left.
      counter <= counter + 1;
      case (counter[bits:bits-2])
          3'b000: begin  // use the MSB 4 bits
                  seg_out <= segments[data_in[31:28]];
                  strobe_out <= 8'b0111_1111 ;
                 end

          3'b001: begin
                  seg_out <= segments[data_in[27:24]];
                  strobe_out <= 8'b1011_1111 ;
                 end

          3'b010: begin
                   seg_out <= segments[data_in[23:20]];
                   strobe_out <= 8'b1101_1111 ;
                  end
          3'b011: begin
                  seg_out <= segments[data_in[19:16]];
                  strobe_out <= 8'b1110_1111;        
                 end
          3'b100: begin
                  seg_out <= segments[data_in[15:12]];
                  strobe_out <= 8'b1111_0111;
                 end

          3'b101: begin
                  seg_out <= segments[data_in[11:8]];
                  strobe_out <= 8'b1111_1011;
                 end

          3'b110: begin
                   seg_out <= segments[data_in[7:4]];
                   strobe_out <= 8'b1111_1101;
                  end
          3'b111: begin
                  seg_out <= segments[data_in[3:0]];
                  strobe_out <= 8'b1111_1110;
                 end

       endcase
      end

endmodule

//////////////////////////////////////////////////////////////////////////////////
// Update: 8/8/2019 GH 
// Create Date: 10/02/2015 02:05:19 AM
// Module Name: xvga
//
// xvga: Generate VGA display signals (1024 x 768 @ 60Hz)
//
//                              ---- HORIZONTAL -----     ------VERTICAL -----
//                              Active                    Active
//                    Freq      Video   FP  Sync   BP      Video   FP  Sync  BP
//   640x480, 60Hz    25.175    640     16    96   48       480    11   2    31
//   800x600, 60Hz    40.000    800     40   128   88       600     1   4    23
//   1024x768, 60Hz   65.000    1024    24   136  160       768     3   6    29
//   1280x1024, 60Hz  108.00    1280    48   112  248       768     1   3    38
//   1280x720p 60Hz   75.25     1280    72    80  216       720     3   5    30
//   1920x1080 60Hz   148.5     1920    88    44  148      1080     4   5    36
//
// change the clock frequency, front porches, sync's, and back porches to create 
// other screen resolutions
////////////////////////////////////////////////////////////////////////////////

module xvga(input vclock_in,
            output reg [10:0] hcount_out,    // pixel number on current line
            output reg [9:0] vcount_out,     // line number
            output reg vsync_out, hsync_out,
            output reg blank_out);

   parameter DISPLAY_WIDTH  = 1024;      // display width
   parameter DISPLAY_HEIGHT = 768;       // number of lines

   parameter  H_FP = 24;                 // horizontal front porch
   parameter  H_SYNC_PULSE = 136;        // horizontal sync
   parameter  H_BP = 160;                // horizontal back porch

   parameter  V_FP = 3;                  // vertical front porch
   parameter  V_SYNC_PULSE = 6;          // vertical sync 
   parameter  V_BP = 29;                 // vertical back porch

   // horizontal: 1344 pixels total
   // display 1024 pixels per line
   reg hblank,vblank;
   wire hsyncon,hsyncoff,hreset,hblankon;
   assign hblankon = (hcount_out == (DISPLAY_WIDTH -1));    
   assign hsyncon = (hcount_out == (DISPLAY_WIDTH + H_FP - 1));  //1047
   assign hsyncoff = (hcount_out == (DISPLAY_WIDTH + H_FP + H_SYNC_PULSE - 1));  // 1183
   assign hreset = (hcount_out == (DISPLAY_WIDTH + H_FP + H_SYNC_PULSE + H_BP - 1));  //1343

   // vertical: 806 lines total
   // display 768 lines
   wire vsyncon,vsyncoff,vreset,vblankon;
   assign vblankon = hreset & (vcount_out == (DISPLAY_HEIGHT - 1));   // 767 
   assign vsyncon = hreset & (vcount_out == (DISPLAY_HEIGHT + V_FP - 1));  // 771
   assign vsyncoff = hreset & (vcount_out == (DISPLAY_HEIGHT + V_FP + V_SYNC_PULSE - 1));  // 777
   assign vreset = hreset & (vcount_out == (DISPLAY_HEIGHT + V_FP + V_SYNC_PULSE + V_BP - 1)); // 805

   // sync and blanking
   wire next_hblank,next_vblank;
   assign next_hblank = hreset ? 0 : hblankon ? 1 : hblank;
   assign next_vblank = vreset ? 0 : vblankon ? 1 : vblank;
   always_ff @(posedge vclock_in) begin
      hcount_out <= hreset ? 0 : hcount_out + 1;
      hblank <= next_hblank;
      hsync_out <= hsyncon ? 0 : hsyncoff ? 1 : hsync_out;  // active low

      vcount_out <= hreset ? (vreset ? 0 : vcount_out + 1) : vcount_out;
      vblank <= next_vblank;
      vsync_out <= vsyncon ? 0 : vsyncoff ? 1 : vsync_out;  // active low

      blank_out <= next_vblank | (next_hblank & ~hreset);
   end
   
endmodule


