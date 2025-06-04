@echo off
echo 正在编译语法编译器...
gcc -Wall -Wextra -std=c99 -g -c main.c -o main.o
gcc -Wall -Wextra -std=c99 -g -c lexer.c -o lexer.o
gcc -Wall -Wextra -std=c99 -g -c parser.c -o parser.o
gcc -Wall -Wextra -std=c99 -g -c ast.c -o ast.o
gcc -Wall -Wextra -std=c99 -g -c codegen.c -o codegen.o
gcc main.o lexer.o parser.o ast.o codegen.o -o grammar_compiler.exe

if exist grammar_compiler.exe (
    echo 编译成功！生成了 grammar_compiler.exe
) else (
    echo 编译失败！请检查是否安装了 GCC 编译器
    echo 推荐安装 MinGW-w64 或 TDM-GCC
)
pause