`include "uvm_macros.svh"

package test_pkg;

import uvm_pkg::*;
import environment_pkg::*;
import sequence_pkg::*;

class test1 extends uvm_test;
	
	`uvm_component_utils(test1)

	cal_environment cal_env;
	cal_sequence cal_seq;
	int number = 8;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		cal_env = cal_environment::type_id::create("cal_env", this);
		cal_seq = cal_sequence::type_id::create("cal_seq", this);
		uvm_config_db #(int)::set(null, "*", "number", number);
	endfunction

	task main_phase(uvm_phase phase);
		phase.raise_objection(this);
		cal_seq.number = number;
		cal_seq.start(cal_env.active_agt.cal_seqr);
		phase.drop_objection(this);
	endtask

endclass

endpackage
