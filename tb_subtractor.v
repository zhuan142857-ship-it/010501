module tb_subtractor;
    reg  [15:0] d_a, d_b;
    reg clk=0, rstn, en_a, en_b, en_result, bin;
    wire [15:0] result;
    wire bout;
    
    system_subtractor uut (
        .d_a(d_a),
        .d_b(d_b),
        .clk(clk),
        .rstn(rstn),
        .en_a(en_a),
        .en_b(en_b),
        .en_result(en_result),
        .bin(bin),
        .result(result),
        .bout(bout)
    );
    
    initial forever #5 clk = ~clk;
    
    initial begin
        // 初始化
        $dumpfile("wave_subtractor.vcd");
        $dumpvars(0, uut);
        
        d_a=0; d_b=0; bin=0; 
        en_a=0; en_b=0; en_result=0;
        rstn=0; #15; rstn=1; #10;
        
        // 测试1：完整流程 - 正常减法
        $display("=== 测试1：完整减法流程 (150 - 50) ===");
        // 步骤1：写入A
        d_a=150; en_a=1; #10; en_a=0;
        $display("t=%0t: 写入A=150，当前结果=%0d", $time, result);
        
        // 步骤2：写入B
        d_b=50; en_b=1; #10; en_b=0;
        $display("t=%0t: 写入B=50，当前结果=%0d", $time, result);
        
        // 步骤3：触发计算并存储结果
        en_result=1; #10; en_result=0;
        $display("t=%0t: 存储结果，result=%0d (应为100)", $time, result);
        
        // 测试2：带借位的减法
        $display("\n=== 测试2：带借位的减法 ===");
        d_a=100; d_b=200; bin=0;
        en_a=1; en_b=1; #10; en_a=0; en_b=0;
        en_result=1; #10; en_result=0;
        $display("t=%0t: 100-200=%0d bout=%0d (借位发生)", $time, result, bout);
        
        // 测试3：更新A值并重新计算
        $display("\n=== 测试3：更新A值并重新计算 ===");
        d_a=500; en_a=1; #10; en_a=0;
        en_result=1; #10; en_result=0;
        $display("t=%0t: 500-200=%0d bout=%0d", $time, result, bout);
        
        // 测试4：带借位输入的减法
        $display("\n=== 测试4：带借位输入(bin=1)的减法 ===");
        d_a=300; d_b=200; bin=1;
        en_a=1; en_b=1; #10; en_a=0; en_b=0;
        en_result=1; #10; en_result=0;
        $display("t=%0t: 300-200-1=%0d bout=%0d", $time, result, bout);
        
        // 测试5：边界测试 - 最小值
        $display("\n=== 测试5：边界测试 (0-1) ===");
        d_a=0; d_b=1; bin=0;
        en_a=1; en_b=1; #10; en_a=0; en_b=0;
        en_result=1; #10; en_result=0;
        $display("t=%0t: 0-1=%0d bout=%0d (应为65535，借位=1)", $time, result, bout);
        
        // 测试6：测试寄存器保持功能
        $display("\n=== 测试6：测试寄存器保持功能 ===");
        // 先设置一个减法
        d_a=1000; d_b=500; bin=0;
        en_a=1; en_b=1; #10; en_a=0; en_b=0;
        en_result=1; #10; en_result=0;
        $display("t=%0t: 初始计算 1000-500=%0d", $time, result);
        
        // 只改变输入但不使能，结果应保持不变
        d_a=2000; d_b=1000; bin=0;
        #10;
        $display("t=%0t: 改变输入但不使能，结果仍为=%0d", $time, result);
        
        // 测试7：大数减小数
        $display("\n=== 测试7：大数减小数 ===");
        d_a=65535; d_b=1; bin=0;
        en_a=1; en_b=1; #10; en_a=0; en_b=0;
        en_result=1; #10; en_result=0;
        $display("t=%0t: 65535-1=%0d bout=%0d", $time, result, bout);
        
        // 测试8：复位功能测试
        $display("\n=== 测试8：复位功能测试 ===");
        // 先进行一次计算
        d_a=300; d_b=100; bin=0;
        en_a=1; en_b=1; #10; en_a=0; en_b=0;
        en_result=1; #10; en_result=0;
        $display("t=%0t: 计算300-100=%0d", $time, result);
        
        // 执行复位
        rstn=0; #10; rstn=1;
        $display("t=%0t: 复位后结果=%0d (应为0)", $time, result);
        
        // 测试9：复位后重新计算
        $display("\n=== 测试9：复位后重新计算 ===");
        d_a=12345; d_b=5432; bin=0;
        en_a=1; en_b=1; #10; en_a=0; en_b=0;
        en_result=1; #10; en_result=0;
        $display("t=%0t: 12345-5432=%0d (应为6913)", $time, result);
        
        #20; 
        $display("\n=== 所有测试完成 ===");
        $finish;
    end
    
    // 监视器，持续监测关键信号
    always @(posedge clk) begin
        if (en_a) $display("t=%0t: INFO - 写入寄存器A: %0d", $time, d_a);
        if (en_b) $display("t=%0t: INFO - 写入寄存器B: %0d", $time, d_b);
        if (en_result) $display("t=%0t: INFO - 存储结果到寄存器", $time);
        if (!rstn) $display("t=%0t: INFO - 系统复位", $time);
    end
endmodule