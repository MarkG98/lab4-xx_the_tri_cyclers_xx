# to run: make run
# to attach certain tests: make run CHECKS="regmem (index),(value) (index),(value) ... datamem (index),(value) (index),(value) ..."
# if you want to run other test benches, do make run TEST=(name)
# make sure to include the correct directory path for the folder in the TEST.
#
# ------------------------
# | Other Possible Tests |
# ------------------------
# test ALU --> make run TEST=ALU/alu
# test regfile --> make run TEST=Regfile/regfile
# test sign extend --> make run TEST=signExtend

ICARUS_OPTIONS := -Wall
IVERILOG := iverilog $(ICARUS_OPTIONS)
SIM := vvp

TEST:= cpu

cpu.vvp: cpu.t.v cpu.v
	$(IVERILOG) -o $@ $<

%.vvp: %.t.v %.v
	$(IVERILOG) -o $@ $<

run: $(TEST).vvp memchecker.py
	$(SIM) $< && python memchecker.py $(CHECKS)

clean:
	rm *.vvp
