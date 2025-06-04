#!/bin/bash

echo "=========================================="
echo "测试简单算法编译器"
echo "=========================================="

# 编译编译器
echo "编译编译器..."
gcc -Wall -Wextra -std=c99 *.c -o compiler
if [ $? -ne 0 ]; then
    echo "编译失败！"
    exit 1
fi
echo "编译成功！"

echo ""
echo "测试示例程序："
echo ""

# 测试hello.alg
echo "1. 测试 hello.alg:"
./compiler -i examples/hello.alg
echo ""

# 测试math.alg
echo "2. 测试 math.alg:"
./compiler -i examples/math.alg
echo ""

# 测试loop.alg
echo "3. 测试 loop.alg:"
./compiler -i examples/loop.alg
echo ""

# 测试fibonacci.alg
echo "4. 测试 fibonacci.alg:"
./compiler -i examples/fibonacci.alg
echo ""

echo "所有测试完成！"