# Windows 用户使用指南

这个语法编译器可以在 Windows 系统上轻松使用。以下是详细的安装和使用说明。

## 前置要求

### 安装 GCC 编译器

您需要在 Windows 上安装 GCC 编译器。推荐以下选项：

#### 选项 1: MinGW-w64 (推荐)
1. 下载 [MinGW-w64](https://www.mingw-w64.org/downloads/)
2. 或者使用 [MSYS2](https://www.msys2.org/) 安装：
   ```bash
   pacman -S mingw-w64-x86_64-gcc
   ```
3. 确保将 MinGW 的 bin 目录添加到系统 PATH

#### 选项 2: TDM-GCC
1. 下载 [TDM-GCC](https://jmeubank.github.io/tdm-gcc/)
2. 安装时选择添加到 PATH

#### 选项 3: Dev-C++ 或 Code::Blocks
这些 IDE 通常自带 MinGW 编译器

### 验证安装
打开命令提示符 (cmd) 或 PowerShell，输入：
```cmd
gcc --version
```
如果显示版本信息，说明安装成功。

## 快速开始

### 1. 编译语法编译器
双击运行 `build.bat` 或在命令行中执行：
```cmd
build.bat
```

### 2. 运行演示
双击运行 `demo.bat` 查看完整演示：
```cmd
demo.bat
```

### 3. 测试示例语法
测试简单语法：
```cmd
test_simple.bat
```

测试算术表达式语法：
```cmd
test_arithmetic.bat
```

## 手动使用

### 基本用法
```cmd
# 从语法文件生成解析器
grammar_compiler.exe examples\simple.grammar my_parser.c

# 编译生成的解析器
gcc my_parser.c -o my_parser.exe

# 测试解析器
my_parser.exe "hello world"
```

### 创建自己的语法

1. 创建一个 `.grammar` 文件，例如 `my_grammar.grammar`：
```
start: greeting name;
greeting: "你好" | "hello";
name: "世界" | "world";
```

2. 生成解析器：
```cmd
grammar_compiler.exe my_grammar.grammar my_parser.c
```

3. 编译并测试：
```cmd
gcc my_parser.c -o my_parser.exe
my_parser.exe "你好 世界"
```

## 批处理脚本说明

- **`build.bat`**: 编译语法编译器
- **`demo.bat`**: 完整演示，展示所有功能
- **`test_simple.bat`**: 测试简单问候语法
- **`test_arithmetic.bat`**: 测试算术表达式语法
- **`clean.bat`**: 清理所有编译生成的文件

## 语法语法说明

支持的语法元素：
- `"终结符"` - 字面字符串
- `非终结符` - 引用其他规则
- `a | b` - 选择（或）
- `a b` - 序列（连接）
- `a?` - 可选元素
- `a*` - 零次或多次重复
- `a+` - 一次或多次重复
- `(a b)` - 分组

### 示例语法

#### 简单问候语法
```
start: greeting name;
greeting: "hello" | "hi";
name: "world" | "there";
```

#### 算术表达式语法
```
expr: term (("+" | "-") term)*;
term: factor (("*" | "/") factor)*;
factor: number | "(" expr ")";
number: "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9";
```

## 故障排除

### 常见问题

1. **"gcc 不是内部或外部命令"**
   - 确保已安装 GCC 并添加到 PATH
   - 重启命令提示符

2. **编译错误**
   - 检查语法文件格式是否正确
   - 确保所有规则都以分号结尾

3. **生成的解析器无法运行**
   - 检查输入字符串格式
   - 查看错误位置信息

### 获取帮助

如果遇到问题，可以：
1. 查看错误信息中的位置提示
2. 检查语法文件是否符合 BNF 格式
3. 运行 `demo.bat` 查看工作示例

## 高级用法

### 自定义输出文件名
```cmd
grammar_compiler.exe my_grammar.grammar custom_parser.c
```

### 批量处理
创建批处理脚本处理多个语法文件：
```cmd
@echo off
for %%f in (*.grammar) do (
    echo 处理 %%f...
    grammar_compiler.exe %%f %%~nf_parser.c
    gcc %%~nf_parser.c -o %%~nf_parser.exe
)
```

这个语法编译器为您提供了一个强大而简单的工具来创建自定义解析器！