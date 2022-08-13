GTKW		= gtkwave
GHDL		= ghdl
PR			= ../cc-toolchain-win/bin/p_r/p_r.exe
GHDLFLAGS	= --std=08 --workdir=$(WORKDIR)
SIMTIME		?= 1ms 
YOSYS		= yosys
YOSYS_MODULE = -m /usr/lib/ghdl_yosys.so
RM			= rm -f

WORKDIR		= work
SRCDIR		= src
SIMDIR		= sim
SYNDIR		= syn

DEP_BLINKY	= $(WORKDIR) $(WORKDIR)/helper_pkg.o $(WORKDIR)/blinky.o
SRC			= $(SRCDIR)/helper/helper_pkg.vhd $(SRCDIR)/blinky/blinky.vhd $(SRCDIR)/blinky/blinky_syn.vhd
BOARD		= gatemate_evb_jtag

all:
	@printf "run \e[1mmake syn_blinky\e[0m for synthesis or run \e[1mmake sim_blinky\e[0m for simulation\n"

blinky: $(DEP_BLINKY) run_blinky

.PHONY: all run_% show_% syn_% clean

$(WORKDIR):
	mkdir -p $(WORKDIR)

$(SIMDIR):
	mkdir -p $(SIMDIR)

clean:
	$(GHDL) --clean $(GHDLFLAGS)
	$(RM) -r $(WORKDIR)
	$(RM) -r $(SIMDIR)/*.ghw
	$(RM) -r $(SIMDIR)/*.raw
	$(RM) -r $(SIMDIR)/*.bin

include sim.mk
include syn.mk
