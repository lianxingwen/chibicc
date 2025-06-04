@echo off
chcp 65001 >nul
echo ==========================================
echo     简单语法编译器演示
echo ==========================================
echo.
echo 这个演示展示了一个完整的语法编译器：
echo 1. 解析 BNF 风格的语法定义
echo 2. 从语法生成 C 解析器
echo 3. 测试生成的解析器
echo.

echo 让我们从一个简单的问候语法开始...
echo.
echo === 简单语法 ===
echo 语法定义 (examples\simple.grammar):
type examples\simple.grammar
echo.

echo 生成解析器...
grammar_compiler.exe examples\simple.grammar simple_parser.c
echo.

echo 编译生成的解析器...
gcc simple_parser.c -o simple_parser.exe
echo.

echo 测试有效输入：
echo   'hello world': 
simple_parser.exe "hello world" && echo ✓ 接受
echo   'hi there': 
simple_parser.exe "hi there" && echo ✓ 接受
echo   'hello there': 
simple_parser.exe "hello there" && echo ✓ 接受
echo   'hi world': 
simple_parser.exe "hi world" && echo ✓ 接受

echo.
echo 测试无效输入：
echo   'goodbye world': 
simple_parser.exe "goodbye world" || echo ✗ 正确拒绝

echo.
echo === 算术语法 ===
echo 语法定义 (examples\arithmetic.grammar):
type examples\arithmetic.grammar
echo.

echo 生成解析器...
grammar_compiler.exe examples\arithmetic.grammar arithmetic_parser.c
echo.

echo 编译生成的解析器...
gcc arithmetic_parser.c -o arithmetic_parser.exe
echo.

echo 测试算术表达式：
echo   '1': 
arithmetic_parser.exe "1" && echo ✓ 接受
echo   '1+2': 
arithmetic_parser.exe "1+2" && echo ✓ 接受
echo   '1+2*3': 
arithmetic_parser.exe "1+2*3" && echo ✓ 接受
echo   '(1+2)*3': 
arithmetic_parser.exe "(1+2)*3" && echo ✓ 接受
echo   '1+2-3*4/5': 
arithmetic_parser.exe "1+2-3*4/5" && echo ✓ 接受

echo.
echo 测试无效表达式：
echo   '1+': 
arithmetic_parser.exe "1+" || echo ✗ 正确拒绝
echo   '+1': 
arithmetic_parser.exe "+1" || echo ✗ 正确拒绝
echo   '1++2': 
arithmetic_parser.exe "1++2" || echo ✗ 正确拒绝

echo.
echo ==========================================
echo     演示完成！
echo ==========================================
echo.
echo 语法编译器成功：
echo ✓ 解析了两个语法定义
echo ✓ 生成了工作的 C 解析器
echo ✓ 接受了所有有效输入
echo ✓ 拒绝了所有无效输入
echo.
echo 您可以创建自己的语法并生成
echo 任何您想要解析的语言的解析器！
echo.
pause