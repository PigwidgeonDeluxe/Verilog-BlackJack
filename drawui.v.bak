module drawui (LSCORE_1, // input character values
		LSCORE_2,
		LSCORE_3,
		RSCORE_1,
		RSCORE_2,
		RSCORE_3,
		LCARD_1,
		LCARD_2,
		RCARD_1,
		RCARD_2,
		LTOTAL_1,
		LTOTAL_2,
		RTOTAL_1,
		RTOTAL_2, 
		CLOCK_50,//	On Board 50 MHz
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B,   						//	VGA Blue[9:0]
		
		);
	input 	[4:0] LSCORE_1; // 5bit character value, reference table below
	input 	[4:0] LSCORE_2;
	input 	[4:0] LSCORE_3;
	input 	[4:0] RSCORE_1;
	input 	[4:0] RSCORE_2;
	input 	[4:0] RSCORE_3;
	input 	[4:0] LCARD_1;
	input 	[4:0] LCARD_2;
	input 	[4:0] RCARD_1;
	input 	[4:0] RCARD_2;
	input 	[4:0] LTOTAL_1;
	input 	[4:0] LTOTAL_2;
	input 	[4:0] RTOTAL_1;
	input 	[4:0] RTOTAL_2 ;

	input			CLOCK_50;				//	50 MHz

	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]

	// Create the colour, x, y wires that are inputs to the controller.
	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	
	// the vga module
	vga_adapter VGA(
			.resetn(1'b1),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(1'b1),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "staticbg.mono.mif";
	 
	 
	 
	/// declare all cases' local parameter names and values
	localparam DRAW_LSCORE_1 = 6'b000000, // left score digit 1 (from left)
		RESET_LSCORE_1 = 6'b000001,
		DRAW_LSCORE_2 = 6'b000010, // left score digit 2
		RESET_LSCORE_2 = 6'b000011, 
		DRAW_LSCORE_3 = 6'b000100, // left score digit3
		RESET_LSCORE_3 = 6'b000101, 
		DRAW_RSCORE_1 = 6'b000110, // right score digit 1
		RESET_RSCORE_1 = 6'b000111,
		DRAW_RSCORE_2 = 6'b001000, // right score digit 2
		RESET_RSCORE_2 = 6'b001001, 
		DRAW_RSCORE_3 = 6'b001010, // right score digit 3
		RESET_RSCORE_3 = 6'b001011, 
		DRAW_LCARD_1 = 6'b001100, // left card digit 1 (from left)
		RESET_LCARD_1 = 6'b001101, 
		DRAW_LCARD_2 = 6'b001110, // left card digit 2
		RESET_LCARD_2 = 6'b001111,
		DRAW_RCARD_1 = 6'b010000, // right card ''
		RESET_RCARD_1 = 6'b010001, 
		DRAW_RCARD_2 = 6'b010010, // right card ''
		RESET_RCARD_2 = 6'b010011, 
		DRAW_LTOTAL_1 = 6'b010100, // left total digit 1 (from left)
		RESET_LTOTAL_1 = 6'b010101, 
		DRAW_LTOTAL_2 = 6'b010110, // left total digit 2
		RESET_LTOTAL_2 = 6'b010111, 
		DRAW_RTOTAL_1 = 6'b011000, // right total ''
		RESET_RTOTAL_1 = 6'b011001, 
		DRAW_RTOTAL_2 = 6'b011010, // right total ''
		RESET_RTOTAL_2 = 6'b011011; 
	
	reg [7:0] char_x; // character's x coordinate (top left)
	reg [7:0] char_y; // character's y coordinate (top left)
	reg [2:0] char_colour; // character's colour
	reg [4:0] character;
	//wire [4:0] character; // character value
	
	drawcharacter drawstuff(.CLOCK_50(CLOCK_50), // instantiate main module for drawing characters 
		.x_coord(char_x), // input coordinate
		.y_coord(char_y), 
		.colour_in(char_colour),
		.character(character),
		.x_out(x), //output coordinate to VGA module
		.y_out(y),
		.colour_out(colour));
	
	reg [5:0] state = DRAW_LSCORE_1;
	// check for cases
	// this one big loop that continuously draws the GUI
	 always@(posedge CLOCK_50)
	 begin
		case (state)
		DRAW_LSCORE_1: begin
				char_x = 8'b00010110; //22
				char_y = 8'b00000111; //7
				char_colour = 3'b111;
				character = LSCORE_1;
				state = RESET_LSCORE_1;
			end
		RESET_LSCORE_1: begin
				char_x = 8'b00010110; 
				char_y = 8'b00000111;
				char_colour = 3'b000;
				character = 5'b01000;
				state = DRAW_LSCORE_2;
			end
		DRAW_LSCORE_2: begin
				char_x = 8'b00011101; //29
				char_y = 8'b00000111;
				char_colour = 3'b111;
				character = LSCORE_2;
				state = RESET_LSCORE_2;
			end
		RESET_LSCORE_2: begin
				char_x = 8'b00011101;
				char_y = 8'b00000111;
				char_colour = 3'b000;
				character = 5'b01000;
				state = DRAW_LSCORE_3;
			end
		DRAW_LSCORE_3: begin
				char_x = 8'b00100100; //36
				char_y = 8'b00000111;
				char_colour = 3'b111;
				character = LSCORE_3;
				state = RESET_LSCORE_3;
			end
		RESET_LSCORE_3: begin
				char_x = 8'b00100100;
				char_y = 8'b00000111;
				char_colour = 3'b000;
				character = 5'b01000;
				state = DRAW_RSCORE_1;
			end
		DRAW_RSCORE_1: begin
				char_x = 8'b10001100; //140
				char_y = 8'b00000111;
				char_colour = 3'b111;
				character = RSCORE_1;
				state = RESET_RSCORE_1;
			end
		RESET_RSCORE_1: begin
				char_x = 8'b10001100;
				char_y = 8'b00000111;
				char_colour = 3'b000;
				character = 5'b01000;
				state = DRAW_RSCORE_2;
			end
		DRAW_RSCORE_2: begin
				char_x = 8'b10010011; //147
				char_y = 8'b00000111;
				char_colour = 3'b111;
				character = RSCORE_2;
				state = RESET_RSCORE_2;
			end
		RESET_RSCORE_2: begin
				char_x = 8'b10010011;
				char_y = 8'b00000111;
				char_colour = 3'b000;
				character = 5'b01000;
				state = DRAW_RSCORE_3;
			end
		DRAW_RSCORE_3: begin
				char_x = 8'b10011010; // 154
				char_y = 8'b00000111;
				char_colour = 3'b111;
				character = RSCORE_3;
				state = RESET_RSCORE_3;
			end
		RESET_RSCORE_3: begin
				char_x = 8'b10011010;
				char_y = 8'b00000111;
				char_colour = 3'b000;
				character = 5'b01000;
				state = DRAW_LCARD_1;
			end
		DRAW_LCARD_1: begin
				char_x = 8'b00010001; // 17
				char_y = 8'b00110100; // 52
				char_colour = 3'b111;
				character = LCARD_1;
				state = RESET_LCARD_1;
			end
		RESET_LCARD_1: begin
				char_x = 8'b00010001;
				char_y = 8'b00110100;
				char_colour = 3'b000;
				character = 5'b01000;
				state = DRAW_LCARD_2;
			end
		DRAW_LCARD_2: begin
				char_x = 8'b00011000; // 24
				char_y = 8'b00110100;
				char_colour = 3'b111;
				character = LCARD_2;
				state = RESET_LCARD_2;
			end
		RESET_LCARD_2: begin
				char_x = 8'b00011000;
				char_y = 8'b00110100;
				char_colour = 3'b000;
				character = 5'b01000;
				state = DRAW_RCARD_1;
			end
		DRAW_RCARD_1: begin
				char_x = 8'b10000011; // 131
				char_y = 8'b00110100;
				char_colour = 3'b111;
				character = RCARD_1;
				state = RESET_RCARD_1;
			end
		RESET_RCARD_1: begin
				char_x = 8'b10000011;
				char_y = 8'b00110100;
				char_colour = 3'b000;
				character = 5'b01000;
				state = DRAW_RCARD_2;
			end
		DRAW_RCARD_2: begin
				char_x = 8'b10001011; // 139
				char_y = 8'b00110100;
				char_colour = 3'b111;
				character = RCARD_2;
				state = RESET_RCARD_2;
			end
		RESET_RCARD_2: begin
				char_x = 8'b10001011;
				char_y = 8'b00110100;
				char_colour = 3'b000;
				character = 5'b01000;
				state = DRAW_LTOTAL_1;
			end
		DRAW_LTOTAL_1: begin
				char_x = 8'b00010110; // 22
				char_y = 8'b01101001; // 105
				char_colour = 3'b111;
				character = LTOTAL_1;
				state = RESET_LTOTAL_1;
			end
		RESET_LTOTAL_1: begin
				char_x = 8'b00010110;
				char_y = 8'b01101001;
				char_colour = 3'b000;
				character = 5'b01000;
				state = DRAW_LTOTAL_2;
			end
		DRAW_LTOTAL_2: begin
				char_x = 8'b00011101; // 29
				char_y = 8'b01101001;
				char_colour = 3'b111;
				character = LTOTAL_2;
				state = RESET_LTOTAL_2;
			end
		RESET_LTOTAL_2: begin
				char_x = 8'b00011101;
				char_y = 8'b01101001;
				char_colour = 3'b000;
				character = 5'b01000;
				state = DRAW_RTOTAL_1;
			end
		DRAW_RTOTAL_1: begin
				char_x = 8'b10001011; // 139
				char_y = 8'b01101001;
				char_colour = 3'b111;
				character = RTOTAL_1;
				state = RESET_RTOTAL_1;
			end
		RESET_RTOTAL_1: begin
				char_x = 8'b10001011;
				char_y = 8'b01101001;
				char_colour = 3'b000;
				character = 5'b01000;
				state = DRAW_RTOTAL_2;
			end
		DRAW_RTOTAL_2: begin
				char_x = 8'b10010010; // 146
				char_y = 8'b01101001;
				char_colour = 3'b111;
				character = RTOTAL_2;
				state = RESET_RTOTAL_2;
			end
		RESET_RTOTAL_2: begin
				char_x = 8'b10010010;
				char_y = 8'b01101001;
				char_colour = 3'b000;
				character = 5'b01000;
				state = DRAW_LSCORE_1;
			end
		endcase
	 end


endmodule

// module that draws individual characters at given locations and colour
module drawcharacter(CLOCK_50, x_coord, y_coord, colour_in, character, x_out, y_out, colour_out);
	input CLOCK_50;
	input [7:0] x_coord; 
	input [7:0] y_coord;
	input [2:0] colour_in;
	input [4:0] character;
	output reg [7:0] x_out;
	output reg [6:0] y_out;
	output [2:0] colour_out;
	
	assign colour_out = colour_in;
	
	reg [5:0] counter;
	wire [4:0] state;
	assign state = character;	
	
	// characters and their respective state/case value: 0-16 for 0,1,2,3,4,5,6,7,8,9,J,Q,K,H,C,S,D
	localparam C0 = 5'b00000,
		C1 = 5'b00001,
		C2 = 5'b00010,
		C3 = 5'b00011,
		C4 = 5'b00100,
		C5 = 5'b00101,
		C6 = 5'b00110,
		C7 = 5'b00111,
		C8 = 5'b01000,
		C9 = 5'b01001,
		CJ = 5'b01010,
		CQ = 5'b01011,
		CK = 5'b01100,
		CH = 5'b01101,
		CC = 5'b01110,
		CS = 5'b01111,
		CD = 5'b10000;

	// create registers for the x and y coordinates for each character (1D array of pixel locations from left to right, top to bottom, single pixel at a time)
	reg [7:0] C0X [39:0];
	reg [7:0] C1X [15:0];
	reg [7:0] C2X [39:0];
	reg [7:0] C3X [39:0];
	reg [7:0] C4X [29:0];
	reg [7:0] C5X [39:0];
	reg [7:0] C6X [41:0];
	reg [7:0] C7X [25:0];
	reg [7:0] C8X [43:0];
	reg [7:0] C9X [33:0];
	reg [7:0] JX [23:0];
	reg [7:0] QX [37:0];
	reg [7:0] KX [31:0];
	reg [7:0] HX [35:0];
	reg [7:0] CX [31:0];
	reg [7:0] SX [37:0];
	reg [7:0] DX [37:0];

	reg [7:0] C0Y [39:0];
	reg [7:0] C1Y [15:0];
	reg [7:0] C2Y [39:0];
	reg [7:0] C3Y [39:0];
	reg [7:0] C4Y [29:0];
	reg [7:0] C5Y [39:0];
	reg [7:0] C6Y [41:0];
	reg [7:0] C7Y [25:0];
	reg [7:0] C8Y [43:0];
	reg [7:0] C9Y [33:0];
	reg [7:0] JY [23:0];
	reg [7:0] QY [37:0];
	reg [7:0] KY [31:0];
	reg [7:0] HY [35:0];
	reg [7:0] CY [31:0];
	reg [7:0] SY [37:0];
	reg [7:0] DY [37:0];

	always@(posedge CLOCK_50)
	begin

	// assign values for the X and Y registers for the characters
	//// character 0Blackjack
	C0X[0] = x_coord ;
	C0Y[0] = y_coord ;
	C0X[1] = x_coord + 7'b0000001;
	C0Y[1] = y_coord ;
	C0X[2] = x_coord + 7'b0000010;
	C0Y[2] = y_coord ;
	C0X[3] = x_coord + 7'b0000011;
	C0Y[3] = y_coord ;
	C0X[4] = x_coord + 7'b0000100;
	C0Y[4] = y_coord ;
	C0X[5] = x_coord + 7'b0000101;
	C0Y[5] = y_coord ;
	C0X[6] = x_coord ;
	C0Y[6] = y_coord + 7'b0000001;
	C0X[7] = x_coord + 7'b0000001;
	C0Y[7] = y_coord + 7'b0000001;
	C0X[8] = x_coord + 7'b0000010;
	C0Y[8] = y_coord + 7'b0000001;
	C0X[9] = x_coord + 7'b0000011;
	C0Y[9] = y_coord + 7'b0000001;
	C0X[10] = x_coord + 7'b0000100;
	C0Y[10] = y_coord + 7'b0000001;
	C0X[11] = x_coord + 7'b0000101;
	C0Y[11] = y_coord + 7'b0000001;
	C0X[12] = x_coord ;
	C0Y[12] = y_coord + 7'b0000010;
	C0X[13] = x_coord + 7'b0000001;
	C0Y[13] = y_coord + 7'b0000010;
	C0X[14] = x_coord + 7'b0000100;
	C0Y[14] = y_coord + 7'b0000010;
	C0X[15] = x_coord + 7'b0000101;
	C0Y[15] = y_coord + 7'b0000010;
	C0X[16] = x_coord ;
	C0Y[16] = y_coord + 7'b0000011;
	C0X[17] = x_coord + 7'b0000001;
	C0Y[17] = y_coord + 7'b0000011;
	C0X[18] = x_coord + 7'b0000100;
	C0Y[18] = y_coord + 7'b0000011;
	C0X[19] = x_coord + 7'b0000101;
	C0Y[19] = y_coord + 7'b0000011;
	C0X[20] = x_coord ;
	C0Y[20] = y_coord + 7'b0000100;
	C0X[21] = x_coord + 7'b0000001;
	C0Y[21] = y_coord + 7'b0000100;
	C0X[22] = x_coord + 7'b0000100;
	C0Y[22] = y_coord + 7'b0000100;
	C0X[23] = x_coord + 7'b0000101;
	C0Y[23] = y_coord + 7'b0000100;
	C0X[24] = x_coord ;
	C0Y[24] = y_coord + 7'b0000101;
	C0X[25] = x_coord + 7'b0000001;
	C0Y[25] = y_coord + 7'b0000101;
	C0X[26] = x_coord + 7'b0000100;
	C0Y[26] = y_coord + 7'b0000101;
	C0X[27] = x_coord + 7'b0000101;
	C0Y[27] = y_coord + 7'b0000101;
	C0X[28] = x_coord ;
	C0Y[28] = y_coord + 7'b0000110;
	C0X[29] = x_coord + 7'b0000001;
	C0Y[29] = y_coord + 7'b0000110;
	C0X[30] = x_coord + 7'b0000010;
	C0Y[30] = y_coord + 7'b0000110;
	C0X[31] = x_coord + 7'b0000011;
	C0Y[31] = y_coord + 7'b0000110;
	C0X[32] = x_coord + 7'b0000100;
	C0Y[32] = y_coord + 7'b0000110;
	C0X[33] = x_coord + 7'b0000101;
	C0Y[33] = y_coord + 7'b0000110;
	C0X[34] = x_coord ;
	C0Y[34] = y_coord + 7'b0000111;
	C0X[35] = x_coord + 7'b0000001;
	C0Y[35] = y_coord + 7'b0000111;
	C0X[36] = x_coord + 7'b0000010;
	C0Y[36] = y_coord + 7'b0000111;
	C0X[37] = x_coord + 7'b0000011;
	C0Y[37] = y_coord + 7'b0000111;
	C0X[38] = x_coord + 7'b0000100;
	C0Y[38] = y_coord + 7'b0000111;
	C0X[39] = x_coord + 7'b0000101;
	C0Y[39] = y_coord + 7'b0000111;

	//// character 1
	C1X[0] = x_coord ;
	C1Y[0] = y_coord ;
	C1X[1] = x_coord + 7'b0000001;
	C1Y[1] = y_coord ;
	C1X[2] = x_coord ;
	C1Y[2] = y_coord + 7'b0000001;
	C1X[3] = x_coord + 7'b0000001;
	C1Y[3] = y_coord + 7'b0000001;
	C1X[4] = x_coord ;
	C1Y[4] = y_coord + 7'b0000010;
	C1X[5] = x_coord + 7'b0000001;
	C1Y[5] = y_coord + 7'b0000010;
	C1X[6] = x_coord ;
	C1Y[6] = y_coord + 7'b0000011;
	C1X[7] = x_coord + 7'b0000001;
	C1Y[7] = y_coord + 7'b0000011;
	C1X[8] = x_coord ;
	C1Y[8] = y_coord + 7'b0000100;
	C1X[9] = x_coord + 7'b0000001;
	C1Y[9] = y_coord + 7'b0000100;
	C1X[10] = x_coord ;
	C1Y[10] = y_coord + 7'b0000101;
	C1X[11] = x_coord + 7'b0000001;
	C1Y[11] = y_coord + 7'b0000101;
	C1X[12] = x_coord ;
	C1Y[12] = y_coord + 7'b0000110;
	C1X[13] = x_coord + 7'b0000001;
	C1Y[13] = y_coord + 7'b0000110;
	C1X[14] = x_coord ;
	C1Y[14] = y_coord + 7'b0000111;
	C1X[15] = x_coord + 7'b0000001;
	C1Y[15] = y_coord + 7'b0000111;

	//// character 2
	C2X[0] = x_coord ;
	C2Y[0] = y_coord ;
	C2X[1] = x_coord + 7'b0000001;
	C2Y[1] = y_coord ;
	C2X[2] = x_coord + 7'b0000010;
	C2Y[2] = y_coord ;
	C2X[3] = x_coord + 7'b0000011;
	C2Y[3] = y_coord ;
	C2X[4] = x_coord + 7'b0000100;
	C2Y[4] = y_coord ;
	C2X[5] = x_coord + 7'b0000101;
	C2Y[5] = y_coord ;
	C2X[6] = x_coord ;
	C2Y[6] = y_coord + 7'b0000001;
	C2X[7] = x_coord + 7'b0000001;
	C2Y[7] = y_coord + 7'b0000001;
	C2X[8] = x_coord + 7'b0000010;
	C2Y[8] = y_coord + 7'b0000001;
	C2X[9] = x_coord + 7'b0000011;
	C2Y[9] = y_coord + 7'b0000001;
	C2X[10] = x_coord + 7'b0000100;
	C2Y[10] = y_coord + 7'b0000001;
	C2X[11] = x_coord + 7'b0000101;
	C2Y[11] = y_coord + 7'b0000001;
	C2X[12] = x_coord + 7'b0000100;
	C2Y[12] = y_coord + 7'b0000010;
	C2X[13] = x_coord + 7'b0000101;
	C2Y[13] = y_coord + 7'b0000010;
	C2X[14] = x_coord ;
	C2Y[14] = y_coord + 7'b0000011;
	C2X[15] = x_coord + 7'b0000001;
	C2Y[15] = y_coord + 7'b0000011;
	C2X[16] = x_coord + 7'b0000010;
	C2Y[16] = y_coord + 7'b0000011;
	C2X[17] = x_coord + 7'b0000011;
	C2Y[17] = y_coord + 7'b0000011;
	C2X[18] = x_coord + 7'b0000100;
	C2Y[18] = y_coord + 7'b0000011;
	C2X[19] = x_coord + 7'b0000101;
	C2Y[19] = y_coord + 7'b0000011;
	C2X[20] = x_coord ;
	C2Y[20] = y_coord + 7'b0000100;
	C2X[21] = x_coord + 7'b0000001;
	C2Y[21] = y_coord + 7'b0000100;
	C2X[22] = x_coord + 7'b0000010;
	C2Y[22] = y_coord + 7'b0000100;
	C2X[23] = x_coord + 7'b0000011;
	C2Y[23] = y_coord + 7'b0000100;
	C2X[24] = x_coord + 7'b0000100;
	C2Y[24] = y_coord + 7'b0000100;
	C2X[25] = x_coord + 7'b0000101;
	C2Y[25] = y_coord + 7'b0000100;
	C2X[26] = x_coord ;
	C2Y[26] = y_coord + 7'b0000101;
	C2X[27] = x_coord + 7'b0000001;
	C2Y[27] = y_coord + 7'b0000101;
	C2X[28] = x_coord ;
	C2Y[28] = y_coord + 7'b0000110;
	C2X[29] = x_coord + 7'b0000001;
	C2Y[29] = y_coord + 7'b0000110;
	C2X[30] = x_coord + 7'b0000010;
	C2Y[30] = y_coord + 7'b0000110;
	C2X[31] = x_coord + 7'b0000011;
	C2Y[31] = y_coord + 7'b0000110;
	C2X[32] = x_coord + 7'b0000100;
	C2Y[32] = y_coord + 7'b0000110;
	C2X[33] = x_coord + 7'b0000101;
	C2Y[33] = y_coord + 7'b0000110;
	C2X[34] = x_coord ;
	C2Y[34] = y_coord + 7'b0000111;
	C2X[35] = x_coord + 7'b0000001;
	C2Y[35] = y_coord + 7'b0000111;
	C2X[36] = x_coord + 7'b0000010;
	C2Y[36] = y_coord + 7'b0000111;
	C2X[37] = x_coord + 7'b0000011;
	C2Y[37] = y_coord + 7'b0000111;
	C2X[38] = x_coord + 7'b0000100;
	C2Y[38] = y_coord + 7'b0000111;
	C2X[39] = x_coord + 7'b0000101;
	C2Y[39] = y_coord + 7'b0000111;

	//// character 3
	C3X[0] = x_coord ;
	C3Y[0] = y_coord ;
	C3X[1] = x_coord + 7'b0000001;
	C3Y[1] = y_coord ;
	C3X[2] = x_coord + 7'b0000010;
	C3Y[2] = y_coord ;
	C3X[3] = x_coord + 7'b0000011;
	C3Y[3] = y_coord ;
	C3X[4] = x_coord + 7'b0000100;
	C3Y[4] = y_coord ;
	C3X[5] = x_coord + 7'b0000101;
	C3Y[5] = y_coord ;
	C3X[6] = x_coord ;
	C3Y[6] = y_coord + 7'b0000001;
	C3X[7] = x_coord + 7'b0000001;
	C3Y[7] = y_coord + 7'b0000001;
	C3X[8] = x_coord + 7'b0000010;
	C3Y[8] = y_coord + 7'b0000001;
	C3X[9] = x_coord + 7'b0000011;
	C3Y[9] = y_coord + 7'b0000001;
	C3X[10] = x_coord + 7'b0000100;
	C3Y[10] = y_coord + 7'b0000001;
	C3X[11] = x_coord + 7'b0000101;
	C3Y[11] = y_coord + 7'b0000001;
	C3X[12] = x_coord + 7'b0000100;
	C3Y[12] = y_coord + 7'b0000010;
	C3X[13] = x_coord + 7'b0000101;
	C3Y[13] = y_coord + 7'b0000010;
	C3X[14] = x_coord ;
	C3Y[14] = y_coord + 7'b0000011;
	C3X[15] = x_coord + 7'b0000001;
	C3Y[15] = y_coord + 7'b0000011;
	C3X[16] = x_coord + 7'b0000010;
	C3Y[16] = y_coord + 7'b0000011;
	C3X[17] = x_coord + 7'b0000011;
	C3Y[17] = y_coord + 7'b0000011;
	C3X[18] = x_coord + 7'b0000100;
	C3Y[18] = y_coord + 7'b0000011;
	C3X[19] = x_coord + 7'b0000101;
	C3Y[19] = y_coord + 7'b0000011;
	C3X[20] = x_coord ;
	C3Y[20] = y_coord + 7'b0000100;
	C3X[21] = x_coord + 7'b0000001;
	C3Y[21] = y_coord + 7'b0000100;
	C3X[22] = x_coord + 7'b0000010;
	C3Y[22] = y_coord + 7'b0000100;
	C3X[23] = x_coord + 7'b0000011;
	C3Y[23] = y_coord + 7'b0000100;
	C3X[24] = x_coord + 7'b0000100;
	C3Y[24] = y_coord + 7'b0000100;
	C3X[25] = x_coord + 7'b0000101;
	C3Y[25] = y_coord + 7'b0000100;
	C3X[26] = x_coord + 7'b0000100;
	C3Y[26] = y_coord + 7'b0000101;
	C3X[27] = x_coord + 7'b0000101;
	C3Y[27] = y_coord + 7'b0000101;
	C3X[28] = x_coord ;
	C3Y[28] = y_coord + 7'b0000110;
	C3X[29] = x_coord + 7'b0000001;
	C3Y[29] = y_coord + 7'b0000110;
	C3X[30] = x_coord + 7'b0000010;
	C3Y[30] = y_coord + 7'b0000110;
	C3X[31] = x_coord + 7'b0000011;
	C3Y[31] = y_coord + 7'b0000110;
	C3X[32] = x_coord + 7'b0000100;
	C3Y[32] = y_coord + 7'b0000110;
	C3X[33] = x_coord + 7'b0000101;
	C3Y[33] = y_coord + 7'b0000110;
	C3X[34] = x_coord ;
	C3Y[34] = y_coord + 7'b0000111;
	C3X[35] = x_coord + 7'b0000001;
	C3Y[35] = y_coord + 7'b0000111;
	C3X[36] = x_coord + 7'b0000010;
	C3Y[36] = y_coord + 7'b0000111;
	C3X[37] = x_coord + 7'b0000011;
	C3Y[37] = y_coord + 7'b0000111;
	C3X[38] = x_coord + 7'b0000100;
	C3Y[38] = y_coord + 7'b0000111;
	C3X[39] = x_coord + 7'b0000101;
	C3Y[39] = y_coord + 7'b0000111;

	//// character 4
	C4X[0] = x_coord ;
	C4Y[0] = y_coord ;
	C4X[1] = x_coord + 7'b0000001;
	C4Y[1] = y_coord ;
	C4X[2] = x_coord + 7'b0000100;
	C4Y[2] = y_coord ;
	C4X[3] = x_coord + 7'b0000101;
	C4Y[3] = y_coord ;
	C4X[4] = x_coord ;
	C4Y[4] = y_coord + 7'b0000001;
	C4X[5] = x_coord + 7'b0000001;
	C4Y[5] = y_coord + 7'b0000001;
	C4X[6] = x_coord + 7'b0000100;
	C4Y[6] = y_coord + 7'b0000001;
	C4X[7] = x_coord + 7'b0000101;
	C4Y[7] = y_coord + 7'b0000001;
	C4X[8] = x_coord ;
	C4Y[8] = y_coord + 7'b0000010;
	C4X[9] = x_coord + 7'b0000001;
	C4Y[9] = y_coord + 7'b0000010;
	C4X[10] = x_coord + 7'b0000100;
	C4Y[10] = y_coord + 7'b0000010;
	C4X[11] = x_coord + 7'b0000101;
	C4Y[11] = y_coord + 7'b0000010;
	C4X[12] = x_coord ;
	C4Y[12] = y_coord + 7'b0000011;
	C4X[13] = x_coord + 7'b0000001;
	C4Y[13] = y_coord + 7'b0000011;
	C4X[14] = x_coord + 7'b0000010;
	C4Y[14] = y_coord + 7'b0000011;
	C4X[15] = x_coord + 7'b0000011;
	C4Y[15] = y_coord + 7'b0000011;
	C4X[16] = x_coord + 7'b0000100;
	C4Y[16] = y_coord + 7'b0000011;
	C4X[17] = x_coord + 7'b0000101;
	C4Y[17] = y_coord + 7'b0000011;
	C4X[18] = x_coord ;
	C4Y[18] = y_coord + 7'b0000100;
	C4X[19] = x_coord + 7'b0000001;
	C4Y[19] = y_coord + 7'b0000100;
	C4X[20] = x_coord + 7'b0000010;
	C4Y[20] = y_coord + 7'b0000100;
	C4X[21] = x_coord + 7'b0000011;
	C4Y[21] = y_coord + 7'b0000100;
	C4X[22] = x_coord + 7'b0000100;
	C4Y[22] = y_coord + 7'b0000100;
	C4X[23] = x_coord + 7'b0000101;
	C4Y[23] = y_coord + 7'b0000100;
	C4X[24] = x_coord + 7'b0000100;
	C4Y[24] = y_coord + 7'b0000101;
	C4X[25] = x_coord + 7'b0000101;
	C4Y[25] = y_coord + 7'b0000101;
	C4X[26] = x_coord + 7'b0000100;
	C4Y[26] = y_coord + 7'b0000110;
	C4X[27] = x_coord + 7'b0000101;
	C4Y[27] = y_coord + 7'b0000110;
	C4X[28] = x_coord + 7'b0000100;
	C4Y[28] = y_coord + 7'b0000111;
	C4X[29] = x_coord + 7'b0000101;
	C4Y[29] = y_coord + 7'b0000111;

	//// character 5
	C5X[0] = x_coord ;
	C5Y[0] = y_coord ;
	C5X[1] = x_coord + 7'b0000001;
	C5Y[1] = y_coord ;
	C5X[2] = x_coord + 7'b0000010;
	C5Y[2] = y_coord ;
	C5X[3] = x_coord + 7'b0000011;
	C5Y[3] = y_coord ;
	C5X[4] = x_coord + 7'b0000100;
	C5Y[4] = y_coord ;
	C5X[5] = x_coord + 7'b0000101;
	C5Y[5] = y_coord ;
	C5X[6] = x_coord ;
	C5Y[6] = y_coord + 7'b0000001;
	C5X[7] = x_coord + 7'b0000001;
	C5Y[7] = y_coord + 7'b0000001;
	C5X[8] = x_coord + 7'b0000010;
	C5Y[8] = y_coord + 7'b0000001;
	C5X[9] = x_coord + 7'b0000011;
	C5Y[9] = y_coord + 7'b0000001;
	C5X[10] = x_coord + 7'b0000100;
	C5Y[10] = y_coord + 7'b0000001;
	C5X[11] = x_coord + 7'b0000101;
	C5Y[11] = y_coord + 7'b0000001;
	C5X[12] = x_coord ;
	C5Y[12] = y_coord + 7'b0000010;
	C5X[13] = x_coord + 7'b0000001;
	C5Y[13] = y_coord + 7'b0000010;
	C5X[14] = x_coord ;
	C5Y[14] = y_coord + 7'b0000011;
	C5X[15] = x_coord + 7'b0000001;
	C5Y[15] = y_coord + 7'b0000011;
	C5X[16] = x_coord + 7'b0000010;
	C5Y[16] = y_coord + 7'b0000011;
	C5X[17] = x_coord + 7'b0000011;
	C5Y[17] = y_coord + 7'b0000011;
	C5X[18] = x_coord + 7'b0000100;
	C5Y[18] = y_coord + 7'b0000011;
	C5X[19] = x_coord + 7'b0000101;
	C5Y[19] = y_coord + 7'b0000011;
	C5X[20] = x_coord ;
	C5Y[20] = y_coord + 7'b0000100;
	C5X[21] = x_coord + 7'b0000001;
	C5Y[21] = y_coord + 7'b0000100;
	C5X[22] = x_coord + 7'b0000010;
	C5Y[22] = y_coord + 7'b0000100;
	C5X[23] = x_coord + 7'b0000011;
	C5Y[23] = y_coord + 7'b0000100;
	C5X[24] = x_coord + 7'b0000100;
	C5Y[24] = y_coord + 7'b0000100;
	C5X[25] = x_coord + 7'b0000101;
	C5Y[25] = y_coord + 7'b0000100;
	C5X[26] = x_coord + 7'b0000100;
	C5Y[26] = y_coord + 7'b0000101;
	C5X[27] = x_coord + 7'b0000101;
	C5Y[27] = y_coord + 7'b0000101;
	C5X[28] = x_coord ;
	C5Y[28] = y_coord + 7'b0000110;
	C5X[29] = x_coord + 7'b0000001;
	C5Y[29] = y_coord + 7'b0000110;
	C5X[30] = x_coord + 7'b0000010;
	C5Y[30] = y_coord + 7'b0000110;
	C5X[31] = x_coord + 7'b0000011;
	C5Y[31] = y_coord + 7'b0000110;
	C5X[32] = x_coord + 7'b0000100;
	C5Y[32] = y_coord + 7'b0000110;
	C5X[33] = x_coord + 7'b0000101;
	C5Y[33] = y_coord + 7'b0000110;
	C5X[34] = x_coord ;
	C5Y[34] = y_coord + 7'b0000111;
	C5X[35] = x_coord + 7'b0000001;
	C5Y[35] = y_coord + 7'b0000111;
	C5X[36] = x_coord + 7'b0000010;
	C5Y[36] = y_coord + 7'b0000111;
	C5X[37] = x_coord + 7'b0000011;
	C5Y[37] = y_coord + 7'b0000111;
	C5X[38] = x_coord + 7'b0000100;
	C5Y[38] = y_coord + 7'b0000111;
	C5X[39] = x_coord + 7'b0000101;
	C5Y[39] = y_coord + 7'b0000111;

	//// character 6
	C6X[0] = x_coord ;
	C6Y[0] = y_coord ;
	C6X[1] = x_coord + 7'b0000001;
	C6Y[1] = y_coord ;
	C6X[2] = x_coord + 7'b0000010;
	C6Y[2] = y_coord ;
	C6X[3] = x_coord + 7'b0000011;
	C6Y[3] = y_coord ;
	C6X[4] = x_coord + 7'b0000100;
	C6Y[4] = y_coord ;
	C6X[5] = x_coord + 7'b0000101;
	C6Y[5] = y_coord ;
	C6X[6] = x_coord ;
	C6Y[6] = y_coord + 7'b0000001;
	C6X[7] = x_coord + 7'b0000001;
	C6Y[7] = y_coord + 7'b0000001;
	C6X[8] = x_coord + 7'b0000010;
	C6Y[8] = y_coord + 7'b0000001;
	C6X[9] = x_coord + 7'b0000011;
	C6Y[9] = y_coord + 7'b0000001;
	C6X[10] = x_coord + 7'b0000100;
	C6Y[10] = y_coord + 7'b0000001;
	C6X[11] = x_coord + 7'b0000101;
	C6Y[11] = y_coord + 7'b0000001;
	C6X[12] = x_coord ;
	C6Y[12] = y_coord + 7'b0000010;
	C6X[13] = x_coord + 7'b0000001;
	C6Y[13] = y_coord + 7'b0000010;
	C6X[14] = x_coord ;
	C6Y[14] = y_coord + 7'b0000011;
	C6X[15] = x_coord + 7'b0000001;
	C6Y[15] = y_coord + 7'b0000011;
	C6X[16] = x_coord + 7'b0000010;
	C6Y[16] = y_coord + 7'b0000011;
	C6X[17] = x_coord + 7'b0000011;
	C6Y[17] = y_coord + 7'b0000011;
	C6X[18] = x_coord + 7'b0000100;
	C6Y[18] = y_coord + 7'b0000011;
	C6X[19] = x_coord + 7'b0000101;
	C6Y[19] = y_coord + 7'b0000011;
	C6X[20] = x_coord ;
	C6Y[20] = y_coord + 7'b0000100;
	C6X[21] = x_coord + 7'b0000001;
	C6Y[21] = y_coord + 7'b0000100;
	C6X[22] = x_coord + 7'b0000010;
	C6Y[22] = y_coord + 7'b0000100;
	C6X[23] = x_coord + 7'b0000011;
	C6Y[23] = y_coord + 7'b0000100;
	C6X[24] = x_coord + 7'b0000100;
	C6Y[24] = y_coord + 7'b0000100;
	C6X[25] = x_coord + 7'b0000101;
	C6Y[25] = y_coord + 7'b0000100;
	C6X[26] = x_coord ;
	C6Y[26] = y_coord + 7'b0000101;
	C6X[27] = x_coord + 7'b0000001;
	C6Y[27] = y_coord + 7'b0000101;
	C6X[28] = x_coord + 7'b0000100;
	C6Y[28] = y_coord + 7'b0000101;
	C6X[29] = x_coord + 7'b0000101;
	C6Y[29] = y_coord + 7'b0000101;
	C6X[30] = x_coord ;
	C6Y[30] = y_coord + 7'b0000110;
	C6X[31] = x_coord + 7'b0000001;
	C6Y[31] = y_coord + 7'b0000110;
	C6X[32] = x_coord + 7'b0000010;
	C6Y[32] = y_coord + 7'b0000110;
	C6X[33] = x_coord + 7'b0000011;
	C6Y[33] = y_coord + 7'b0000110;
	C6X[34] = x_coord + 7'b0000100;
	C6Y[34] = y_coord + 7'b0000110;
	C6X[35] = x_coord + 7'b0000101;
	C6Y[35] = y_coord + 7'b0000110;
	C6X[36] = x_coord ;
	C6Y[36] = y_coord + 7'b0000111;
	C6X[37] = x_coord + 7'b0000001;
	C6Y[37] = y_coord + 7'b0000111;
	C6X[38] = x_coord + 7'b0000010;
	C6Y[38] = y_coord + 7'b0000111;
	C6X[39] = x_coord + 7'b0000011;
	C6Y[39] = y_coord + 7'b0000111;
	C6X[40] = x_coord + 7'b0000100;
	C6Y[40] = y_coord + 7'b0000111;
	C6X[41] = x_coord + 7'b0000101;
	C6Y[41] = y_coord + 7'b0000111;

	//// character 7
	C7X[0] = x_coord ;
	C7Y[0] = y_coord ;
	C7X[1] = x_coord + 7'b0000001;
	C7Y[1] = y_coord ;
	C7X[2] = x_coord + 7'b0000010;
	C7Y[2] = y_coord ;
	C7X[3] = x_coord + 7'b0000011;
	C7Y[3] = y_coord ;
	C7X[4] = x_coord + 7'b0000100;
	C7Y[4] = y_coord ;
	C7X[5] = x_coord + 7'b0000101;
	C7Y[5] = y_coord ;
	C7X[6] = x_coord ;
	C7Y[6] = y_coord + 7'b0000001;
	C7X[7] = x_coord + 7'b0000001;
	C7Y[7] = y_coord + 7'b0000001;
	C7X[8] = x_coord + 7'b0000010;
	C7Y[8] = y_coord + 7'b0000001;
	C7X[9] = x_coord + 7'b0000011;
	C7Y[9] = y_coord + 7'b0000001;
	C7X[10] = x_coord + 7'b0000100;
	C7Y[10] = y_coord + 7'b0000001;
	C7X[11] = x_coord + 7'b0000101;
	C7Y[11] = y_coord + 7'b0000001;
	C7X[12] = x_coord ;
	C7Y[12] = y_coord + 7'b0000010;
	C7X[13] = x_coord + 7'b0000001;
	C7Y[13] = y_coord + 7'b0000010;
	C7X[14] = x_coord + 7'b0000100;
	C7Y[14] = y_coord + 7'b0000010;
	C7X[15] = x_coord + 7'b0000101;
	C7Y[15] = y_coord + 7'b0000010;
	C7X[16] = x_coord + 7'b0000100;
	C7Y[16] = y_coord + 7'b0000011;
	C7X[17] = x_coord + 7'b0000101;
	C7Y[17] = y_coord + 7'b0000011;
	C7X[18] = x_coord + 7'b0000100;
	C7Y[18] = y_coord + 7'b0000100;
	C7X[19] = x_coord + 7'b0000101;
	C7Y[19] = y_coord + 7'b0000100;
	C7X[20] = x_coord + 7'b0000100;
	C7Y[20] = y_coord + 7'b0000101;
	C7X[21] = x_coord + 7'b0000101;
	C7Y[21] = y_coord + 7'b0000101;
	C7X[22] = x_coord + 7'b0000100;
	C7Y[22] = y_coord + 7'b0000110;
	C7X[23] = x_coord + 7'b0000101;
	C7Y[23] = y_coord + 7'b0000110;
	C7X[24] = x_coord + 7'b0000100;
	C7Y[24] = y_coord + 7'b0000111;
	C7X[25] = x_coord + 7'b0000101;
	C7Y[25] = y_coord + 7'b0000111;

	//// character 8
	C8X[0] = x_coord ;
	C8Y[0] = y_coord ;
	C8X[1] = x_coord + 7'b0000001;
	C8Y[1] = y_coord ;
	C8X[2] = x_coord + 7'b0000010;
	C8Y[2] = y_coord ;
	C8X[3] = x_coord + 7'b0000011;
	C8Y[3] = y_coord ;
	C8X[4] = x_coord + 7'b0000100;
	C8Y[4] = y_coord ;
	C8X[5] = x_coord + 7'b0000101;
	C8Y[5] = y_coord ;
	C8X[6] = x_coord ;
	C8Y[6] = y_coord + 7'b0000001;
	C8X[7] = x_coord + 7'b0000001;
	C8Y[7] = y_coord + 7'b0000001;
	C8X[8] = x_coord + 7'b0000010;
	C8Y[8] = y_coord + 7'b0000001;
	C8X[9] = x_coord + 7'b0000011;
	C8Y[9] = y_coord + 7'b0000001;
	C8X[10] = x_coord + 7'b0000100;
	C8Y[10] = y_coord + 7'b0000001;
	C8X[11] = x_coord + 7'b0000101;
	C8Y[11] = y_coord + 7'b0000001;
	C8X[12] = x_coord ;
	C8Y[12] = y_coord + 7'b0000010;
	C8X[13] = x_coord + 7'b0000001;
	C8Y[13] = y_coord + 7'b0000010;
	C8X[14] = x_coord + 7'b0000100;
	C8Y[14] = y_coord + 7'b0000010;
	C8X[15] = x_coord + 7'b0000101;
	C8Y[15] = y_coord + 7'b0000010;
	C8X[16] = x_coord ;
	C8Y[16] = y_coord + 7'b0000011;
	C8X[17] = x_coord + 7'b0000001;
	C8Y[17] = y_coord + 7'b0000011;
	C8X[18] = x_coord + 7'b0000010;
	C8Y[18] = y_coord + 7'b0000011;
	C8X[19] = x_coord + 7'b0000011;
	C8Y[19] = y_coord + 7'b0000011;
	C8X[20] = x_coord + 7'b0000100;
	C8Y[20] = y_coord + 7'b0000011;
	C8X[21] = x_coord + 7'b0000101;
	C8Y[21] = y_coord + 7'b0000011;
	C8X[22] = x_coord ;
	C8Y[22] = y_coord + 7'b0000100;
	C8X[23] = x_coord + 7'b0000001;
	C8Y[23] = y_coord + 7'b0000100;
	C8X[24] = x_coord + 7'b0000010;
	C8Y[24] = y_coord + 7'b0000100;
	C8X[25] = x_coord + 7'b0000011;
	C8Y[25] = y_coord + 7'b0000100;
	C8X[26] = x_coord + 7'b0000100;
	C8Y[26] = y_coord + 7'b0000100;
	C8X[27] = x_coord + 7'b0000101;
	C8Y[27] = y_coord + 7'b0000100;
	C8X[28] = x_coord ;
	C8Y[28] = y_coord + 7'b0000101;
	C8X[29] = x_coord + 7'b0000001;
	C8Y[29] = y_coord + 7'b0000101;
	C8X[30] = x_coord + 7'b0000100;
	C8Y[30] = y_coord + 7'b0000101;
	C8X[31] = x_coord + 7'b0000101;
	C8Y[31] = y_coord + 7'b0000101;
	C8X[32] = x_coord ;
	C8Y[32] = y_coord + 7'b0000110;
	C8X[33] = x_coord + 7'b0000001;
	C8Y[33] = y_coord + 7'b0000110;
	C8X[34] = x_coord + 7'b0000010;
	C8Y[34] = y_coord + 7'b0000110;
	C8X[35] = x_coord + 7'b0000011;
	C8Y[35] = y_coord + 7'b0000110;
	C8X[36] = x_coord + 7'b0000100;
	C8Y[36] = y_coord + 7'b0000110;
	C8X[37] = x_coord + 7'b0000101;
	C8Y[37] = y_coord + 7'b0000110;
	C8X[38] = x_coord ;
	C8Y[38] = y_coord + 7'b0000111;
	C8X[39] = x_coord + 7'b0000001;
	C8Y[39] = y_coord + 7'b0000111;
	C8X[40] = x_coord + 7'b0000010;
	C8Y[40] = y_coord + 7'b0000111;
	C8X[41] = x_coord + 7'b0000011;
	C8Y[41] = y_coord + 7'b0000111;
	C8X[42] = x_coord + 7'b0000100;
	C8Y[42] = y_coord + 7'b0000111;
	C8X[43] = x_coord + 7'b0000101;
	C8Y[43] = y_coord + 7'b0000111;	

	//// character 9
	C9X[0] = x_coord ;
	C9Y[0] = y_coord ;
	C9X[1] = x_coord + 7'b0000001;
	C9Y[1] = y_coord ;
	C9X[2] = x_coord + 7'b0000010;
	C9Y[2] = y_coord ;
	C9X[3] = x_coord + 7'b0000011;
	C9Y[3] = y_coord ;
	C9X[4] = x_coord + 7'b0000100;
	C9Y[4] = y_coord ;
	C9X[5] = x_coord + 7'b0000101;
	C9Y[5] = y_coord ;
	C9X[6] = x_coord ;
	C9Y[6] = y_coord + 7'b0000001;
	C9X[7] = x_coord + 7'b0000001;
	C9Y[7] = y_coord + 7'b0000001;
	C9X[8] = x_coord + 7'b0000010;
	C9Y[8] = y_coord + 7'b0000001;
	C9X[9] = x_coord + 7'b0000011;
	C9Y[9] = y_coord + 7'b0000001;
	C9X[10] = x_coord + 7'b0000100;
	C9Y[10] = y_coord + 7'b0000001;
	C9X[11] = x_coord + 7'b0000101;
	C9Y[11] = y_coord + 7'b0000001;
	C9X[12] = x_coord ;
	C9Y[12] = y_coord + 7'b0000010;
	C9X[13] = x_coord + 7'b0000001;
	C9Y[13] = y_coord + 7'b0000010;
	C9X[14] = x_coord + 7'b0000100;
	C9Y[14] = y_coord + 7'b0000010;
	C9X[15] = x_coord + 7'b0000101;
	C9Y[15] = y_coord + 7'b0000010;
	C9X[16] = x_coord ;
	C9Y[16] = y_coord + 7'b0000011;
	C9X[17] = x_coord + 7'b0000001;
	C9Y[17] = y_coord + 7'b0000011;
	C9X[18] = x_coord + 7'b0000010;
	C9Y[18] = y_coord + 7'b0000011;
	C9X[19] = x_coord + 7'b0000011;
	C9Y[19] = y_coord + 7'b0000011;
	C9X[20] = x_coord + 7'b0000100;
	C9Y[20] = y_coord + 7'b0000011;
	C9X[21] = x_coord + 7'b0000101;
	C9Y[21] = y_coord + 7'b0000011;
	C9X[22] = x_coord ;
	C9Y[22] = y_coord + 7'b0000100;
	C9X[23] = x_coord + 7'b0000001;
	C9Y[23] = y_coord + 7'b0000100;
	C9X[24] = x_coord + 7'b0000010;
	C9Y[24] = y_coord + 7'b0000100;
	C9X[25] = x_coord + 7'b0000011;
	C9Y[25] = y_coord + 7'b0000100;
	C9X[26] = x_coord + 7'b0000100;
	C9Y[26] = y_coord + 7'b0000100;
	C9X[27] = x_coord + 7'b0000101;
	C9Y[27] = y_coord + 7'b0000100;
	C9X[28] = x_coord + 7'b0000100;
	C9Y[28] = y_coord + 7'b0000101;
	C9X[29] = x_coord + 7'b0000101;
	C9Y[29] = y_coord + 7'b0000101;
	C9X[30] = x_coord + 7'b0000100;
	C9Y[30] = y_coord + 7'b0000110;
	C9X[31] = x_coord + 7'b0000101;
	C9Y[31] = y_coord + 7'b0000110;
	C9X[32] = x_coord + 7'b0000100;
	C9Y[32] = y_coord + 7'b0000111;
	C9X[33] = x_coord + 7'b0000101;
	C9Y[33] = y_coord + 7'b0000111;

	//// character J
	JX[0] = x_coord + 7'b0000100;
	JY[0] = y_coord ;
	JX[1] = x_coord + 7'b0000101;
	JY[1] = y_coord ;
	JX[2] = x_coord + 7'b0000100;
	JY[2] = y_coord + 7'b0000001;
	JX[3] = x_coord + 7'b0000101;
	JY[3] = y_coord + 7'b0000001;
	JX[4] = x_coord + 7'b0000100;
	JY[4] = y_coord + 7'b0000010;
	JX[5] = x_coord + 7'b0000101;
	JY[5] = y_coord + 7'b0000010;
	JX[6] = x_coord + 7'b0000100;
	JY[6] = y_coord + 7'b0000011;
	JX[7] = x_coord + 7'b0000101;
	JY[7] = y_coord + 7'b0000011;
	JX[8] = x_coord + 7'b0000100;
	JY[8] = y_coord + 7'b0000100;
	JX[9] = x_coord + 7'b0000101;
	JY[9] = y_coord + 7'b0000100;
	JX[10] = x_coord + 7'b0000100;
	JY[10] = y_coord + 7'b0000101;
	JX[11] = x_coord + 7'b0000101;
	JY[11] = y_coord + 7'b0000101;
	JX[12] = x_coord ;
	JY[12] = y_coord + 7'b0000110;
	JX[13] = x_coord + 7'b0000001;
	JY[13] = y_coord + 7'b0000110;
	JX[14] = x_coord + 7'b0000010;
	JY[14] = y_coord + 7'b0000110;
	JX[15] = x_coord + 7'b0000011;
	JY[15] = y_coord + 7'b0000110;
	JX[16] = x_coord + 7'b0000100;
	JY[16] = y_coord + 7'b0000110;
	JX[17] = x_coord + 7'b0000101;
	JY[17] = y_coord + 7'b0000110;
	JX[18] = x_coord ;
	JY[18] = y_coord + 7'b0000111;
	JX[19] = x_coord + 7'b0000001;
	JY[19] = y_coord + 7'b0000111;
	JX[20] = x_coord + 7'b0000010;
	JY[20] = y_coord + 7'b0000111;
	JX[21] = x_coord + 7'b0000011;
	JY[21] = y_coord + 7'b0000111;
	JX[22] = x_coord + 7'b0000100;
	JY[22] = y_coord + 7'b0000111;
	JX[23] = x_coord + 7'b0000101;
	JY[23] = y_coord + 7'b0000111;

	//// character Q
	QX[0] = x_coord ;
	QY[0] = y_coord ;
	QX[1] = x_coord + 7'b0000001;
	QY[1] = y_coord ;
	QX[2] = x_coord + 7'b0000010;
	QY[2] = y_coord ;
	QX[3] = x_coord + 7'b0000011;
	QY[3] = y_coord ;
	QX[4] = x_coord + 7'b0000100;
	QY[4] = y_coord ;
	QX[5] = x_coord + 7'b0000101;
	QY[5] = y_coord ;
	QX[6] = x_coord ;
	QY[6] = y_coord + 7'b0000001;
	QX[7] = x_coord + 7'b0000001;
	QY[7] = y_coord + 7'b0000001;
	QX[8] = x_coord + 7'b0000010;
	QY[8] = y_coord + 7'b0000001;
	QX[9] = x_coord + 7'b0000011;
	QY[9] = y_coord + 7'b0000001;
	QX[10] = x_coord + 7'b0000100;
	QY[10] = y_coord + 7'b0000001;
	QX[11] = x_coord + 7'b0000101;
	QY[11] = y_coord + 7'b0000001;
	QX[12] = x_coord ;
	QY[12] = y_coord + 7'b0000010;
	QX[13] = x_coord + 7'b0000001;
	QY[13] = y_coord + 7'b0000010;
	QX[14] = x_coord + 7'b0000100;
	QY[14] = y_coord + 7'b0000010;
	QX[15] = x_coord + 7'b0000101;
	QY[15] = y_coord + 7'b0000010;
	QX[16] = x_coord ;
	QY[16] = y_coord + 7'b0000011;
	QX[17] = x_coord + 7'b0000001;
	QY[17] = y_coord + 7'b0000011;
	QX[18] = x_coord + 7'b0000100;
	QY[18] = y_coord + 7'b0000011;
	QX[19] = x_coord + 7'b0000101;
	QY[19] = y_coord + 7'b0000011;
	QX[20] = x_coord ;
	QY[20] = y_coord + 7'b0000100;
	QX[21] = x_coord + 7'b0000001;
	QY[21] = y_coord + 7'b0000100;
	QX[22] = x_coord + 7'b0000011;
	QY[22] = y_coord + 7'b0000100;
	QX[23] = x_coord + 7'b0000100;
	QY[23] = y_coord + 7'b0000100;
	QX[24] = x_coord + 7'b0000101;
	QY[24] = y_coord + 7'b0000100;
	QX[25] = x_coord ;
	QY[25] = y_coord + 7'b0000101;
	QX[26] = x_coord + 7'b0000001;
	QY[26] = y_coord + 7'b0000101;
	QX[27] = x_coord + 7'b0000010;
	QY[27] = y_coord + 7'b0000101;
	QX[28] = x_coord + 7'b0000011;
	QY[28] = y_coord + 7'b0000101;
	QX[29] = x_coord + 7'b0000100;
	QY[29] = y_coord + 7'b0000101;
	QX[30] = x_coord ;
	QY[30] = y_coord + 7'b0000110;
	QX[31] = x_coord + 7'b0000001;
	QY[31] = y_coord + 7'b0000110;
	QX[32] = x_coord + 7'b0000010;
	QY[32] = y_coord + 7'b0000110;
	QX[33] = x_coord + 7'b0000011;
	QY[33] = y_coord + 7'b0000110;
	QX[34] = x_coord + 7'b0000100;
	QY[34] = y_coord + 7'b0000110;
	QX[35] = x_coord + 7'b0000101;
	QY[35] = y_coord + 7'b0000110;
	QX[36] = x_coord + 7'b0000100;
	QY[36] = y_coord + 7'b0000111;
	QX[37] = x_coord + 7'b0000101;
	QY[37] = y_coord + 7'b0000111;

	//// charcter K
	KX[0] = x_coord ;
	KY[0] = y_coord ;
	KX[1] = x_coord + 7'b0000001;
	KY[1] = y_coord ;
	KX[2] = x_coord + 7'b0000100;
	KY[2] = y_coord ;
	KX[3] = x_coord + 7'b0000101;
	KY[3] = y_coord ;
	KX[4] = x_coord ;
	KY[4] = y_coord + 7'b0000001;
	KX[5] = x_coord + 7'b0000001;
	KY[5] = y_coord + 7'b0000001;
	KX[6] = x_coord + 7'b0000100;
	KY[6] = y_coord + 7'b0000001;
	KX[7] = x_coord + 7'b0000101;
	KY[7] = y_coord + 7'b0000001;
	KX[8] = x_coord ;
	KY[8] = y_coord + 7'b0000010;
	KX[9] = x_coord + 7'b0000001;
	KY[9] = y_coord + 7'b0000010;
	KX[10] = x_coord + 7'b0000100;
	KY[10] = y_coord + 7'b0000010;
	KX[11] = x_coord + 7'b0000101;
	KY[11] = y_coord + 7'b0000010;
	KX[12] = x_coord ;
	KY[12] = y_coord + 7'b0000011;
	KX[13] = x_coord + 7'b0000001;
	KY[13] = y_coord + 7'b0000011;
	KX[14] = x_coord + 7'b0000010;
	KY[14] = y_coord + 7'b0000011;
	KX[15] = x_coord + 7'b0000011;
	KY[15] = y_coord + 7'b0000011;
	KX[16] = x_coord ;
	KY[16] = y_coord + 7'b0000100;
	KX[17] = x_coord + 7'b0000001;
	KY[17] = y_coord + 7'b0000100;
	KX[18] = x_coord + 7'b0000010;
	KY[18] = y_coord + 7'b0000100;
	KX[19] = x_coord + 7'b0000011;
	KY[19] = y_coord + 7'b0000100;
	KX[20] = x_coord ;
	KY[20] = y_coord + 7'b0000101;
	KX[21] = x_coord + 7'b0000001;
	KY[21] = y_coord + 7'b0000101;
	KX[22] = x_coord + 7'b0000100;
	KY[22] = y_coord + 7'b0000101;
	KX[23] = x_coord + 7'b0000101;
	KY[23] = y_coord + 7'b0000101;
	KX[24] = x_coord ;
	KY[24] = y_coord + 7'b0000110;
	KX[25] = x_coord + 7'b0000001;
	KY[25] = y_coord + 7'b0000110;
	KX[26] = x_coord + 7'b0000100;
	KY[26] = y_coord + 7'b0000110;
	KX[27] = x_coord + 7'b0000101;
	KY[27] = y_coord + 7'b0000110;
	KX[28] = x_coord ;
	KY[28] = y_coord + 7'b0000111;
	KX[29] = x_coord + 7'b0000001;
	KY[29] = y_coord + 7'b0000111;
	KX[30] = x_coord + 7'b0000100;
	KY[30] = y_coord + 7'b0000111;
	KX[31] = x_coord + 7'b0000101;
	KY[31] = y_coord + 7'b0000111;

	//// character H
	HX[0] = x_coord ;
	HY[0] = y_coord ;
	HX[1] = x_coord + 7'b0000001;
	HY[1] = y_coord ;
	HX[2] = x_coord + 7'b0000100;
	HY[2] = y_coord ;
	HX[3] = x_coord + 7'b0000101;
	HY[3] = y_coord ;
	HX[4] = x_coord ;
	HY[4] = y_coord + 7'b0000001;
	HX[5] = x_coord + 7'b0000001;
	HY[5] = y_coord + 7'b0000001;
	HX[6] = x_coord + 7'b0000100;
	HY[6] = y_coord + 7'b0000001;
	HX[7] = x_coord + 7'b0000101;
	HY[7] = y_coord + 7'b0000001;
	HX[8] = x_coord ;
	HY[8] = y_coord + 7'b0000010;
	HX[9] = x_coord + 7'b0000001;
	HY[9] = y_coord + 7'b0000010;
	HX[10] = x_coord + 7'b0000100;
	HY[10] = y_coord + 7'b0000010;
	HX[11] = x_coord + 7'b0000101;
	HY[11] = y_coord + 7'b0000010;
	HX[12] = x_coord ;
	HY[12] = y_coord + 7'b0000011;
	HX[13] = x_coord + 7'b0000001;
	HY[13] = y_coord + 7'b0000011;
	HX[14] = x_coord + 7'b0000010;
	HY[14] = y_coord + 7'b0000011;
	HX[15] = x_coord + 7'b0000011;
	HY[15] = y_coord + 7'b0000011;
	HX[16] = x_coord + 7'b0000100;
	HY[16] = y_coord + 7'b0000011;
	HX[17] = x_coord + 7'b0000101;
	HY[17] = y_coord + 7'b0000011;
	HX[18] = x_coord ;
	HY[18] = y_coord + 7'b0000100;
	HX[19] = x_coord + 7'b0000001;
	HY[19] = y_coord + 7'b0000100;
	HX[20] = x_coord + 7'b0000010;
	HY[20] = y_coord + 7'b0000100;
	HX[21] = x_coord + 7'b0000011;
	HY[21] = y_coord + 7'b0000100;
	HX[22] = x_coord + 7'b0000100;
	HY[22] = y_coord + 7'b0000100;
	HX[23] = x_coord + 7'b0000101;
	HY[23] = y_coord + 7'b0000100;
	HX[24] = x_coord ;
	HY[24] = y_coord + 7'b0000101;
	HX[25] = x_coord + 7'b0000001;
	HY[25] = y_coord + 7'b0000101;
	HX[26] = x_coord + 7'b0000100;
	HY[26] = y_coord + 7'b0000101;
	HX[27] = x_coord + 7'b0000101;
	HY[27] = y_coord + 7'b0000101;
	HX[28] = x_coord ;
	HY[28] = y_coord + 7'b0000110;
	HX[29] = x_coord + 7'b0000001;
	HY[29] = y_coord + 7'b0000110;
	HX[30] = x_coord + 7'b0000100;
	HY[30] = y_coord + 7'b0000110;
	HX[31] = x_coord + 7'b0000101;
	HY[31] = y_coord + 7'b0000110;
	HX[32] = x_coord ;
	HY[32] = y_coord + 7'b0000111;
	HX[33] = x_coord + 7'b0000001;
	HY[33] = y_coord + 7'b0000111;
	HX[34] = x_coord + 7'b0000100;
	HY[34] = y_coord + 7'b0000111;
	HX[35] = x_coord + 7'b0000101;
	HY[35] = y_coord + 7'b0000111;

	//// character C
	CX[0] = x_coord ;
	CY[0] = y_coord ;
	CX[1] = x_coord + 7'b0000001;
	CY[1] = y_coord ;
	CX[2] = x_coord + 7'b0000010;
	CY[2] = y_coord ;
	CX[3] = x_coord + 7'b0000011;
	CY[3] = y_coord ;
	CX[4] = x_coord + 7'b0000100;
	CY[4] = y_coord ;
	CX[5] = x_coord + 7'b0000101;
	CY[5] = y_coord ;
	CX[6] = x_coord ;
	CY[6] = y_coord + 7'b0000001;
	CX[7] = x_coord + 7'b0000001;
	CY[7] = y_coord + 7'b0000001;
	CX[8] = x_coord + 7'b0000010;
	CY[8] = y_coord + 7'b0000001;
	CX[9] = x_coord + 7'b0000011;
	CY[9] = y_coord + 7'b0000001;
	CX[10] = x_coord + 7'b0000100;
	CY[10] = y_coord + 7'b0000001;
	CX[11] = x_coord + 7'b0000101;
	CY[11] = y_coord + 7'b0000001;
	CX[12] = x_coord ;
	CY[12] = y_coord + 7'b0000010;
	CX[13] = x_coord + 7'b0000001;
	CY[13] = y_coord + 7'b0000010;
	CX[14] = x_coord ;
	CY[14] = y_coord + 7'b0000011;
	CX[15] = x_coord + 7'b0000001;
	CY[15] = y_coord + 7'b0000011;
	CX[16] = x_coord ;
	CY[16] = y_coord + 7'b0000100;
	CX[17] = x_coord + 7'b0000001;
	CY[17] = y_coord + 7'b0000100;
	CX[18] = x_coord ;
	CY[18] = y_coord + 7'b0000101;
	CX[19] = x_coord + 7'b0000001;
	CY[19] = y_coord + 7'b0000101;
	CX[20] = x_coord ;
	CY[20] = y_coord + 7'b0000110;
	CX[21] = x_coord + 7'b0000001;
	CY[21] = y_coord + 7'b0000110;
	CX[22] = x_coord + 7'b0000010;
	CY[22] = y_coord + 7'b0000110;
	CX[23] = x_coord + 7'b0000011;
	CY[23] = y_coord + 7'b0000110;
	CX[24] = x_coord + 7'b0000100;
	CY[24] = y_coord + 7'b0000110;
	CX[25] = x_coord + 7'b0000101;
	CY[25] = y_coord + 7'b0000110;
	CX[26] = x_coord ;
	CY[26] = y_coord + 7'b0000111;
	CX[27] = x_coord + 7'b0000001;
	CY[27] = y_coord + 7'b0000111;
	CX[28] = x_coord + 7'b0000010;
	CY[28] = y_coord + 7'b0000111;
	CX[29] = x_coord + 7'b0000011;
	CY[29] = y_coord + 7'b0000111;
	CX[30] = x_coord + 7'b0000100;
	CY[30] = y_coord + 7'b0000111;
	CX[31] = x_coord + 7'b0000101;
	CY[31] = y_coord + 7'b0000111;

	////character S
	SX[0] = x_coord + 7'b0000001;
	SY[0] = y_coord ;
	SX[1] = x_coord + 7'b0000010;
	SY[1] = y_coord ;
	SX[2] = x_coord + 7'b0000011;
	SY[2] = y_coord ;
	SX[3] = x_coord + 7'b0000100;
	SY[3] = y_coord ;
	SX[4] = x_coord + 7'b0000101;
	SY[4] = y_coord ;
	SX[5] = x_coord ;
	SY[5] = y_coord + 7'b0000001;
	SX[6] = x_coord + 7'b0000001;
	SY[6] = y_coord + 7'b0000001;
	SX[7] = x_coord + 7'b0000010;
	SY[7] = y_coord + 7'b0000001;
	SX[8] = x_coord + 7'b0000011;
	SY[8] = y_coord + 7'b0000001;
	SX[9] = x_coord + 7'b0000100;
	SY[9] = y_coord + 7'b0000001;
	SX[10] = x_coord + 7'b0000101;
	SY[10] = y_coord + 7'b0000001;
	SX[11] = x_coord ;
	SY[11] = y_coord + 7'b0000010;
	SX[12] = x_coord + 7'b0000001;
	SY[12] = y_coord + 7'b0000010;
	SX[13] = x_coord ;
	SY[13] = y_coord + 7'b0000011;
	SX[14] = x_coord + 7'b0000001;
	SY[14] = y_coord + 7'b0000011;
	SX[15] = x_coord + 7'b0000010;
	SY[15] = y_coord + 7'b0000011;
	SX[16] = x_coord + 7'b0000011;
	SY[16] = y_coord + 7'b0000011;
	SX[17] = x_coord + 7'b0000100;
	SY[17] = y_coord + 7'b0000011;
	SX[18] = x_coord + 7'b0000101;
	SY[18] = y_coord + 7'b0000011;
	SX[19] = x_coord ;
	SY[19] = y_coord + 7'b0000100;
	SX[20] = x_coord + 7'b0000001;
	SY[20] = y_coord + 7'b0000100;
	SX[21] = x_coord + 7'b0000010;
	SY[21] = y_coord + 7'b0000100;
	SX[22] = x_coord + 7'b0000011;
	SY[22] = y_coord + 7'b0000100;
	SX[23] = x_coord + 7'b0000100;
	SY[23] = y_coord + 7'b0000100;
	SX[24] = x_coord + 7'b0000101;
	SY[24] = y_coord + 7'b0000100;
	SX[25] = x_coord + 7'b0000100;
	SY[25] = y_coord + 7'b0000101;
	SX[26] = x_coord + 7'b0000101;
	SY[26] = y_coord + 7'b0000101;
	SX[27] = x_coord ;
	SY[27] = y_coord + 7'b0000110;
	SX[28] = x_coord + 7'b0000001;
	SY[28] = y_coord + 7'b0000110;
	SX[29] = x_coord + 7'b0000010;
	SY[29] = y_coord + 7'b0000110;
	SX[30] = x_coord + 7'b0000011;
	SY[30] = y_coord + 7'b0000110;
	SX[31] = x_coord + 7'b0000100;
	SY[31] = y_coord + 7'b0000110;
	SX[32] = x_coord + 7'b0000101;
	SY[32] = y_coord + 7'b0000110;
	SX[33] = x_coord ;
	SY[33] = y_coord + 7'b0000111;
	SX[34] = x_coord + 7'b0000001;
	SY[34] = y_coord + 7'b0000111;
	SX[35] = x_coord + 7'b0000010;
	SY[35] = y_coord + 7'b0000111;
	SX[36] = x_coord + 7'b0000011;
	SY[36] = y_coord + 7'b0000111;
	SX[37] = x_coord + 7'b0000100;
	SY[37] = y_coord + 7'b0000111;

	//// character D
	DX[0] = x_coord ;
	DY[0] = y_coord ;
	DX[1] = x_coord + 7'b0000001;
	DY[1] = y_coord ;
	DX[2] = x_coord + 7'b0000010;
	DY[2] = y_coord ;
	DX[3] = x_coord + 7'b0000011;
	DY[3] = y_coord ;
	DX[4] = x_coord + 7'b0000100;
	DY[4] = y_coord ;
	DX[5] = x_coord ;
	DY[5] = y_coord + 7'b0000001;
	DX[6] = x_coord + 7'b0000001;
	DY[6] = y_coord + 7'b0000001;
	DX[7] = x_coord + 7'b0000010;
	DY[7] = y_coord + 7'b0000001;
	DX[8] = x_coord + 7'b0000011;
	DY[8] = y_coord + 7'b0000001;
	DX[9] = x_coord + 7'b0000100;
	DY[9] = y_coord + 7'b0000001;
	DX[10] = x_coord + 7'b0000101;
	DY[10] = y_coord + 7'b0000001;
	DX[11] = x_coord ;
	DY[11] = y_coord + 7'b0000010;
	DX[12] = x_coord + 7'b0000001;
	DY[12] = y_coord + 7'b0000010;
	DX[13] = x_coord + 7'b0000100;
	DY[13] = y_coord + 7'b0000010;
	DX[14] = x_coord + 7'b0000101;
	DY[14] = y_coord + 7'b0000010;
	DX[15] = x_coord ;
	DY[15] = y_coord + 7'b0000011;
	DX[16] = x_coord + 7'b0000001;
	DY[16] = y_coord + 7'b0000011;
	DX[17] = x_coord + 7'b0000100;
	DY[17] = y_coord + 7'b0000011;
	DX[18] = x_coord + 7'b0000101;
	DY[18] = y_coord + 7'b0000011;
	DX[19] = x_coord ;
	DY[19] = y_coord + 7'b0000100;
	DX[20] = x_coord + 7'b0000001;
	DY[20] = y_coord + 7'b0000100;
	DX[21] = x_coord + 7'b0000100;
	DY[21] = y_coord + 7'b0000100;
	DX[22] = x_coord + 7'b0000101;
	DY[22] = y_coord + 7'b0000100;
	DX[23] = x_coord ;
	DY[23] = y_coord + 7'b0000101;
	DX[24] = x_coord + 7'b0000001;
	DY[24] = y_coord + 7'b0000101;
	DX[25] = x_coord + 7'b0000100;
	DY[25] = y_coord + 7'b0000101;
	DX[26] = x_coord + 7'b0000101;
	DY[26] = y_coord + 7'b0000101;
	DX[27] = x_coord ;
	DY[27] = y_coord + 7'b0000110;
	DX[28] = x_coord + 7'b0000001;
	DY[28] = y_coord + 7'b0000110;
	DX[29] = x_coord + 7'b0000010;
	DY[29] = y_coord + 7'b0000110;
	DX[30] = x_coord + 7'b0000011;
	DY[30] = y_coord + 7'b0000110;
	DX[31] = x_coord + 7'b0000100;
	DY[31] = y_coord + 7'b0000110;
	DX[32] = x_coord + 7'b0000101;
	DY[32] = y_coord + 7'b0000110;
	DX[33] = x_coord ;
	DY[33] = y_coord + 7'b0000111;
	DX[34] = x_coord + 7'b0000001;
	DY[34] = y_coord + 7'b0000111;
	DX[35] = x_coord + 7'b0000010;
	DY[35] = y_coord + 7'b0000111;
	DX[36] = x_coord + 7'b0000011;
	DY[36] = y_coord + 7'b0000111;
	DX[37] = x_coord + 7'b0000100;
	DY[37] = y_coord + 7'b0000111;


	// for each character/state loop through the correct amount of pixels and output to x and y outs
		case (state)
			C0: begin
				if (counter <= 6'b100111) begin
					x_out = C0X[counter];
					y_out = C0Y[counter][6:0];
					counter = counter + 1'b1;
				end
				else begin
					counter = 6'b000000;
					x_out = C0X[0];
					y_out = C0Y[0][6:0];
					counter = counter + 1'b1;
				end
			end
			C1: begin
				if (counter <= 6'b001111) begin
					x_out = C1X[counter];
					y_out = C1Y[counter][6:0];
					counter = counter + 1'b1;
				end
				else begin
					counter = 6'b000000;
					x_out = C1X[0];
					y_out = C1Y[0][6:0];
					counter = counter + 1'b1;
				end
			end
			C2: begin
				if (counter <= 6'b100111) begin
					x_out = C2X[counter];
					y_out = C2Y[counter][6:0];
					counter = counter + 1'b1;
				end
				else begin
					counter = 6'b000000;
					x_out = C2X[0];
					y_out = C2Y[0][6:0];
					counter = counter + 1'b1;
				end
			end
			C3: begin
				if (counter <= 6'b100111) begin
					x_out = C3X[counter];
					y_out = C3Y[counter][6:0];
					counter = counter + 1'b1;
				end
				else begin
					counter = 6'b000000;
					x_out = C3X[0];
					y_out = C3Y[0][6:0];
					counter = counter + 1'b1;
				end
			end
			C4: begin
				if (counter <= 6'b011101) begin
					x_out = C4X[counter];
					y_out = C4Y[counter][6:0];
					counter = counter + 1'b1;
				end
				else begin
					counter = 6'b000000;
					x_out = C4X[0];
					y_out = C4Y[0][6:0];
					counter = counter + 1'b1;
				end
			end
			C5: begin
				if (counter <= 6'b100111) begin
					x_out = C5X[counter];
					y_out = C5Y[counter][6:0];
					counter = counter + 1'b1;
				end
				else begin
					counter = 6'b000000;
					x_out = C5X[0];
					y_out = C5Y[0][6:0];
					counter = counter + 1'b1;
				end
			end
			C6: begin
				if (counter <= 6'b101001) begin
					x_out = C6X[counter];
					y_out = C6Y[counter][6:0];
					counter = counter + 1'b1;
				end
				else begin
					counter = 6'b000000;
					x_out = C6X[0];
					y_out = C6Y[0][6:0];
					counter = counter + 1'b1;
				end
			end
			C7: begin
				if (counter <= 6'b011001) begin
					x_out = C7X[counter];
					y_out = C7Y[counter][6:0];
					counter = counter + 1'b1;
				end
				else begin
					counter = 6'b000000;
					x_out = C7X[0];
					y_out = C7Y[0][6:0];
					counter = counter + 1'b1;
				end
			end
			C8: begin
				if (counter <= 6'b101011 ) begin
					x_out = C8X[counter];
					y_out = C8Y[counter][6:0];
					counter = counter + 1'b1;
				end
				else begin
					counter = 6'b000000;
					x_out = C8X[0];
					y_out = C8Y[0][6:0];
					counter = counter + 1'b1;
				end
			end
			C9: begin
				if (counter <= 6'b100001) begin
					x_out = C9X[counter];
					y_out = C9Y[counter][6:0];
					counter = counter + 1'b1;
				end
				else begin
					counter = 6'b000000;
					x_out = C9X[0];
					y_out = C9Y[0][6:0];
					counter = counter + 1'b1;
				end
			end
			CJ: begin
				if (counter <= 6'b010111) begin
					x_out = JX[counter];
					y_out = JY[counter][6:0];
					counter = counter + 1'b1;
				end
				else begin
					counter = 6'b000000;
					x_out = JX[0];
					y_out = JY[0][6:0];
					counter = counter + 1'b1;
				end
			end
			CQ: begin
				if (counter <= 6'b100101) begin
					x_out = QX[counter];
					y_out = QY[counter][6:0];
					counter = counter + 1'b1;
				end
				else begin
					counter = 6'b000000;
					x_out = QX[0];
					y_out = QY[0][6:0];
					counter = counter + 1'b1;
				end
			end
			CK: begin
				if (counter <= 6'b011111) begin
					x_out = KX[counter];
					y_out = KY[counter][6:0];
					counter = counter + 1'b1;
				end
				else begin
					counter = 6'b000000;
					x_out = KX[0];
					y_out = KY[0][6:0];
					counter = counter + 1'b1;
				end
			end
			CH: begin
				if (counter <= 6'b100011) begin
					x_out = HX[counter];
					y_out = HY[counter][6:0];
					counter = counter + 1'b1;
				end
				else begin
					counter = 6'b000000;
					x_out = HX[0];
					y_out = HY[0][6:0];
					counter = counter + 1'b1;
				end
			end
			CC: begin
				if (counter <= 6'b011111) begin
					x_out = CX[counter];
					y_out = CY[counter][6:0];
					counter = counter + 1'b1;
				end
				else begin
					counter = 6'b000000;
					x_out = CX[0];
					y_out = CY[0][6:0];
					counter = counter + 1'b1;
				end
			end
			CS: begin
				if (counter <= 6'b100101) begin
					x_out = SX[counter];
					y_out = SY[counter][6:0];
					counter = counter + 1'b1;
				end
				else begin
					counter = 6'b000000;
					x_out = SX[0];
					y_out = SY[0][6:0];
					counter = counter + 1'b1;
				end
			end
			CD: begin
				if (counter <= 6'b100101) begin
					x_out = DX[counter];
					y_out = DY[counter][6:0];
					counter = counter + 1'b1;
				end
				else begin
					counter = 6'b000000;
					x_out = DX[0];
					y_out = DY[0][6:0];
					counter = counter + 1'b1;
					
				end
			end
			default: begin
				if (counter <= 6'b100101) begin
					x_out = DX[counter];
					y_out = DY[counter][6:0];
					counter = counter + 1'b1;
				end
				else begin
					counter = 6'b000000;
					x_out = DX[0];
					y_out = DY[0][6:0];
					counter = counter + 1'b1;
					
				end
			end
		endcase
		
	end

endmodule

