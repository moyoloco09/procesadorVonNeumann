module procesadorVonNeumann(
	input wire clk,			  // Señal de reloj 
	input wire reset,		  // Señal de reset	
	input wire wr,			  // Señal de lecutra/escritura
	input wire [5:0] direccion,	  // Direccion de memoria sobre la cual operar
	input wire [11:0] datoEntrante,   // Dato con el cual operar
	output wire [11:0] datoSaliente   // Dato con el resultado de la operacion
);

// Set de instruccioness
parameter NOP   = 4'b0000; // No operacion
parameter LOAD  = 4'b0001; // Cargar dato en el acumulador
parameter STORE = 4'b0010; // Guardar dato en la memoria
parameter ADD   = 4'b0011; // Suma
parameter SUB   = 4'b0100; // Resta
parameter MUL   = 4'b0101; // Mltiplicacion
parameter DIV   = 4'b0110; // Division
parameter AND   = 4'b0111; // AND logico
parameter OR    = 4'b1000; // OR logico
parameter XOR   = 4'b1001; // XOR logico
parameter NOT   = 4'b1010; // NOT logico
parameter JMP   = 4'b1011; // Saltar a la siguiente instruccion
parameter INC   = 4'b1100; // Incrementar el valor en 1
parameter DEC   = 4'b1101; // Decrementar el valor en 1
parameter SHL	= 4'b1110; // Desplazar el valor una posicion a la izquierda 
parameter SHR   = 4'b1111; // Desplazar el valor una posicion a la derecha

// Parametros
parameter LARGO_DIRECCION = 6;
parameter LARGO_DATO      = 12;
parameter LARGO_CODIGOOP  = 4;

// Registros
reg [LARGO_DATO-1:0] acumulador;
reg [LARGO_CODIGOOP-1:0] registroInstruccion;
reg [LARGO_DATO-1:0] memoria [0:63];
reg [LARGO_DIRECCION-1:0] contador;
reg [LARGO_DATO-1:0] direccionOperando;

// Asignacion del dato saliente
assign datoSaliente = acumulador;

// Implementacion del comportamiento del procesador
always @(posedge clk or posedge reset) begin
	if (reset) begin

		// Reestablecer valores
		acumulador          <= 0;
		registroInstruccion <= NOP;
		contador 	    <= 0;

	end else begin

		if (wr) begin

			// Cargar el dato entrante en la direccion de memoria especificada.
			memoria[direccion] <= datoEntrante;

		end else begin
			
			// Leer el codigo de operacion desde la memoria
			registroInstruccion <= memoria[contador][LARGO_DATO-1:LARGO_DATO-LARGO_CODIGOOP];

			// Leer la direccion del operando
			direccionOperando   <= memoria[contador][LARGO_DATO-LARGO_CODIGOOP-1:0];
			
			// Seleccionar la operacion a realizar
			case (registroInstruccion)
				NOP:   acumulador = acumulador;
				LOAD:  acumulador = memoria[direccionOperando];
				STORE: memoria[direccionOperando] = acumulador;
				ADD:   acumulador = acumulador + memoria[direccionOperando];
				SUB:   acumulador = acumulador - memoria[direccionOperando];
				MUL:   acumulador = acumulador * memoria[direccionOperando];
				DIV:   acumulador = acumulador / memoria[direccionOperando];
				AND:   acumulador = acumulador & memoria[direccionOperando];
				OR:    acumulador = acumulador | memoria[direccionOperando];
				XOR:   acumulador = acumulador ^ memoria[direccionOperando];
				NOT:   acumulador = ~memoria[direccionOperando][7:0];
				JMP:   contador   = memoria[direccionOperando] - 1;
				INC:   acumulador = memoria[direccionOperando] + 1;
				DEC:   acumulador = memoria[direccionOperando] - 1;
				SHL:   acumulador = memoria[direccionOperando] << 1;
				SHR:   acumulador = memoria[direccionOperando] >> 1;
			endcase
			
			// Incrementar el contador
			contador <= contador + 1;
		end
	end
end

endmodule