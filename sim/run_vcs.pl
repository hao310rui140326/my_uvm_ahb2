#!/urs/bin/perl

use warnings;


main();



#----------------------------- Main ------------------------------#
sub main(){

                clean();
                variables();    #Initialize all variables
		##library();      #Create and Map library
		##compile();      #Compile

                read_test();

                print "\nEnter Test No. (Press 0 for regress) = ";
                $i = <STDIN>;
                chomp($i);
                print "\n";



                if($i == 0){
                        run_regress();
			##report();
			##view_browser();
                }else{
                        print "Start test in CMD/GUI: (e.g. cmd / gui) = ";
                        $mode = <STDIN>;
                        chop($mode);
                        print "\n";
                        if($mode eq "gui"){
                                 run_gui();
                        }elsif($mode eq "cmd"){
                                run_cmd();
                        }
                }

}



#-------------------- Variable Initialization --------------------#
sub variables(){

        $IF = "../rtl/*.sv";
        $RTL = "../rtl/*.sv";
        $TOP = "../ahb_env/top.sv";
        $PKG = "../ahb_test/ahb_test_pkg.sv";
	$DUMP = "../ahb_env/dump.sv";	
        $WORK = "work";
	##$INC = "+incdir+../rtl +incdir+../ahb_env +incdir+../ahb_test +incdir+../reset_agent +incdir+../ahb_master_agent +incdir+../ahb_slv_agent";
	$INC = "+incdir+../ahb_master_agent +incdir+../ahb_slv_agent +incdir+../ahb_env +incdir+../ahb_test +incdir+../rtl +incdir+../reset_agent";


}



#-------------------- SIM Variable Initialization -----------------#
sub simulation(){

        $VSIMOPT = "-novopt -assertdebug -sva -sv_seed 16422201 -l $LOG work.top";
        $VSIMBATCH = "-c -do \"coverage save -onexit -assert -directive -cvg -codeAll $COV; run -all; exit\"";
	$verdi_path = "/usr/synopsys/Verdi3_L-2016.06-1";
	$VCSOPT1 = "-full64 -cpp g++-4.8 -cc gcc-4.8  -lca -timescale=1ns/1ps  -P  ${verdi_path}/share/PLI/VCS/LINUX64/novas.tab   ${verdi_path}/share/PLI/VCS/LINUX64/pli.a +vcs+lic+wait +vcd+vcdpluson  -sverilog +verilog2001ext+.v  +lint=TFIPC-L  -ntb_opts uvm  +define+UVM_NO_DEPRECATED+UVM_OBJECT_MUST_HAVE_CONSTRUCTO  -debug_all ";
	$UVM_INFO="UVM_LOW";	
	$VCSOPT2 =  "  +UVM_VERBOSITY=${UVM_INFO}   -cm line+cond+fsm+tgl -cm_dir  ./cov_info ";
	$SIMVOPT =  "  +UVM_VERBOSITY=${UVM_INFO}   -cm line+cond+fsm+tgl -cm_dir  ./cov_info   ";


}



#---------------------- Library & Mapping--------------------------#
sub library(){
        system "vlib $WORK";
        system "vmap work $WORK";
}



#-------------------------- Compile -------------------------------#
sub compile(){
        system "vlog -work $WORK $INC $IF $PKG $TOP";
}



#-----------------------------------------------------------------#
sub run_cmd(){
        $LOG = "test".$i."_sim.log";
        $COV = "cov".$i;
        simulation();
	##system "vsim $VSIMBATCH $VSIMOPT +UVM_TESTNAME=$tests[$i-1]";
	##system "vcover report -html $COV";
        system "vcs ${VCSOPT1}  ${INC} ${RTL} ${PKG} ${TOP} ${DUMP}   -top  top +UVM_TESTNAME=$tests[$t-1]  ${VCSOPT2}";

        system "./simv  +UVM_TESTNAME=$tests[$i-1]  $SIMVOPT  -l vcs_sim_$tests[$i-1].log ";

}


#-----------------------------------------------------------------#
sub run_regress(){

        $t = 1;

        foreach(@tests){
                $LOG = "test".$t."_sim.log";
                $COV = "cov".$t;
                simulation();
		##system "vsim $VSIMBATCH $VSIMOPT +UVM_TESTNAME=$tests[$t-1]";
                system "vcs ${VCSOPT1}  ${INC} ${RTL} ${PKG} ${TOP} ${DUMP}   -top  top +UVM_TESTNAME=$tests[$t-1]  ${VCSOPT2}";
                system "./simv  +UVM_TESTNAME=$tests[$t-1]  $SIMVOPT  -l vcs_sim_$tests[$t-1].log ";
		##system "vcover report -html $COV";

                $t++;
        }
}


#-----------------------------------------------------------------#
sub report(){
        system "vcover merge cov_final cov?";
        system "vcover report -html cov_final";
}


#-----------------------------------------------------------------#
sub view_browser(){
        system "firefox covhtmlreport/pages/__frametop.htm";

}


#-----------------------------------------------------------------#
sub run_gui(){
        $LOG = "test".$i."_sim.log";
        $COV = "cov".$i;
        simulation();
        system "vsim $VSIMOPT +UVM_TESTNAME=$tests[$i-1]";
        system "vcover report -html $COV";
}



#-----------------------------------------------------------------#
sub clean(){
        system "rm -rf modelsim* transcript* *log* work vsim.wlf wlf* fcover* covhtml* cov* csrc simv* ";
        system "clear";
}

#-----------------------------------------------------------------#
sub read_test(){

        print "\n\n------------------------------------------------\n";
        print "Tests Available";
        print "\n------------------------------------------------\n";

        $i = 1;

        $FH;
        open(FH, "<testcases.txt");
        @tests = <FH>;
        foreach (@tests){
                chomp($_);
                print "$i. $_\n";
                $i++;
        }
        close(FH);
        print "------------------------------------------------\n";


}




