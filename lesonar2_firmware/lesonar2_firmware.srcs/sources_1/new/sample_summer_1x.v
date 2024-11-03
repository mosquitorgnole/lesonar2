`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/05/2024 12:21:38 PM
// Design Name:
// Module Name: sample_summer_1x
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


module sample_summer_1x(
    input wire i_clk,
    input wire i_sample,
    input wire i_zero_enable,
    input wire [11:0] i_coeff_counter,
    input wire signed [31:0] i_cos_coeff,
    input wire signed [31:0] i_sin_coeff,
    output reg signed [0:15] o_accumulator_cos,
    output reg signed [0:15] o_accumulator_sin,
    input wire rst
);

reg signed [31:0] cos_coeff;
reg signed [31:0] sin_coeff;

reg signed [31:0] next_cos_coeff;
reg signed [31:0] next_sin_coeff;

reg signed [0:31] cos_acc;
reg signed [0:31] sin_acc;

always @(posedge i_clk) begin
    if(rst) begin
        cos_acc <= 0;
        sin_acc <= 0;

        next_cos_coeff <= 0;
        next_sin_coeff <= 0;

        o_accumulator_cos <= 0;
        o_accumulator_sin <= 0;

    end else begin
        cos_coeff <= i_cos_coeff;
        sin_coeff <= i_sin_coeff;
        if(i_sample) begin
            next_cos_coeff <= cos_coeff;
            next_sin_coeff <= sin_coeff;
        end else begin
            next_cos_coeff <= -cos_coeff;
            next_sin_coeff <= -sin_coeff;
        end

        if(i_zero_enable) begin
            cos_acc <= 0;
            sin_acc <= 0;
        end else begin
            cos_acc <= cos_acc + next_cos_coeff;
            sin_acc <= sin_acc + next_sin_coeff;
        end
        o_accumulator_cos <= (cos_acc[0:15]);
        o_accumulator_sin <= (sin_acc[0:15]);
    end
end


endmodule
