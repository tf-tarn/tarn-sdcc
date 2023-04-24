all: build/echo.ihex build/monitor.ihex

clean:
	@rm -Rf build/*

CC=/home/tarn/projects/tarnos/sdcc/sdcc-4.2.0/bin/sdcc

.SECONDARY: # don't rm all "intermediate" targets

build/%.asm: src/%.c
	$(CC) -S $< -o $@

build/%.o: build/%.asm
	@echo $@;
	tarn-elf32-as $< -o $@

build/%.s.o: asm_src/%.s
	@echo $@;
	tarn-elf32-as -I /home/tarn/projects/tarnos/asm/src $< -o $@

build/%.elf: build/%.o build/ram-boot.ld.txt
	@echo $@; tarn-elf32-ld -T build/ram-boot.ld.txt -o $@ $< && tarn-elf32-objdump -d $@
	tarn-elf32-nm $@ | sort

build/%.s.elf: build/%.s.o build/ram-boot.ld.txt
	@echo $@; tarn-elf32-ld -T build/ram-boot.ld.txt -o $@ $< && tarn-elf32-objdump -d $@
	tarn-elf32-nm $@ | sort

build/%.ihex: build/%.elf
	@echo $@; tarn-elf32-objcopy --keep-section .init -O ihex $< $@

build/ram-boot.ld.txt: ram-boot.ld.txt
	TEXT=0x4000 envsubst < $< > $@
