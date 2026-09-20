`timescale 1ns / 1ps

module tb_topmodule;

    // Inputs
    reg clk;
    reg rst;

    // Outputs
    wire [6:0] seg;
    wire [3:0] an;

    // Instantiate the full top-level design, divider and all.
    topmodule uut (
        .clk(clk),
        .rst(rst),
        .seg(seg),
        .an(an)
    );

    // Speed up the display clock divider FOR SIMULATION ONLY.
    // This overrides the MAX_COUNT parameter inside the CLK_DIV instance
    // (requires clkdivider's hardcoded 26'd4999999 to be changed to a
    // "parameter MAX_COUNT = 26'd4999999;" -- see notes). The hardware
    // default (~50ms/edge) is untouched; this line only exists here,
    // in the testbench, and never reaches your synthesized bitstream.
    defparam uut.CLK_DIV.MAX_COUNT = 26'd5;

    // Clock generation: 100 MHz clock (10ns period)
    always #5 clk = ~clk;

    // ---- Self-checking Fibonacci sequence check ----
    reg  [31:0] expected [0:9];
    reg  [31:0] prev_fib;
    integer     idx;
    integer     pass_count;
    integer     fail_count;

    initial begin
        expected[0] = 0;
        expected[1] = 1;
        expected[2] = 2;
        expected[3] = 3;
        expected[4] = 5;
        expected[5] = 8;
        expected[6] = 13;
        expected[7] = 21;
        expected[8] = 34;
        expected[9] = 55;
        idx        = 0;
        pass_count = 0;
        fail_count = 0;
        prev_fib   = 32'hFFFFFFFF; // sentinel so the first real value always triggers a check
    end

    // Fires a check every time Fib_value (= register x1's contents) changes
    // after reset is released -- exactly when the program writes a new
    // Fibonacci result to x1.
    always @(posedge clk) begin
        if (!rst) begin
            if (uut.Fib_value !== prev_fib) begin
                if (idx <= 9) begin
                    if (uut.Fib_value === expected[idx]) begin
                        $display("PASS[%0d]: Fib_value=%0d (expected %0d) at time=%0t",
                                 idx, uut.Fib_value, expected[idx], $time);
                        pass_count = pass_count + 1;
                    end else begin
                        $display("FAIL[%0d]: Fib_value=%0d, expected=%0d at time=%0t",
                                 idx, uut.Fib_value, expected[idx], $time);
                        fail_count = fail_count + 1;
                    end
                    idx = idx + 1;
                end
                prev_fib = uut.Fib_value;
            end
        end
    end

    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 1;

        // With MAX_COUNT=5, clkout toggles every 5 raw clk cycles instead
        // of 5,000,000 -- a full CPU clock period is ~120ns instead of
        // ~100ms. Hold reset for 300ns (well over 2 clkout periods) so the
        // processor is guaranteed to see a valid clkout edge while rst is
        // still high -- required for its synchronous reset to actually fire.
        #300;
        rst = 0;

        // Your loop takes ~720ns per iteration (6 instructions x ~120ns/cycle).
        // 15,000 ns comfortably covers the first ~20 iterations -- plenty to
        // capture all 10 checks without running into 32-bit overflow territory.
        #15000;

        $display("---------------------------------------------");
        $display("Summary: %0d PASS, %0d FAIL out of %0d checks", pass_count, fail_count, idx);
        $display("---------------------------------------------");

        $finish;
    end

    // Monitor internal CPU values and 7-segment outputs
    initial begin
        $monitor("Time=%0t | rst=%b | Fib_value (Decimal)=%0d | an=%b | seg=%b",
                 $time, rst, uut.Fib_value, an, seg);
    end

    //  Dump waves for GTKWave or Vivado
    initial begin
        $dumpfile("pipeline_riscv.vcd");
        $dumpvars(0, tb_topmodule);
    end

endmodule
