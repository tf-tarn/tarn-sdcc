OUTPUTS = stdout


# N.B. We name and open the input VCD file here because if this
# is an out-of-tree build we want make to tell us the pathname.
$(OUTPUTS):	test.cmd test.ihx test-in.vcd
	$(call run-sim, -t S003 -e 'set hw vcd input "$(filter %.vcd,$+)"')


include test-lib.mk
