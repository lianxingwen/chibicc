@echo off
echo 测试算术表达式语法...
echo.

echo 生成解析器...
grammar_compiler.exe examples\arithmetic.grammar arithmetic_parser.c

echo 编译生成的解析器...
gcc arithmetic_parser.c -o arithmetic_parser.exe

echo.
echo 测试有效表达式：
echo   测试 "1":
arithmetic_parser.exe "1"
echo   测试 "1+2":
arithmetic_parser.exe "1+2"
echo   测试 "1+2*3":
arithmetic_parser.exe "1+2*3"
echo   测试 "(1+2)*3":
arithmetic_parser.exe "(1+2)*3"
echo   测试 "1+2-3*4/5":
arithmetic_parser.exe "1+2-3*4/5"

echo.
echo 测试无效表达式：
echo   测试 "1+":
arithmetic_parser.exe "1+"
echo   测试 "+1":
arithmetic_parser.exe "+1"
echo   测试 "1++2":
arithmetic_parser.exe "1++2"

echo.
echo 测试完成！
pause