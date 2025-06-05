#!/bin/bash
# Linux shell脚本 - 多周期处理器仿真

echo "========================================"
echo "多周期MIPS处理器仿真"
echo "========================================"

# 检查Icarus Verilog是否安装
if ! command -v iverilog &> /dev/null; then
    echo "错误: 未找到iverilog命令"
    echo "请安装Icarus Verilog:"
    echo "  Ubuntu/Debian: sudo apt-get install iverilog"
    echo "  CentOS/RHEL: sudo yum install iverilog"
    exit 1
fi

echo "正在编译Verilog源文件..."
iverilog -o multicycle_processor alu.v register_file.v memory.v control_unit.v datapath.v multicycle_processor.v testbench.v

if [ $? -ne 0 ]; then
    echo "编译失败！"
    exit 1
fi

echo "编译成功！正在运行仿真..."
vvp multicycle_processor

if [ $? -ne 0 ]; then
    echo "仿真运行失败！"
    exit 1
fi

echo ""
echo "仿真完成！"
echo "生成的波形文件: multicycle_processor.vcd"

# 检查GTKWave是否安装
if command -v gtkwave &> /dev/null; then
    echo ""
    read -p "是否打开波形查看器？(y/n): " choice
    if [[ $choice == [Yy]* ]]; then
        echo "正在打开GTKWave..."
        gtkwave multicycle_processor.vcd &
    fi
else
    echo ""
    echo "提示: 安装GTKWave可以查看波形文件"
    echo "  Ubuntu/Debian: sudo apt-get install gtkwave"
    echo "  CentOS/RHEL: sudo yum install gtkwave"
fi

echo ""