`timescale 1ns/1ps
`ifndef ADDER_IF_SV
`define ADDER_IF_SV

interface adder_if(input logic clk);
    logic        rst_n;
    logic [7:0]  a_in;
    logic [7:0]  b_in;
    logic [8:0]  sum_out;

    logic [7:0]  a_ff;
    logic [7:0]  b_ff;

    clocking drv_cb @(posedge clk);
        default input #1ns output #1ns;
        output a_in;
        output b_in;
        input  sum_out;
    endclocking

    clocking mon_cb @(posedge clk);
        default input #1ns output #1ns;
        input rst_n;
        input a_in;
        input b_in;
        input sum_out;
        input a_ff;
        input b_ff;
    endclocking

    property p_reset_check;
        @(posedge clk) (!rst_n) |-> (sum_out == 0 && a_ff == 0 && b_ff == 0);
    endproperty
    ASSERT_RESET: assert property (p_reset_check) else $error("SVA: Reset fail!");

    property p_ff_check;
        @(posedge clk) disable iff (!rst_n)
        (a_ff == $past(a_in)) && (b_ff == $past(b_in));
    endproperty
    ASSERT_STAGE1: assert property (p_ff_check) else $error("SVA: Stage 1 Pipeline fail!");

    property p_latency_check;
        @(posedge clk) disable iff (!rst_n)
        sum_out == ($past(a_in, 2) + $past(b_in, 2));
    endproperty
    ASSERT_LATENCY_2: assert property (p_latency_check) else $error("SVA: Latency 2 fail!");

endinterface

`endif