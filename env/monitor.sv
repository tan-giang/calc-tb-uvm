`include "uvm_macros.svh"

package monitor_pkg;

import uvm_pkg::*;
import transaction_pkg::*;

class cal_monitor extends uvm_monitor;

	`uvm_component_utils(cal_monitor)

	virtual cal_if calif;
	//bit flag;
	bit mode;

	uvm_analysis_port #(cal_transaction) cal_mnt_ap;

	function new(string name, uvm_component parent);
		super.new(name, parent);
		cal_mnt_ap = new("cal_mnt_ap", this);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(virtual cal_if)::get(this, "", "cal_if", calif))
			`uvm_error("", "uvm_config_db::get failed")
	endfunction

	virtual task main_phase(uvm_phase phase);		
		if(mode == 1'b0) begin
			cal_transaction data_out;
			forever begin
				wait(calif.out_resp1 == 2'b01 || calif.out_resp1 == 2'b10 || calif.out_resp1 == 2'b11) //begin
					@(calif.clk_block);
					//`uvm_info("", "\n\t++++++++++++++++++++++++++++", UVM_LOW)
					data_out = cal_transaction::type_id::create("data_out", this);
					//`uvm_info("", "\n\tpassive monitor", UVM_LOW)
					data_out.out_resp = calif.out_resp1;
					data_out.out_data = calif.out_data1;
					//flag = 1'b1;
					//uvm_config_db #(bit)::set(null, "*", "flag", flag);
					if (data_out.out_resp == 2'b01 || data_out.out_resp == 2'b10 || data_out.out_resp == 2'b11) begin
						cal_mnt_ap.write(data_out);
						`uvm_info(get_type_name(), $sformatf("\n\tMonitor passive output: %s", data_out.convert2string), UVM_LOW)
					end
				
			end
		end else begin
			cal_transaction data_out;
			forever begin
				data_out = cal_transaction::type_id::create("data_out", this);
					wait(calif.req1_cmd_in != 4'b0000)
					//`uvm_info("", "\n\tactive monitor", UVM_LOW)
					@(calif.clk_block);
					data_out.cmd_in = calif.req1_cmd_in;
					data_out.data1_in = calif.req1_data_in;
					wait(calif.req1_cmd_in == 4'b0000)
					@(calif.clk_block);
					data_out.data2_in = calif.req1_data_in;
					cal_mnt_ap.write(data_out);
					`uvm_info(get_type_name(), $sformatf("\n\tMonitor active output: %s", data_out.convert2string), UVM_LOW)
				
				
			end
		end
	endtask

endclass

endpackage
