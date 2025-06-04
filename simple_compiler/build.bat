@echo off
chcp 65001 >nul
echo ==========================================
echo     编译简单算法编译器
echo ==========================================
echo.

echo 检查 GCC 编译器...
gcc --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ 未找到 GCC 编译器！
    echo 请先安装 MinGW-w64 或 TDM-GCC
    pause
    exit /b 1
)

echo ✓ 找到 GCC 编译器
echo.

echo 编译源文件...
gcc -Wall -Wextra -std=c99 -c main.c -o main.o
gcc -Wall -Wextra -std=c99 -c lexer.c -o lexer.o
gcc -Wall -Wextra -std=c99 -c parser.c -o parser.o
gcc -Wall -Wextra -std=c99 -c ast.c -o ast.o
gcc -Wall -Wextra -std=c99 -c environment.c -o environment.o
gcc -Wall -Wextra -std=c99 -c interpreter.c -o interpreter.o
gcc -Wall -Wextra -std=c99 -c codegen.c -o codegen.o

echo 链接生成可执行文件...
gcc main.o lexer.o parser.o ast.o environment.o interpreter.o codegen.o -o compiler.exe

if exist compiler.exe (
    echo.
    echo ✓ 编译成功！生成了 compiler.exe
    echo.
    echo 可用命令：
    echo   compiler.exe -h                    # 显示帮助
    echo   compiler.exe -i 源文件.txt         # 解释执行
    echo   compiler.exe -c 源文件.txt 输出.c  # 编译为C代码
) else (
    echo.
    echo ❌ 编译失败！
)

echo.
pause