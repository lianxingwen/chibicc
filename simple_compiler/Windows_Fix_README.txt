Windows 批处理文件修复说明
================================

问题描述：
原始的批处理文件包含中文字符，在某些Windows系统上可能出现编码问题，
导致出现类似以下错误：
- 'cho' 不是内部或外部命令
- 'ice"=="7" goto test_all' 不是内部或外部命令
- 'menu' 不是内部或外部命令
- 系统找不到指定的路径
- 乱码字符错误

解决方案：
我们提供了修复版本的批处理文件，使用英文界面避免编码问题：

修复文件列表：
- build_fixed.bat    # 修复版编译脚本
- demo_fixed.bat     # 修复版演示脚本
- test_fixed.bat     # 修复版测试脚本
- clean_fixed.bat    # 修复版清理脚本

使用方法：
1. 如果遇到编码问题，请使用 *_fixed.bat 版本的文件
2. 双击 build_fixed.bat 编译编译器
3. 双击 demo_fixed.bat 运行演示
4. 双击 test_fixed.bat 运行测试

注意事项：
- 确保已安装 GCC 编译器 (MinGW-w64 或 TDM-GCC)
- 确保 GCC 在系统 PATH 环境变量中
- 如果仍有问题，请在命令提示符中手动运行：
  gcc -Wall -Wextra -std=c99 *.c -o compiler.exe

技术说明：
修复版本移除了所有中文字符和特殊编码，使用标准ASCII字符，
确保在所有Windows系统上都能正常运行。