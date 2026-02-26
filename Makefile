all: out/marathon-s1.sms

out/ build/:
	install -D -d $@

out/marathon-s1.sms: src/whole.lnk build/whole.o | out/
	wlalink -v -S $< $@

build/whole.o: src/whole.asm $(wildcard src/data/*) | build/
	wla-z80 -v -o $@ $<
