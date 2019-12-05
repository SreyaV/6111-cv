`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2019 01:18:17 PM
// Design Name: 
// Module Name: centroid
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//x and y coordinate signal
//frame done
//update centroid_x, centroid_y when done
//send in x, y, isgreen
module centroid(clock, reset, x, y, color, centroid_x, centroid_y, frame_done, count_out, detected, count_threshold);
    input logic clock;
    input logic reset;
    input logic [10:0] x;
    input logic [9:0] y;
    input logic color;
    input logic frame_done;
    input [16:0] count_threshold;
    logic [15:0] averaging;
    output logic [10:0] centroid_x;
    output logic [9:0] centroid_y;
    output logic detected;
    logic [55:0] centroid_x_temp;
    logic [55:0] centroid_y_temp;
    logic [26:0] x_acc;
    logic [26:0] y_acc;
    logic [16:0] count;
    output logic [16:0] count_out;
    logic last_frame_done;
    logic ready;
    
    always_ff @(posedge clock) begin
        if (reset) begin
            x_acc <= 0;
            y_acc <= 0;
            count <= 0;
            centroid_x <= 0;
            centroid_y <= 0;
            ready <= 0;
        end
        else if (frame_done) begin
            /*if (count >25000) begin 
                centroid_x <= x_acc>>15;
                centroid_y <= y_acc>>15;
            end else if (count >12000) begin
                centroid_x <= x_acc>>14;
                centroid_y <= y_acc>>14;
            end else if (count >6000) begin
                centroid_x <= x_acc>>13;
                centroid_y <= y_acc>>13;
            end else if (count < 100) begin
                centroid_x <= x_acc>>6;
                centroid_y <= y_acc>>6;
            end else begin
                centroid_x <= x_acc>>13;
                centroid_y <= y_acc>>13;
            end*/
            //ready <= 1;
            count_out <= count;
            if (count > count_threshold) begin
                centroid_x <= centroid_x_temp[33:24];  //d or e (13 or 14) seems good
                centroid_y <= centroid_y_temp[32:24];
                detected<=1;
            end
            else begin
                detected<=0;
            end
         end    
         else if (!frame_done && last_frame_done) begin
            x_acc <= 0;
            y_acc <= 0;
            count <= 0;
            ready <= 0;
         end
         else begin
            if (color) begin
                x_acc <= x_acc + x;
                y_acc <= y_acc + y;
                count <= count + 1;
            end
         end
         last_frame_done <= frame_done;
    end
    
    centroid_div xcenter(
    .aclk(clock),
    .s_axis_divisor_tdata(count),
    .s_axis_divisor_tvalid(1),
    .s_axis_dividend_tdata(x_acc),
    .s_axis_dividend_tvalid(1),
    .m_axis_dout_tdata(centroid_x_temp),
    .m_axis_dout_tvalid()
  );
  
  centroid_div ycenter(
    .aclk(clock),
    .s_axis_divisor_tdata(count),
    .s_axis_divisor_tvalid(1),
    .s_axis_dividend_tdata(y_acc),
    .s_axis_dividend_tvalid(1),
    .m_axis_dout_tdata(centroid_y_temp),
    .m_axis_dout_tvalid()
  );
    
    
     
endmodule