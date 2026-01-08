module tb;
    reg d, clk;
    wire q;
    
    dff uut (.d(d), .clk(clk), .q(q));
    
    always #5 clk = ~clk;
    always #7 d = ~d;
    
    initial begin
        clk = 0;
        d = 0;

        #430$finish;
    end

    initial begin
        //$dumpfile("wave.vcd");      // VCD 文件名
        $dumpvars(0, tb);
        #400
        $finish;               // 仿真时间
    end
    
    initial begin
        $monitor("time=%t, clk=%b, d=%b, q=%b", $time, clk, d, q);
    end
endmodule