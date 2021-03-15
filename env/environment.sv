`include "uvm_macros.svh"

package environment_pkg;

import uvm_pkg::*;
import agent_pkg::*;
import scoreboard_pkg::*;

class cal_environment extends uvm_env;

	`uvm_component_utils(cal_environment)

	cal_agent passive_agt;
	cal_agent active_agt;
	cal_scoreboard cal_scb;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		//cal_seqr = cal_sequencer::type_id::create("cal_seqr", this);
		passive_agt = cal_agent::type_id::create("passive_agt", this);
		active_agt = cal_agent::type_id::create("active_agt", this);
		cal_scb = cal_scoreboard::type_id::create("cal_scb", this);
		uvm_config_db #(int)::set(this, "passive_agt", "is_active", UVM_PASSIVE);
		uvm_config_db #(int)::set(this, "active_agt", "is_active", UVM_ACTIVE);
	endfunction
	
	function void connect_phase(uvm_phase phase);
		passive_agt.cal_agt_ap.connect(cal_scb.cal_agt_passive_port);
		active_agt.cal_agt_ap.connect(cal_scb.cal_agt_active_port);
	endfunction

endclass

endpackage
