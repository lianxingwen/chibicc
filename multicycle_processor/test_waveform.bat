@echo off
chcp 65001 >nul
echo ========================================
echo 测试波形显示修复
echo ========================================

echo 重新编译Verilog文件...
iverilog -o multicycle_processor alu.v register_file.v memory.v control_unit.v datapath.v multicycle_processor.v testbench.v

if %errorlevel% neq 0 (
    echo 编译失败！
    pause
    exit /b 1
)

echo 运行仿真...
vvp multicycle_processor

if %errorlevel% neq 0 (
    echo 仿真失败！
    pause
    exit /b 1
)

echo.
echo 检查VCD文件...
dir multicycle_processor.vcd

echo.
echo 现在在GTKWave中您应该能看到以下信号：
echo ✓ testbench.clk_wire - 时钟信号
echo ✓ testbench.reset_wire - 复位信号  
echo ✓ testbench.pc_wire - 程序计数器
echo ✓ testbench.instruction_wire - 当前指令
echo ✓ testbench.state_wire - 控制状态
echo ✓ testbench.reg1_wire - $1寄存器
echo ✓ testbench.reg2_wire - $2寄存器
echo ✓ testbench.reg3_wire - $3寄存器
echo ✓ testbench.reg4_wire - $4寄存器
echo ✓ testbench.reg7_wire - $7寄存器

echo.
set /p choice="打开GTKWave查看波形？(y/n): "
if /i "%choice%"=="y" (
    echo 正在打开GTKWave...
    gtkwave multicycle_processor.vcd
)

echo.
pause