# Makefile for Single-Cycle Processor

# Verilog files
VERILOG_FILES = single_cycle_processor.v \
                instruction_memory.v \
                register_file.v \
                alu.v \
                data_memory.v \
                control_unit.v \
                testbench.v

# Output files
EXECUTABLE = processor_sim
VCD_FILE = processor_waveform.vcd

# Default target
all: simulate

# Compile and simulate
simulate: $(EXECUTABLE)
	./$(EXECUTABLE)

# Compile with iverilog
$(EXECUTABLE): $(VERILOG_FILES)
	iverilog -o $(EXECUTABLE) $(VERILOG_FILES)

# View waveforms (requires gtkwave)
wave: $(VCD_FILE)
	gtkwave $(VCD_FILE) &

# Clean generated files
clean:
	rm -f $(EXECUTABLE) $(VCD_FILE)

# Install dependencies (Ubuntu/Debian)
install-deps:
	sudo apt-get update
	sudo apt-get install -y iverilog gtkwave

# Help
help:
	@echo "Available targets:"
	@echo "  all         - Compile and simulate (default)"
	@echo "  simulate    - Compile and run simulation"
	@echo "  wave        - View waveforms with gtkwave"
	@echo "  clean       - Remove generated files"
	@echo "  install-deps- Install iverilog and gtkwave"
	@echo "  help        - Show this help message"

.PHONY: all simulate wave clean install-deps help