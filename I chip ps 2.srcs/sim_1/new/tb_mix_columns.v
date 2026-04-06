`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2026 11:02:43
// Design Name: 
// Module Name: tb_mix_columns
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


module tb_mix_columns(

    );
    
    reg  [127:0] data_in;
    wire [127:0] data_out;

    mix_columns uut (
        .data_in(data_in),
        .data_out(data_out)
    );

    initial begin
    
    data_in = 128'h0;
    data_in[127:0] = 128'h00112233445566778899aabbccddeeff;
    #10;
    $display("Input  = %h", data_in[127:0]);
    $display("Output = %h", data_out[127:0]);
    end
endmodule
