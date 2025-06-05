@echo off
REM Windows批处理文件 - 多周期处理器仿真

echo ========================================
echo 多周期MIPS处理器仿真
echo ========================================

REM 检查Icarus Verilog是否安装
where iverilog >nul 2>nul
if %errorlevel% neq 0 (
    echo 错误: 未找到iverilog命令
    echo 请安装Icarus Verilog: http://bleyer.org/icarus/
    pause
    exit /b 1
)

echo 正在编译Verilog源文件...
iverilog -o multicycle_processor alu.v register_file.v memory.v control_unit.v datapath.v multicycle_processor.v testbench.v

if %errorlevel% neq 0 (
    echo 编译失败！
    pause
    exit /b 1
)

echo 编译成功！正在运行仿真...
vvp multicycle_processor

if %errorlevel% neq 0 (
    echo 仿真运行失败！
    pause
    exit /b 1
)

echo.
echo 仿真完成！
echo 生成的波形文件: multicycle_processor.vcd

REM 检查GTKWave是否安装
where gtkwave >nul 2>nul
if %errorlevel% equ 0 (
    echo.
    set /p choice="是否打开波形查看器？(y/n): "
    if /i "%choice%"=="y" (
        echo 正在打开GTKWave...
        start gtkwave multicycle_processor.vcd
    )
) else (
    echo.
    echo 提示: 安装GTKWave可以查看波形文件
    echo 下载地址: http://gtkwave.sourceforge.net/
)

echo.
pause