module top;

parameter simulation_cycle = 10;

bit clock;

bit [6:0] reset;

bit b_clk;
bit c_clk;
bit scan_in;
bit scan_out;
bit [0:3] error_found;

bit[0:31] out_data1;
bit[0:31] out_data2;
bit[0:31] out_data3;
bit[0:31] out_data4;
bit[0:1] out_resp1;
bit[0:1] out_resp2;
bit[0:1] out_resp3;
bit[0:1] out_resp4;
bit[0:3] req1_cmd_in;
bit[0:3] req2_cmd_in;
bit[0:3] req3_cmd_in;
bit[0:3] req4_cmd_in;
bit[0:31] req1_data_in;
bit[0:31] req2_data_in;
bit[0:31] req3_data_in;
bit[0:31] req4_data_in;

always #(simulation_cycle/2) begin
    clock = ~clock;
    b_clk = ~b_clk;
    c_clk = ~c_clk;
end

always @(posedge clock)
	$monitor("%t %d %d ", $time, out_data1, out_resp1);

calc1_top DUT(
	.out_data1(out_data1),
	.out_data2(out_data2),
	.out_data3(out_data3),
	.out_data4(out_data4),
	.out_resp1(out_resp1),
	.out_resp2(out_resp2),
	.out_resp3(out_resp3),
	.out_resp4(out_resp4),
	.scan_out(scan_out),
	.a_clk(clock),
	.b_clk(b_clk),
	.c_clk(c_clk),
	.error_found(error_found),
	.req1_cmd_in(req1_cmd_in),
	.req1_data_in(req1_data_in),
	.req2_cmd_in(req2_cmd_in),
	.req2_data_in(req2_data_in),
	.req3_cmd_in(req3_cmd_in),
	.req3_data_in(req3_data_in),
	.req4_cmd_in(req4_cmd_in),
	.req4_data_in(req4_data_in),
	.reset(reset),
	.scan_in(scan_in)
);

initial begin
	reset = 7'b1111111;
	req1_cmd_in = 4'b0000;
	req2_cmd_in = 4'b0000;
	req3_cmd_in = 4'b0000;
	req4_cmd_in = 4'b0000;
	req1_data_in = 32'b00000000000000000000000000000000;
	req2_data_in = 32'b00000000000000000000000000000000;
	req3_data_in = 32'b00000000000000000000000000000000;
	req4_data_in = 32'b00000000000000000000000000000000;
	#80
	reset = 7'b0000000;
	#10
	//$monitor("%t %d %d ", $time, out_data2, out_resp2);
	req1_cmd_in = 4'b1000;
	req1_data_in = 32'b00000000000000000000000000000001;
	#10
	req1_data_in = 32'b00000000000000000000000000000100;
	//$monitor("%t %d %d ", $time, out_data2, out_resp2);
	//#90
  //run_test("test1");
	#20
	//$monitor("%t %d %d ", $time, out_data2, out_resp2);
	$finish;
end


endmodule
