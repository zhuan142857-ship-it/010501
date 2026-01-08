// ==================== 1. 16位寄存器模块 ====================
module dff_16bit (
    input      [15:0] d,
    input             clk,
    input             rstn,
    input             en,
    output reg [15:0] q
);
    always @(posedge clk) begin
        if (!rstn)
            q <= 16'b0;
        else if (en)
            q <= d;
    end
endmodule

// ==================== 2. 16位加法器模块 ====================
module sixteen_bit_adder(
    input [15:0] a,
    input [15:0] b,
    input cin,
    output [15:0] sum,
    output cout
);
    assign {cout, sum} = a + b + cin;
endmodule

// ==================== 3. 顶层系统模块 ====================
module system (
    // 寄存器输入端口
    input      [15:0] d,
    input             clk,
    input             rstn,
    input             en,
    
    // 加法器其他输入端口
    input      [15:0] b,
    input             cin,
    
    // 系统输出端口
    output     [15:0] sum,
    output            cout
);
    
    // 内部连线：寄存器的输出
    wire [15:0] q;
    
    // 实例化16位寄存器
    dff_16bit register_inst (
        .d   (d),
        .clk (clk),
        .rstn(rstn),
        .en  (en),
        .q   (q)
    );
    
    // 实例化16位加法器
    sixteen_bit_adder adder_inst (
        .a   (q),    // 关键连接：从寄存器输出读取
        .b   (b),
        .cin (cin),
        .sum (sum),
        .cout(cout)
    );
    
endmodule