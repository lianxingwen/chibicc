# 多周期MIPS处理器

这是一个用Verilog实现的多周期MIPS处理器，支持基本的MIPS指令集。

## 特性

- **多周期设计**: 每条指令需要多个时钟周期完成
- **支持指令类型**:
  - R型指令: ADD, SUB, AND, OR, SLT
  - I型指令: ADDI, LW, SW, BEQ
  - J型指令: J
- **32位数据通路**
- **32个通用寄存器**
- **4KB统一存储器**（指令和数据）

## 文件结构

```
multicycle_processor/
├── alu.v                    # 算术逻辑单元
├── register_file.v          # 寄存器文件
├── memory.v                 # 存储器模块
├── control_unit.v           # 控制单元
├── datapath.v               # 数据通路
├── multicycle_processor.v   # 顶层模块
├── testbench.v              # 测试平台
├── Makefile                 # 编译脚本
└── README.md                # 说明文档
```

## 环境要求

### Windows环境
1. 安装 [Icarus Verilog](http://bleyer.org/icarus/)
2. 可选：安装 [GTKWave](http://gtkwave.sourceforge.net/) 用于查看波形
3. 确保工具在PATH环境变量中

### Linux环境
```bash
# Ubuntu/Debian
sudo apt-get install iverilog gtkwave

# CentOS/RHEL
sudo yum install iverilog gtkwave
```

## 使用方法

### 1. 编译和运行
```bash
# 编译并运行仿真
make all

# 或者分步执行
make compile
make run
```

### 2. 查看波形
```bash
make wave
```

### 3. 清理文件
```bash
make clean
```

## 处理器架构

### 状态机设计
处理器使用有限状态机控制指令执行：

1. **FETCH**: 取指令
2. **DECODE**: 译码
3. **EXECUTE**: 执行（R型指令）
4. **MEMADR**: 计算存储器地址（LW/SW）
5. **MEMREAD**: 读存储器（LW）
6. **MEMWRITE**: 写存储器（SW）
7. **BRANCH**: 分支判断（BEQ）
8. **JUMP**: 跳转执行（J）

### 数据通路组件

- **PC**: 程序计数器
- **指令寄存器**: 存储当前指令
- **寄存器文件**: 32个32位寄存器
- **ALU**: 算术逻辑单元
- **存储器**: 统一的指令/数据存储器
- **控制单元**: 生成控制信号

## 测试程序

内置测试程序执行以下指令序列：

```assembly
add  $1, $0, $0     # $1 = 0
addi $1, $1, 5      # $1 = 5
addi $2, $0, 3      # $2 = 3
add  $3, $1, $2     # $3 = $1 + $2 = 8
sub  $4, $3, $2     # $4 = $3 - $2 = 5
beq  $1, $4, 2      # if $1 == $4, jump 2 instructions
addi $5, $0, 10     # $5 = 10 (should be skipped)
addi $6, $0, 20     # $6 = 20 (should be skipped)
addi $7, $0, 100    # $7 = 100
```

### 预期结果
- $1 = 5
- $2 = 3
- $3 = 8
- $4 = 5
- $5 = 0 (被跳过)
- $6 = 0 (被跳过)
- $7 = 100

## 支持的指令格式

### R型指令
```
[31:26] [25:21] [20:16] [15:11] [10:6] [5:0]
opcode    rs      rt      rd    shamt  funct
```

### I型指令
```
[31:26] [25:21] [20:16] [15:0]
opcode    rs      rt    immediate
```

### J型指令
```
[31:26] [25:0]
opcode  address
```

## 扩展建议

1. **添加更多指令**: SLL, SRL, SRA, ORI, ANDI等
2. **异常处理**: 添加异常检测和处理机制
3. **流水线**: 改进为流水线处理器
4. **缓存**: 添加指令和数据缓存
5. **浮点运算**: 支持浮点指令

## 故障排除

### 常见问题

1. **编译错误**: 检查Icarus Verilog是否正确安装
2. **波形无法显示**: 确保GTKWave已安装
3. **仿真结果不正确**: 检查时钟和复位信号

### 调试技巧

1. 使用`$display`语句输出调试信息
2. 查看波形文件分析信号变化
3. 单步调试状态机转换

## 许可证

本项目采用MIT许可证，详见LICENSE文件。

## 贡献

欢迎提交问题报告和改进建议！