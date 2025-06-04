@echo off
echo ==========================================
echo     Simple Algorithm Compiler Demo
echo ==========================================
echo.

if not exist compiler.exe (
    echo Compiler not found, building...
    call build_fixed.bat
    echo.
)

if not exist compiler.exe (
    echo Build failed, cannot continue demo
    pause
    exit /b 1
)

:menu
cls
echo ==========================================
echo     Simple Algorithm Compiler Demo Menu
echo ==========================================
echo.
echo 1. Show help information
echo 2. Run Hello World example
echo 3. Run math calculation example
echo 4. Run loop example (sum 1 to 10)
echo 5. Run Fibonacci sequence example
echo 6. Compile example to C code
echo 7. Run all tests
echo 8. Custom input
echo 0. Exit
echo.
set /p choice=Please choose (0-8): 

if "%choice%"=="0" goto end
if "%choice%"=="1" goto help
if "%choice%"=="2" goto hello
if "%choice%"=="3" goto math
if "%choice%"=="4" goto loop
if "%choice%"=="5" goto fibonacci
if "%choice%"=="6" goto compile
if "%choice%"=="7" goto test_all
if "%choice%"=="8" goto custom

echo Invalid choice, please try again
pause
goto menu

:help
cls
echo ==========================================
echo     Compiler Help Information
echo ==========================================
compiler.exe -h
echo.
pause
goto menu

:hello
cls
echo ==========================================
echo     Hello World Example
echo ==========================================
echo Source code:
type examples\hello.alg
echo.
echo Execution result:
compiler.exe -i examples\hello.alg
echo.
pause
goto menu

:math
cls
echo ==========================================
echo     Math Calculation Example
echo ==========================================
echo Source code:
type examples\math.alg
echo.
echo Execution result:
compiler.exe -i examples\math.alg
echo.
pause
goto menu

:loop
cls
echo ==========================================
echo     Loop Example (sum 1 to 10)
echo ==========================================
echo Source code:
type examples\loop.alg
echo.
echo Execution result:
compiler.exe -i examples\loop.alg
echo.
pause
goto menu

:fibonacci
cls
echo ==========================================
echo     Fibonacci Sequence Example
echo ==========================================
echo Source code:
type examples\fibonacci.alg
echo.
echo Execution result:
compiler.exe -i examples\fibonacci.alg
echo.
pause
goto menu

:compile
cls
echo ==========================================
echo     Compile to C Code Example
echo ==========================================
echo Compiling hello.alg to hello.c...
compiler.exe -c examples\hello.alg hello.c
echo.
if exist hello.c (
    echo Success! Generated C code:
    echo.
    type hello.c
    echo.
    echo Compiling and running generated C program...
    gcc hello.c -o hello.exe
    if exist hello.exe (
        echo C program compiled successfully, execution result:
        hello.exe
    )
)
echo.
pause
goto menu

:test_all
cls
echo ==========================================
echo     Run All Tests
echo ==========================================
call test_fixed.bat
goto menu

:custom
cls
echo ==========================================
echo     Custom Input
echo ==========================================
echo Please enter algorithm code (end with empty line):
echo.

set "input_file=temp_input.alg"
if exist "%input_file%" del "%input_file%"

:input_loop
set /p line=
if "%line%"=="" goto run_custom
echo %line% >> "%input_file%"
goto input_loop

:run_custom
echo.
echo Execution result:
compiler.exe -i "%input_file%"
echo.
if exist "%input_file%" del "%input_file%"
pause
goto menu

:end
echo.
echo Thank you for using Simple Algorithm Compiler!
pause