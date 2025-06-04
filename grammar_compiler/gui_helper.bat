@echo off
chcp 65001 >nul
:menu
cls
echo ==========================================
echo     语法编译器 - 简易操作界面
echo ==========================================
echo.
echo 请选择操作：
echo.
echo 1. 编译语法编译器
echo 2. 运行完整演示
echo 3. 测试简单语法 (问候语)
echo 4. 测试算术表达式语法
echo 5. 从自定义语法生成解析器
echo 6. 查看示例语法文件
echo 7. 清理编译文件
echo 8. 查看帮助文档
echo 9. 退出
echo.
set /p choice=请输入选择 (1-9): 

if "%choice%"=="1" goto build
if "%choice%"=="2" goto demo
if "%choice%"=="3" goto test_simple
if "%choice%"=="4" goto test_arithmetic
if "%choice%"=="5" goto custom
if "%choice%"=="6" goto show_examples
if "%choice%"=="7" goto clean
if "%choice%"=="8" goto help
if "%choice%"=="9" goto exit

echo 无效选择，请重试...
pause
goto menu

:build
echo.
echo 正在编译语法编译器...
call build.bat
goto menu

:demo
echo.
echo 运行完整演示...
call demo.bat
goto menu

:test_simple
echo.
echo 测试简单语法...
call test_simple.bat
goto menu

:test_arithmetic
echo.
echo 测试算术表达式语法...
call test_arithmetic.bat
goto menu

:custom
echo.
echo 从自定义语法生成解析器
echo.
set /p grammar_file=请输入语法文件名 (例如: my_grammar.grammar): 
if not exist "%grammar_file%" (
    echo 文件 %grammar_file% 不存在！
    pause
    goto menu
)

set /p output_file=请输入输出文件名 (例如: my_parser.c): 
if "%output_file%"=="" set output_file=generated_parser.c

echo.
echo 生成解析器...
grammar_compiler.exe "%grammar_file%" "%output_file%"

if exist "%output_file%" (
    echo ✓ 解析器生成成功: %output_file%
    echo.
    set /p compile_choice=是否编译解析器? (y/n): 
    if /i "!compile_choice!"=="y" (
        set parser_exe=%output_file:.c=.exe%
        gcc "%output_file%" -o "!parser_exe!"
        if exist "!parser_exe!" (
            echo ✓ 编译成功: !parser_exe!
            echo.
            set /p test_input=请输入测试字符串 (或按回车跳过): 
            if not "!test_input!"=="" (
                "!parser_exe!" "!test_input!"
            )
        )
    )
) else (
    echo ❌ 解析器生成失败！
)
pause
goto menu

:show_examples
echo.
echo === 示例语法文件 ===
echo.
echo 1. 简单问候语法 (examples\simple.grammar):
echo.
type examples\simple.grammar
echo.
echo.
echo 2. 算术表达式语法 (examples\arithmetic.grammar):
echo.
type examples\arithmetic.grammar
echo.
pause
goto menu

:clean
echo.
echo 清理编译文件...
call clean.bat
goto menu

:help
echo.
echo 打开帮助文档...
if exist README_Windows.md (
    notepad README_Windows.md
) else (
    echo 帮助文档不存在！
)
goto menu

:exit
echo.
echo 感谢使用语法编译器！
pause
exit