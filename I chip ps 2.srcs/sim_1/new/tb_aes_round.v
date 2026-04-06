`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2026 15:09:20
// Design Name: 
// Module Name: tb_aes_round
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


module tb_aes_round(

    );
    
    reg  [127:0] data_in;
    reg  [127:0] round_key;
    wire [127:0] data_out;
    
    aes_round u1(
    .data_in(data_in),
    .round_key(round_key),
    .data_out(data_out)
    );
    
    initial
    begin
        data_in[127:0] = 128'h00112233445566778899aabbccddeeff;
        round_key[127:0] = 128'h000102030405060708090a0b0c0d0e0f;
        #10;
        $display("Input  = %h", data_in[127:0]);
        $display("Output = %h", data_out[127:0]);
    end
endmodule
