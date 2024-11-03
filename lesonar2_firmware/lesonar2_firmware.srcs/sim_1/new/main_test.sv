`timescale 1ns / 1ps

module main_test(
);
reg clk;
reg [189:0] mic_wires;
reg rst;
integer k;

initial begin
    std::randomize(mic_wires);
    clk <= 1'b0;
    rst <= 1;
        #30
        clk <= ~clk;
        #30
        clk <= ~clk;
        #30
        clk <= ~clk;
        #30
        clk <= ~clk;
        #30
        clk <= ~clk;
        #30
        clk <= ~clk;
        #30
        clk <= ~clk;
        #30
        clk <= ~clk;
        #30
        clk <= ~clk;
        #30
        clk <= ~clk;
        #30
        clk <= ~clk;
        #30
        clk <= ~clk;
        #30
        clk <= ~clk;
        #30
        clk <= ~clk;
        #30
        clk <= ~clk;
        #30
        rst <= 0;
        clk <= ~clk;
        #30
        clk <= ~clk;

    forever begin
        #30
        clk <= ~clk;
        std::randomize(mic_wires);
    end
end

main_fifo_bigfir bigfir (
    .clk(clk),
    .mic_wire(mic_wires),
    .rst(rst)
);





endmodule
