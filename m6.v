module tb;
    reg d, clk, rstn;
    wire q;
    
    dff uut (.d(d), .clk(clk), .rstn(rstn), .q(q));
    
    always #5 clk = ~clk;
    //always #15 rstn = ~rstn;
    always #7 d = ~d;
    
    initial begin
        clk = 0;
        d = 0;
        rstn = 0;

        #20 rstn = 1;
    end

    initial begin
        $dumpvars(0, tb);
        #400 $finish;
    end
    
    initial begin
        $monitor("time=%t, clk=%b, rstn=%b, d=%b, q=%b", $time, clk, rstn, d, q);
    end
endmodule