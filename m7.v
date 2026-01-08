module dff (
    input   d,
    input   clk,
    input   rstn,      // Active-low reset
    input   en,        // Enable signal
    output reg q
);
    always @ (posedge clk) begin
        if (!rstn)
            q <= 0;
        else if (en)
            q <= d;
        // else: keep current value
    end
endmodule