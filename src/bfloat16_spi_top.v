module bfloat16_spi_top (
    input  wire clk,
    input  wire ss,
    input  wire rst,
    input  wire mosi,
    output wire miso
);

// === SEÑALES INTERFAS SPI ===
wire [15:0] word;
wire        word_ready;

// === REGISTROS DE OPERANDOS Y CONTROL ===
reg [15:0] instr, op1, op2, acc;
wire [15:0] result_wire; 

// === SEÑALES DE UNIDADES ARITMÉTICAS ===
wire [15:0] mult_result, div_result, add_result, res_result, acc_sum_result, acc_sub_result;
wire        mult_ready, div_ready, add_ready, res_ready, acc_sum_ready, acc_sub_ready;


// === ENABLES INDIVIDUALES ===
reg mult_en, div_en, add_en, res_en, load_en, acc_sum_en, acc_sub_en;
wire load_ready = load_en;

// === MULTIPLEXOR DE RESULTADOS ===
assign result_wire = mult_en    ? mult_result     :
                     div_en     ? div_result      :
                     add_en     ? add_result      :
                     res_en     ? res_result      :
                     load_en    ? acc             :
                     16'h0000;

// === MAQUINA DE ESTADOS ===
reg [3:0] state;
parameter IDLE        = 4'b0000;
parameter DECODE      = 4'b0001;
parameter OP1         = 4'b0010;
parameter OP2         = 4'b0011;
parameter EXEC_MULT   = 4'b0100;
parameter EXEC_DIV    = 4'b0101;
parameter EXEC_ADD    = 4'b0110;
parameter EXEC_RES    = 4'b0111;
parameter EXEC_LOAD   = 4'b1000;
parameter SUMMATION   = 4'b1001;
parameter SUBTRACTION = 4'b1010;

// === INSTANCIAS ===
sipo sipo (
    .clk        (clk),
    .ss         (ss),
    .rst        (rst),
    .mosi       (mosi),
    .word       (word),
    .word_ready (word_ready)
);

piso piso (
    .clk        (clk),
    .ss         (ss),
    .rst        (rst),
    .result     (result_wire),
    .ready      (mult_ready | div_ready | add_ready | res_ready | load_ready),
    .miso       (miso)
);

// === UNIDAD ARITMÉTICA: MULTIPLICADOR ===
fpmul fpmul (
    .x1    (op1),
    .x2    (op2),
    .y     (mult_result),
    .clk   (clk),
    .rst   (rst),
    .en    (mult_en),
    .ready (mult_ready)
);

// === UNIDAD ARITMÉTICA: DIVISOR ===
fpdiv fpdiv (
    .x1    (op1),
    .x2    (op2),
    .y     (div_result),
    .clk   (clk),
    .rst   (rst),
    .en    (div_en),
    .ready (div_ready)
);

