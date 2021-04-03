
RTL = ../rtl/*.sv
TOP = ../ahb_env/top.sv
DUMP = ../ahb_env/dump.sv
PKG = ../ahb_test/ahb_test_pkg.sv

INC = +incdir+../ahb_master_agent +incdir+../ahb_slv_agent +incdir+../ahb_env +incdir+../ahb_test +incdir+../rtl +incdir+../reset_agent

WORK = work

VSIMOPT = -novopt -sva -sv_seed random -l s.log work.top

verdi_path = /usr/synopsys/Verdi3_L-2016.06-1

CASE=err_test
UVM_INFO=UVM_LOW

VCSOPT1 = -full64 -cpp g++-4.8 -cc gcc-4.8  -lca -timescale=1ns/1ps  -P  $(verdi_path)/share/PLI/VCS/LINUX64/novas.tab   $(verdi_path)/share/PLI/VCS/LINUX64/pli.a +vcs+lic+wait +vcd+vcdpluson  -sverilog +verilog2001ext+.v  +lint=TFIPC-L  -ntb_opts uvm  +define+UVM_NO_DEPRECATED+UVM_OBJECT_MUST_HAVE_CONSTRUCTO  -debug_all 
VCSOPT2 =   +UVM_TESTNAME=${CASE} +UVM_VERBOSITY=${UVM_INFO}   -cm line+cond+fsm+tgl -cm_dir  ./cov_info 
SIMVOPT =    +UVM_TESTNAME=${CASE} +UVM_VERBOSITY=${UVM_INFO}   -cm line+cond+fsm+tgl -cm_dir  ./cov_info         -l vcs_sim_${CASE}.log 




VSIMBATCH1 = -c -do "coverage save -onexit -assert -directive -cvg -codeAll cov1; run -all; exit"
VSIMBATCH2 = -c -do "coverage save -onexit -assert -directive -cvg -codeAll cov2; run -all; exit"
VSIMBATCH3 = -c -do "coverage save -onexit -assert -directive -cvg -codeAll cov3; run -all; exit"
VSIMBATCH4 = -c -do "coverage save -onexit -assert -directive -cvg -codeAll cov4; run -all; exit"


lib:
	vlib $(WORK)
	vmap work $(WORK)

cmp:
	vlog -work $(WORK) $(INC) $(RTL) $(PKG) $(TOP)

run_gui: clean lib cmp
	vsim -coverage -novopt -sva -sv_seed 3311333501 -l test4_sim.log work.top +UVM_TESTNAME=w4busy_test
	vcover report -html cov

run_test1: clean lib cmp
	vsim $(VSIMBATCH1) -coverage -novopt -sva -sv_seed random -l test1_sim.log work.top +UVM_TESTNAME=reset_test
	vcover report -html cov1

run_test2: clean lib cmp
	vsim $(VSIMBATCH2) -coverage -novopt -sva -sv_seed random -l test2_sim.log work.top +UVM_TESTNAME=inc4_test
	vcover report -html cov2

run_test3: clean lib cmp
	vsim $(VSIMBATCH3) -coverage -novopt -sva -sv_seed random -l test3_sim.log work.top +UVM_TESTNAME=crt_test
	vcover report -html cov3

run_test4: clean lib cmp
	vsim $(VSIMBATCH4) -coverage -novopt -sva -sv_seed random -l test4_sim.log work.top +UVM_TESTNAME=w4busy_test
	vcover report -html cov4
clean: 
	rm -rf modelsim.* transcript* *log* work vsim.wlf vish_* fcover* covhtml* cov*  csrc simv*
	clear
vcs_sim:
	vcs $(VCSOPT1)  $(INC) $(RTL) $(PKG) $(TOP) $(DUMP)   -top  top   $(VCSOPT2)
	 ./simv  +UVM_TESTNAME=${CASE} +UVM_VERBOSITY=${UVM_INFO}   -cm line+cond+fsm+tgl -cm_dir  ./cov_info         -l vcs_sim.log 

verdi:
	verdi -sv  $(INC) $(RTL) $(PKG) $(TOP) $(DUMP)   -top  top  &



