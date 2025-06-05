# PowerShell script to fix waveform display
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Fix Waveform Display" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# Check if all source files exist
$sourceFiles = @("alu.v", "register_file.v", "memory.v", "control_unit.v", "datapath.v", "multicycle_processor.v", "testbench.v")
$missingFiles = @()

foreach ($file in $sourceFiles) {
    if (-not (Test-Path $file)) {
        $missingFiles += $file
    }
}

if ($missingFiles.Count -gt 0) {
    Write-Host "ERROR: Missing source files:" -ForegroundColor Red
    foreach ($file in $missingFiles) {
        Write-Host "  - $file" -ForegroundColor Red
    }
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "All source files found" -ForegroundColor Green

# Compile
Write-Host "Compiling Verilog files..." -ForegroundColor Yellow
$compileResult = & iverilog -o multicycle_processor alu.v register_file.v memory.v control_unit.v datapath.v multicycle_processor.v testbench.v 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-Host "Compilation failed!" -ForegroundColor Red
    Write-Host $compileResult -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "Compilation successful!" -ForegroundColor Green

# Run simulation
Write-Host "Running simulation..." -ForegroundColor Yellow
$simResult = & vvp multicycle_processor 2>&1
Write-Host $simResult

if ($LASTEXITCODE -ne 0) {
    Write-Host "Simulation failed!" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

# Check VCD file
if (Test-Path "multicycle_processor.vcd") {
    $vcdSize = (Get-Item "multicycle_processor.vcd").Length
    Write-Host "VCD file created successfully (Size: $vcdSize bytes)" -ForegroundColor Green
} else {
    Write-Host "ERROR: VCD file not created" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "In GTKWave you should now see these signals:" -ForegroundColor Cyan
Write-Host "- testbench.clk_wire (clock signal)" -ForegroundColor White
Write-Host "- testbench.reset_wire (reset signal)" -ForegroundColor White
Write-Host "- testbench.pc_wire (program counter)" -ForegroundColor White
Write-Host "- testbench.instruction_wire (current instruction)" -ForegroundColor White
Write-Host "- testbench.state_wire (control state)" -ForegroundColor White
Write-Host "- testbench.reg1_wire to reg7_wire (registers)" -ForegroundColor White

Write-Host ""
$choice = Read-Host "Open GTKWave to view waveforms? (y/n)"
if ($choice -eq "y" -or $choice -eq "Y") {
    Write-Host "Opening GTKWave..." -ForegroundColor Yellow
    Start-Process -FilePath "gtkwave" -ArgumentList "multicycle_processor.vcd"
}

Write-Host ""
Write-Host "Script completed!" -ForegroundColor Green
Read-Host "Press Enter to exit"