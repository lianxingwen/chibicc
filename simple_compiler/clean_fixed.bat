@echo off
echo ==========================================
echo Clean Simple Algorithm Compiler
echo ==========================================

echo Cleaning object files...
if exist *.o del *.o

echo Cleaning executable...
if exist compiler.exe del compiler.exe

echo Cleaning temporary files...
if exist temp_input.alg del temp_input.alg
if exist hello.c del hello.c
if exist hello.exe del hello.exe

echo Clean completed!
pause