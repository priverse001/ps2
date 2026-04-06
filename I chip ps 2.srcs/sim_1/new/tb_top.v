`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2026 20:56:00
// Design Name: 
// Module Name: tb_top
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


module tb_top;

reg  [127:0] input_data;
reg  [127:0] key;
wire [127:0] output_data;

top uut (
    .input_data(input_data),
    .key(key),
    .output_data(output_data)
);

initial begin

    input_data = 128'h00112233445566778899aabbccddeeff;
    key       = 128'h000102030405060708090a0b0c0d0e0f;

    #20;  // allow propagation through full combinational path

    // Display values
    $display("input  = %h", input_data);
    $display("Key        = %h", key);
    $display("After ARK   = %h", uut.s0);
    $display("After R1    = %h", uut.s1);
    $display("After SubBytes = %h", uut.r1.sub_bytes_out);
    $display("After ShiftRows = %h", uut.r1.shift_rows_out);
    $display("After MixColumns = %h", uut.r1.mix_columns_out);
    $display("After R5    = %h", uut.s5);
    $display("After R9    = %h", uut.s9);
    $display("output = %h", output_data);

    // Check result
    if (output_data == 128'h69c4e0d86a7b0430d8cdb78070b4c55a)
        $display("? AES TEST PASSED");
    else begin
        $display("? AES TEST FAILED");
        $display("Expected   = 69c4e0d86a7b0430d8cdb78070b4c55a");
    end

    $finish;
end

endmodule
