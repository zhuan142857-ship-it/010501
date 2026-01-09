module system_divider (
    // 寄存器输入端口
    input      [15:0] d_a,         // 被除数输入
    input      [15:0] d_b,         // 除数输入
    input             clk,
    input             rstn,
    input             en_a,         // 被除数寄存器使能
    input             en_b,         // 除数寄存器使能
    input             en_result,    // 结果寄存器使能
    
    // 系统输出端口
    output     [15:0] quotient,     // 商输出
    output     [15:0] remainder     // 余数输出
);
    
    // 内部连线
    wire [15:0] q_a;               // 被除数寄存器输出
    wire [15:0] q_b;               // 除数寄存器输出
    wire [15:0] quotient_wire;     // 除法器商输出
    wire [15:0] remainder_wire;    // 除法器余数输出
    reg  [15:0] quotient_reg;      // 商寄存器
    reg  [15:0] remainder_reg;     // 余数寄存器
    
    // 1. 实例化第一个16位寄存器（被除数）
    dff_16bit dividend_register_inst (
        .d   (d_a),
        .clk (clk),
        .rstn(rstn),
        .en  (en_a),
        .q   (q_a)
    );
    
    // 2. 实例化第二个16位寄存器（除数）
    dff_16bit divisor_register_inst (
        .d   (d_b),
        .clk (clk),
        .rstn(rstn),
        .en  (en_b),
        .q   (q_b)
    );
    
    // 3. 实例化16位除法器
    divider_16bits divider_inst (
        .dividend (q_a),
        .divisor  (q_b),
        .quotient (quotient_wire),
        .remainder(remainder_wire)
    );
    
    // 4. 结果寄存器（商和余数）
    always @(posedge clk) begin
        if (!rstn) begin
            quotient_reg  <= 16'b0;
            remainder_reg <= 16'b0;
        end
        else if (en_result) begin
            quotient_reg  <= quotient_wire;
            remainder_reg <= remainder_wire;
        end
    end

    assign quotient  = quotient_reg;
    assign remainder = remainder_reg;
    
endmodule

