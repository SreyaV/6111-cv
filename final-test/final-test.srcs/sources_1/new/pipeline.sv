`timescale 1ns / 1ps

module pipeline(
    input clk_in,
    input rst_in,
    input [(N_BITS-1):0] data_in,
    output logic [(N_BITS-1):0] data_out); 
    parameter N_BITS = 1;
    parameter N_REGISTERS = 2; // If just one register do manually
    
    logic [(N_BITS * N_REGISTERS - 1):0] buffer ;
    always_ff @(posedge clk_in) begin
        if (rst_in) begin
            buffer <= 0;
        end else begin 
            buffer <= {data_in, buffer[(N_BITS * N_REGISTERS - 1):N_BITS]};
        end
    
    end
    assign data_out = buffer[(N_BITS - 1):0];

endmodule