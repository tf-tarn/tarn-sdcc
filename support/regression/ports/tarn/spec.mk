# Regression test specification for the tarn14 target running with uCsim

# simulation timeout in seconds
SIM_TIMEOUT = 30

# path to uCsim

EMU = ~/projects/tarnos/sim/sim

AS = tarn-elf32-as

ifndef CROSSCOMPILING
  SDCCFLAGS += --nostdinc -I$(top_srcdir)
  # LINKFLAGS += --nostdlib -L$(top_builddir)/device/lib/build/pdk15
endif

ifdef CROSSCOMPILING
  SDCCFLAGS += -I$(top_srcdir)
endif

SDCCFLAGS += -mtarn --less-pedantic -S # --out-fmt-ihx
# LINKFLAGS += pdk15.lib

OBJEXT = .o
BINEXT = .elf

# otherwise `make` deletes testfwk.rel and `make -j` will fail
.PRECIOUS: $(PORT_CASES_DIR)/%$(OBJEXT)

#$(PORT_CASES_DIR)/testfwk$(OBJEXT) $(PORT_CASES_DIR)/support$(OBJEXT)
# include $(srcdir)/fwk/lib/spec.mk

# build/%.asm: src/%.c
# 	sdcc -S $< -o $@

# build/%.o: build/%.asm
# 	@echo $@; tarn-elf32-as $< -o $@

# build/%.elf: build/%.o build/ram-boot.ld.txt
# 	@echo $@; tarn-elf32-ld -T build/ram-boot.ld.txt -o $@ $< && tarn-elf32-objdump -d $@
# 	tarn-elf32-nm $@ | sort

# build/%.ihex: build/%.elf
# 	@echo $@; tarn-elf32-objcopy --keep-section .init -O ihex $< $@

# build/ram-boot.ld.txt: ram-boot.ld.txt
# 	TEXT=0x4000 envsubst < $< > $@


.SUFFIXES: # disable built-in rules
.SECONDARY: # don't rm all "intermediate" targets

# Required extras
EXTRAS = $(PORT_CASES_DIR)/testfwk$(OBJEXT) $(PORT_CASES_DIR)/support$(OBJEXT)
include $(srcdir)/fwk/lib/spec.mk

# Rule to link into .ihx
# $(PORT_CASES_DIR)/extern2.o
%$(BINEXT): %$(OBJEXT) $(EXTRAS) $(FWKLIB) $(EXTRAS) $(PORT_CASES_DIR)/statics.o $(PORT_CASES_DIR)/extern1.o
	tarn-elf32-ld -T /home/tarn/projects/tarnos/build/ram-boot.ld.txt -o $@ $^ $(top_builddir)/device/lib/build/tarn/tarn.lib

################################################################################

gen/tarn/array/array_storage___code_type_int.elf:
	echo	-e '\x1B[1;33mskip because of left shift\x1B[0;37m'
gen/tarn/array/array_storage_none_type_int.elf:
	echo	-e '\x1B[1;33mskip because of left shift\x1B[0;37m'
gen/tarn/bug-2175/bug-2175.elf:
	echo	-e '\x1B[1;33mskip because of left shift\x1B[0;37m'
gen/tarn/bug-2181/bug-2181.elf:
	echo	-e '\x1B[1;33mskip because of left shift\x1B[0;37m'
gen/tarn/bug-2222/bug-2222.elf:
	echo	-e '\x1B[1;33mskip because of left shift\x1B[0;37m'
gen/tarn/bug-2305/bug-2305.elf:
	echo	-e '\x1B[1;33mskip because of left shift\x1B[0;37m'
gen/tarn/bug-2357/bug-2357.elf:
	echo	-e '\x1B[1;33mskip because of left shift\x1B[0;37m'
gen/tarn/bug-2458/bug-2458.elf:
	echo	-e '\x1B[1;33mskip because of left shift\x1B[0;37m'
gen/tarn/bug-2559/bug-2559.elf:
	echo	-e '\x1B[1;33mskip because of left shift\x1B[0;37m'
gen/tarn/bug-2567/bug-2567.elf:
	echo	-e '\x1B[1;33mskip because of left shift\x1B[0;37m'
gen/tarn/bug-2764/bug-2764.elf:
	echo	-e '\x1B[1;33mskip because of left shift\x1B[0;37m'
