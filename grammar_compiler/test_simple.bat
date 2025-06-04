@echo off
echo 测试简单语法...
echo.

echo 生成解析器...
grammar_compiler.exe examples\simple.grammar simple_parser.c

echo 编译生成的解析器...
gcc simple_parser.c -o simple_parser.exe

echo.
echo 测试有效输入：
echo   测试 "hello world":
simple_parser.exe "hello world"
echo   测试 "hi there":
simple_parser.exe "hi there"
echo   测试 "hello there":
simple_parser.exe "hello there"
echo   测试 "hi world":
simple_parser.exe "hi world"

echo.
echo 测试无效输入：
echo   测试 "goodbye world":
simple_parser.exe "goodbye world"

echo.
echo 测试完成！
pause