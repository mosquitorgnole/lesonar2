`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/05/2024 12:00:24 PM
// Design Name:
// Module Name: 2048_fir_coeff_table
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


module fir_coeff_table_2048(
    input wire i_clk,
    input wire [11:0] i_coeff_counter,
    output wire signed [31:0] o_cos_coeff,
    output wire signed [31:0] o_sin_coeff,
    input wire rst
);

reg signed [31:0] cos_coeff;
reg signed [31:0] sin_coeff;

assign o_cos_coeff = cos_coeff;
assign o_sin_coeff = sin_coeff;

wire signed[31:0] mem_out_cos;
wire signed[31:0] mem_out_sin;

// 11 LSB bits : 0-2047
wire [10:0] coeff_addr ;
assign coeff_addr = i_coeff_counter[10:0];

always @(posedge i_clk) begin
    if(rst) begin
        sin_coeff <= 0;
        cos_coeff <= 0;

    end else if(i_coeff_counter < 2048) begin
        cos_coeff <= mem_out_cos;
        sin_coeff <= mem_out_sin;
    end else begin
        sin_coeff <= 0;
        cos_coeff <= 0;
    end
end




xpm_memory_sdpram #(
    .ADDR_WIDTH_A(11),               // DECIMAL
    .ADDR_WIDTH_B(11),               // DECIMAL
    .AUTO_SLEEP_TIME(0),            // DECIMAL
    .BYTE_WRITE_WIDTH_A(32),        // DECIMAL
    .CASCADE_HEIGHT(0),             // DECIMAL
    .CLOCKING_MODE("common_clock"), // String
    .ECC_BIT_RANGE("7:0"),          // String
    .ECC_MODE("no_ecc"),            // String
    .ECC_TYPE("none"),              // String
    .IGNORE_INIT_SYNTH(0),          // DECIMAL
    .MEMORY_INIT_FILE("cosine_2048_lowpass_1000_40k.mem"),      // String
    .MEMORY_INIT_PARAM(""),        // String
    .MEMORY_OPTIMIZATION("true"),   // String
    .MEMORY_PRIMITIVE("auto"),      // String
    .MEMORY_SIZE(2048*32),             // DECIMAL
    .MESSAGE_CONTROL(0),            // DECIMAL
    .RAM_DECOMP("auto"),            // String
    .READ_DATA_WIDTH_B(32),         // DECIMAL
    .READ_LATENCY_B(3),             // DECIMAL
    .READ_RESET_VALUE_B("0"),       // String
    .RST_MODE_A("SYNC"),            // String
    .RST_MODE_B("SYNC"),            // String
    .SIM_ASSERT_CHK(0),             // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
    .USE_EMBEDDED_CONSTRAINT(0),    // DECIMAL
    .USE_MEM_INIT(1),               // DECIMAL
    .USE_MEM_INIT_MMI(0),           // DECIMAL
    .WAKEUP_TIME("disable_sleep"),  // String
    .WRITE_DATA_WIDTH_A(32),        // DECIMAL
    .WRITE_MODE_B("no_change"),     // String
    .WRITE_PROTECT(1)               // DECIMAL
)
xpm_memory_sdpram_cos (
    //.dbiterrb(dbiterrb),             // 1-bit output: Status signal to indicate double bit error occurrence
    // on the data output of port B.

    .doutb(mem_out_cos),                   // READ_DATA_WIDTH_B-bit output: Data output for port B read operations.
    //.sbiterrb(sbiterrb),             // 1-bit output: Status signal to indicate single bit error occurrence
    // on the data output of port B.

    .addra(0),                   // ADDR_WIDTH_A-bit input: Address for port A write operations.
    .addrb(coeff_addr),                   // ADDR_WIDTH_B-bit input: Address for port B read operations.
    .clka(i_clk),                     // 1-bit input: Clock signal for port A. Also clocks port B when
    // parameter CLOCKING_MODE is "common_clock".

    //.clkb(clkb),                     // 1-bit input: Clock signal for port B when parameter CLOCKING_MODE is
    // "independent_clock". Unused when parameter CLOCKING_MODE is
    // "common_clock".

    .dina(0),                     // WRITE_DATA_WIDTH_A-bit input: Data input for port A write operations.
    .ena(0),                       // 1-bit input: Memory enable signal for port A. Must be high on clock
    // cycles when write operations are initiated. Pipelined internally.

    .enb(1),                       // 1-bit input: Memory enable signal for port B. Must be high on clock
    // cycles when read operations are initiated. Pipelined internally.

    //.injectdbiterra(injectdbiterra), // 1-bit input: Controls double bit error injection on input data when
    // ECC enabled (Error injection capability is not available in
    // "decode_only" mode).

    //.injectsbiterra(injectsbiterra), // 1-bit input: Controls single bit error injection on input data when
    // ECC enabled (Error injection capability is not available in
    // "decode_only" mode).

    .regceb(1),                 // 1-bit input: Clock Enable for the last register stage on the output
    // data path.

    .rstb(0),                     // 1-bit input: Reset signal for the final port B output register stage.
    // Synchronously resets output port doutb to the value specified by
    // parameter READ_RESET_VALUE_B.

    .sleep(0),                   // 1-bit input: sleep signal to enable the dynamic power saving feature.
    .wea(11'b1)                        // WRITE_DATA_WIDTH_A/BYTE_WRITE_WIDTH_A-bit input: Write enable vector
    // for port A input data port dina. 1 bit wide when word-wide writes are
    // used. In byte-wide write configurations, each bit controls the
    // writing one byte of dina to address addra. For example, to
    // synchronously write only bits [15-8] of dina when WRITE_DATA_WIDTH_A
    // is 32, wea would be 4'b0010.

);

xpm_memory_sdpram #(
    .ADDR_WIDTH_A(11),               // DECIMAL
    .ADDR_WIDTH_B(11),               // DECIMAL
    .AUTO_SLEEP_TIME(0),            // DECIMAL
    .BYTE_WRITE_WIDTH_A(32),        // DECIMAL
    .CASCADE_HEIGHT(0),             // DECIMAL
    .CLOCKING_MODE("common_clock"), // String
    .ECC_BIT_RANGE("7:0"),          // String
    .ECC_MODE("no_ecc"),            // String
    .ECC_TYPE("none"),              // String
    .IGNORE_INIT_SYNTH(0),          // DECIMAL
    .MEMORY_INIT_FILE("sine_2048_lowpass_1000_40k.mem"),      // String
    .MEMORY_INIT_PARAM(""),        // String
    .MEMORY_OPTIMIZATION("true"),   // String
    .MEMORY_PRIMITIVE("auto"),      // String
    .MEMORY_SIZE(2048*32),             // DECIMAL
    .MESSAGE_CONTROL(0),            // DECIMAL
    .RAM_DECOMP("auto"),            // String
    .READ_DATA_WIDTH_B(32),         // DECIMAL
    .READ_LATENCY_B(3),             // DECIMAL
    .READ_RESET_VALUE_B("0"),       // String
    .RST_MODE_A("SYNC"),            // String
    .RST_MODE_B("SYNC"),            // String
    .SIM_ASSERT_CHK(0),             // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
    .USE_EMBEDDED_CONSTRAINT(0),    // DECIMAL
    .USE_MEM_INIT(1),               // DECIMAL
    .USE_MEM_INIT_MMI(0),           // DECIMAL
    .WAKEUP_TIME("disable_sleep"),  // String
    .WRITE_DATA_WIDTH_A(32),        // DECIMAL
    .WRITE_MODE_B("no_change"),     // String
    .WRITE_PROTECT(1)               // DECIMAL
)
xpm_memory_sdpram_sin (
    //.dbiterrb(dbiterrb),             // 1-bit output: Status signal to indicate double bit error occurrence
    // on the data output of port B.

    .doutb(mem_out_sin),                   // READ_DATA_WIDTH_B-bit output: Data output for port B read operations.
    //.sbiterrb(sbiterrb),             // 1-bit output: Status signal to indicate single bit error occurrence
    // on the data output of port B.

    .addra(0),                   // ADDR_WIDTH_A-bit input: Address for port A write operations.
    .addrb(coeff_addr),                   // ADDR_WIDTH_B-bit input: Address for port B read operations.
    .clka(i_clk),                     // 1-bit input: Clock signal for port A. Also clocks port B when
    // parameter CLOCKING_MODE is "common_clock".

    //.clkb(clkb),                     // 1-bit input: Clock signal for port B when parameter CLOCKING_MODE is
    // "independent_clock". Unused when parameter CLOCKING_MODE is
    // "common_clock".

    .dina(0),                     // WRITE_DATA_WIDTH_A-bit input: Data input for port A write operations.
    .ena(0),                       // 1-bit input: Memory enable signal for port A. Must be high on clock
    // cycles when write operations are initiated. Pipelined internally.

    .enb(1),                       // 1-bit input: Memory enable signal for port B. Must be high on clock
    // cycles when read operations are initiated. Pipelined internally.

    //.injectdbiterra(injectdbiterra), // 1-bit input: Controls double bit error injection on input data when
    // ECC enabled (Error injection capability is not available in
    // "decode_only" mode).

    //.injectsbiterra(injectsbiterra), // 1-bit input: Controls single bit error injection on input data when
    // ECC enabled (Error injection capability is not available in
    // "decode_only" mode).

    .regceb(1),                 // 1-bit input: Clock Enable for the last register stage on the output
    // data path.

    .rstb(0),                     // 1-bit input: Reset signal for the final port B output register stage.
    // Synchronously resets output port doutb to the value specified by
    // parameter READ_RESET_VALUE_B.

    .sleep(0),                   // 1-bit input: sleep signal to enable the dynamic power saving feature.
    .wea(11'b1)                        // WRITE_DATA_WIDTH_A/BYTE_WRITE_WIDTH_A-bit input: Write enable vector
    // for port A input data port dina. 1 bit wide when word-wide writes are
    // used. In byte-wide write configurations, each bit controls the
    // writing one byte of dina to address addra. For example, to
    // synchronously write only bits [15-8] of dina when WRITE_DATA_WIDTH_A
    // is 32, wea would be 4'b0010.

);




endmodule
