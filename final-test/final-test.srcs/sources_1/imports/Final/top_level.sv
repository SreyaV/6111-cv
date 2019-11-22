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
   input clk_100mhz,
   input[15:0] sw,
   input btnc, btnu, btnl, btnr, btnd,
   input [7:0] ja,
   input [2:0] jb,
   output   jbclk,
   input [2:0] jd,
   output   jdclk,
   output[3:0] vga_r,
   output[3:0] vga_b,
   output[3:0] vga_g,
   //output [7:0] hue,
   //output [7:0] saturation,
   //output [7:0] value,
   output vga_hs, //delay 22 cycles
   output vga_vs, //delay 22 cycles
   output led16_b, led16_g, led16_r,
   output led17_b, led17_g, led17_r,
   output[15:0] led,
   output ca, cb, cc, cd, ce, cf, cg, dp,  // segments a-g, dp
   output[7:0] an    // Display location 0-7
   );
    logic clk_65mhz;
    // create 65mhz system clock, happens to match 1024 x 768 XVGA timing
    //clk_wiz_0 clkdivider(.clk_in1(clk_100mhz), .clk_out1(clk_65mhz));
    clk_wiz_lab3 clkdivider(.clk_in1(clk_100mhz), .clk_out1(clk_65mhz));

    wire [31:0] data;      //  instantiate 7-segment display; display (8) 4-bit hex
    wire [6:0] segments;
    assign {cg, cf, ce, cd, cc, cb, ca} = segments[6:0];
    //display_8hex display(.clk_in(clk_65mhz),.data_in(data), .seg_out(segments), .strobe_out(an));
    //assign seg[6:0] = segments;
    assign  dp = 1'b1;  // turn off the period

    assign led = sw;                        // turn leds on
    assign data = {28'h0123456, sw[3:0]};   // display 0123456 + sw[3:0]
    assign led16_r = btnl;                  // left button -> red led
    assign led16_g = btnc;                  // center button -> green led
    assign led16_b = btnr;                  // right button -> blue led
    assign led17_r = btnl;
    assign led17_g = btnc;
    assign led17_b = btnr;

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
    
    logic [10:0] centroid_x;
    logic [9:0] centroid_y;
    wire green;
    logic frame_done;
    
    logic [15:0] averaging;
    assign averaging = sw;
    
    logic [6:0] h_upper;
    logic [6:0] h_lower;
    logic [7:0] v_upper;
    logic [5:0] v_lower;
    
    logic [10:0] hcount_camera;
    logic [9:0] vcount_camera;
    logic [10:0] hcount_fifo;
    logic [9:0] vcount_fifo;
    
    
    
    assign xclk = (xclk_count >2'b01);
    assign jbclk = xclk;
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
        pclk_buff <= jb[0];//WAS JB
        vsync_buff <= jb[1]; //WAS JB
        href_buff <= jb[2]; //WAS JB
        pixel_buff <= ja;
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
    assign h_upper = 96;
    assign h_lower = 30;
//    assign h_upper = sw[15:9]; //96
//    assign h_lower = sw[6:0]; //48
    assign v_upper = 255;
    assign v_lower = 240;
//    assign v_upper = sw[15:8];
//    assign v_lower = sw[7:0];

    logic empty_p;
    
     pipeline #(.N_BITS(1), .N_REGISTERS(22)) pipeline_x(
        .clk_in(clk_65mhz), 
        .rst_in(reset),
        .data_in(empty),
        .data_out(empty_p));

    assign cam = frame_buff_out;
    
    rgb2hsv rgb2hsv1 (.clock(clk_65mhz), .reset(reset), .r(cam[11:8]<<4), .g(cam[7:4]<<4), .b(cam[3:0]<<4), .green(green), .h_upper(h_upper), .h_lower(h_lower), .v_upper(v_upper), .v_lower(v_lower), .out_v(out_v));
    
    logic [16:0] count;
    logic [26:0] x_acc;
    
    centroid centroid1 (.x_acc(x_acc),.clock(clk_65mhz), .reset(reset), .x(hcount_fifo), .y(vcount_fifo), .green(!empty_p ? green : 0), .frame_done(frame_done), .centroid_x(centroid_x), .centroid_y(centroid_y), .count(count), .averaging(averaging));
    
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
       
       blk_mem_gen_0 jojos_bram(.addra(pixel_addr_in), 
                             .clka(clk_65mhz),
                             .dina((hcount_fifo==centroid_x || vcount_fifo==centroid_y) ? 12'hF00 : green ? 12'h062 : cam),
                             .wea(!delayed_empty),
                             .addrb(vga_pixel_addr_out),
                             .clkb(clk_65mhz),
                             .doutb(temp_rgb));
                             
    assign rgb = (hcount<320 && vcount<240) ? temp_rgb : 0;
    
    logic [7:0] display_v;
    assign display_v = (hcount==160 && vcount==120) ? out_v : display_v;
    
    display_8hex display(.clk_in(clk_65mhz),.data_in(x_acc), .seg_out(segments), .strobe_out(an));
    
    //hcount vcount and frame_buff_out bc theyre all synchronized here
    //put throug rgb to hsv module
    //use a shift register to delay 22 counts
    
//    ila_0 joes_ila(.clk(clk_65mhz),    .probe0(pixel_in), 
//                                        .probe1(pclk_in), 
//                                        .probe2(vsync_in),
//                                        .probe3(href_in),
//                                        .probe4(jbclk));


                                        
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

    wire phsync,pvsync,pblank;
    pong_game pg(.vclock_in(clk_65mhz),.reset_in(reset),
                .up_in(up),.down_in(down),.pspeed_in(sw[15:12]),
                .hcount_in(hcount),.vcount_in(vcount),
                .hsync_in(hsync),.vsync_in(vsync),.blank_in(blank),
                .phsync_out(phsync),.pvsync_out(pvsync),.pblank_out(pblank),.pixel_out(pixel), .centroid_x(centroid_x), .centroid_y(centroid_y));

    wire border = (hcount==0 | hcount==1023 | vcount==0 | vcount==767 |
                   hcount == 512 | vcount == 384);

    reg b,hs,vs;
    always_ff @(posedge clk_65mhz) begin
         // default: pong
         hs <= phsync;
         vs <= pvsync;
         b <= pblank;
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

//    assign rgb = sw[0] ? {12{border}} : pixel ; //{{4{hcount[7]}}, {4{hcount[6]}}, {4{hcount[5]}}};

    // the following lines are required for the Nexys4 VGA circuit - do not change
    assign vga_r = ~b ? rgb[11:8]: 0;
    assign vga_g = ~b ? rgb[7:4] : 0;
    assign vga_b = ~b ? rgb[3:0] : 0;
    

    assign vga_hs = ~hs;
    assign vga_vs = ~vs;
    
    logic [21:0] hsync_shift_reg;
    logic [21:0] vsync_shift_reg;
    logic [4:0] sync_dly;
    assign sync_dly = 22;
    
    assign hs = hsync_shift_reg[sync_dly-1];
    assign vs = vsync_shift_reg[sync_dly-1];

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


