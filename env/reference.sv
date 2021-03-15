`include "uvm_macros.svh"

package reference_pkg;

import uvm_pkg::*;
import transaction_pkg::*;

class cal_reference extends uvm_component;
	
	`uvm_component_utils(cal_reference)
	
	uvm_analysis_port #(cal_transaction) cal_ref_ap;
	uvm_analysis_imp #(cal_transaction, cal_reference) cal_ref_imp;

	cal_transaction data_out;
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
    cal_ref_ap = new("cal_ref_ap", this);
		cal_ref_imp = new("cal_ref_imp", this);
		data_out = cal_transaction::type_id::create("data_out", this);
  endfunction: build_phase

	virtual function void write(cal_transaction data);
		`uvm_info(get_type_name(), $sformatf("\n\tReference input: %s", data.convert2string), UVM_LOW)
		data_out.copy(data);
		if (data.cmd_in == 4'b0001) begin
			data_out.out_data = data.data1_in + data.data2_in;
			data_out.out_resp = 2'b01;
		end	else if (data.cmd_in == 4'b0010) begin
			data_out.out_data = data.data1_in - data.data2_in;
			data_out.out_resp = 2'b01;
		end else if (data.cmd_in == 4'b0101) begin
			data_out.out_data = data.data1_in << data.data2_in;
			data_out.out_resp = 2'b01;
		end else if (data.cmd_in == 4'b0110) begin
			data_out.out_data = data.data1_in >> data.data2_in;
			data_out.out_resp = 2'b01;
		end else if (data.cmd_in == 4'b0000) begin
			data_out.out_resp = 2'b00;
			data_out.out_data = 32'b00000000000000000000000000000000;
		end else begin
			//data.out_data = 
			data_out.out_resp = 2'b10;
		end
		`uvm_info(get_type_name(), $sformatf("\n\tReference output: %s", data_out.convert2string), UVM_LOW)
		cal_ref_ap.write(data_out);
	endfunction

endclass

endpackage
