@echo off
echo ==========================================
echo Test Simple Algorithm Compiler
echo ==========================================

if not exist compiler.exe (
    echo Compiler not found, building...
    call build_fixed.bat
    if not exist compiler.exe (
        echo Build failed!
        exit /b 1
    )
)
echo Compiler found!

echo.
echo Testing example programs:
echo.

echo 1. Testing hello.alg:
compiler.exe -i examples\hello.alg
echo.

echo 2. Testing math.alg:
compiler.exe -i examples\math.alg
echo.

echo 3. Testing loop.alg:
compiler.exe -i examples\loop.alg
echo.

echo 4. Testing fibonacci.alg:
compiler.exe -i examples\fibonacci.alg
echo.

echo All tests completed!
pause