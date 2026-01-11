module unified_computing_system (
    // 寄存器输入端口
    input      [15:0] d_a,          // 操作数A输入
    input      [15:0] d_b,          // 操作数B输入
    input      [1:0]  op_code,      // 操作码: 00=加法, 01=减法, 10=乘法, 11=除法
    input             clk,
    input             rstn,
    input             en_a,          // A寄存器使能
    input             en_b,          // B寄存器使能
    input             en_result,     // 结果寄存器使能
    
    // 加减法专用输入
    input             cin,           // 加法进位输入
    input             bin,           // 减法借位输入
    
    // 系统输出端口
    output reg [31:0] result,        // 统一的结果输出（32位）
    output reg [15:0] remainder,     // 除法专用：余数输出
    output reg        cout,          // 加法：进位输出
    output reg        bout,          // 减法：借位输出
    output reg        overflow_flag, // 溢出标志
    output reg        error_flag     // 错误标志（除数为0）
);
    
    // 内部连线
    wire [15:0] q_a;           // 寄存器A输出
    wire [15:0] q_b;           // 寄存器B输出
    
    // 各运算模块的输出
    wire [15:0] sum_result;
    wire        sum_cout;
    wire [15:0] diff_result;
    wire        diff_bout;
    wire [31:0] product_result;
    wire [15:0] quotient_result;
    wire [15:0] remainder_result;
    
    // 临时结果寄存器
    reg [31:0] temp_result;
    reg [15:0] temp_remainder;
    reg        temp_cout;
    reg        temp_bout;
    reg        temp_overflow;
    reg        temp_error;
    
    // 1. 实例化操作数寄存器
    dff_16bit register_a_inst (
        .d   (d_a),
        .clk (clk),
        .rstn(rstn),
        .en  (en_a),
        .q   (q_a)
    );
    
    dff_16bit register_b_inst (
        .d   (d_b),
        .clk (clk),
        .rstn(rstn),
        .en  (en_b),
        .q   (q_b)
    );
    
    // 2. 实例化四个运算单元（所有运算并行计算）
    adder_16bits adder_inst (
        .a   (q_a),
        .b   (q_b),
        .cin (cin),
        .sum (sum_result),
        .cout(sum_cout)
    );
    
    subtractor_16bits subtractor_inst (
        .a    (q_a),
        .b    (q_b),
        .bin  (bin),
        .diff (diff_result),
        .bout (diff_bout)
    );
    
    multiplier_16bits multiplier_inst (
        .a      (q_a),
        .b      (q_b),
        .product(product_result)
    );
    
    divider_16bits divider_inst (
        .dividend (q_a),
        .divisor  (q_b),
        .quotient (quotient_result),
        .remainder(remainder_result)
    );
    
    // 3. 根据操作码选择运算结果
    always @(*) begin
        // 默认值
        temp_result = 32'b0;
        temp_remainder = 16'b0;
        temp_cout = 1'b0;
        temp_bout = 1'b0;
        temp_overflow = 1'b0;
        temp_error = 1'b0;
        
        case(op_code)
            2'b00: begin // 加法
                temp_result = {16'b0, sum_result};
                temp_cout = sum_cout;
                
                // 溢出检测（有符号数加法）
                if ((q_a[15] == q_b[15]) && (sum_result[15] != q_a[15])) begin
                    temp_overflow = 1'b1;
                end
            end
            
            2'b01: begin // 减法
                temp_result = {16'b0, diff_result};
                temp_bout = diff_bout;
                
                // 溢出检测（有符号数减法）
                if ((q_a[15] != q_b[15]) && (diff_result[15] != q_a[15])) begin
                    temp_overflow = 1'b1;
                end
            end
            
            2'b10: begin // 乘法
                temp_result = product_result;
                
                // 溢出检测（乘法结果超出16位范围）
                if (product_result[31:16] != 16'b0 && 
                    product_result[31:16] != 16'hFFFF) begin
                    temp_overflow = 1'b1;
                end
            end
            
            2'b11: begin // 除法
                if (q_b == 16'b0) begin // 除数为0
                    temp_result = 32'b0;
                    temp_error = 1'b1;
                end else begin
                    temp_result = {16'b0, quotient_result}; // 只输出商
                    temp_remainder = remainder_result;
                end
            end
            
            default: begin
                // 保持默认值
            end
        endcase
    end
    
    // 4. 结果寄存器（存储选定的运算结果）
    always @(posedge clk) begin
        if (!rstn) begin
            result <= 32'b0;
            remainder <= 16'b0;
            cout <= 1'b0;
            bout <= 1'b0;
            overflow_flag <= 1'b0;
            error_flag <= 1'b0;
        end
        else if (en_result) begin
            result <= temp_result;
            remainder <= temp_remainder;
            cout <= temp_cout;
            bout <= temp_bout;
            overflow_flag <= temp_overflow;
            error_flag <= temp_error;
        end
    end
    
endmodule