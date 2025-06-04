@echo off
chcp 65001 >nul
echo ==========================================
echo     清理编译文件
echo ==========================================
echo.

echo 删除目标文件...
if exist *.o (
    del *.o
    echo ✓ 已删除 .o 文件
) else (
    echo - 没有找到 .o 文件
)

echo 删除可执行文件...
if exist compiler.exe (
    del compiler.exe
    echo ✓ 已删除 compiler.exe
) else (
    echo - 没有找到 compiler.exe
)

if exist hello.exe (
    del hello.exe
    echo ✓ 已删除 hello.exe
)

if exist hello.c (
    del hello.c
    echo ✓ 已删除 hello.c
)

echo.
echo ✓ 清理完成！
pause