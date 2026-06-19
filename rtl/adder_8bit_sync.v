module adder_8bit_sync (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  a_in,
    input  wire [7:0]  b_in,
    output reg  [8:0]  sum_out
);

    reg [7:0] a_ff;
    reg [7:0] b_ff;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_ff <= 8'd0;
            b_ff <= 8'd0;
        end else begin
            a_ff <= a_in;
            b_ff <= b_in;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_out <= 9'd0;
        end else begin
            sum_out <= a_ff + b_ff;
        end
    end

endmodule
