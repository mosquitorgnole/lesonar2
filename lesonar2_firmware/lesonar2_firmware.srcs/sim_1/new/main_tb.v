`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.03.2024 21:30:53
// Design Name: 
// Module Name: main_tb
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


module main_tb();
    reg ft_clk;
    reg mic_wire[190];
    reg ft_clk;
    reg ft_txe_n;
    reg ft_rxf_n;
    
    wire [31:0] ft_data;
    inout ft_be;

    localparam CLK_PERIOD = 15;
    localparam MIC_PERIOD = 2400;

    initial ft_clk = 1'b0;
    initial mic_wire = 190'b0;

    always #(CLK_PERIOD/2.0) 
        ft_clk = ~ft_clk;
    always #(MIC_PERIOD/2.0)
        mic_wire = ~mic_wire;

endmodule
