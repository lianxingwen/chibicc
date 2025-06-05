@echo off
chcp 65001 >nul
echo ========================================
echo System Check for Multicycle Processor
echo ========================================
echo.

echo Checking Windows version...
ver
echo.

echo Checking Icarus Verilog installation...
where iverilog >nul 2>nul
if %errorlevel% equ 0 (
    echo ✓ iverilog found
    iverilog -V
) else (
    echo × iverilog NOT found
    echo   Please install from: http://bleyer.org/icarus/
)
echo.

echo Checking VVP (Verilog simulator)...
where vvp >nul 2>nul
if %errorlevel% equ 0 (
    echo ✓ vvp found
    vvp -V
) else (
    echo × vvp NOT found
)
echo.

echo Checking GTKWave (optional)...
where gtkwave >nul 2>nul
if %errorlevel% equ 0 (
    echo ✓ gtkwave found
) else (
    echo - gtkwave not found (optional for waveform viewing)
    echo   Download from: http://gtkwave.sourceforge.net/
)
echo.

echo Checking source files...
if exist "alu.v" (
    echo ✓ alu.v found
) else (
    echo × alu.v missing
)

if exist "register_file.v" (
    echo ✓ register_file.v found
) else (
    echo × register_file.v missing
)

if exist "memory.v" (
    echo ✓ memory.v found
) else (
    echo × memory.v missing
)

if exist "control_unit.v" (
    echo ✓ control_unit.v found
) else (
    echo × control_unit.v missing
)

if exist "datapath.v" (
    echo ✓ datapath.v found
) else (
    echo × datapath.v missing
)

if exist "multicycle_processor.v" (
    echo ✓ multicycle_processor.v found
) else (
    echo × multicycle_processor.v missing
)

if exist "testbench.v" (
    echo ✓ testbench.v found
) else (
    echo × testbench.v missing
)

echo.
echo PATH environment variable:
echo %PATH%
echo.

echo ========================================
echo Check completed!
echo ========================================
echo.
echo If all source files are found and iverilog is available,
echo you can run: run.bat
echo.
pause