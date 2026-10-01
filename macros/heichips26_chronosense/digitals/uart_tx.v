// uart_tx.v
// 8N1 transmitter. One byte per start pulse.
// DIV = clk frequency / baud rate.
`default_nettype none

module uart_tx #(
    parameter integer DIV = 87
)(
    input  wire       clk,
    input  wire       rst_n,
    input  wire [7:0] data,
    input  wire       start,      // pulse high for one clk when data is valid
    output reg        tx,
    output wire       busy
);

    localparam integer DW = (DIV <= 2) ? 2 : $clog2(DIV);

    reg [DW-1:0] div_cnt;
    reg [3:0]    bit_idx;         // 0 = start, 1..8 = data, 9 = stop
    reg [7:0]    shreg;
    reg          active;

    assign busy = active | start;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tx      <= 1'b1;
            div_cnt <= {DW{1'b0}};
            bit_idx <= 4'd0;
            shreg   <= 8'd0;
            active  <= 1'b0;
        end else if (!active) begin
            tx <= 1'b1;
            if (start) begin
                shreg   <= data;
                active  <= 1'b1;
                bit_idx <= 4'd0;
                div_cnt <= {DW{1'b0}};
                tx      <= 1'b0;          // start bit
            end
        end else begin
            if (div_cnt == DIV[DW-1:0] - 1'b1) begin
                div_cnt <= {DW{1'b0}};
                if (bit_idx == 4'd9) begin
                    active <= 1'b0;
                    tx     <= 1'b1;
                end else begin
                    bit_idx <= bit_idx + 1'b1;
                    tx      <= (bit_idx == 4'd8) ? 1'b1 : shreg[0];
                    shreg   <= {1'b0, shreg[7:1]};
                end
            end else begin
                div_cnt <= div_cnt + 1'b1;
            end
        end
    end

endmodule

`default_nettype wire
