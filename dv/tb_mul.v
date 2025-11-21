`timescale 1ns / 1ps

module tb_mul;

reg [15:0] x1, x2;
wire [15:0] y;
reg clk, rst, en;
wire ready;
real value1, value2;

parameter clk_period = 10;
parameter rst_time = 100;


function [15:0] dtobf16 (input real a);
    reg [63:0] a_bits; 
    reg s;
    reg [7:0] exp;
    reg [8:0] mant;
    reg [11:0] mant_grs;
    reg [6:0] o_mant;
    begin
        if (a == 0.0)
            dtobf16 = 16'd0;
        else begin    
            a_bits = $realtobits(a);
            s = a_bits[63];
            exp = (a_bits[62:52] - 1023) + 127;

            mant_grs = {2'b01, a_bits[51:42]};
            mant = mant_grs[11:3];
            
            if (mant_grs[2:0] > 3'd4)
                mant = mant_grs[11:3] + 9'd1;
            
            if (mant_grs[2:0] == 3'd4) begin
                if (mant_grs[3] == 1'b1)
                    mant = mant_grs[11:3] + 9'd1;
                else
                    mant = mant_grs[11:3];
            end
            
            if (mant[8] == 1'b1) begin
                o_mant = mant[7:1];
                exp = exp + 1;
            end else
                o_mant = mant[6:0];
                    
            dtobf16 = {s, exp, o_mant};
        end
    end
endfunction

fpmul uut (
    .x1(x1),
    .x2(x2),
    .y(y),
    .clk(clk),
    .rst(rst),
    .en(en),
    .ready(ready)
);


initial begin
    clk = 0;
    forever #(clk_period / 2) clk = ~clk;
end

initial begin
    rst = 1;
    #rst_time rst = 0;
end

initial begin
    en = 0;
    #rst_time en = 1;
end

initial begin
    $dumpfile("test_mul.vcd");
    $dumpvars(0, tb_mul);
    $monitor($time, " clk=%b | x1=%h x2=%h y=%h | ready=%b", clk, x1, x2, y, ready);

    value1 = 12.5;
    value2 = 3.2;

    x1 <= 0;
    x2 <= 0;
    #(rst_time);

    // Multiplicaciones con distintas combinaciones de signo
    x1 <= dtobf16(value1);
    x2 <= dtobf16(value2);
    #(clk_period);

    x1 <= dtobf16(-value1);
    x2 <= dtobf16(value2);
    #(clk_period);

    x1 <= dtobf16(value1);
    x2 <= dtobf16(-value2);
    #(clk_period);

    x1 <= dtobf16(-value1);
    x2 <= dtobf16(-value2);
    #(clk_period);

    // Casos adicionales (valores pequeños / grandes)
    value1 = 0.5;
    value2 = 256.0;
    x1 <= dtobf16(value1);
    x2 <= dtobf16(value2);
    #(clk_period);

    value1 = 1.0;
    value2 = 0.0;
    x1 <= dtobf16(value1);
    x2 <= dtobf16(value2);
    #(clk_period);

    value1 = -3.5;
    value2 = 2.25;
    x1 <= dtobf16(value1);
    x2 <= dtobf16(value2);
    #(clk_period);

    #(clk_period * 20);
    $finish;
end

endmodule
