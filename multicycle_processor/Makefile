# Makefile for Multicycle Processor
# 支持Windows和Linux环境

# 检测操作系统
ifeq ($(OS),Windows_NT)
    # Windows环境
    IVERILOG = iverilog.exe
    VVP = vvp.exe
    GTKWAVE = gtkwave.exe
    RM = del /Q
    MKDIR = mkdir
else
    # Linux/Unix环境
    IVERILOG = iverilog
    VVP = vvp
    GTKWAVE = gtkwave
    RM = rm -f
    MKDIR = mkdir -p
endif

# 源文件
SOURCES = alu.v register_file.v memory.v control_unit.v datapath.v multicycle_processor.v testbench.v

# 目标文件
TARGET = multicycle_processor
VCD_FILE = $(TARGET).vcd

# 默认目标
all: compile run

# 编译
compile:
	$(IVERILOG) -o $(TARGET) $(SOURCES)

# 运行仿真
run: compile
	$(VVP) $(TARGET)

# 查看波形（需要安装GTKWave）
wave: run
	$(GTKWAVE) $(VCD_FILE)

# 清理
clean:
ifeq ($(OS),Windows_NT)
	if exist $(TARGET) $(RM) $(TARGET)
	if exist $(VCD_FILE) $(RM) $(VCD_FILE)
else
	$(RM) $(TARGET) $(VCD_FILE)
endif

# 帮助
help:
	@echo "可用目标:"
	@echo "  all     - 编译并运行仿真"
	@echo "  compile - 编译Verilog源文件"
	@echo "  run     - 运行仿真"
	@echo "  wave    - 查看波形文件"
	@echo "  clean   - 清理生成的文件"
	@echo "  help    - 显示此帮助信息"

.PHONY: all compile run wave clean help