gen/tarn/bug-2964/bug-2964.elf:
	echo	-e '\x1B[1;33mskip because of left shift\x1B[0;37m'
gen/tarn/bug-3066/bug-3066.elf:
	echo	-e '\x1B[1;33mskip because of left shift\x1B[0;37m'
gen/tarn/bug-2590/bug-2590.elf:
	echo	-e '\x1B[1;33mskip because of left shift\x1B[0;37m'
gen/tarn/bug-2825/bug-2825.elf:
	echo	-e '\x1B[1;33mskip because of left shift\x1B[0;37m'
gen/tarn/bug-2630/bug-2630.elf:
	echo	-e '\x1B[1;33mskip because of left shift\x1B[0;37m'
gen/tarn/bug-3129/bug-3129.elf:
	echo	-e '\x1B[1;33mskip because of left shift\x1B[0;37m'
gen/tarn/bug-3322/bug-3322.elf:
	echo	-e '\x1B[1;33mskip because of left shift\x1B[0;37m'
gen/tarn/bug-408x972/bug-408972.elf:
	echo	-e '\x1B[1;33mskip because of left shift\x1B[0;37m'
gen/tarn/bug-448984/bug-448984.elf:
	echo	-e '\x1B[1;33mskip because of left shift\x1B[0;37m'
gen/tarn/bug-524691/bug-524691.elf:
	echo	-e '\x1B[1;33mskip because of no floating point routines (left shift)\x1B[0;37m'

gen/tarn/absolute/absolute_mem___xdata.elf:
	echo	-e '\x1B[1;33mskip because no xdata\x1B[0;37m'
gen/tarn/array/array_storage___xdata_type_char.elf:
	echo	-e '\x1B[1;33mskip because no xdata\x1B[0;37m'
gen/tarn/array/array_storage___xdata_type_int.elf:
	echo	-e '\x1B[1;33mskip because no xdata\x1B[0;37m'
gen/tarn/bug-2133/bug-2133.elf:
	echo	-e '\x1B[1;33mskip because no xdata\x1B[0;37m'
gen/tarn/bug-221100/bug-221100.elf:
	echo	-e '\x1B[1;33mskip because no xdata\x1B[0;37m'
gen/tarn/bug-221168/bug-221168.elf:
	echo	-e '\x1B[1;33mskip because no xdata\x1B[0;37m'
gen/tarn/bug-2216/bug-2216.elf:
	echo	-e '\x1B[1;33mskip because no xdata\x1B[0;37m'
gen/tarn/bug-2320/bug-2320.elf:
	echo	-e '\x1B[1;33mskip because no xdata\x1B[0;37m'
gen/tarn/bug-2373/bug-2373.elf:
	echo	-e '\x1B[1;33mskip because no xdata\x1B[0;37m'
gen/tarn/bug-2403/bug-2403.elf:
	echo	-e '\x1B[1;33mskip because no xdata\x1B[0;37m'
gen/tarn/bug-2625/bug-2625.elf:
	echo	-e '\x1B[1;33mskip because no xdata\x1B[0;37m'
gen/tarn/bug-2601/bug-2601_mem___xdata.elf:
	echo	-e '\x1B[1;33mskip because no xdata\x1B[0;37m'
gen/tarn/bug-2752/bug-2752.elf:
	echo	-e '\x1B[1;33mskip because no xdata\x1B[0;37m'

gen/tarn/atomic/atomic.elf:
	echo	-e '\x1B[1;33mskip because no atomic\x1B[0;37m'

gen/tarn/bug-2254/bug-2254.elf:
	echo	-e '\x1B[1;33mskip because of no floating point routines (left shift)\x1B[0;37m'
gen/tarn/bug-2304/bug-2304.elf:
	echo	-e '\x1B[1;33mskip because of no floating point routines (left shift)\x1B[0;37m'
gen/tarn/bug-2516/bug-2516.elf:
	echo	-e '\x1B[1;33mskip because of no floating point routines (left shift)\x1B[0;37m'
gen/tarn/bug-2912/bug-2912.elf:
	echo	-e '\x1B[1;33mskip because of no floating point routines (left shift)\x1B[0;37m'
gen/tarn/bug-2611/bug-2611.elf:
	echo	-e '\x1B[1;33mskip because of no floating point routines (left shift)\x1B[0;37m'
gen/tarn/bug-2820/bug-2820.elf:
	echo	-e '\x1B[1;33mskip because of no floating point routines (left shift)\x1B[0;37m'
