module system_multiplier (
    // 寄存器输入端口
    input      [15:0] d_a,      // 操作数A输入
    input      [15:0] d_b,      // 操作数B输入
    input             clk,
    input             rstn,
    input             en_a,      // A寄存器使能
    input             en_b,      // B寄存器使能
    input             en_result, // 结果寄存器使能
    
    // 系统输出端口
    output     [31:0] result     // 32位乘法结果输出
);
    
    // 内部连线
    wire [15:0] q_a;          // 寄存器A输出
    wire [15:0] q_b;          // 寄存器B输出
    wire [31:0] product_wire; // 乘法器直接输出
    wire [31:0] q_result;     // 结果寄存器输出
    
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
    
    // 3. 实例化16位乘法器
    multiplier_16bits multiplier_inst (
        .a      (q_a),
        .b      (q_b),
        .product(product_wire)
    );
    
    // 4. 实例化32位结果寄存器（存储结果）
    // 注意：这里需要使用32位寄存器，所以我们创建一个临时的32位寄存器
    // 由于dff_16bit是16位，我们需要32位版本
    reg [31:0] result_reg;
    
    always @(posedge clk) begin
        if (!rstn)
            result_reg <= 32'b0;
        else if (en_result)
            result_reg <= product_wire;
    end

    assign result = result_reg;
    
endmodule
