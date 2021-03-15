FILES = Design/* env/SV_RAND_CHECK.sv env/cal_if.sv env/transaction.sv env/sequence.sv env/driver.sv env/monitor.sv env/agent.sv env/reference.sv env/scoreboard.sv env/environment.sv Tests/test1.sv env/cal_testbench.sv
 
TOPLEVEL = testbench

include Makefiles/non_DPI/Makefile_non_DPI
