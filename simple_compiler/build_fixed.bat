@echo off
echo ==========================================
echo     Build Simple Algorithm Compiler
echo ==========================================
echo.

echo Checking GCC compiler...
gcc --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: GCC compiler not found!
    echo Please install MinGW-w64 or TDM-GCC first
    pause
    exit /b 1
)

echo Found GCC compiler
echo.

echo Compiling source files...
gcc -Wall -Wextra -std=c99 -c main.c -o main.o
gcc -Wall -Wextra -std=c99 -c lexer.c -o lexer.o
gcc -Wall -Wextra -std=c99 -c parser.c -o parser.o
gcc -Wall -Wextra -std=c99 -c ast.c -o ast.o
gcc -Wall -Wextra -std=c99 -c environment.c -o environment.o
gcc -Wall -Wextra -std=c99 -c interpreter.c -o interpreter.o
gcc -Wall -Wextra -std=c99 -c codegen.c -o codegen.o

echo Linking executable...
gcc main.o lexer.o parser.o ast.o environment.o interpreter.o codegen.o -o compiler.exe

if exist compiler.exe (
    echo.
    echo Success! Generated compiler.exe
    echo.
    echo Available commands:
    echo   compiler.exe -h                    # Show help
    echo   compiler.exe -i source.alg         # Interpret and execute
    echo   compiler.exe -c source.alg out.c   # Compile to C code
) else (
    echo.
    echo Build failed!
)

echo.
pause