`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.04.2026 20:02:47
// Design Name: 
// Module Name: tb_aes_pipeline
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

module tb_aes_pipeline;

reg clk;
reg rst;
reg valid_in;

reg [127:0] plaintext;
reg [127:0] key;

wire [127:0] ciphertext;
wire valid_out;

// DUT
top uut (
    .clk(clk),
    .rst(rst),
    .input_data(plaintext),
    .key(key),
    .output_data(ciphertext),
    .valid_in(valid_in),
    .valid_out(valid_out)
);


// Clock generation
always #5 clk = ~clk;


// Test vectors (from AES standard)
reg [127:0] pt_mem [0:3];
reg [127:0] ct_expected [0:3];

integer i;
integer out_count;

initial begin
    clk = 0;
    rst = 1;
    valid_in = 0;

    // Standard AES test vector
    key = 128'h000102030405060708090a0b0c0d0e0f;

    pt_mem[0] = 128'h00112233445566778899aabbccddeeff;
    pt_mem[1] = 128'h00112233445566778899aabbccddeeff;
    pt_mem[2] = 128'h00112233445566778899aabbccddeeff;
    pt_mem[3] = 128'h00112233445566778899aabbccddeeff;

    ct_expected[0] = 128'h69c4e0d86a7b0430d8cdb78070b4c55a;
    ct_expected[1] = 128'h69c4e0d86a7b0430d8cdb78070b4c55a;
    ct_expected[2] = 128'h69c4e0d86a7b0430d8cdb78070b4c55a;
    ct_expected[3] = 128'h69c4e0d86a7b0430d8cdb78070b4c55a;

    #20 rst = 0;

    // Feed inputs continuously
    for (i = 0; i < 4; i = i + 1) begin
        @(posedge clk);
        plaintext <= pt_mem[i];
        valid_in <= 1;
    end

    // Stop input
    @(posedge clk);
    valid_in <= 0;

end


// Output checking
integer check_idx = 0;

always @(posedge clk) begin
    if (valid_out) begin
        $display("Output %0d = %h", check_idx, ciphertext);

        if (ciphertext == ct_expected[check_idx])
            $display("? PASS");
        else
            $display("? FAIL (Expected = %h)", ct_expected[check_idx]);

        check_idx = check_idx + 1;
    end
end


// Finish simulation
initial begin
    #300;
    $finish;
end

endmodule
