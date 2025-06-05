# PowerShell script for Multicycle MIPS Processor
# Run with: powershell -ExecutionPolicy Bypass -File run.ps1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Multicycle MIPS Processor Simulation" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Icarus Verilog is installed
try {
    $iverilogVersion = & iverilog -V 2>$null
    Write-Host "✓ Icarus Verilog found" -ForegroundColor Green
} catch {
    Write-Host "✗ ERROR: iverilog command not found" -ForegroundColor Red
    Write-Host "Please install Icarus Verilog: http://bleyer.org/icarus/" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "Compiling Verilog source files..." -ForegroundColor Yellow
$compileResult = & iverilog -o multicycle_processor alu.v register_file.v memory.v control_unit.v datapath.v multicycle_processor.v testbench.v 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Compilation failed!" -ForegroundColor Red
    Write-Host $compileResult -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "✓ Compilation successful!" -ForegroundColor Green
Write-Host "Running simulation..." -ForegroundColor Yellow

$simResult = & vvp multicycle_processor 2>&1
Write-Host $simResult

if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Simulation failed!" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "✓ Simulation completed!" -ForegroundColor Green
Write-Host "Generated waveform file: multicycle_processor.vcd" -ForegroundColor Cyan

# Check if GTKWave is installed
try {
    $gtkwaveVersion = & gtkwave --version 2>$null
    Write-Host ""
    Write-Host "✓ GTKWave found" -ForegroundColor Green
    
    $choice = Read-Host "Open waveform viewer? (y/n)"
    if ($choice -eq "y" -or $choice -eq "Y") {
        Write-Host "Opening GTKWave..." -ForegroundColor Yellow
        
        # Start GTKWave in background
        Start-Process -FilePath "gtkwave" -ArgumentList "multicycle_processor.vcd" -NoNewWindow
        
        Write-Host "✓ GTKWave should be opening..." -ForegroundColor Green
    }
} catch {
    Write-Host ""
    Write-Host "GTKWave not found" -ForegroundColor Yellow
    Write-Host "To view waveforms:" -ForegroundColor Cyan
    Write-Host "1. Install GTKWave from: http://gtkwave.sourceforge.net/" -ForegroundColor Cyan
    Write-Host "2. Run: gtkwave multicycle_processor.vcd" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "Script completed!" -ForegroundColor Green
Read-Host "Press Enter to exit"