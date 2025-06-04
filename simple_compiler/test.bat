@echo off
chcp 65001 >nul
echo ==========================================
echo     测试简单算法编译器
echo ==========================================
echo.

if not exist compiler.exe (
    echo ❌ 编译器不存在，请先运行 build.bat
    pause
    exit /b 1
)

echo 测试1：Hello World程序
echo 源代码 (examples\hello.alg):
type examples\hello.alg
echo.
echo 执行结果：
compiler.exe -i examples\hello.alg
echo.

echo ==========================================
echo.

echo 测试2：数学计算程序
echo 源代码 (examples\math.alg):
type examples\math.alg
echo.
echo 执行结果：
compiler.exe -i examples\math.alg
echo.

echo ==========================================
echo.

echo 测试3：循环程序 (1到10的和)
echo 源代码 (examples\loop.alg):
type examples\loop.alg
echo.
echo 执行结果：
compiler.exe -i examples\loop.alg
echo.

echo ==========================================
echo.

echo 测试4：斐波那契数列
echo 源代码 (examples\fibonacci.alg):
type examples\fibonacci.alg
echo.
echo 执行结果：
compiler.exe -i examples\fibonacci.alg
echo.

echo ==========================================
echo.

echo 测试5：编译为C代码
echo 将 hello.alg 编译为 hello.c：
compiler.exe -c examples\hello.alg hello.c
if exist hello.c (
    echo ✓ 编译成功！生成的C代码：
    echo.
    type hello.c
    echo.
    echo 编译并运行生成的C程序：
    gcc hello.c -o hello.exe
    if exist hello.exe (
        echo ✓ C程序编译成功，执行结果：
        hello.exe
    )
)

echo.
echo ==========================================
echo     所有测试完成！
echo ==========================================
pause