@echo off
chcp 65001 >nul
echo ==========================================
echo     语法编译器 Windows 安装程序
echo ==========================================
echo.

echo 检查 GCC 编译器...
gcc --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ 未找到 GCC 编译器！
    echo.
    echo 请先安装以下任一编译器：
    echo 1. MinGW-w64: https://www.mingw-w64.org/downloads/
    echo 2. TDM-GCC: https://jmeubank.github.io/tdm-gcc/
    echo 3. MSYS2: https://www.msys2.org/
    echo.
    echo 安装后请确保将编译器添加到系统 PATH
    echo 然后重新运行此脚本
    pause
    exit /b 1
)

echo ✓ 找到 GCC 编译器
gcc --version | findstr gcc
echo.

echo 编译语法编译器...
call build.bat

if not exist grammar_compiler.exe (
    echo ❌ 编译失败！
    pause
    exit /b 1
)

echo.
echo ✓ 语法编译器编译成功！
echo.

echo 运行快速测试...
echo.

echo 测试简单语法...
grammar_compiler.exe examples\simple.grammar test_parser.c
gcc test_parser.c -o test_parser.exe
echo   测试 "hello world": 
test_parser.exe "hello world" && echo ✓ 成功

echo.
echo 测试算术语法...
grammar_compiler.exe examples\arithmetic.grammar test_arith.c
gcc test_arith.c -o test_arith.exe
echo   测试 "1+2*3": 
test_arith.exe "1+2*3" && echo ✓ 成功

echo.
echo 清理测试文件...
del test_parser.c test_parser.exe test_arith.c test_arith.exe 2>nul

echo.
echo ==========================================
echo     安装完成！
echo ==========================================
echo.
echo 可用的命令：
echo   build.bat        - 编译语法编译器
echo   demo.bat         - 运行完整演示
echo   test_simple.bat  - 测试简单语法
echo   test_arithmetic.bat - 测试算术语法
echo   clean.bat        - 清理编译文件
echo.
echo 基本用法：
echo   grammar_compiler.exe 语法文件.grammar 输出文件.c
echo.
echo 查看 README_Windows.md 获取详细使用说明
echo.
pause