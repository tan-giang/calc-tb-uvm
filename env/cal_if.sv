interface cal_if(input bit clk);
	//input
	//logic clk;
	logic [1:7] reset;
	logic [0:3] req1_cmd_in;
	logic [0:31] req1_data_in;
	logic [0:3] req2_cmd_in;
	logic [0:31] req2_data_in;
	logic [0:3] req3_cmd_in;
	logic [0:31] req3_data_in;
	logic [0:3] req4_cmd_in;
	logic [0:31] req4_data_in;

	//output
	logic [0:1] out_resp1;
	logic [0:31] out_data1;
	logic [0:1] out_resp2;
	logic [0:31] out_data2;
	logic [0:1] out_resp3;
	logic [0:31] out_data3;
	logic [0:1] out_resp4;
	logic [0:31] out_data4;

	clocking clk_block @(posedge clk);
		output req1_cmd_in, req2_cmd_in, req3_cmd_in, req4_cmd_in;
		output req1_data_in, req2_data_in, req3_data_in, req4_data_in;
		input out_resp1, out_resp2, out_resp3, out_resp4;
		input out_data1, out_data2, out_data3, out_data4;
	//	output reset;
	endclocking

endinterface
