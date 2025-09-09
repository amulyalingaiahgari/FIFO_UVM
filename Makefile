# Synopsys VCS Makefile for FIFO UVM Testbench
# Usage : make [target]

# Source files
DUT_SRC = FIFO.v
TB_SRC = interface.sv \
         transaction.sv \
         driver.sv \
         monitor.sv \
         agent.sv \
         scoreboard.sv \
         environment.sv \
         basic_test_seq.sv \
         base_test.sv \
         tb_top.sv \

# Default target
all: compile run debug

compile:
    VCS -sverilog -ntb_opts uvm-1.2 -full64 +vcs+fsdbon -debug_all $(DUT_SRC) $(TB_SRC)

run:
    ./simv

clean:
    rm -rf simv* csrc *.log *.vpd *.vdb ucli.key DVEfiles
