`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2026 20:20:36
// Design Name: 
// Module Name: tb_key_expansion_round
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


module tb_key_expansion_round(

    );

reg  [127:0] input_key;
reg  [3:0]   round;
wire [127:0] output_key;

// Instantiate DUT
key_expansion_round uut (
    .input_key(input_key),
    .round(round),
    .output_key(output_key)
);

initial begin

    // Apply test vector
    input_key = 128'h2b7e151628aed2a6abf7158809cf4f3c;
    round     = 4'd1;

    #20;  // wait for combinational logic
    
    $display("W3        = %h", input_key[31:0]);
    $display("RotWord   = %h", uut.rotword);
    $display("SubWord   = %h", uut.subword);
    $display("Rcon      = %h", uut.rcon(round));
    $display("Temp      = %h", uut.temp);
    $display("W4        = %h", uut.output_key[127:96]);

    $display("Input Key  = %h", input_key);
    $display("Round      = %d", round);
    $display("Output Key = %h", output_key);

    // Expected check
    if (output_key == 128'ha0fafe1788542cb123a339392a6c7605)
        $display("? TEST PASSED");
    else
        $display("? TEST FAILED");

    $finish;
end

endmodule
