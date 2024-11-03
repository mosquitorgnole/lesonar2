`timescale 1ns / 1ps


module main_fifo_rawdata_2 (
    input  wire         clk,
    output reg        mic_clk,
    input wire   [189:0] mic_wire,

    input  wire  ft_clk,
    input  wire  ft_txe_n,
    input  wire  ft_rxf_n,
    output wire  ft_oe_n,
    output wire  ft_wr_n,
    output wire  ft_rd_n,
    output [0:31] ft_data,
    output [ 3:0] ft_be,
    output wire  emitter_p,
    output wire  emitter_n
);

wire rst;
assign rst = 0;

wire clk_100;
wire clk_200;
clk_wiz_0 inst (
    .clk_out1(clk_100),
    .clk_out2(clk_200),
    .reset(0),
    .locked(),
    .clk_in1(clk)
);




reg [0:15] period_counter;
reg [7: 0] sample_counter;
reg [5: 0] clk_counter;


parameter MIC_COUNT = 380;
parameter [0:379] mic_polarity = 379'b01010101010101010110011001011001011001010101010111011001010101101010010101101010010110011010100110100110101001010110101001011001011010010101011010100101011010100101010110101001010101101010010101101010010101011010100101010110101001010110101001010101101010010101011010100101011010101001010110100101010101101010010101101010010101011010100101010110101001010110101001010101101010010101;


reg     [MIC_COUNT-1:0]pdm_in;
wire    pdm_in_valid;
assign pdm_in_valid = clk_counter == 0;



reg [10:0] i;
genvar k;





assign emitter_p = /*(period_counter % 1024 > 512) ||*/ (sample_counter < 24);
assign emitter_n = /*(period_counter % 1024 > 512) ||*/ (sample_counter >= 24);


assign ft_oe_n = 1'b1;
assign ft_rd_n = 1'b1;
assign ft_be[3:0] =  4'b1111;



wire fifo_wr_rst_busy;
wire fifo_rd_rst_busy;
wire fifo_full;
wire fifo_almost_full;
assign fifo_rget = ~fifo_rd_rst_busy & ~ft_txe_n; // get on txempty
wire rst_out;

reg [0:11] tx_counter;
reg  fifo_wput;
reg [0:31] fifo_din;
reg mics_in_ultrasonic_mode;

parameter TX_FIFO_DEPTH = 1024*64;
xpm_fifo_async
#(.CDC_SYNC_STAGES(2),
    .FIFO_MEMORY_TYPE("block"),
    .FIFO_WRITE_DEPTH(TX_FIFO_DEPTH),
    .READ_DATA_WIDTH(32),
    .WRITE_DATA_WIDTH(32),
    .USE_ADV_FEATURES("0000"),
    .PROG_FULL_THRESH(TX_FIFO_DEPTH-1024*2)
) write_fifo
(.dout(ft_data),
    .empty(ft_wr_n),
    .full(fifo_full),
    .prog_full(fifo_almost_full),
    .rd_rst_busy(fifo_rd_rst_busy),
    .wr_rst_busy(fifo_wr_rst_busy),
    .din(fifo_din),
    .rd_clk(ft_clk),
    .rd_en(fifo_rget),
    .rst(rst_out),
    .wr_clk(clk_100),
    .wr_en(fifo_wput), // default input .sleep(0),
    .injectsbiterr(0),
    .injectdbiterr(0)
);

always @(posedge clk_100) begin
    if(tx_counter < MIC_COUNT/32) begin
        for(i = 0; i < 32; i = i+1) begin
            fifo_din[i] <= pdm_in[tx_counter*32+i];
        end
        fifo_wput <= 1;
        tx_counter <= tx_counter + 1;
    end else if(tx_counter == MIC_COUNT/32) begin
        fifo_din <= {16'b0, period_counter[0:7], period_counter[8:15]};
        fifo_wput <= 1;
        tx_counter <= tx_counter + 1;
    end else if(tx_counter == MIC_COUNT/32 + 1) begin
        fifo_din <= 32'b0;
        fifo_wput <= 0;
        if(!fifo_almost_full) begin
            tx_counter <= tx_counter + 1;
            if(period_counter < 37500) begin
                period_counter <= period_counter + 8'b1;
            end else begin
                period_counter <= 0;
                // Mics running-in non-ultrasonic mode for 750frames=20ms
                if(!mics_in_ultrasonic_mode) begin
                    mics_in_ultrasonic_mode <= 1;
                end
            end
        end
    end else if(tx_counter == MIC_COUNT/32 + 2) begin
        fifo_din <= 32'b0;
        fifo_wput <= 0;
        if(pdm_in_valid) begin
            tx_counter <= 0;
        end
    end else begin
        fifo_din <= 32'b0;
        fifo_wput <= 0;
    end
end

always @(posedge clk_100) begin
    if(rst) begin
        clk_counter <= 0;
        sample_counter <= 0;
        mic_clk <= 0;
        pdm_in <= 380'b0;
        mics_in_ultrasonic_mode <= 0;
    end else begin
        if(clk_counter < 20) begin
            clk_counter <= clk_counter + 1'b1;
        end else if(clk_counter == 20) begin
            if(sample_counter == 47) begin
                sample_counter <= 0;
            end else begin
                sample_counter <= sample_counter + 1;
            end
            mic_clk <= !mic_clk;
            clk_counter <= 0;
            for(i = 0; i < MIC_COUNT; i = i+1) begin
                if(mic_polarity[i]) begin
                    pdm_in[i] <= mic_wire[i[10:1]];
                end
            end
        end
        if(clk_counter == 9) begin
            if(mics_in_ultrasonic_mode) begin // 2x dividor when in non-ultrasonic
                mic_clk <= !mic_clk;
            end
            for(i = 0; i < MIC_COUNT; i = i+1) begin
                if(!mic_polarity[i]) begin
                    pdm_in[i] <= mic_wire[i[10:1]];
                end
            end
        end
    end
end
endmodule
