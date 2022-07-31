all: build/echo.ihex build/monitor.ihex

clean:
	rm -Rf build/*

.SECONDARY: # don't rm all "intermediate" targets

build/%.asm: src/%.c
	@echo $@; sdcc -S $< -o $@

build/%.o: build/%.asm
	@echo $@; tarn-elf32-as $< -o $@

build/%.elf: build/%.o build/ram-boot.ld.txt
	@echo $@; tarn-elf32-ld -T build/ram-boot.ld.txt -o $@ $< && tarn-elf32-objdump -d $@ && tarn-elf32-nm $@ | sort -g

build/%.ihex: build/%.elf
	@echo $@; tarn-elf32-objcopy -O ihex $< $@

build/ram-boot.ld.txt: ram-boot.ld.txt
	TEXT=0x4000 envsubst < $< > $@
