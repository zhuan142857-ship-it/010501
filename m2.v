module test_sixteen_bit;
    reg [15:0] a=0, b=0;
    reg cin=0;
    wire [15:0] sum;
    wire cout;
    
    sixteen_bit_adder dut(a, b, cin, sum, cout);
    
    initial begin
        #10 a = 16'h0001; b = 16'h0002;
        #10 a = 16'h0003; b = 16'h0004; cin = 1;
        #10 a = 16'hFFFF; b = 16'h0001;
        #10 a = 16'h3FFF; b = 16'h7FFF;cin =0;
        #10 $finish;
    end
    
    initial $monitor("a=%h b=%h cin=%b -> sum=%h cout=%b", a, b, cin, sum, cout);
endmodule