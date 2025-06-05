@echo off
echo ========================================
echo Test Waveform Display Fix
echo ========================================

echo Recompiling Verilog files...
iverilog -o multicycle_processor alu.v register_file.v memory.v control_unit.v datapath.v multicycle_processor.v testbench.v

if %errorlevel% neq 0 (
    echo Compilation failed!
    echo Please check if all .v files are in current directory
    dir *.v
    pause
    exit /b 1
)

echo Compilation successful!
echo Running simulation...
vvp multicycle_processor

if %errorlevel% neq 0 (
    echo Simulation failed!
    pause
    exit /b 1
)

echo.
echo Checking VCD file...
if exist "multicycle_processor.vcd" (
    echo VCD file created successfully
    dir multicycle_processor.vcd
) else (
    echo ERROR: VCD file not created
    pause
    exit /b 1
)

echo.
echo In GTKWave you should now see these signals:
echo - testbench.clk_wire (clock signal)
echo - testbench.reset_wire (reset signal)
echo - testbench.pc_wire (program counter)
echo - testbench.instruction_wire (current instruction)
echo - testbench.state_wire (control state)
echo - testbench.reg1_wire to reg7_wire (registers)

echo.
set /p choice="Open GTKWave to view waveforms? (y/n): "
if /i "%choice%"=="y" (
    echo Opening GTKWave...
    gtkwave multicycle_processor.vcd
)

echo.
pause