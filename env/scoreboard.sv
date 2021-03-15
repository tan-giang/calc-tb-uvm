`include "uvm_macros.svh"

package scoreboard_pkg;

import uvm_pkg::*;
import transaction_pkg::*;
import reference_pkg::*;

class cal_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(cal_scoreboard)

	cal_reference cal_ref;
	uvm_analysis_export #(cal_transaction) cal_agt_active_port;
  uvm_analysis_export #(cal_transaction) cal_agt_passive_port;
 
  uvm_tlm_analysis_fifo #(cal_transaction) ref_data;
  uvm_tlm_analysis_fifo #(cal_transaction) dut_data;

	int number;
	int count = 0;

	function new(string name, uvm_component parent);
		super.new(name, parent);
		cal_agt_active_port = new("cal_agt_active_port", this);
		cal_agt_passive_port = new("cal_agt_passive_port", this);
		ref_data = new("ref_data", this);
		dut_data = new("dut_data", this);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		cal_ref = cal_reference::type_id::create("cal_ref", this);
		if(!uvm_config_db #(int)::get(this, "*", "number", number))
			`uvm_error("", "uvm_config_db::get failed")
	endfunction

	virtual function void connect_phase(uvm_phase phase);
		//connect scoreboard with reference to get transaction from active agent
		//export.connect(subcomponent.export);
		cal_agt_active_port.connect(cal_ref.cal_ref_imp);
	
		//connect reference with tlm_analysis_fifo for storing output from a reference
		//comp1.port.connect(comp2.export);
		cal_ref.cal_ref_ap.connect(ref_data.analysis_export);
		
		//connect scoreboard with tlm_analysis_fifo to get transaction from passive agent
		//export.connect(subcomponent.export);
		cal_agt_passive_port.connect(dut_data.analysis_export);
	endfunction

	virtual task main_phase(uvm_phase phase);
		cal_transaction dut_result;
		cal_transaction ref_result;
		phase.raise_objection(this);
		forever begin
			dut_data.get(dut_result);
			`uvm_info(get_type_name(), $sformatf("\n\tDUT output %s", dut_result.convert2string), UVM_LOW)
			ref_data.get(ref_result);
			`uvm_info(get_type_name(), $sformatf("\n\tReference output %s", ref_result.convert2string), UVM_LOW)
			if(ref_result.compare_t(dut_result)) begin
				`uvm_info(get_type_name(), "\n\tPASS", UVM_LOW)
				count++;
			end else begin
				`uvm_info(get_type_name(), $sformatf("\n\tFAILED: expected results: out_resp = %0d, out_data = %0d \n\t\t real results: out_resp = %0d, out_data = %0d", ref_result.out_resp, ref_result.out_data, dut_result.out_resp, dut_result.out_data), UVM_LOW)
				count++;
			end
			if(count == number)
				break;
		end
		phase.drop_objection(this);
	endtask
endclass

endpackage