gen/tarn/bug-2833/bug-2833.elf:
	echo	-e '\x1B[1;33mskip because of no floating point routines (left shift)\x1B[0;37m'
gen/tarn/bug-3276/bug-3276.elf:
	echo	-e '\x1B[1;33mskip because of no floating point routines (left shift)\x1B[0;37m'
gen/tarn/bug-500536/bug-500536.elf:
	echo	-e '\x1B[1;33mskip because of no floating point routines (left shift)\x1B[0;37m'

gen/tarn/bug-3167/bug-3167.elf:
	echo	-e '\x1B[1;33mskip because this test is only for z80\x1B[0;37m'

gen/tarn/bug-868103/bug-868103_storage1___code_storage2___far.elf:
	echo	-e '\x1B[1;33mskip because we have no __far nor near\x1B[0;37m'
gen/tarn/bug-868103/bug-868103_storage1___far_storage2___far.elf:
	echo	-e '\x1B[1;33mskip because we have no __far nor near\x1B[0;37m'
gen/tarn/bug-868103/bug-868103_storage1___far_storage2___near.elf:
	echo	-e '\x1B[1;33mskip because we have no __far nor near\x1B[0;37m'
gen/tarn/bug-868103/bug-868103_storage1___far_storage2_none.elf:
	echo	-e '\x1B[1;33mskip because we have no __far nor near\x1B[0;37m'
gen/tarn/bug-868103/bug-868103_storage1___near_storage2___far.elf:
	echo	-e '\x1B[1;33mskip because we have no __far nor near\x1B[0;37m'
gen/tarn/bug-868103/bug-868103_storage1_none_storage2___far.elf:
	echo	-e '\x1B[1;33mskip because we have no __far nor near\x1B[0;37m'

# should be investigated:
gen/tarn/bug-1918/bug-1918.elf:
	echo	-e '\x1B[1;33mskip because function must be reentrant?\x1B[0;37m'
gen/tarn/bug-2124/bug-2124.elf:
	echo	-e '\x1B[1;33mskip because function must be reentrant?\x1B[0;37m'
gen/tarn/bug-2271/bug-2271.elf:
	echo	-e '\x1B[1;33mskip because function must be reentrant?\x1B[0;37m'
gen/tarn/bug-2455/bug-2455.elf:
	echo	-e '\x1B[1;33mskip because function must be reentrant?\x1B[0;37m'
gen/tarn/bug-2497/bug-2497.elf:
	echo	-e '\x1B[1;33mskip because function must be reentrant?\x1B[0;37m'
gen/tarn/bug-2855/bug-2855.elf:
	echo	-e '\x1B[1;33mskip because function must be reentrant?\x1B[0;37m'
gen/tarn/bug-2663/bug-2663.elf:
	echo	-e '\x1B[1;33mskip because function must be reentrant?\x1B[0;37m'
gen/tarn/bug-2767/bug-2767.elf:
	echo	-e '\x1B[1;33mskip because function must be reentrant?\x1B[0;37m'
gen/tarn/bug-716242/bug-716242.elf:
	echo	-e '\x1B[1;33mskip because function must be reentrant?\x1B[0;37m'

gen/tarn/bug-2274/bug-2274.elf:
	echo	-e '\x1B[1;33mskip because linking fails (undefined reference) ??\x1B[0;37m'
gen/tarn/bug-2732/bug-2732.elf:
	echo	-e '\x1B[1;33mskip because linking fails (undefined reference) ??\x1B[0;37m'
gen/tarn/bug-2931/bug-2931.elf:
	echo	-e '\x1B[1;33mskip because linking fails (undefined reference) ??\x1B[0;37m'
gen/tarn/bug-3117729/bug-3117729.elf:
	echo	-e '\x1B[1;33mskip because linking fails (undefined reference) ??\x1B[0;37m'
gen/tarn/bug-3127/bug-3127.elf:
	echo	-e '\x1B[1;33mskip because linking fails (undefined reference) ??\x1B[0;37m'
gen/tarn/bug-3256/bug-3256.elf:
	echo	-e '\x1B[1;33mskip because linking fails (undefined reference) ??\x1B[0;37m'
gen/tarn/bug-3495411/bug-3495411.elf:
	echo	-e '\x1B[1;33mskip because linking fails (undefined reference) ??\x1B[0;37m'
