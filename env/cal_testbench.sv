`include "uvm_macros.svh"

import uvm_pkg::*;
import test_pkg::*;

module testbench;

parameter simulation_cycle = 10;

bit clock;

bit [6:0] reset;

bit b_clk;
bit c_clk;
bit scan_in;
bit scan_out;
bit [0:3] error_found;

always #(simulation_cycle/2) begin
    clock = ~clock;
    b_clk = ~b_clk;
    c_clk = ~c_clk;
end

cal_if calif(clock);

initial begin
    uvm_config_db#(virtual cal_if)::set(uvm_root::get(),"*","cal_if",calif);
    //$dumpfile("dump.vcd"); $dumpvars;
end

calc1_top DUT(
	.out_data1(calif.out_data1),
	.out_data2(calif.out_data2),
	.out_data3(calif.out_data3),
	.out_data4(calif.out_data4),
	.out_resp1(calif.out_resp1),
	.out_resp2(calif.out_resp2),
	.out_resp3(calif.out_resp3),
	.out_resp4(calif.out_resp4),
	.scan_out(scan_out),
	.a_clk(calif.clk),
	.b_clk(b_clk),
	.c_clk(c_clk),
	.error_found(error_found),
	.req1_cmd_in(calif.req1_cmd_in),
	.req1_data_in(calif.req1_data_in),
	.req2_cmd_in(calif.req2_cmd_in),
	.req2_data_in(calif.req2_data_in),
	.req3_cmd_in(calif.req3_cmd_in),
	.req3_data_in(calif.req3_data_in),
	.req4_cmd_in(calif.req4_cmd_in),
	.req4_data_in(calif.req4_data_in),
	.reset(calif.reset),
	.scan_in(scan_in)
);

initial begin
	//#90
  run_test("test1");
end

endmodule
