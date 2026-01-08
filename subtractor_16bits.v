module subtractor_16bits(
    input [15:0] a,
    input [15:0] b,
    input bin,
    output [15:0] diff,
    output bout
)
    assign {bout, diff} = a - b - bin;
endmodule
