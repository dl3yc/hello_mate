syn_%: $(WORKDIR)/%.v $(SYNDIR)/%.ccf | $(WORKDIR)
	cd $(WORKDIR); ../$(PR) -i $*.v -o $* -ccf ../$(SYNDIR)/$*.ccf

$(WORKDIR)/%.v: $(SRC) | $(WORKDIR)
	yosys $(YOSYS_MODULE) -p 'ghdl $(GHDLFLAGS) $(SRC) -e $*_syn; chformal -remove; synth_gatemate -top $*_syn -nomx8; write_verilog -noattr $(WORKDIR)/$*.v'

pgm_%:
	openFPGALoader -b $(BOARD) $(WORKDIR)/$*_00.cfg

pgm_flash_%:
	openFPGALoader -b $(BOARD) -f --verify $(WORKDIR)/$*_00.cfg
