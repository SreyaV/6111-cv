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
module centroid(clock, reset, x, y, green, centroid_x, centroid_y, frame_done, count);
    input logic clock;
    input logic reset;
    input logic [10:0] x;
    input logic [9:0] y;
    input logic green;
    input logic frame_done;
    
    output logic [10:0] centroid_x;
    output logic [9:0] centroid_y;
    logic [26:0] x_acc;
    logic [25:0] y_acc;
    output logic [0:16] count;
    logic last_frame_done;
    
    always_ff @(posedge clock) begin
        if (reset) begin
            x_acc <= 0;
            y_acc <= 0;
            count <= 0;
            centroid_x <= 0;
            centroid_y <= 0;
        end
        else if (frame_done) begin
            if (count >25000) begin 
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
                centroid_x <= x_acc>>12;
                centroid_y <= y_acc>>12;
            end
         end
         else if (!frame_done && last_frame_done) begin
            x_acc <= 0;
            y_acc <= 0;
            count <= 0;
         end
         else begin
            if (green) begin
                x_acc <= x_acc + x;
                y_acc <= y_acc + y;
                count <= count + 1;
            end
         end
         last_frame_done <= frame_done;
    end
    
    
     
endmodule
