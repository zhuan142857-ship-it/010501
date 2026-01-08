module system (
    // 寄存器输入端口
    input      [15:0] d_a,      // 第一个操作数输入
    input      [15:0] d_b,      // 第二个操作数输入
    input             clk,
    input             rstn,
    input             en_a,      // 第一个寄存器使能
    input             en_b,      // 第二个寄存器使能
    
    // 加法器其他输入端口
    input             cin,
    
    // 系统输出端口
    output     [15:0] sum,
    output            cout
);
    
    // 内部连线：两个寄存器的输出
    wire [15:0] q_a;
    wire [15:0] q_b;
    
    // 1. 实例化第一个16位寄存器（存储操作数a）
    dff_16bit register_a_inst (
        .d   (d_a),
        .clk (clk),
        .rstn(rstn),
        .en  (en_a),
        .q   (q_a)
    );
    
    // 2. 实例化第二个16位寄存器（存储操作数b）
    dff_16bit register_b_inst (
        .d   (d_b),
        .clk (clk),
        .rstn(rstn),
        .en  (en_b),
        .q   (q_b)
    );
    
    // 3. 实例化16位加法器
    sixteen_bit_adder adder_inst (
        .a   (q_a),    // 从寄存器A输出读取
        .b   (q_b),    // 从寄存器B输出读取
        .cin (cin),
        .sum (sum),
        .cout(cout)
    );
    
endmodule