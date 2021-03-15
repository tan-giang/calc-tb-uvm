`include "uvm_macros.svh"

package transaction_pkg;

import uvm_pkg::*;

class cal_transaction extends uvm_sequence_item;
	
	rand bit [0:3] cmd_in;
	rand bit [0:31] data1_in;
	rand bit [0:31] data2_in;
	bit [0:1] out_resp;
	bit [0:31] out_data;

	`uvm_object_utils_begin(cal_transaction)
		`uvm_field_int(cmd_in,UVM_ALL_ON)
		`uvm_field_int(data1_in,UVM_ALL_ON)
		`uvm_field_int(data2_in,UVM_ALL_ON)
		`uvm_field_int(out_resp,UVM_ALL_ON)
		`uvm_field_int(out_data,UVM_ALL_ON)
	`uvm_object_utils_end

	constraint c_cmd{cmd_in inside {4'b0010};}; //{4'b0000, 4'b0001, 4'b0010, 4'b0101, 4'b0110};};
	constraint c_data2{data2_in inside {[32'h00000000:32'h0000000f]};};
	constraint c_data1{data1_in inside {[32'h00000000:data2_in]};};
	function new (string name = "cal_transaction");
		super.new(name);
	endfunction

	function string convert2string;
		return $sformatf("cmd = %d, data1 = %0d, data2 = %0d, out_resp = %0d, out_data = %0d", cmd_in, data1_in, data2_in, out_resp, out_data);
	endfunction

	function void do_copy(uvm_object rhs);
		cal_transaction tx;
		$cast(tx, rhs);
		cmd_in = tx.cmd_in;
		data1_in = tx.data1_in;
		data2_in = tx.data2_in;
	endfunction

	function bit do_compare(uvm_object rhs, uvm_comparer comparer);
		cal_transaction tx;
		bit status = 1;
		$cast(tx, rhs);
		status &= (out_resp == tx.out_resp);
		status &= (out_data == tx.out_data);
		//status &= (data2_in == tx.data2_in);
		return status;
	endfunction
	
	function bit compare_t(cal_transaction rhs);
		if ((this.out_resp == rhs.out_resp) && (this.out_data == rhs.out_data))
			return 1'b1;
		else
			return 1'b0;	
	endfunction

endclass

endpackage
