module instruction_memory (
    input [31:0] PCF,
    output [31:0] InstrF
);
    reg [31:0] mem [127:0];
    initial begin
        $readmemh("program.mem",mem);
    end
    assign InstrF = mem[PCF[31:2]];
endmodule