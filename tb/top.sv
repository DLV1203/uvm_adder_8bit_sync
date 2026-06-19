`timescale 1ns/1ps
module top;
    import uvm_pkg::*;
    import adder_pkg::*;

    logic clk;
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    adder_if inf(clk);
    adder_8bit_sync dut (
        .clk(inf.clk),
        .rst_n(inf.rst_n),
        .a_in(inf.a_in),
        .b_in(inf.b_in),
        .sum_out(inf.sum_out)
    );

	assign inf.a_ff = dut.a_ff;
    assign inf.b_ff = dut.b_ff;
	initial begin
        inf.rst_n = 1'b0;
        #15;
        inf.rst_n = 1'b1;
    end
	
    initial begin
        uvm_config_db#(virtual adder_if)::set(null, "*", "vif", inf);
        
        run_test("adder_test");
    end
endmodule
