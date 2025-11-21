module sipo (
    input        clk,
    input        ss,
    input        rst,
    input        mosi,
    output reg [15:0] word,
    output reg        word_ready
);


    reg [4:0] bit_counter;  
    reg [15:0] shift_reg;   
    reg receiving;          


    initial begin
        bit_counter = 5'd0;
        shift_reg = 16'h0000;
        word = 16'h0000;
        word_ready = 1'b0;
        receiving = 1'b0;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            bit_counter <= 5'd0;
            shift_reg   <= 16'h0000;
            word        <= 16'h0000;
            word_ready  <= 1'b0;
            receiving   <= 1'b0;
        end
        else begin

            if (!ss && !receiving) begin
                receiving   <= 1'b1;
                bit_counter <= 5'd0;
                word_ready  <= 1'b0;
            end


            if (receiving && !ss) begin

                shift_reg <= {mosi, shift_reg[15:1]};

                if (bit_counter == 5'd15) begin
                    word        <= {mosi, shift_reg[15:1]};  // Capturar valor completo
                    word_ready  <= 1'b1;
                    receiving   <= 1'b0;
                    bit_counter <= 5'd0;
                end
                else begin
                    bit_counter <= bit_counter + 1'b1;
                end
            end

            if (ss) begin
                word_ready <= 1'b0;
                receiving  <= 1'b0;
            end
        end
    end

endmodule