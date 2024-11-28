module procesadorTestBench;

	// Parametro para el periodo de reloj
	localparam periodo = 2;

	// Registros del test bench
  	reg clk;
  	reg reset;
	reg wr;
  	reg [5:0] direccion;
	reg [11:0] datoEntrante;
	wire [11:0] datoSaliente;
	integer i;

	// Instanciar el procesador
    	procesadorVonNeumann DUT (
        	.clk(clk),
        	.reset(reset),
        	.wr(wr),
        	.direccion(direccion),
        	.datoEntrante(datoEntrante),
        	.datoSaliente(datoSaliente)
    	);

	// Generar la señal de reloj
	always #(periodo / 2) clk = ~clk; 

	// Iniciar las señales
	initial begin
		clk   = 0;
		reset = 1;
		wr    = 1; // Se escribiran instrucciones en la memoria
		
		#(periodo*6); // Esperar para que el reset sea efectivo
		reset=0;

		// Inicializar la memoria en 0
		for (i=0; i<64; i=i+1) begin
			direccion = i; datoEntrante = 0; #(periodo*2);
		end
		
		// Cargar datos e instrucciones en la memoria
		direccion = 20; datoEntrante = 5;  #(periodo*2); // Cargar el valor 5 en la direccion 20
		direccion = 21; datoEntrante = 15; #(periodo*2); // Cargar el valor 15 en la direccion 21
		direccion = 0;  datoEntrante = {4'b0001, 8'b00010100}; #(periodo*2); // Cargar la instruccion LOAD 20 en la direccion 0
		direccion = 1;  datoEntrante = {4'b0011, 8'b00010101}; #(periodo*2); // Cargar la instruccion ADD 21 en la direccion 1
		direccion = 2;  datoEntrante = {4'b0010, 8'b00010110}; #(periodo*2); // Cargar la instruccion STORE 22 en la direccion 2
		direccion = 23; datoEntrante = 8;  #(periodo*2); // Cargar el valor 8 en la direccion 23
		direccion = 3;  datoEntrante = {4'b0100, 8'b00010111}; #(periodo*2); // Cargar la instruccion SUB 23 en la direccion 3;
		direccion = 24; datoEntrante = 3;  #(periodo*2); // Cargar el valor 3 en la direccion 24
		direccion = 4;  datoEntrante = {4'b0101, 8'b00011000}; #(periodo*2); // Cargar la instruccion MUL 24 en la direccion 4;
		direccion = 25; datoEntrante = 6;  #(periodo*2); // Cargar el valor 6 en la direccion 25;
		direccion = 5;  datoEntrante = {4'b0110, 8'b00011001}; #(periodo*2); // Cargar la instruccion DIV 25 en la direccion 5;
		direccion = 30; datoEntrante = 1;  #(periodo*2); // Cargar el valor 1 en la direccion 30
		direccion = 31; datoEntrante = 0;  #(periodo*2); // Cargar el valor 1 en la direccion 31
		direccion = 6;  datoEntrante = {4'b0001, 8'b00011110}; #(periodo*2); // Cargar la instruccion LOAD 30 en la direccion 6
		direccion = 7;  datoEntrante = {4'b0111, 8'b00011111}; #(periodo*2); // Cargar la instruccion AND 31 en la direccion 7
		direccion = 8;  datoEntrante = {4'b1000, 8'b00011110}; #(periodo*2); // Cargar la instruccion OR 30 en la direccion 8
		direccion = 9;  datoEntrante = {4'b1001, 8'b00011110}; #(periodo*2); // Cargar la instruccion XOR 30 en la direccion 9
		direccion = 40; datoEntrante = 15; #(periodo*2); // Cargar el valor 15 en la direccion 40;
		direccion = 10; datoEntrante = {4'b1010, 8'b00101000}; #(periodo*2); // Cargar la instruccion NOT 40 en la direccion 10;
		direccion = 33; datoEntrante = 14; #(periodo*2); // Cargar el valor 14 en la direccion 33
		direccion = 11; datoEntrante = {4'b1011, 8'b00100001}; #(periodo*2); // Cargar la instruccion JMP 33 en la direccion 12
		direccion = 14; datoEntrante = {4'b1100, 8'b00010100}; #(periodo*2); // Cargar la instruccion INC 20 en la direccion 14
		direccion = 15; datoEntrante = {4'b1101, 8'b00010100}; #(periodo*2); // Cargar la instruccion DEC 20 en la direccion 15
		direccion = 16; datoEntrante = {4'b1110, 8'b00010101}; #(periodo*2); // Cargar la instruccion SHL 21 en la direccion 16
		direccion = 17; datoEntrante = {4'b1111, 8'b00010101}; #(periodo*2); // Cargar la instruccion SHR 21 en la direccion 17
 		wr = 0; #(periodo*2); // Empezar la ejecucion

		#(periodo*100); // Esperar el tiempo suficiente para que se ejecuten las instrucciones
		$stop;
	end

	// Mantener un trackeo del estado del acumulador
	always @(datoSaliente) begin
		$display("acumulador = %d, %0t", datoSaliente, $time); 
	end

endmodule