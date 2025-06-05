# Windows环境安装指南

本指南将帮助您在Windows系统上设置和运行多周期MIPS处理器。

## 系统要求

- Windows 7/8/10/11
- 至少1GB可用磁盘空间
- 管理员权限（用于安装软件）

## 安装步骤

### 1. 下载并安装Icarus Verilog

1. 访问官方网站：http://bleyer.org/icarus/
2. 点击"Download"链接
3. 下载最新的Windows安装包（通常是.exe文件）
4. 以管理员身份运行安装程序
5. 按照安装向导完成安装
6. **重要**：确保在安装过程中选择"Add to PATH"选项

### 2. 验证安装

打开命令提示符（cmd）并输入：
```cmd
iverilog -V
```

如果显示版本信息，说明安装成功。

### 3. 可选：安装GTKWave（波形查看器）

1. 访问：http://gtkwave.sourceforge.net/
2. 下载Windows版本
3. 安装到默认目录
4. 确保添加到PATH环境变量

## 运行处理器

### 方法1：使用批处理文件（推荐）

1. 双击`run.bat`文件
2. 按照屏幕提示操作

### 方法2：使用命令行

打开命令提示符，导航到项目目录：
```cmd
cd path\to\multicycle_processor
```

编译并运行：
```cmd
iverilog -o multicycle_processor alu.v register_file.v memory.v control_unit.v datapath.v multicycle_processor.v testbench.v
vvp multicycle_processor
```

查看波形（如果安装了GTKWave）：
```cmd
gtkwave multicycle_processor.vcd
```

### 方法3：使用Make（如果安装了MinGW或MSYS2）

```cmd
make all
make wave
```

## 故障排除

### 问题1：找不到iverilog命令

**解决方案**：
1. 重新安装Icarus Verilog，确保选择"Add to PATH"
2. 手动添加到PATH环境变量：
   - 右键"此电脑" → "属性" → "高级系统设置"
   - 点击"环境变量"
   - 在"系统变量"中找到"Path"，点击"编辑"
   - 添加Icarus Verilog安装目录（通常是`C:\iverilog\bin`）

### 问题2：编译错误

**解决方案**：
1. 确保所有.v文件都在同一目录下
2. 检查文件名是否正确
3. 确保没有中文路径

### 问题3：无法查看波形

**解决方案**：
1. 安装GTKWave
2. 确保.vcd文件已生成
3. 手动打开GTKWave并加载.vcd文件

## 开发环境推荐

### 文本编辑器
- **Visual Studio Code**：免费，支持Verilog语法高亮
- **Notepad++**：轻量级，支持语法高亮
- **Sublime Text**：功能强大的编辑器

### Verilog插件（VS Code）
1. 安装"Verilog-HDL/SystemVerilog/Bluespec SystemVerilog"插件
2. 安装"TerosHDL"插件（可选，提供更多功能）

## 项目结构

```
multicycle_processor/
├── alu.v                    # 算术逻辑单元
├── register_file.v          # 寄存器文件
├── memory.v                 # 存储器模块
├── control_unit.v           # 控制单元
├── datapath.v               # 数据通路
├── multicycle_processor.v   # 顶层模块
├── testbench.v              # 测试平台
├── run.bat                  # Windows批处理文件
├── run.sh                   # Linux脚本文件
├── Makefile                 # Make构建文件
├── README.md                # 项目说明
└── WINDOWS_SETUP.md         # 本文件
```

## 下一步

1. 尝试修改测试程序（在memory.v中）
2. 添加新的指令支持
3. 优化处理器性能
4. 学习更高级的Verilog特性

## 获取帮助

如果遇到问题：
1. 查看README.md文件
2. 检查错误信息
3. 确保按照本指南正确安装了所有软件

祝您学习愉快！