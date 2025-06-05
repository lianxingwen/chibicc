@echo off
chcp 65001 >nul
REM Windows自动安装脚本 - 多周期处理器

echo ========================================
echo 多周期MIPS处理器 - Windows安装向导
echo ========================================
echo.

REM 检查是否以管理员身份运行
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo 警告: 建议以管理员身份运行此脚本以确保正确安装
    echo.
)

REM 检查Icarus Verilog是否已安装
where iverilog >nul 2>nul
if %errorlevel% equ 0 (
    echo ✓ Icarus Verilog 已安装
    iverilog -V
    goto :test_processor
)

echo × Icarus Verilog 未安装
echo.
echo 正在为您提供安装选项...
echo.
echo 选项1: 手动下载安装 (推荐)
echo   1. 访问: http://bleyer.org/icarus/
echo   2. 下载最新的Windows版本
echo   3. 运行安装程序，确保选择"Add to PATH"
echo.
echo 选项2: 使用包管理器 (需要先安装Chocolatey)
echo   choco install iverilog
echo.
echo 选项3: 使用便携版本
echo   下载预编译的便携版本并手动添加到PATH
echo.

set /p choice="请选择安装方式 (1/2/3) 或按Enter跳过安装: "

if "%choice%"=="1" (
    echo 正在打开下载页面...
    start http://bleyer.org/icarus/
    echo.
    echo 请完成安装后重新运行此脚本
    pause
    exit /b 0
)

if "%choice%"=="2" (
    echo 正在尝试使用Chocolatey安装...
    choco install iverilog -y
    if %errorlevel% equ 0 (
        echo ✓ 安装成功
        goto :test_processor
    ) else (
        echo × Chocolatey安装失败，请尝试手动安装
        pause
        exit /b 1
    )
)

if "%choice%"=="3" (
    echo 便携版本安装说明:
    echo 1. 创建目录: C:\iverilog
    echo 2. 下载并解压Icarus Verilog到该目录
    echo 3. 添加 C:\iverilog\bin 到系统PATH环境变量
    echo 4. 重启命令提示符
    echo.
    pause
    exit /b 0
)

echo 跳过安装，继续检查...

:test_processor
echo.
echo ========================================
echo 测试处理器
echo ========================================

REM 检查源文件是否存在
if not exist "alu.v" (
    echo × 错误: 找不到Verilog源文件
    echo 请确保在正确的目录中运行此脚本
    pause
    exit /b 1
)

echo ✓ 源文件检查通过
echo.

REM 再次检查iverilog
where iverilog >nul 2>nul
if %errorlevel% neq 0 (
    echo × 错误: iverilog命令仍然不可用
    echo 请检查安装和PATH设置
    echo.
    echo 手动设置PATH的方法:
    echo 1. 右键"此电脑" → "属性"
    echo 2. 点击"高级系统设置"
    echo 3. 点击"环境变量"
    echo 4. 在"系统变量"中找到"Path"
    echo 5. 添加Icarus Verilog的bin目录路径
    echo.
    pause
    exit /b 1
)

echo 正在编译Verilog源文件...
iverilog -o multicycle_processor alu.v register_file.v memory.v control_unit.v datapath.v multicycle_processor.v testbench.v

if %errorlevel% neq 0 (
    echo × 编译失败！
    echo 请检查源文件是否完整
    pause
    exit /b 1
)

echo ✓ 编译成功！
echo.

echo 正在运行仿真...
vvp multicycle_processor

if %errorlevel% neq 0 (
    echo × 仿真运行失败！
    pause
    exit /b 1
)

echo.
echo ✓ 仿真完成！
echo.

REM 检查GTKWave
where gtkwave >nul 2>nul
if %errorlevel% equ 0 (
    set /p wave_choice="是否打开波形查看器？(y/n): "
    if /i "%wave_choice%"=="y" (
        echo 正在打开GTKWave...
        start gtkwave multicycle_processor.vcd
    )
) else (
    echo.
    echo 提示: 安装GTKWave可以查看波形文件
    echo 下载地址: http://gtkwave.sourceforge.net/
    echo 波形文件: multicycle_processor.vcd
)

echo.
echo ========================================
echo 安装和测试完成！
echo ========================================
echo.
pause