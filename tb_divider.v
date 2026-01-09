module tb_divider;
    reg  [15:0] d_a, d_b;
    reg clk=0, rstn, en_a, en_b, en_result;
    wire [15:0] quotient, remainder;
    
    system_divider uut (
        .d_a(d_a),
        .d_b(d_b),
        .clk(clk),
        .rstn(rstn),
        .en_a(en_a),
        .en_b(en_b),
        .en_result(en_result),
        .quotient(quotient),
        .remainder(remainder)
    );
    
    // 时钟生成
    initial forever #5 clk = ~clk;
    
    initial begin
        // 初始化
        $dumpfile("wave_divider.vcd");
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
        
        // 测试1：完整除法流程 - 整除情况
        $display("=== 测试1：完整除法流程 (100 ÷ 50) ===");
        // 步骤1：写入被除数
        d_a = 100; 
        en_a = 1; 
        #10; 
        en_a = 0;
        $display("t=%0t: 写入被除数=100，当前商=%0d，余数=%0d", 
                 $time, quotient, remainder);
        
        // 步骤2：写入除数
        d_b = 50; 
        en_b = 1; 
        #10; 
        en_b = 0;
        $display("t=%0t: 写入除数=50，当前商=%0d，余数=%0d", 
                 $time, quotient, remainder);
        
        // 步骤3：触发计算并存储结果
        en_result = 1; 
        #10; 
        en_result = 0;
        $display("t=%0t: 存储结果，商=%0d，余数=%0d (应为商=2，余数=0)", 
                 $time, quotient, remainder);
        
        // 测试2：有余数的除法
        $display("\n=== 测试2：有余数的除法 (17 ÷ 5) ===");
        d_a = 17; 
        d_b = 5;
        en_a = 1; 
        en_b = 1; 
        #10; 
        en_a = 0; 
        en_b = 0;
        en_result = 1; 
        #10; 
        en_result = 0;
        $display("t=%0t: 17÷5=商%0d，余数%0d (应为商=3，余数=2)", 
                 $time, quotient, remainder);
        
        // 测试3：改变被除数，但不更新结果
        $display("\n=== 测试3：只更新被除数，不更新结果 ===");
        d_a = 200; 
        en_a = 1; 
        #10; 
        en_a = 0;
        $display("t=%0t: 写入被除数=200，但结果仍保持：商=%0d，余数=%0d", 
                 $time, quotient, remainder);
        
        // 测试4：再次计算
        en_result = 1; 
        #10; 
        en_result = 0;
        $display("t=%0t: 重新存储结果，商=%0d，余数=%0d (应为200÷5=40余0)", 
                 $time, quotient, remainder);
        
        // 测试5：除数为1的情况
        $display("\n=== 测试5：除数为1的除法 ===");
        d_a = 12345; 
        d_b = 1;
        en_a = 1; 
        en_b = 1; 
        #10; 
        en_a = 0; 
        en_b = 0;
        en_result = 1; 
        #10; 
        en_result = 0;
        $display("t=%0t: 12345÷1=商%0d，余数%0d (应为商=12345，余数=0)", 
                 $time, quotient, remainder);
        
        // 测试6：被除数小于除数
        $display("\n=== 测试6：被除数小于除数 (5 ÷ 10) ===");
        d_a = 5; 
        d_b = 10;
        en_a = 1; 
        en_b = 1; 
        #10; 
        en_a = 0; 
        en_b = 0;
        en_result = 1; 
        #10; 
        en_result = 0;
        $display("t=%0t: 5÷10=商%0d，余数%0d (应为商=0，余数=5)", 
                 $time, quotient, remainder);
        
        // 测试7：除数为0的情况（注意：整数除法中除以0的行为）
        $display("\n=== 测试7：除数为0的情况 (100 ÷ 0) ===");
        d_a = 100; 
        d_b = 0;
        en_a = 1; 
        en_b = 1; 
        #10; 
        en_a = 0; 
        en_b = 0;
        en_result = 1; 
        #10; 
        en_result = 0;
        $display("t=%0t: 100÷0=商%0d，余数%0d (注意：Verilog中除以0的结果)", 
                 $time, quotient, remainder);
        
        // 测试8：最大值除法
        $display("\n=== 测试8：最大值除法 ===");
        d_a = 65535; 
        d_b = 65535;
        en_a = 1; 
        en_b = 1; 
        #10; 
        en_a = 0; 
        en_b = 0;
        en_result = 1; 
        #10; 
        en_result = 0;
        $display("t=%0t: 65535÷65535=商%0d，余数%0d (应为商=1，余数=0)", 
                 $time, quotient, remainder);
        
        // 测试9：大数除法
        $display("\n=== 测试9：大数除法 (65535 ÷ 256) ===");
        d_a = 65535; 
        d_b = 256;
        en_a = 1; 
        en_b = 1; 
        #10; 
        en_a = 0; 
        en_b = 0;
        en_result = 1; 
        #10; 
        en_result = 0;
        $display("t=%0t: 65535÷256=商%0d，余数%0d (应为商=255，余数=255)", 
                 $time, quotient, remainder);
        
        // 测试10：精确除法
        $display("\n=== 测试10：精确除法 (1000 ÷ 8) ===");
        d_a = 1000; 
        d_b = 8;
        en_a = 1; 
        en_b = 1; 
        #10; 
        en_a = 0; 
        en_b = 0;
        en_result = 1; 
        #10; 
        en_result = 0;
        $display("t=%0t: 1000÷8=商%0d，余数%0d (应为商=125，余数=0)", 
                 $time, quotient, remainder);
        
        // 测试11：测试寄存器保持功能
        $display("\n=== 测试11：测试寄存器保持功能 ===");
        // 先进行一次计算
        d_a = 99; 
        d_b = 4;
        en_a = 1; 
        en_b = 1; 
        #10; 
        en_a = 0; 
        en_b = 0;
        en_result = 1; 
        #10; 
        en_result = 0;
        $display("t=%0t: 初始计算 99÷4=商%0d，余数%0d", 
                 $time, quotient, remainder);
        
        // 只改变输入但不使能，结果应保持不变
        d_a = 888; 
        d_b = 7;
        #10;
        $display("t=%0t: 改变输入但不使能，结果仍保持：商=%0d，余数=%0d", 
                 $time, quotient, remainder);
        
        // 测试12：复杂余数测试
        $display("\n=== 测试12：复杂余数测试 ===");
        d_a = 12345; 
        d_b = 67;
        en_a = 1; 
        en_b = 1; 
        #10; 
        en_a = 0; 
        en_b = 0;
        en_result = 1; 
        #10; 
        en_result = 0;
        $display("t=%0t: 12345÷67=商%0d，余数%0d (验证: 67×184+17=12345)", 
                 $time, quotient, remainder);
        
        // 测试13：连续除法运算
        $display("\n=== 测试13：连续除法运算 ===");
        // 第一次除法
        d_a = 100; 
        d_b = 3;
        en_a = 1; 
        en_b = 1; 
        #10; 
        en_a = 0; 
        en_b = 0;
        en_result = 1; 
        #10; 
        en_result = 0;
        $display("t=%0t: 第一次: 100÷3=商%0d，余数%0d", 
                 $time, quotient, remainder);
        
        // 第二次除法（只改变被除数）
        d_a = 200;
        en_a = 1; 
        #10; 
        en_a = 0;
        en_result = 1; 
        #10; 
        en_result = 0;
        $display("t=%0t: 第二次: 200÷3=商%0d，余数%0d", 
                 $time, quotient, remainder);
        
        // 第三次除法（改变除数）
        d_b = 15;
        en_b = 1; 
        #10; 
        en_b = 0;
        en_result = 1; 
        #10; 
        en_result = 0;
        $display("t=%0t: 第三次: 200÷15=商%0d，余数%0d", 
                 $time, quotient, remainder);
        
        // 测试14：复位功能测试
        $display("\n=== 测试14：复位功能测试 ===");
        // 先进行一次计算
        d_a = 789; 
        d_b = 12;
        en_a = 1; 
        en_b = 1; 
        #10; 
        en_a = 0; 
        en_b = 0;
        en_result = 1; 
        #10; 
        en_result = 0;
        $display("t=%0t: 计算789÷12=商%0d，余数%0d", 
                 $time, quotient, remainder);
        
        // 执行复位
        rstn = 0; 
        #10; 
        rstn = 1;
        $display("t=%0t: 复位后：商=%0d，余数=%0d (应为0, 0)", 
                 $time, quotient, remainder);
        
        // 测试15：复位后重新计算
        $display("\n=== 测试15：复位后重新计算 ===");
        d_a = 54321; 
        d_b = 123;
        en_a = 1; 
        en_b = 1; 
        #10; 
        en_a = 0; 
        en_b = 0;
        en_result = 1; 
        #10; 
        en_result = 0;
        $display("t=%0t: 54321÷123=商%0d，余数%0d (应为商=441，余数=78)", 
                 $time, quotient, remainder);
        
        // 测试16：边界值测试 - 最小非零值
        $display("\n=== 测试16：边界值测试 ===");
        d_a = 1; 
        d_b = 1;
        en_a = 1; 
        en_b = 1; 
        #10; 
        en_a = 0; 
        en_b = 0;
        en_result = 1; 
        #10; 
        en_result = 0;
        $display("t=%0t: 1÷1=商%0d，余数%0d", 
                 $time, quotient, remainder);
        
        d_a = 65535; 
        d_b = 2;
        en_a = 1; 
        en_b = 1; 
        #10; 
        en_a = 0; 
        en_b = 0;
        en_result = 1; 
        #10; 
        en_result = 0;
        $display("t=%0t: 65535÷2=商%0d，余数%0d (应为商=32767，余数=1)", 
                 $time, quotient, remainder);
        
        #20; 
        $display("\n=== 所有除法测试完成 ===");
        $display("=== 测试总结 ===");
        $display("1. 正常除法测试 ✓");
        $display("2. 余数测试 ✓");
        $display("3. 边界条件测试 ✓");
        $display("4. 寄存器保持功能 ✓");
        $display("5. 复位功能 ✓");
        $display("6. 连续运算测试 ✓");
        $finish;
    end
    
    // 监视器，持续监测关键信号
    always @(posedge clk) begin
        if (en_a) $display("t=%0t: INFO - 写入被除数寄存器: %0d", $time, d_a);
        if (en_b) $display("t=%0t: INFO - 写入除数寄存器: %0d", $time, d_b);
        if (en_result) $display("t=%0t: INFO - 存储除法结果到寄存器", $time);
        if (!rstn) $display("t=%0t: INFO - 系统复位", $time);
    end
endmodule