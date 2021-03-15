`include "uvm_macros.svh"

package agent_pkg;

import uvm_pkg::*;
import driver_pkg::*;
import monitor_pkg::*;
import sequence_pkg::*;
import transaction_pkg::*;

class cal_agent extends uvm_agent;
	
	`uvm_component_utils(cal_agent)

	typedef uvm_sequencer #(cal_transaction) cal_sequencer;
	
	cal_sequencer cal_seqr;
	cal_driver cal_drv;
	cal_monitor cal_mnt;
	
	uvm_analysis_port #(cal_transaction) cal_agt_ap;

	virtual cal_if calif;
	//bit flag = 1'b1;	

	function new(string name, uvm_component parent);
		super.new(name, parent);
		cal_agt_ap = new("cal_agt_ap", this);
	endfunction
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(virtual cal_if)::get(this, "", "cal_if", calif))
			`uvm_error("", "uvm_config_db::get failed")
		//uvm_config_db #(bit)::set(null, "*", "flag", flag);
		cal_mnt = cal_monitor::type_id::create("cal_mnt", this);
		cal_mnt.mode = 1'b0;
		if (get_is_active() == UVM_ACTIVE) begin
			cal_seqr = cal_sequencer::type_id::create("cal_seqr", this);
			cal_drv = cal_driver::type_id::create("cal_drv", this);
			cal_mnt.mode = 1'b1;
		end
	endfunction

	virtual function void connect_phase(uvm_phase phase);
		//cal_agt_ap.connect(cal_mnt.cal_mnt_ap);
		cal_mnt.cal_mnt_ap.connect(cal_agt_ap);
		cal_mnt.calif = calif;
		if (get_is_active() == UVM_ACTIVE) begin
			cal_drv.seq_item_port.connect(cal_seqr.seq_item_export);
			cal_drv.calif = calif;
		end
	endfunction

endclass

endpackage
