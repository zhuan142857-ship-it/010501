module tb_system;
    reg  [15:0] d_a, d_b;
    reg clk=0, rstn, en_a, en_b, en_result, cin;
    wire [15:0] result;
    wire cout;
    
    system uut (
        .d_a(d_a),
        .d_b(d_b),
        .clk(clk),
        .rstn(rstn),
        .en_a(en_a),
        .en_b(en_b),
        .en_result(en_result),
        .cin(cin),
        .result(result),
        .cout(cout)
    );
    
    initial forever #5 clk = ~clk;
    
    initial begin
        // 初始化
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_system);
        
        d_a=0; d_b=0; cin=0; 
        en_a=0; en_b=0; en_result=0;
        rstn=0; #15; rstn=1; #10;
        
        // 测试1：完整流程
        $display("=== 测试1：完整加法流程 ===");
        // 步骤1：写入A
        d_a=100; en_a=1; #10; en_a=0;
        $display("t=%0t: 写入A=100，当前结果=%0d", $time, result);
        
        // 步骤2：写入B
        d_b=50; en_b=1; #10; en_b=0;
        $display("t=%0t: 写入B=50，当前结果=%0d", $time, result);
        
        // 步骤3：触发计算并存储结果
        en_result=1; #10; en_result=0;
        $display("t=%0t: 存储结果，result=%0d (应为150)", $time, result);
        
        // 测试2：改变A，但不更新结果
        $display("\n=== 测试2：只更新A，不更新结果 ===");
        d_a=200; en_a=1; #10; en_a=0;
        $display("t=%0t: 写入A=200，但结果仍保持=%0d", $time, result);
        
        // 测试3：再次计算
        en_result=1; #10; en_result=0;
        $display("t=%0t: 重新存储结果，result=%0d (应为250)", $time, result);
        
        // 测试4：溢出测试
        $display("\n=== 测试3：溢出测试 ===");
        d_a=65535; d_b=1; 
        en_a=1; en_b=1; #10; en_a=0; en_b=0;
        en_result=1; #10; en_result=0;
        $display("t=%0t: 65535+1=%0d cout=%0d", $time, result, cout);
        
        // 测试5：复位
        rstn=0; #10; rstn=1;
        $display("t=%0t: 复位后结果=%0d", $time, result);
        
        #20; $finish;
    end
endmodule