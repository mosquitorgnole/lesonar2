`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/05/2024 11:37:57 AM
// Design Name:
// Module Name: sample_accumulator_18x2048
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
module sample_accumulator_18x2048 (
    input wire i_clk,
    input wire [17:0] i_samples,
    input wire        i_ce,
    input wire [10:0] i_read_addr,
    output wire [17:0] o_samples,
    input wire rst
    );

    reg [10:0] write_addr;
    always @(posedge i_clk) begin
        if(rst) begin
            write_addr <= 0;
        end else if(i_ce) begin
            write_addr <= write_addr + 1;
        end
    end



// xpm_memory_sdpram: Simple Dual Port RAM
// Xilinx Parameterized Macro, version 2023.2

xpm_memory_sdpram #(
   .ADDR_WIDTH_A(11),               // DECIMAL
   .ADDR_WIDTH_B(11),               // DECIMAL
   .AUTO_SLEEP_TIME(0),            // DECIMAL
   .BYTE_WRITE_WIDTH_A(18),        // DECIMAL
   .CASCADE_HEIGHT(0),             // DECIMAL
   .CLOCKING_MODE("common_clock"), // String
   .ECC_BIT_RANGE("7:0"),          // String
   .ECC_MODE("no_ecc"),            // String
   .ECC_TYPE("none"),              // String
   .IGNORE_INIT_SYNTH(0),          // DECIMAL
   .MEMORY_INIT_FILE("none"),      // String
   .MEMORY_INIT_PARAM("0"),        // String
   .MEMORY_OPTIMIZATION("true"),   // String
   .MEMORY_PRIMITIVE("block"),      // String
   .MEMORY_SIZE(2048*18),             // DECIMAL
   .MESSAGE_CONTROL(0),            // DECIMAL
   .RAM_DECOMP("auto"),            // String
   .READ_DATA_WIDTH_B(18),         // DECIMAL
   .READ_LATENCY_B(4),             // DECIMAL
   .READ_RESET_VALUE_B("0"),       // String
   .RST_MODE_A("SYNC"),            // String
   .RST_MODE_B("SYNC"),            // String
   .SIM_ASSERT_CHK(0),             // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
   .USE_EMBEDDED_CONSTRAINT(0),    // DECIMAL
   .USE_MEM_INIT(1),               // DECIMAL
   .USE_MEM_INIT_MMI(0),           // DECIMAL
   .WAKEUP_TIME("disable_sleep"),  // String
   .WRITE_DATA_WIDTH_A(18),        // DECIMAL
   .WRITE_MODE_B("no_change"),     // String
   .WRITE_PROTECT(1)               // DECIMAL
)
xpm_memory_sdpram_inst (
   //.dbiterrb(dbiterrb),             // 1-bit output: Status signal to indicate double bit error occurrence
                                    // on the data output of port B.

   .doutb(o_samples),                   // READ_DATA_WIDTH_B-bit output: Data output for port B read operations.
   //.sbiterrb(sbiterrb),             // 1-bit output: Status signal to indicate single bit error occurrence
                                    // on the data output of port B.

   .addra(write_addr),                   // ADDR_WIDTH_A-bit input: Address for port A write operations.
   .addrb(i_read_addr),                   // ADDR_WIDTH_B-bit input: Address for port B read operations.
   .clka(i_clk),                     // 1-bit input: Clock signal for port A. Also clocks port B when
                                    // parameter CLOCKING_MODE is "common_clock".

   //.clkb(clkb),                     // 1-bit input: Clock signal for port B when parameter CLOCKING_MODE is
                                    // "independent_clock". Unused when parameter CLOCKING_MODE is
                                    // "common_clock".

   .dina(i_samples),                     // WRITE_DATA_WIDTH_A-bit input: Data input for port A write operations.
   .ena(i_ce),                       // 1-bit input: Memory enable signal for port A. Must be high on clock
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
   .wea(18'b111111111111111111)                        // WRITE_DATA_WIDTH_A/BYTE_WRITE_WIDTH_A-bit input: Write enable vector
                                    // for port A input data port dina. 1 bit wide when word-wide writes are
                                    // used. In byte-wide write configurations, each bit controls the
                                    // writing one byte of dina to address addra. For example, to
                                    // synchronously write only bits [15-8] of dina when WRITE_DATA_WIDTH_A
                                    // is 32, wea would be 4'b0010.

);

// End of xpm_memory_sdpram_inst instantiation



endmodule
