module instruction_memory (
    input [31:0] PCF,
    output [31:0] InstrF
);
    reg [31:0] mem [127:0];
    integer i;
    initial begin
        for (i = 0; i < 128; i = i + 1)
            mem[i] = 32'h00000013; // NOP (ADDI x0, x0, 0) -- safe default
        $readmemh("program.mem", mem);
    end
    assign InstrF = mem[PCF[31:2]];
endmodule
