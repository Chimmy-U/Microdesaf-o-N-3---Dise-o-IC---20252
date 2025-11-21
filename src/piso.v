module piso (
    input        clk,
    input        ss,
    input        rst,
    input  [15:0] result,
    input         ready,
    output reg    miso
);

    reg [4:0] tx_bit_counter;
    reg [15:0] tx_shift_reg;
    reg tx_active;
    
    parameter GARBAGE_DATA = 16'hFFFF;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tx_bit_counter <= 5'd0;
            tx_shift_reg <= GARBAGE_DATA;
            miso <= 1'b0;
            tx_active <= 1'b0;
        end
        
        else begin

            if (ready && (tx_shift_reg == GARBAGE_DATA)) begin
                tx_shift_reg <= result;
            end

 
            else if (!ss && !tx_active && (tx_shift_reg != GARBAGE_DATA)) begin
                tx_active <= 1'b1;
                tx_bit_counter <= 5'd0;
            end
            

            else if (tx_active && !ss) begin
                miso <= tx_shift_reg[0];
                tx_shift_reg <= {1'b0, tx_shift_reg[15:1]};
                
                if (tx_bit_counter < 5'd15) begin
                    tx_bit_counter <= tx_bit_counter + 1'b1;
                end else begin
                    tx_active <= 1'b0;
                    tx_bit_counter <= 5'd0;
                    tx_shift_reg <= GARBAGE_DATA;  // Liberar buffer AL FINAL
                end
            end
            

            if (ss) begin
                tx_active <= 1'b0;
                tx_bit_counter <= 5'd0;
            end
        end
    end

endmodule