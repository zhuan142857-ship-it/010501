module subtractor_16bits(
    input [15:0] a,
    input [15:0] b,
    input bin,
    output [15:0] diff,
    output bout
);
    assign {bout, diff} = a - b - bin;
endmodule

module adder_16bits(
    input [15:0] a,
    input [15:0] b,
    input cin,
    output [15:0] sum,
    output cout
);
    assign {cout, sum} = a + b + cin;
endmodule

module multiplier_16bits(
    input [15:0] a,
    input [15:0] b,
    output [31:0] product
);
    assign product = a * b;
endmodule

module divider_16bits(
    input [15:0] dividend,
    input [15:0] divisor,
    output [15:0] quotient,
    output [15:0] remainder
);
    assign quotient = dividend / divisor;
    assign remainder = dividend % divisor;
endmodule

module dff_16bit (
    input      [15:0] d,
    input             clk,
    input             rstn,
    input             en,
    output reg [15:0] q
);
    always @(posedge clk) begin
        if (!rstn)
            q <= 16'b0;
        else if (en)
            q <= d;
    end
endmodule