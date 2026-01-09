module tb_multiplier;
    reg  [15:0] d_a, d_b;
    reg clk=0, rstn, en_a, en_b, en_result;
    wire [31:0] result;
    
    system_multiplier uut (
        .d_a(d_a),
        .d_b(d_b),
        .clk(clk),
        .rstn(rstn),
        .en_a(en_a),
        .en_b(en_b),
        .en_result(en_result),
        .result(result)
    );
    
    // 时钟生成
    initial forever #5 clk = ~clk;
    
    initial begin
        // 初始化
        $dumpfile("wave_multiplier.vcd");
        $dumpvars(0, uut);
        
        d_a = 0; 
        d_b = 0;
        en_a = 0; 
        en_b = 0; 
        en_result = 0;
        rstn = 0; 
        #15; 
        rstn = 1; 
        #10;
        
        // 测试1：完整乘法流程 - 小数字
        $display("=== 测试1：完整乘法流程 (100 × 50) ===");
        // 步骤1：写入A
        d_a = 100; 
        en_a = 1; 
        #10; 
        en_a = 0;
        $display("t=%0t: 写入A=100，当前结果=%0d", $time, result);
        
        // 步骤2：写入B
        d_b = 50; 
        en_b = 1; 
        #10; 
        en_b = 0;
        $display("t=%0t: 写入B=50，当前结果=%0d", $time, result);
        
        // 步骤3：触发计算并存储结果
        en_result = 1; 
        #10; 
        en_result = 0;
        $display("t=%0t: 存储结果，result=%0d (应为5000)", $time, result);
        
        // 测试2：改变A，但不更新结果
        $display("\n=== 测试2：只更新A，不更新结果 ===");
        d_a = 200; 
        en_a = 1; 
        #10; 
        en_a = 0;
        $display("t=%0t: 写入A=200，但结果仍保持=%0d", $time, result);
        
        // 测试3：再次计算
        en_result = 1; 
        #10; 
        en_result = 0;
        $display("t=%0t: 重新存储结果，result=%0d (应为10000)", $time, result);
        
        // 测试4：大数乘法
        $display("\n=== 测试3：大数乘法测试 ===");
        d_a = 255; 
        d_b = 255;
        en_a = 1; 
        en_b = 1; 
        #10; 
        en_a = 0; 
        en_b = 0;
        en_result = 1; 
        #10; 
        en_result = 0;
        $display("t=%0t: 255×255=%0d (应为65025)", $time, result);
        
        // 测试5：最大值乘法
        $display("\n=== 测试4：最大值乘法测试 ===");
        d_a = 65535; 
        d_b = 1;
        en_a = 1; 
        en_b = 1; 
        #10; 
        en_a = 0; 
        en_b = 0;
        en_result = 1; 
        #10; 
        en_result = 0;
        $display("t=%0t: 65535×1=%0d", $time, result);
        
        // 测试6：中等大小数乘法
        $display("\n=== 测试5：中等大小数乘法 ===");
        d_a = 1234; 
        d_b = 567;
        en_a = 1; 
        en_b = 1; 
        #10; 
        en_a = 0; 
        en_b = 0;
        en_result = 1; 
        #10; 
        en_result = 0;
        $display("t=%0t: 1234×567=%0d (应为699,678)", $time, result);
        
        // 测试7：测试寄存器保持功能
        $display("\n=== 测试6：测试寄存器保持功能 ===");
        // 先设置一个乘法
        d_a = 100; 
        d_b = 10;
        en_a = 1; 
        en_b = 1; 
        #10; 
        en_a = 0; 
        en_b = 0;
        en_result = 1; 
        #10; 
        en_result = 0;
        $display("t=%0t: 初始计算 100×10=%0d", $time, result);
        
        // 只改变输入但不使能，结果应保持不变
        d_a = 2000; 
        d_b = 3000;
        #10;
        $display("t=%0t: 改变输入但不使能，结果仍为=%0d", $time, result);
        
        // 测试8：乘0测试
        $display("\n=== 测试7：乘0测试 ===");
        d_a = 12345; 
        d_b = 0;
        en_a = 1; 
        en_b = 1; 
        #10; 
        en_a = 0; 
        en_b = 0;
        en_result = 1; 
        #10; 
        en_result = 0;
        $display("t=%0t: 12345×0=%0d (应为0)", $time, result);
        
        // 测试9：对称乘法
        $display("\n=== 测试8：对称乘法测试 ===");
        d_a = 77; 
        d_b = 88;
        en_a = 1; 
        en_b = 1; 
        #10; 
        en_a = 0; 
        en_b = 0;
        en_result = 1; 
        #10; 
        en_result = 0;
        $display("t=%0t: 77×88=%0d (应为6776)", $time, result);
        
        // 验证交换律
        d_a = 88; 
        d_b = 77;
        en_a = 1; 
        en_b = 1; 
        #10; 
        en_a = 0; 
        en_b = 0;
        en_result = 1; 
        #10; 
        en_result = 0;
        $display("t=%0t: 88×77=%0d (也应为6776)", $time, result);
        
        // 测试10：复位功能测试
        $display("\n=== 测试9：复位功能测试 ===");
        // 先进行一次计算
        d_a = 300; 
        d_b = 100;
        en_a = 1; 
        en_b = 1; 
        #10; 
        en_a = 0; 
        en_b = 0;
        en_result = 1; 
        #10; 
        en_result = 0;
        $display("t=%0t: 计算300×100=%0d", $time, result);
        
        // 执行复位
        rstn = 0; 
        #10; 
        rstn = 1;
        $display("t=%0t: 复位后结果=%0d (应为0)", $time, result);
        
        // 测试11：复位后重新计算
        $display("\n=== 测试10：复位后重新计算 ===");
        d_a = 123; 
        d_b = 456;
        en_a = 1; 
        en_b = 1; 
        #10; 
        en_a = 0; 
        en_b = 0;
        en_result = 1; 
        #10; 
        en_result = 0;
        $display("t=%0t: 123×456=%0d (应为56088)", $time, result);
        
        // 测试12：边界值测试
        $display("\n=== 测试11：边界值测试 ===");
        d_a = 1; 
        d_b = 65535;
        en_a = 1; 
        en_b = 1; 
        #10; 
        en_a = 0; 
        en_b = 0;
        en_result = 1; 
        #10; 
        en_result = 0;
        $display("t=%0t: 1×65535=%0d", $time, result);
        
        d_a = 32767; 
        d_b = 2;
        en_a = 1; 
        en_b = 1; 
        #10; 
        en_a = 0; 
        en_b = 0;
        en_result = 1; 
        #10; 
        en_result = 0;
        $display("t=%0t: 32767×2=%0d (应为65534)", $time, result);
        
        #20; 
        $display("\n=== 所有乘法测试完成 ===");
        $finish;
    end
    
    // 监视器，持续监测关键信号
    always @(posedge clk) begin
        if (en_a) $display("t=%0t: INFO - 写入寄存器A: %0d", $time, d_a);
        if (en_b) $display("t=%0t: INFO - 写入寄存器B: %0d", $time, d_b);
        if (en_result) $display("t=%0t: INFO - 存储乘法结果到寄存器", $time);
        if (!rstn) $display("t=%0t: INFO - 系统复位", $time);
    end
endmodule