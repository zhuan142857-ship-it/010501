module system_adder (
    // 寄存器输入端口
    input      [15:0] d_a,      // 操作数A输入
    input      [15:0] d_b,      // 操作数B输入
    input             clk,
    input             rstn,
    input             en_a,      // A寄存器使能
    input             en_b,      // B寄存器使能
    input             en_result, // 新增：结果寄存器使能
    
    // 加法器其他输入端口
    input             cin,
    
    // 系统输出端口
    output     [15:0] result,    // 改为：存储的结果输出
    output            cout
);
    
    // 内部连线
    wire [15:0] q_a;      // 寄存器A输出
    wire [15:0] q_b;      // 寄存器B输出
    wire [15:0] sum_wire; // 加法器直接输出
    wire [15:0] q_result; // 结果寄存器输出
    
    // 1. 实例化第一个16位寄存器（操作数A）
    dff_16bit register_a_inst (
        .d   (d_a),
        .clk (clk),
        .rstn(rstn),
        .en  (en_a),
        .q   (q_a)
    );
    
    // 2. 实例化第二个16位寄存器（操作数B）
    dff_16bit register_b_inst (
        .d   (d_b),
        .clk (clk),
        .rstn(rstn),
        .en  (en_b),
        .q   (q_b)
    );
    
    // 3. 实例化16位加法器
    adder_16bits adder_inst (
        .a   (q_a),
        .b   (q_b),
        .cin (cin),
        .sum (sum_wire),      // 连接到中间线
        .cout(cout)
    );
    
    // 4. 实例化第三个16位寄存器（存储结果）
    dff_16bit result_register_inst (
        .d   (sum_wire),      
        .clk (clk),
        .rstn(rstn),
        .en  (en_result),     
        .q   (q_result)       
    );

    assign result = q_result;
    
endmodule