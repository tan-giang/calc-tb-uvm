`include "uvm_macros.svh"

package sequence_pkg;

import uvm_pkg::*;
import transaction_pkg::*;

//typedef uvm_sequencer #(cal_transaction) cal_sequencer;

class cal_sequence extends uvm_sequence #(cal_transaction);
	`uvm_object_utils(cal_sequence)

	int number;
	
	function new (string name = "cal_sequence");
		super.new(name);
		//if(!uvm_config_db #(int)::get(this, "*", "number", number))
		//	`uvm_error("", "uvm_config_db::get failed")
	endfunction

	task body;
		if(starting_phase != null)
			starting_phase.raise_objection(this);

		repeat(number)
		begin
			req = cal_transaction::type_id::create("req");
			start_item(req);
		
			if(!req.randomize())
				`uvm_error("", "Randomize failed")

			`uvm_info(get_type_name(), $sformatf("\n\tGenerated transaction: %s", req.convert2string), UVM_LOW)
			finish_item(req);

		end

		if(starting_phase != null)
			starting_phase.drop_objection(this);
	endtask

endclass

endpackage
