@echo off
chcp 65001 >nul
echo ==========================================
echo     简单算法编译器演示
echo ==========================================
echo.

if not exist compiler.exe (
    echo 编译器不存在，正在编译...
    call build.bat
    echo.
)

if not exist compiler.exe (
    echo ❌ 编译失败，无法继续演示
    pause
    exit /b 1
)

:menu
cls
echo ==========================================
echo     简单算法编译器演示菜单
echo ==========================================
echo.
echo 1. 显示帮助信息
echo 2. 运行 Hello World 示例
echo 3. 运行数学计算示例
echo 4. 运行循环示例 (1到10的和)
echo 5. 运行斐波那契数列示例
echo 6. 编译示例为C代码
echo 7. 运行所有测试
echo 8. 自定义输入
echo 0. 退出
echo.
set /p choice=请选择 (0-8): 

if "%choice%"=="0" goto end
if "%choice%"=="1" goto help
if "%choice%"=="2" goto hello
if "%choice%"=="3" goto math
if "%choice%"=="4" goto loop
if "%choice%"=="5" goto fibonacci
if "%choice%"=="6" goto compile
if "%choice%"=="7" goto test_all
if "%choice%"=="8" goto custom

echo 无效选择，请重试
pause
goto menu

:help
cls
echo ==========================================
echo     编译器帮助信息
echo ==========================================
compiler.exe -h
echo.
pause
goto menu

:hello
cls
echo ==========================================
echo     Hello World 示例
echo ==========================================
echo 源代码：
type examples\hello.alg
echo.
echo 执行结果：
compiler.exe -i examples\hello.alg
echo.
pause
goto menu

:math
cls
echo ==========================================
echo     数学计算示例
echo ==========================================
echo 源代码：
type examples\math.alg
echo.
echo 执行结果：
compiler.exe -i examples\math.alg
echo.
pause
goto menu

:loop
cls
echo ==========================================
echo     循环示例 (1到10的和)
echo ==========================================
echo 源代码：
type examples\loop.alg
echo.
echo 执行结果：
compiler.exe -i examples\loop.alg
echo.
pause
goto menu

:fibonacci
cls
echo ==========================================
echo     斐波那契数列示例
echo ==========================================
echo 源代码：
type examples\fibonacci.alg
echo.
echo 执行结果：
compiler.exe -i examples\fibonacci.alg
echo.
pause
goto menu

:compile
cls
echo ==========================================
echo     编译为C代码示例
echo ==========================================
echo 将 hello.alg 编译为 hello.c...
compiler.exe -c examples\hello.alg hello.c
echo.
if exist hello.c (
    echo ✓ 编译成功！生成的C代码：
    echo.
    type hello.c
    echo.
    echo 编译并运行生成的C程序...
    gcc hello.c -o hello.exe
    if exist hello.exe (
        echo ✓ C程序编译成功，执行结果：
        hello.exe
    )
)
echo.
pause
goto menu

:test_all
cls
echo ==========================================
echo     运行所有测试
echo ==========================================
call test.bat
goto menu

:custom
cls
echo ==========================================
echo     自定义输入
echo ==========================================
echo 请输入算法代码 (以空行结束):
echo.

set "input_file=temp_input.alg"
if exist "%input_file%" del "%input_file%"

:input_loop
set /p line=
if "%line%"=="" goto run_custom
echo %line% >> "%input_file%"
goto input_loop

:run_custom
echo.
echo 执行结果：
compiler.exe -i "%input_file%"
echo.
if exist "%input_file%" del "%input_file%"
pause
goto menu

:end
echo.
echo 感谢使用简单算法编译器！
pause