run_%: %_tb | $(SIMDIR)
	cd $(WORKDIR); $(GHDL) -r $*_tb --stop-time=$(SIMTIME) --wave=../$(SIMDIR)/$*.ghw --ieee-asserts=enable
show_%: | $(SIMDIR)
	$(GTKW) $(SIMDIR)/$*.ghw $(SIMDIR)/$*.sav &

sim_%: % show_%
	echo simulation done.

.SECONDEXPANSION:
$(WORKDIR)/%.o: BASE = $(notdir $(basename $@))
$(WORKDIR)/%.o: BASE_REQ = $(SRCDIR)/$(firstword $(subst _, ,$(BASE)))/$(BASE).vhd

$(WORKDIR)/%.o: $$(BASE_REQ) | $(WORKDIR)
	$(GHDL) -a $(GHDLFLAGS) $(SRCDIR)/$(firstword $(subst _, ,$(BASE)))/$*.vhd

%_tb: $(WORKDIR)/%_tb.o | $(WORKDIR)
	$(GHDL) -m $(GHDLFLAGS) -o $(WORKDIR)/$*_tb $*_tb
