################################################################################
# Tools
################################################################################

# -Wall turns on all warnings
# -g2012 selects the 2012 version of iVerilog
IVERILOG=iverilog -Wall -g2012
VVP=vvp
VERILATOR_LINT=verilator_bin --lint-only

# Look up .PHONY rules for Makefiles
.PHONY: clean

test_alu_slice.bin: defines.v test_alu_slice.v alu_slice.v
	${IVERILOG} -o $@ $^

test_alu_slice.lint: defines.v test_alu_slice.v alu_slice.v
	${VERILATOR_LINT} $^

test_alu.bin: defines.v test_alu.v alu.v alu_slice.v
	${IVERILOG} -o $@ $^

test_alu.lint: defines.v test_alu.v alu.v alu_slice.v
	${VERILATOR_LINT} $^

# This calls VVP on the *.bin file you generated to make a *.vcd file
# for GTKWave
%.vcd: %.bin
	${VVP} $^

# Call this to clean up all your generated files
clean:
	rm -f *.bin *.vcd
