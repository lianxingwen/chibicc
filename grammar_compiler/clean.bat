@echo off
echo 清理编译文件...
del /Q *.o 2>nul
del /Q *.exe 2>nul
del /Q *_parser.c 2>nul
del /Q generated_parser.c 2>nul
echo 清理完成！
pause