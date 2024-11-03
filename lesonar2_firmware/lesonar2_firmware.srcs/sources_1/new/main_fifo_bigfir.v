`timescale 1ns / 1ps


module main_fifo_bigfir (
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


reg                 [MIC_COUNT-1:0]cic_in;
wire                [MIC_COUNT-1:0]cic_out;
wire                [MIC_COUNT-1:0]cic_in_valid;


reg [10:0] i;
genvar k;
for(k = 0; k < MIC_COUNT; k = k+1) begin
    assign cic_in_valid[k] = clk_counter == 0;
end

reg [10:0] fir_read_index;
reg [11:0] fir_counter;

always @(posedge clk_100) begin
    if(rst) begin
        fir_read_index <= 0;
        fir_counter <= 0;
    end else if(fir_counter == 2498) begin
        fir_read_index <= fir_read_index + 119;
        fir_counter <= 0;
    end else begin
        if(fir_counter < 2048) begin
            fir_read_index <= fir_read_index - 1;
        end
        fir_counter <= fir_counter + 1;
    end
end

wire signed[31:0] cos_coeff;
wire signed[31:0] sin_coeff;

generate for(k = 0; k < 21; k = k+1) begin
    sample_accumulator_18x2048 accumulator (
        .i_clk(clk_100),
        .i_samples(cic_in[(k+1)*18-1:k*18]),
        .i_ce(cic_in_valid[0]),
        .i_read_addr(fir_read_index),
        .o_samples(cic_out[(k+1)*18-1:k*18]),
        .rst(rst)
    );
end endgenerate
sample_accumulator_18x2048 accumulator (
    .i_clk(clk_100), .i_samples(cic_in[379:378]),
    .i_ce(cic_in_valid[0]),
    .i_read_addr(fir_read_index),
    .o_samples(cic_out[379:378]),
    .rst(rst)
);


fir_coeff_table_2048 coeff_table(
    .i_clk(clk_100),
    .i_coeff_counter(fir_counter),
    .o_cos_coeff(cos_coeff),
    .o_sin_coeff(sin_coeff),
    .rst(rst)
);

wire signed [0:15] fir_out_real[0:MIC_COUNT-1];
wire signed [0:15] fir_out_imag[0:MIC_COUNT-1];
wire               fir_out_valid;
assign fir_out_valid = fir_counter == 0;


generate for(k = 0; k < MIC_COUNT; k = k+1) begin
    sample_summer_1x summer(
        .i_clk(clk_100),
        .i_sample(cic_out[k]),
        .i_zero_enable(fir_counter == 0),
        .i_coeff_counter(fir_counter),
        .i_cos_coeff(cos_coeff),
        .i_sin_coeff(sin_coeff),
        .o_accumulator_cos(fir_out_real[k]),
        .o_accumulator_sin(fir_out_imag[k]),
        .rst(rst)
    );
end endgenerate



reg signed [0:15] mic_data_real[0:MIC_COUNT-1];
reg signed [0:15] mic_data_imag[0:MIC_COUNT-1];


assign emitter_p = (period_counter%751 > 20) || (sample_counter < 60);
assign emitter_n = (period_counter%751 > 20) || (sample_counter >= 60);


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
    .PROG_FULL_THRESH(1024*62)
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
    if(tx_counter < MIC_COUNT) begin

        fifo_din[0:7]  <= mic_data_real[tx_counter][0:7];
        fifo_din[8:15] <= (mic_data_real[tx_counter][8:15] == 8'b0) ?
            mic_data_real[tx_counter][8:15] + 8'b1 : mic_data_real[tx_counter][8:15];
        fifo_din[16:23]  <= mic_data_imag[tx_counter][0:7];
        fifo_din[24:31]  <= (mic_data_imag[tx_counter][8:15] == 8'b0) ?
            mic_data_imag[tx_counter][8:15] + 8'b1 : mic_data_imag[tx_counter][8:15];

        fifo_wput <= 1;
        tx_counter <= tx_counter + 1;
    end else if(tx_counter == MIC_COUNT) begin
        fifo_din <= {16'b0, period_counter[0:7], period_counter[8:15]};
        fifo_wput <= 1;
        tx_counter <= tx_counter + 1;
    end else if(tx_counter == MIC_COUNT + 1) begin
        fifo_din <= 32'b0;
        fifo_wput <= 0;
        if(!fifo_almost_full) begin
            tx_counter <= tx_counter + 1;
            if(period_counter < 37550) begin
                period_counter <= period_counter + 8'b1;
            end else begin
                period_counter <= 0;
                // Mics running-in non-ultrasonic mode for 750frames=20ms
                if(!mics_in_ultrasonic_mode) begin
                    mics_in_ultrasonic_mode <= 1;
                end
            end
        end
    end else if(tx_counter == MIC_COUNT + 2) begin
        fifo_din <= 32'b0;
        fifo_wput <= 0;
        if(fir_out_valid) begin
            tx_counter <= 0;

            for(i = 0; i < MIC_COUNT; i = i+1) begin
                mic_data_real[i] <= fir_out_real[i];
                mic_data_imag[i] <= fir_out_imag[i];
            end
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
        cic_in <= 380'b0;
        mics_in_ultrasonic_mode <= 0;
    end else begin
        if(clk_counter < 20) begin
            clk_counter <= clk_counter + 1'b1;
        end else if(clk_counter == 20) begin
            if(sample_counter == 118) begin
                sample_counter <= 0;
            end else begin
                sample_counter <= sample_counter + 1;
            end
            mic_clk <= !mic_clk;
            clk_counter <= 0;
            for(i = 0; i < MIC_COUNT; i = i+1) begin
                if(mic_polarity[i]) begin
                    cic_in[i] <= mic_wire[i[10:1]];
                end
            end
        end
        if(clk_counter == 9) begin
            if(mics_in_ultrasonic_mode) begin // 2x dividor when in non-ultrasonic
                mic_clk <= !mic_clk;
            end
            for(i = 0; i < MIC_COUNT; i = i+1) begin
                if(!mic_polarity[i]) begin
                    cic_in[i] <= mic_wire[i[10:1]];
                end
            end
        end
    end
end
endmodule
