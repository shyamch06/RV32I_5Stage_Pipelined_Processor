module topmodule (

    input clk,
    input rst,

    output [6:0] seg,
    output [3:0] an

);

   // CLOCK DIVIDER

    wire clkout;

    clkdivider CLK_DIV (

        .clk(clk),
        .reset(rst),
        .clkout(clkout)

    );

   // PROCESSOR RESULT

    wire [31:0] ResultW;
    wire [31:0] Fib_value;
   // BCD SIGNALS

    wire [15:0] BCD;

    wire [3:0] ones;
    wire [3:0] tens;
    wire [3:0] hunds;
    wire [3:0] thsnds;

    wire [3:0] digit;

  // PROCESSOR

    processor CPU (

        .clk(clkout),
        .rst(rst),

        .ResultW(ResultW),
        .Fib_value(Fib_value)

    );

    // BINARY TO BCD
 
    bcdconvertor BCD_CONVERTER (

        .bin(Fib_value),
        .bcd(BCD)

    );


    assign ones   = BCD[3:0];
    assign tens   = BCD[7:4];
    assign hunds  = BCD[11:8];
    assign thsnds = BCD[15:12];

     // DISPLAY MULTIPLEXING
    // Use ORIGINAL 100 MHz clock

    display DISPLAY (

        .an(an),
        .digit(digit),

        .ones(ones),
        .tens(tens),
        .hunds(hunds),
        .thsnds(thsnds),

        .clk(clk)

    );

   // 7-SEGMENT DECODER

    sevenseg SEVEN_SEG (

        .bcd(digit),
        .seg(seg)

    );

endmodule