`timescale 1ns/1ps

module tb_bfloat16_spi_top();

    // Señales del testbench
    reg         clk;
    reg         ss;
    reg         rst;
    reg         mosi;
    wire        miso;
    
    // Variables de control
    reg [15:0] test_data [0:15];
    integer    test_index;
    reg [4:0]  bit_count;
    reg        transmitting;
    
    // Instancia del DUT (Device Under Test)
    bfloat16_spi_top DUT (
        .clk  (clk),
        .ss   (ss),
        .rst  (rst),
        .mosi (mosi),
        .miso (miso)
    );
    
    // Generación de clock
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end
    
    // Inicialización
    initial begin
        // Datos de prueba

        // // Pruebas ACC
        // test_data [0] = 16'h0002; // LOAD_ACC para obtener resultado
        // test_data [1] = 16'h0001; // SET_ACC para cargar un valor
        // test_data [2] = 16'hbbbb;
        // test_data [3] = 16'h0002;
        // test_data [4] = 16'h0000; //Zero para limpiar ACC
        // test_data [5] = 16'h0002;
        


        // // Primera operación: Multiplicación 
        // test_data[0] = 16'h0005;
        // test_data[1] = 16'h4148;
        // test_data[2] = 16'h404d;
        // test_data[3] = 16'hFFFF; // Resultado (4220 bfloat 16)

        // // Segunda operación: División 
        // test_data[0] = 16'h0006;
        // test_data[1] = 16'h41cd;
        // test_data[2] = 16'h404d;
        // test_data[3] = 16'hFFFF; // Resultado (4100 bfloat16)

        // // Tercera operación: Suma 
        // test_data[0] = 16'h0003;
        // test_data[1] = 16'h4237;
        // test_data[2] = 16'h441c;
        // test_data[3] = 16'hFFFF; // Resultado (4427 bfloat16)

        // Cuarta operación: Resta c411
        test_data[0] = 16'h0004;
        test_data[1] = 16'h4237;
        test_data[2] = 16'h441c;
        test_data[3] = 16'hFFFF; // Resultado (c411 bfloat16)

        // //Pruebas SUM (Sumatoria)
        // test_data[0] = 16'h0007;
        // test_data[1] = 16'h3f80; // 1.0 decimal
        // test_data[2] = 16'h4000; // 2.0 decimal
        // test_data[3] = 16'h4040; // 3.0 decimal, 
        // test_data[4] = 16'h3f80; // 1.0 decimal, suma esperada 6.0 (40E0 bfloat16)
        // test_data[5] = 16'hffff; // Fin de datos
        // test_data[6] = 16'h0002; // LOAD_ACC para obtener resultado
        // test_data[7] = 16'hffff;

        // //Pruebas SUB (restatoria)
        // test_data[0] = 16'h0008; // Instrucción SUB
        // test_data[1] = 16'h3f80; // 1.0 decimal
        // test_data[2] = 16'h4000; // 2.0 decimal
        // test_data[3] = 16'h4040; // 3.0 decimal, resta esperada -6.0 (c0c0 bfloat16)
        // test_data[4] = 16'hffff; // Fin de datos
        // test_data[5] = 16'h0002; // LOAD_ACC para obtener resultado
        // test_data[6] = 16'hffff;


        // Inicializar señales
        ss = 1'b1;
        rst = 1'b1;
        mosi = 1'b0;
        test_index = 0;
        bit_count = 0;
        transmitting = 1'b0;
        
        // Secuencia de inicialización
        #100;
        rst = 1'b0;
        
        // Esperar a que el sistema se estabilice
        #50;
        
        // Iniciar secuencia de pruebas
        repeat(7) begin
            // Seleccionar dispositivo (bajar SS)
            ss = 1'b0;
            #20;
            
            // Transmitir palabra de 16 bits (LSB first)
            transmitting = 1'b1;
            for (bit_count = 0; bit_count < 16; bit_count = bit_count + 1) begin
                mosi = test_data[test_index][bit_count];
                #20;
            end
            
            transmitting = 1'b0;
            
            // Deseleccionar dispositivo (subir SS)
            ss = 1'b1;
            #40;
            
            test_index = test_index + 1;
        end
        
        // Fin de la simulación
        #200;
        $finish;
    end
    
    // Generar archivo VCD para visualización
    initial begin
        $dumpfile("test_bfloat16_spi_top.vcd");
        $dumpvars(0, tb_bfloat16_spi_top);
    end

endmodule

