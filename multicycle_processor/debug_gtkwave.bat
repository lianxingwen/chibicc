@echo off
chcp 65001 >nul
echo ========================================
echo GTKWave Debug Information
echo ========================================
echo.

echo 1. Checking GTKWave installation...
where gtkwave
if %errorlevel% equ 0 (
    echo ✓ GTKWave found in PATH
) else (
    echo × GTKWave NOT found in PATH
    goto :end
)

echo.
echo 2. GTKWave version information...
gtkwave --version
echo.

echo 3. Checking VCD file...
if exist "multicycle_processor.vcd" (
    echo ✓ VCD file exists
    dir multicycle_processor.vcd
) else (
    echo × VCD file not found
    echo Please run the simulation first
    goto :end
)

echo.
echo 4. Testing GTKWave launch methods...

echo.
echo Method 1: Direct command
echo Command: gtkwave multicycle_processor.vcd
echo Press any key to test this method...
pause >nul
gtkwave multicycle_processor.vcd
echo Method 1 exit code: %errorlevel%

echo.
echo Method 2: Using start command
echo Command: start gtkwave multicycle_processor.vcd
echo Press any key to test this method...
pause >nul
start gtkwave multicycle_processor.vcd
echo Method 2 exit code: %errorlevel%

echo.
echo Method 3: Using start with empty title
echo Command: start "" gtkwave multicycle_processor.vcd
echo Press any key to test this method...
pause >nul
start "" gtkwave multicycle_processor.vcd
echo Method 3 exit code: %errorlevel%

echo.
echo Method 4: Full path execution
for /f "tokens=*" %%i in ('where gtkwave') do set GTKWAVE_PATH=%%i
echo GTKWave full path: %GTKWAVE_PATH%
echo Command: "%GTKWAVE_PATH%" multicycle_processor.vcd
echo Press any key to test this method...
pause >nul
"%GTKWAVE_PATH%" multicycle_processor.vcd
echo Method 4 exit code: %errorlevel%

:end
echo.
echo ========================================
echo Debug completed!
echo ========================================
echo.
echo If none of the methods worked, try:
echo 1. Run from PowerShell: gtkwave multicycle_processor.vcd
echo 2. Double-click GTKWave icon and open file manually
echo 3. Check if GTKWave is properly installed
echo.
pause