`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.04.2026 10:49:21
// Design Name: 
// Module Name: aes_axi
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

module aes_axi_ip #
(
    parameter ADDR_WIDTH = 6,
    parameter DATA_WIDTH = 32
)
(
    input  wire clk,
    input  wire rst,

    // ================= AXI4-Lite =================
    input  wire [ADDR_WIDTH-1:0] s_axi_awaddr,
    input  wire                  s_axi_awvalid,
    output wire                  s_axi_awready,

    input  wire [DATA_WIDTH-1:0] s_axi_wdata,
    input  wire                  s_axi_wvalid,
    output wire                  s_axi_wready,

    output reg                   s_axi_bvalid,
    input  wire                  s_axi_bready,

    input  wire [ADDR_WIDTH-1:0] s_axi_araddr,
    input  wire                  s_axi_arvalid,
    output wire                  s_axi_arready,

    output reg  [DATA_WIDTH-1:0] s_axi_rdata,
    output reg                   s_axi_rvalid,
    input  wire                  s_axi_rready,

    // ================= AXI-Stream =================
    input  wire [127:0] s_axis_tdata,
    input  wire         s_axis_tvalid,
    output wire         s_axis_tready,

    output wire [127:0] m_axis_tdata,
    output wire         m_axis_tvalid,
    input  wire         m_axis_tready
);

    // ================= AXI READY =================
    assign s_axi_awready = 1'b1;
    assign s_axi_wready  = 1'b1;
    assign s_axi_arready = 1'b1;

    // ================= REGISTERS =================
    reg [127:0] key_reg;
    reg start;
    reg done;

    // ================= WRITE LOGIC =================
    always @(posedge clk) begin
        if (rst) begin
            key_reg <= 0;
            start   <= 0;
            s_axi_bvalid <= 0;
        end else begin
            if (s_axi_awvalid && s_axi_wvalid) begin
                case (s_axi_awaddr)
                    6'h10: key_reg[127:96] <= s_axi_wdata;
                    6'h14: key_reg[95:64]  <= s_axi_wdata;
                    6'h18: key_reg[63:32]  <= s_axi_wdata;
                    6'h1C: key_reg[31:0]   <= s_axi_wdata;
                    6'h00: start           <= s_axi_wdata[0];
                endcase
                s_axi_bvalid <= 1'b1;
            end else if (s_axi_bready) begin
                s_axi_bvalid <= 0;
            end
        end
    end

    // ================= READ LOGIC =================
    always @(posedge clk) begin
        if (rst) begin
            s_axi_rvalid <= 0;
            s_axi_rdata  <= 0;
        end else begin
            if (s_axi_arvalid) begin
                case (s_axi_araddr)
                    6'h00: s_axi_rdata <= {31'b0, start};
                    6'h04: s_axi_rdata <= {31'b0, done};
                    6'h10: s_axi_rdata <= key_reg[127:96];
                    6'h14: s_axi_rdata <= key_reg[95:64];
                    6'h18: s_axi_rdata <= key_reg[63:32];
                    6'h1C: s_axi_rdata <= key_reg[31:0];
                    default: s_axi_rdata <= 0;
                endcase
                s_axi_rvalid <= 1'b1;
            end else if (s_axi_rready) begin
                s_axi_rvalid <= 0;
            end
        end
    end

    // ================= AES CORE =================
    wire core_valid_out;

    top aes_core (
        .clk(clk),
        .rst(rst),

        .s_axis_tdata(s_axis_tdata),
        .s_axis_tvalid(s_axis_tvalid),
        .s_axis_tready(s_axis_tready),

        .m_axis_tdata(m_axis_tdata),
        .m_axis_tvalid(core_valid_out),
        .m_axis_tready(m_axis_tready),

        .key(key_reg)
    );

    assign m_axis_tvalid = core_valid_out;

    // ================= STATUS =================
    always @(posedge clk) begin
        if (rst)
            done <= 0;
        else if (core_valid_out)
            done <= 1;
        else if (start)
            done <= 0;
    end

endmodule