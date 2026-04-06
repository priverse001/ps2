`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2026 01:32:27
// Design Name: 
// Module Name: tb_sub_bytes
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

module tb_sub_bytes;

reg  [127:0] data_in;
wire [127:0] data_out;

// Instantiate your module
sub_bytes uut (
    .data_in(data_in),
    .data_out(data_out)
);

initial begin
    // Initialize
    data_in = 128'h0;

    data_in[7:0] = 8'h53; #10;  // expect ed

    #10;  // wait for combinational logic

    // Display result
    $display("Input  = %h", data_in[7:0]);
    $display("Output = %h", data_out[7:0]);

    // Check correctness
    if (data_out[7:0] == 8'hED)
        $display("? PASS");
    else
        $display("? FAIL");

    $finish;
end

endmodule