gen/tarn/bug-927659/bug-927659.elf:
	echo	-e '\x1B[1;33mskip because linking fails (undefined reference) ??\x1B[0;37m'
gen/tarn/bug1057979/bug1057979.elf:
	echo	-e '\x1B[1;33mskip because linking fails (undefined reference) ??\x1B[0;37m'
gen/tarn/bug1115321/bug1115321.elf:
	echo	-e '\x1B[1;33mskip because linking fails (undefined reference) ??\x1B[0;37m'
gen/tarn/bug1337835/bug1337835.elf:
	echo	-e '\x1B[1;33mskip because linking fails (undefined reference) ??\x1B[0;37m'

gen/tarn/bug-2031/bug-2031.elf:
	echo	-e '\x1B[1;33mskip because of right shifting things in asm that GAS '"doesn't"' allow\x1B[0;37m'

gen/tarn/bug-2349/bug-2349.elf:
	echo	-e '\x1B[1;33mskip because of function type mismatch\x1B[0;37m'
gen/tarn/bug-3081/bug-3081.elf:
	echo	-e '\x1B[1;33mskip because of function type mismatch\x1B[0;37m'

gen/tarn/bug-2551/bug-2551.elf:
	echo	-e '\x1B[1;33mskip: gen/tarn/bug-2551/bug-2551.c:30: error 9: FATAL Compiler Internal Error in file 'SDCCmem.c' line number '390' : Failed to allocate symbol to memory segment due to missing output storage class\x1B[0;37m'
gen/tarn/bug-2554/bug-2554.elf:
	echo	-e '\x1B[1;33mskip: gen/tarn/bug-2551/bug-2551.c:30: error 9: FATAL Compiler Internal Error in file 'SDCCmem.c' line number '390' : Failed to allocate symbol to memory segment due to missing output storage class\x1B[0;37m'
gen/tarn/bug-2558/bug-2558.elf:
	echo	-e '\x1B[1;33mskip: gen/tarn/bug-2551/bug-2551.c:30: error 9: FATAL Compiler Internal Error in file 'SDCCmem.c' line number '390' : Failed to allocate symbol to memory segment due to missing output storage class\x1B[0;37m'
gen/tarn/bug-2568/bug-2568.elf:
	echo	-e '\x1B[1;33mskip: gen/tarn/bug-2551/bug-2551.c:30: error 9: FATAL Compiler Internal Error in file 'SDCCmem.c' line number '390' : Failed to allocate symbol to memory segment due to missing output storage class\x1B[0;37m'

gen/tarn/bug-2756/bug-2756.elf:
	echo	-e '\x1B[1;33mskip because of no malloc\x1B[0;37m'

# definitely a code-generation problem:
gen/tarn/bug1409955/bug1409955.elf:
	echo	-e '\x1B[1;33mskip because of compiler bug\x1B[0;37m'

################################################################################

%.asm: %.c
	$(SDCC) $(SDCCFLAGS) -S $< -o $@

%$(OBJEXT): %.asm
	$(AS) $< -o $@

$(PORT_CASES_DIR)/%$(OBJEXT): $(PORT_CASES_DIR)/%.asm
	$(AS) $< -o $@

$(PORT_CASES_DIR)/%.asm: $(PORTS_DIR)/$(PORT)/%.c
	$(SDCC) $(SDCCFLAGS) $< -o $@

$(PORT_CASES_DIR)/%.asm: $(srcdir)/fwk/lib/%.c
	$(SDCC) $(SDCCFLAGS) $< -o $@

$(PORT_CASES_DIR)/fwk.lib: $(srcdir)/fwk/lib/fwk.lib
	sed 's/\.rel/\.o/g' < $< > $@

# run simulator with SIM_TIMEOUT seconds timeout
%.out: %$(BINEXT) $(PORT_CASES_DIR)/fwk.lib $(CASES_DIR)/timeout
	mkdir -p $(dir $@)
	-$(CASES_DIR)/timeout $(SIM_TIMEOUT) $(EMU) -v -q -s 50000 %$(BINEXT) $< 2>&1 > $@ \
	  || echo -e --- FAIL: \"timeout, simulation killed\" in $(<:$(BINEXT)=.c)"\n"--- Summary: 1/1/1: timeout >> $@
	$(PYTHON) $(srcdir)/get_ticks.py < $@ >> $@
	-grep -n FAIL $@ /dev/null || true

_clean:
