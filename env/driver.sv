`include "uvm_macros.svh"

package driver_pkg;

import uvm_pkg::*;
import transaction_pkg::*;

class cal_driver extends uvm_driver #(cal_transaction);

	`uvm_component_utils(cal_driver)

	virtual cal_if calif;
	//bit flag;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(virtual cal_if)::get(this, "", "cal_if", calif))
			`uvm_error("", "uvm_config_db::get failed")
	endfunction

	task reset_phase(uvm_phase phase);
		`uvm_info("", "\n\tReset DUT start", UVM_LOW)
  	phase.raise_objection(this);
  	calif.reset = 7'b1111111;
		calif.req1_cmd_in = 4'b0000;
		calif.req2_cmd_in = 4'b0000;
		calif.req3_cmd_in = 4'b0000;
		calif.req4_cmd_in = 4'b0000;
		calif.req1_data_in = 32'b00000000000000000000000000000000;
		calif.req2_data_in = 32'b00000000000000000000000000000000;
		calif.req3_data_in = 32'b00000000000000000000000000000000;
		calif.req4_data_in = 32'b00000000000000000000000000000000;
  	repeat(8)
			@(calif.clk_block);
  	calif.reset = 7'b0000000;
  	phase.drop_objection(this);
		`uvm_info("", "\n\tReset DUT end", UVM_LOW)
	endtask: reset_phase

	task main_phase(uvm_phase phase);
		forever begin
			//uvm_config_db #(bit)::get(this, "*", "flag", flag);
			//if (flag == 1'b1) begin
				seq_item_port.get_next_item(req);
				@(calif.clk_block);
				calif.req1_cmd_in = req.cmd_in;
				calif.req1_data_in = req.data1_in;
				@(calif.clk_block);
				calif.req1_cmd_in = 4'b0000;
				calif.req1_data_in = req.data2_in;
				@(calif.clk_block);
				calif.req1_data_in = 32'b00000000000000000000000000000000;
				//flag = 1'b0;
				//uvm_config_db #(bit)::set(null, "*", "flag", flag);
				seq_item_port.item_done();
				`uvm_info(get_type_name(), $sformatf("\n\tDriver output: %s", req.convert2string), UVM_LOW)
			//end
		end
	endtask

endclass

endpackage