// === UNIDAD ARITMÉTICA: SUMADOR ===
fp16_sum_res_pipe fp16_sum_pipe (
    .x1      (op1),
    .x2      (op2),
    .add_sub (1'b0),  //suma
    .y       (add_result),
    .clk     (clk),
    .rst     (rst),
    .en      (add_en),
    .ready   (add_ready)
);

// === UNIDAD ARITMÉTICA: RESTADOR ===
fp16_sum_res_pipe fp16_res_pipe (
    .x1      (op1),
    .x2      (op2),
    .add_sub (1'b1),  //resta
    .y       (res_result),
    .clk     (clk),
    .rst     (rst),
    .en      (res_en),
    .ready   (res_ready)
);

// === UNIDAD ARITMÉTICA: SUMATORIA ===
fp16_sum_res_pipe acc_sum (
     .x1      (acc),      // Entrada: ACC actual
     .x2      (op1),      // Entrada: Dato del flujo (guardado en op1)
     .add_sub (1'b0),     // 0 = suma
     .y       (acc_sum_result),
     .clk     (clk),
     .rst     (rst),
     .en      (acc_sum_en),
     .ready   (acc_sum_ready)
);

// === UNIDAD ARITMÉTICA: RESTATORIA ===
fp16_sum_res_pipe acc_sub (
    .x1      (acc),      // Entrada: ACC actual
    .x2      (op1),      // Entrada: Dato del flujo (guardado en op1)
    .add_sub (1'b1),     // 1 = resta
    .y       (acc_sub_result),
    .clk     (clk),
    .rst     (rst),
    .en      (acc_sub_en),
    .ready   (acc_sub_ready)
);

// === PRINCIPAL  ===
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state      <= IDLE;
        instr      <= 16'h0000;
        op1        <= 16'h0000;
        op2        <= 16'h0000;
        acc        <= 16'h0000;
        mult_en    <= 1'b0;
        div_en     <= 1'b0;
        add_en     <= 1'b0;
        res_en     <= 1'b0;
        load_en    <= 1'b0;
        acc        <= 16'h0000;
        acc_sum_en <= 1'b0;
        acc_sub_en <= 1'b0;

    end else begin

        mult_en    <= 1'b0;
        div_en     <= 1'b0;
        add_en     <= 1'b0;
        res_en     <= 1'b0;
        load_en    <= 1'b0;
        acc_sum_en <= 1'b0;
        acc_sub_en <= 1'b0;
        
        
        case (state)
            IDLE: begin
                if (word_ready) begin
                    instr <= word;
                    state <= DECODE;
                end
            end
            
            DECODE: begin
                case (instr)
                    16'h0000: begin acc <= 16'h0000; state <= IDLE; end // ZERO
                    16'h0001: state <= OP1;  // SET_ACC
                    16'h0002: state <= EXEC_LOAD; // LOAD_ACC
                    16'h0003: state <= OP1;  // ADD2
                    16'h0004: state <= OP1;  // SUB2
                    16'h0005: state <= OP1;  // MPY2
                    16'h0006: state <= OP1;  // DIV2
                    16'h0007: state <= SUMMATION; // SUM
                    16'h0008: state <= SUBTRACTION; // SUB
                    default:  state <= IDLE; // Instrucción inválida
                endcase
            end
            
            OP1: begin
                if (word_ready) begin
                    op1 <= word;
                    case (instr)
                        16'h0001: begin acc <= word; state <= IDLE; end
                        16'h0003: state <= OP2;
                        16'h0004: state <= OP2;
                        16'h0005: state <= OP2;
                        16'h0006: state <= OP2;
                        default:  state <= IDLE;
                    endcase
                end
            end
            
            OP2: begin
                if (word_ready) begin
                    op2 <= word;
                    case (instr)
                        16'h0003: state <= EXEC_ADD;
                        16'h0004: state <= EXEC_RES;
                        16'h0005: state <= EXEC_MULT;
                        16'h0006: state <= EXEC_DIV;
                        default:  state <= IDLE;
                    endcase
                end
            end
            
            EXEC_MULT: begin
                mult_en <= 1'b1;  
                if (mult_ready) begin
                    state <= IDLE;
                end else begin
                    state <= EXEC_MULT;  
                end
            end
            
            EXEC_DIV: begin
                div_en <= 1'b1;  
                if (div_ready) begin
                    state <= IDLE;
                end else begin
                    state <= EXEC_DIV;  
                end
            end

            EXEC_ADD: begin
                add_en <= 1'b1; 
                if (add_ready) begin
                    state <= IDLE;
                end else begin
                    state <= EXEC_ADD; 
                end
            end

            EXEC_RES: begin
                res_en <= 1'b1;
                if (res_ready) begin
                    state <= IDLE;
                end else begin
                    state <= EXEC_RES; 
                end
            end

            EXEC_LOAD: begin
                load_en <= 1'b1;
                state <= IDLE; 
            end

            SUMMATION: begin
                if (word_ready) begin
                    if (word == 16'hffff) begin
                        state <= IDLE;
                    end else begin
                        op1 <= word;
                        acc_sum_en <= 1'b1;
                    end
                end else begin
                    acc_sum_en <= 1'b0;
                end

                if (acc_sum_ready) begin
                    acc <= acc_sum_result;
                end
            end

            SUBTRACTION: begin
                if (word_ready) begin
                    if (word == 16'hffff) begin
                        state <= IDLE;
                    end else begin
                        op1 <= word;
                        acc_sub_en <= 1'b1; 
                    end
                end else begin
                    acc_sub_en <= 1'b0;
                end

                if (acc_sub_ready) begin
                    acc <= acc_sub_result;
                end
            end

            default: state <= IDLE;
        endcase
    end
end

endmodule

