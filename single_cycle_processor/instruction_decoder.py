#!/usr/bin/env python3
"""
Instruction Decoder for Single-Cycle Processor
Decodes 32-bit MIPS instructions into human-readable assembly
"""

def decode_instruction(instruction_hex):
    """Decode a 32-bit instruction from hex string"""
    if isinstance(instruction_hex, str):
        if instruction_hex.startswith('0x'):
            instruction = int(instruction_hex, 16)
        else:
            instruction = int(instruction_hex, 16)
    else:
        instruction = instruction_hex
    
    # Extract fields
    opcode = (instruction >> 26) & 0x3F
    rs = (instruction >> 21) & 0x1F
    rt = (instruction >> 16) & 0x1F
    rd = (instruction >> 11) & 0x1F
    shamt = (instruction >> 6) & 0x1F
    funct = instruction & 0x3F
    immediate = instruction & 0xFFFF
    address = instruction & 0x3FFFFFF
    
    # Sign extend immediate
    if immediate & 0x8000:
        immediate_signed = immediate - 0x10000
    else:
        immediate_signed = immediate
    
    # Decode instruction
    if opcode == 0x00:  # R-type
        if funct == 0x20:
            return f"add ${rd}, ${rs}, ${rt}"
        elif funct == 0x22:
            return f"sub ${rd}, ${rs}, ${rt}"
        elif funct == 0x24:
            return f"and ${rd}, ${rs}, ${rt}"
        elif funct == 0x25:
            return f"or ${rd}, ${rs}, ${rt}"
        elif funct == 0x2A:
            return f"slt ${rd}, ${rs}, ${rt}"
        else:
            return f"unknown R-type (funct=0x{funct:02x})"
    
    elif opcode == 0x08:  # ADDI
        return f"addi ${rt}, ${rs}, {immediate_signed}"
    
    elif opcode == 0x23:  # LW
        return f"lw ${rt}, {immediate_signed}(${rs})"
    
    elif opcode == 0x2B:  # SW
        return f"sw ${rt}, {immediate_signed}(${rs})"
    
    elif opcode == 0x04:  # BEQ
        return f"beq ${rs}, ${rt}, {immediate_signed}"
    
    elif opcode == 0x02:  # J
        return f"j {address}"
    
    else:
        return f"unknown instruction (opcode=0x{opcode:02x})"

def main():
    """Main function to decode sample instructions"""
    print("Single-Cycle Processor Instruction Decoder")
    print("=" * 45)
    
    # Sample instructions from our test program
    instructions = [
        ("2001000A", "addi $1, $0, 10"),
        ("20020014", "addi $2, $0, 20"),
        ("00221820", "add $3, $1, $2"),
        ("00412022", "sub $4, $2, $1"),
        ("00222824", "and $5, $1, $2"),
        ("00223025", "or $6, $1, $2"),
        ("0022382A", "slt $7, $1, $2"),
        ("AC030000", "sw $3, 0($0)"),
        ("8C080000", "lw $8, 0($0)"),
        ("10210002", "beq $1, $1, 2"),
        ("0800000F", "j 15"),
        ("200B004D", "addi $11, $0, 77"),
        ("200D0037", "addi $13, $0, 55"),
    ]
    
    print(f"{'Hex Code':<10} {'Decoded':<20} {'Expected':<20}")
    print("-" * 60)
    
    for hex_code, expected in instructions:
        decoded = decode_instruction(hex_code)
        status = "✓" if decoded.replace(" ", "") == expected.replace(" ", "") else "✗"
        print(f"{hex_code:<10} {decoded:<20} {expected:<20} {status}")
    
    print("\nInteractive Mode:")
    print("Enter hex instruction codes (e.g., 2001000A) or 'quit' to exit")
    
    while True:
        try:
            user_input = input("\nInstruction (hex): ").strip()
            if user_input.lower() in ['quit', 'exit', 'q']:
                break
            if user_input:
                decoded = decode_instruction(user_input)
                print(f"Decoded: {decoded}")
        except (ValueError, KeyboardInterrupt):
            print("Invalid input or interrupted. Use 'quit' to exit.")
            break

if __name__ == "__main__":
    main()