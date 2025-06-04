# 简单算法编译器

一个用C语言编写的简单算法编译器，支持基本的算术运算、变量赋值、条件语句和循环语句。

## 功能特性

- **词法分析**：将源代码分解为词法单元（tokens）
- **语法分析**：构建抽象语法树（AST）
- **解释执行**：直接执行算法代码
- **代码生成**：将算法代码编译为C语言代码
- **Windows支持**：提供批处理脚本，一键编译和测试

## 支持的语法

### 基本语法
- 变量赋值：`x = 10;`
- 算术运算：`x = a + b * c;`
- 打印输出：`print x;`
- 注释：`// 这是注释`

### 运算符
- 算术运算：`+`, `-`, `*`, `/`
- 比较运算：`==`, `<`, `>`
- 赋值运算：`=`

### 控制结构
- 条件语句：
  ```
  if (x > 0) {
      print x;
  } else {
      print 0;
  }
  ```

- 循环语句：
  ```
  while (x > 0) {
      print x;
      x = x - 1;
  }
  ```

## 快速开始

### Windows用户

1. **编译编译器**
   ```batch
   build.bat
   ```

2. **运行演示**
   ```batch
   demo.bat
   ```

3. **运行测试**
   ```batch
   test.bat
   ```

### 手动编译

```bash
gcc -Wall -Wextra -std=c99 *.c -o compiler
```

## 使用方法

### 解释执行
```bash
compiler.exe -i 源文件.alg
```

### 编译为C代码
```bash
compiler.exe -c 源文件.alg 输出.c
```

### 显示帮助
```bash
compiler.exe -h
```

## 示例程序

### Hello World
```javascript
// hello.alg
x = 42;
print x;
```

### 数学计算
```javascript
// math.alg
a = 10;
b = 20;
c = a + b * 2;
print c;

if (c > 40) {
    print 1;
} else {
    print 0;
}
```

### 循环计算
```javascript
// loop.alg - 计算1到10的和
sum = 0;
i = 1;

while (i < 11) {
    sum = sum + i;
    i = i + 1;
}

print sum;
```

### 斐波那契数列
```javascript
// fibonacci.alg
a = 0;
b = 1;
i = 0;

print a;
print b;

while (i < 8) {
    c = a + b;
    print c;
    a = b;
    b = c;
    i = i + 1;
}
```

## 项目结构

```
simple_compiler/
├── compiler.h          # 头文件
├── lexer.c            # 词法分析器
├── parser.c           # 语法分析器
├── ast.c              # 抽象语法树
├── environment.c      # 变量环境
├── interpreter.c      # 解释器
├── codegen.c          # 代码生成器
├── main.c             # 主程序
├── build.bat          # 编译脚本
├── demo.bat           # 演示脚本
├── test.bat           # 测试脚本
├── clean.bat          # 清理脚本
└── examples/          # 示例程序
    ├── hello.alg
    ├── math.alg
    ├── loop.alg
    └── fibonacci.alg
```

## 编译器架构

1. **词法分析器 (Lexer)**：将源代码转换为词法单元
2. **语法分析器 (Parser)**：构建抽象语法树
3. **解释器 (Interpreter)**：直接执行AST
4. **代码生成器 (CodeGen)**：将AST转换为C代码

## 依赖要求

- GCC编译器 (MinGW-w64 或 TDM-GCC for Windows)
- Windows命令行环境

## 许可证

MIT License

## 贡献

欢迎提交Issue和Pull Request！