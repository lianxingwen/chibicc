@echo off
echo Compiling...
iverilog -o multicycle_processor alu.v register_file.v memory.v control_unit.v datapath.v multicycle_processor.v testbench.v

if %errorlevel% neq 0 (
    echo Compilation failed!
    pause
    exit /b 1
)

echo Running simulation...
vvp multicycle_processor

if %errorlevel% neq 0 (
    echo Simulation failed!
    pause
    exit /b 1
)

echo Opening GTKWave...
gtkwave multicycle_processor.vcd

pause