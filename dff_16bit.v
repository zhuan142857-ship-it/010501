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