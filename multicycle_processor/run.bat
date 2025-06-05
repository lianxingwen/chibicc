@echo off
chcp 65001 >nul
REM Windows Batch File - Multicycle Processor Simulation

echo ========================================
echo Multicycle MIPS Processor Simulation
echo ========================================

REM Check if Icarus Verilog is installed
where iverilog >nul 2>nul
if %errorlevel% neq 0 (
    echo ERROR: iverilog command not found
    echo Please install Icarus Verilog: http://bleyer.org/icarus/
    echo.
    echo Installation steps:
    echo 1. Download from http://bleyer.org/icarus/
    echo 2. Run installer as administrator
    echo 3. Make sure to check "Add to PATH" option
    echo 4. Restart command prompt
    echo.
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
    set /p choice="Open waveform viewer? (y/n): "
    if /i "%choice%"=="y" (
        echo Opening GTKWave...
        echo Trying method 1: Direct command
        gtkwave multicycle_processor.vcd
        if %errorlevel% neq 0 (
            echo Method 1 failed, trying method 2: Using start command
            start "" gtkwave multicycle_processor.vcd
            if %errorlevel% neq 0 (
                echo Method 2 failed, trying method 3: Full path
                for /f "tokens=*" %%i in ('where gtkwave') do set GTKWAVE_PATH=%%i
                echo GTKWave path: %GTKWAVE_PATH%
                "%GTKWAVE_PATH%" multicycle_processor.vcd
                if %errorlevel% neq 0 (
                    echo All methods failed. Please run manually:
                    echo gtkwave multicycle_processor.vcd
                )
            )
        )
    )
) else (
    echo.
    echo TIP: Install GTKWave to view waveform files
    echo Download: http://gtkwave.sourceforge.net/
)

echo.
pause