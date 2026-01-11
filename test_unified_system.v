module test_unified_system;
    // 输入
    reg [15:0] d_a, d_b;
    reg [1:0]  op_code;
    reg clk, rstn, en_a, en_b, en_result, cin, bin;
    
    // 输出
    wire [31:0] result;
    wire [15:0] remainder;
    wire cout, bout, overflow_flag, error_flag;
    
    // 实例化统一计算系统
    unified_computing_system uut (
        .d_a(d_a),
        .d_b(d_b),
        .op_code(op_code),
        .clk(clk),
        .rstn(rstn),
        .en_a(en_a),
        .en_b(en_b),
        .en_result(en_result),
        .cin(cin),
        .bin(bin),
        .result(result),
        .remainder(remainder),
        .cout(cout),
        .bout(bout),
        .overflow_flag(overflow_flag),
        .error_flag(error_flag)
    );
    
    // 时钟生成
    always #5 clk = ~clk;
    
    // 测试计数
    integer test_num = 1;
    
    // 任务：执行单次测试
    task run_test;
        input [1:0]  test_op_code;
        input [15:0] test_d_a;
        input [15:0] test_d_b;
        input        test_cin;
        input        test_bin;
        input [255:0] test_name;
    begin
        $display("测试 %0d: %s", test_num, test_name);
        test_num = test_num + 1;
        
        // 设置测试参数
        op_code = test_op_code;
        d_a = test_d_a;
        d_b = test_d_b;
        cin = test_cin;
        bin = test_bin;
        
        // 执行运算
        #10;
        en_a = 1;
        en_b = 1;
        #10;
        en_a = 0;
        en_b = 0;
        en_result = 1;
        #10;
        en_result = 0;
        
        // 等待结果稳定
        #30;
        
        $display("  输入: A=%0d (0x%h), B=%0d (0x%h)", test_d_a, test_d_a, test_d_b, test_d_b);
        $display("  输出: 结果=%0d (0x%h), 余数=%0d", result, result, remainder);
        $display("        cout=%b, bout=%b, overflow=%b, error=%b", cout, bout, overflow_flag, error_flag);
        $display("");
        
        // 等待一段时间进行下一个测试
        #20;
    end
    endtask
    
    initial begin
        // 初始化所有信号
        clk = 0;
        rstn = 0;
        en_a = 0;
        en_b = 0;
        en_result = 0;
        cin = 0;
        bin = 0;
        d_a = 0;
        d_b = 0;
        op_code = 0;
        
        // 测试开始
        #10;
        rstn = 1;  // 释放复位
        #10;
        
        // ========== 测试加法运算（3种情况）==========
        $display("=== 加法运算测试 ===");
        // 情况1: 正常加法，无进位
        run_test(2'b00, 16'd100, 16'd200, 1'b0, 1'b0, "正常加法: 100 + 200");
        
        // 情况2: 加法有进位
        run_test(2'b00, 16'hFFFF, 16'd1, 1'b0, 1'b0, "进位加法: 0xFFFF + 1");
        
        // 情况3: 有符号加法溢出测试
        run_test(2'b00, 16'h7FFF, 16'd1, 1'b0, 1'b0, "有符号溢出加法: 32767 + 1");
        
        // ========== 测试减法运算（3种情况）==========
        $display("=== 减法运算测试 ===");
        // 情况1: 正常减法，无借位
        run_test(2'b01, 16'd200, 16'd100, 1'b0, 1'b0, "正常减法: 200 - 100");
        
        // 情况2: 减法有借位
        run_test(2'b01, 16'd100, 16'd200, 1'b0, 1'b0, "借位减法: 100 - 200");
        
        // 情况3: 有符号减法溢出测试
        run_test(2'b01, 16'h8000, 16'd1, 1'b0, 1'b0, "有符号溢出减法: -32768 - 1");
        
        // ========== 测试乘法运算（3种情况）==========
        $display("=== 乘法运算测试 ===");
        // 情况1: 正常乘法
        run_test(2'b10, 16'd100, 16'd3, 1'b0, 1'b0, "正常乘法: 100 * 3");
        
        // 情况2: 大数乘法
        run_test(2'b10, 16'd1000, 16'd1000, 1'b0, 1'b0, "大数乘法: 1000 * 1000");
        
        // 情况3: 有符号乘法边界测试
        run_test(2'b10, 16'h7FFF, 16'd2, 1'b0, 1'b0, "边界乘法: 32767 * 2");
        
        // ========== 测试除法运算（3种情况）==========
        $display("=== 除法运算测试 ===");
        // 情况1: 正常除法，有余数
        run_test(2'b11, 16'd100, 16'd7, 1'b0, 1'b0, "正常除法: 100 ÷ 7");
        
        // 情况2: 整除
        run_test(2'b11, 16'd100, 16'd10, 1'b0, 1'b0, "整除: 100 ÷ 10");
        
        // 情况3: 除数为0（错误情况）
        run_test(2'b11, 16'd100, 16'd0, 1'b0, 1'b0, "除数为0: 100 ÷ 0");
        
        // ========== 额外测试：带进位/借位的加减法 ==========
        $display("=== 额外测试：带进位/借位的运算 ===");
        // 带进位的加法
        run_test(2'b00, 16'd100, 16'd200, 1'b1, 1'b0, "带进位加法: 100 + 200 + 1");
        
        // 带借位的减法
        run_test(2'b01, 16'd200, 16'd100, 1'b0, 1'b1, "带借位减法: 200 - 100 - 1");
        
        // 结束测试
        #50;
        $display("=== 所有测试完成 ===");
        $finish;
    end
    
    // 监视时钟沿的变化
    always @(posedge clk) begin
        if (en_result) begin
            case(op_code)
                2'b00: $display("时钟边沿: 加法运算完成，结果=%d", result);
                2'b01: $display("时钟边沿: 减法运算完成，结果=%d", result);
                2'b10: $display("时钟边沿: 乘法运算完成，结果=%d", result);
                2'b11: $display("时钟边沿: 除法运算完成，商=%d, 余数=%d", result, remainder);
            endcase
        end
    end
    
endmodule
