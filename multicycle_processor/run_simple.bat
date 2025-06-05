@echo off
chcp 65001 >nul
echo ========================================
echo Multicycle MIPS Processor Simulation
echo ========================================

REM Check if Icarus Verilog is installed
where iverilog >nul 2>nul
if %errorlevel% neq 0 (
    echo ERROR: iverilog command not found
    echo Please install Icarus Verilog: http://bleyer.org/icarus/
    pause
    exit /b 1
)

echo Compiling Verilog source files...
iverilog -o multicycle_processor alu.v register_file.v memory.v control_unit.v datapath.v multicycle_processor.v testbench.v

if %errorlevel% neq 0 (
    echo Compilation failed!
    pause
    exit /b 1
)

echo Compilation successful! Running simulation...
vvp multicycle_processor

if %errorlevel% neq 0 (
    echo Simulation failed!
    pause
    exit /b 1
)

echo.
echo Simulation completed!
echo Generated waveform file: multicycle_processor.vcd

REM Check if GTKWave is installed
where gtkwave >nul 2>nul
if %errorlevel% equ 0 (
    echo.
    echo GTKWave is available!
    set /p choice="Open waveform viewer? (y/n): "
    if /i "%choice%"=="y" (
        echo.
        echo Opening GTKWave...
        echo If GTKWave doesn't open, please run this command manually:
        echo gtkwave multicycle_processor.vcd
        echo.
        REM Try to open GTKWave
        gtkwave multicycle_processor.vcd &
    )
) else (
    echo.
    echo GTKWave not found in PATH
    echo To view waveforms, install GTKWave from: http://gtkwave.sourceforge.net/
    echo Then run: gtkwave multicycle_processor.vcd
)

echo.
echo Press any key to exit...
pause >nul