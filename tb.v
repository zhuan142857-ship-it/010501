module tb_system;
    reg  [15:0] d_a, d_b;
    reg clk=0, rstn, en_a, en_b, cin;  // clk初始化
    wire [15:0] sum;
    wire cout;
    
    system uut (
        .d_a(d_a),
        .d_b(d_b),
        .clk(clk),
        .rstn(rstn),
        .en_a(en_a),
        .en_b(en_b),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );
    
    // 波形记录（先于clk翻转）
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_system);
    end
    
    initial forever #5 clk = ~clk;
    
    initial begin
        d_a=0; d_b=0; cin=0; en_a=0; en_b=0;
        rstn=0; #15; rstn=1; #10;        // 复位
        
        // 测试1：同时写入两个寄存器并进行加法
        d_a=123; d_b=100; en_a=1; en_b=1; #10;
        $display("t=%0t: 123+100=%0d", $time, sum);
        
        // 测试2：只更新b寄存器的值，a保持原值
        en_a=0; en_b=1; d_b=200; #10;
        $display("t=%0t: 123+200=%0d", $time, sum);
        
        // 测试3：同时更新两个寄存器，测试溢出
        d_a=65535; d_b=1; en_a=1; en_b=1; #10;
        $display("t=%0t: 65535+1=%0d cout=%0d", $time, sum, cout);
        
        // 测试4：只更新a寄存器
        d_a=50; d_b=25; en_a=1; en_b=0; #10;
        $display("t=%0t: 50+1=%0d", $time, sum);  // b仍为1
        
        // 测试5：同时更新两个寄存器
        d_a=100; d_b=200; en_a=1; en_b=1; #10;
        $display("t=%0t: 100+200=%0d", $time, sum);
        
        // 测试6：复位测试
        rstn=0; #10;
        $display("t=%0t: 复位后0+0=%0d", $time, sum);
        
        #10; $finish;
    end
endmodule