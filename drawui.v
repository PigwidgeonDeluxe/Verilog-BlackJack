module drawui (CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
        KEY,
        SW,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
		);

	input			CLOCK_50;				//	50 MHz
	input   [9:0]   SW;
	input   [3:0]   KEY;

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

	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;
	
	vga_adapter VGA(
		.resetn(resetn),
		.clock(CLOCK_50),
		.colour(colour),
		.x(x),
		.y(y),
		.plot(writeEn),
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
	defparam VGA.BACKGROUND_IMAGE = "black.mif";
	
	 reg [5:0] state;
	 
	/// declare all cases' local parameter names and values
	localparam RESET_GUI = 6'b000000,
		DRAW_STATIC_GUI = 6'b000001,	// draws the static GUI: P1, P2, Card outlines, T:
		DRAW_CARD_INFO = 6'b000010, // draws the card's suit and value
		RESET_CARD_INFO = 6'b000011, // resets the card interior to blank so that it may be redrawn ie transition
		DRAW_P1_SCORE = 6'b000100, // draws the score for P1
		RESET_P1_SCORE = 6'b000101, // resets the scores to blank so that it may be redrawn ie transition
		DRAW_P2_SCORE = 6'b000110, // draws the score for P2
		RESET_P2_SCORE = 6'b000111, // resets the scores to blank so that it may be redrawn ie transition
		DRAW_HAND1 = 6'b001000, // draws the total values in hand for p1
		RESET_HAND1 = 6'b001001, // resets the total values in hand for p1
		DRAW_HAND2 = 6'b001010, // draws the total values in hand for p2
		RESET_HAND2 = 6'b001011, // resets the total values in hand for p2
		DRAW_RESULT = 6'b001100, // draws the end game result ie who won
		RESET_RESULT = 6'b001101; // resets the end game result ie who won
	
	// check for cases
	state = DRAW_CARD_INFO;
	 always@(posedge CLOCK_50)
	 begin
		case (state)

			DRAW_CARD_INFO: begin
				state = RESET_CARD_INFO;
			end
			RESET_CARD_INFO: begin
				state = DRAW_P1_SCORE;
			end
			DRAW_P1_SCORE: begin
				state = RESET_P1_SCORE;
			end
			RESET_P1_SCORE: begin
				state = DRAW_P2_SCORE;
			end
			DRAW_P2_SCORE: begin
				state = RESET_P2_SCORE;
			end
			RESET_P2_SCORE: begin
				state = DRAW_HAND1;
			end
			DRAW_HAND1: begin
				state = RESET_HAND1;
			end
			RESET_HAND1: begin
				state = DRAW_HAND2;
			end
			DRAW_HAND2: begin
				state = RESET_HAND2;
			end
			RESET_HAND2: begin
				state = DRAW_RESULT;
			end
			DRAW_RESULT: begin
				state = RESET_RESULT;
			end
			RESET_RESULT: begin
				state = RESET_GUI;
			end
	 end

endmodule

module drawcharacter(CLOCK_50, x_coord, y_coord, colour_in, character, x_out, y_out, colour_out);
	input CLOCK_50;
	input [7:0] x_coord; 
	input [7:0] y_coord;
	input [2:0] colour;
	input [3:0] character; // 13 characters -> 13 indexes -> 4 bits
	output [7:0] x_out;
	output [6:0] y_out;
	output [2:0] colour_out;
	
	colour_out = colour_in;

	reg [4:0] state;
	state = character;	
	
	
	// characters and their respective state/case value: 0-16 for 0,1,2,3,4,5,6,7,8,9,J,Q,K,H,C,S,D
	localparam C0 = 5'b0000,
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

	reg [5:0] counter;

	// create registers for the x and y coordinates for each character (1D array of pixel locations from left to right, top to bottom, single pixel at a time)
	reg [7:0] 0X [39:0];
	reg [7:0] 1X [15:0];
	reg [7:0] 2X [39:0];
	reg [7:0] 3X [39:0];
	reg [7:0] 4X [29:0];
	reg [7:0] 5X [39:0];
	reg [7:0] 6X [41:0];
	reg [7:0] 7X [25:0];
	reg [7:0] 8X [43:0];
	reg [7:0] 9X [33:0];
	reg [7:0] JX [23:0];
	reg [7:0] QX [37:0];
	reg [7:0] KX [31:0];
	reg [7:0] HX [35:0];
	reg [7:0] CX [31:0];
	reg [7:0] SX [37:0];
	reg [7:0] DX [37:0];

	reg [7:0] 0Y [39:0];
	reg [7:0] 1Y [15:0];
	reg [7:0] 2Y [39:0];
	reg [7:0] 3Y [39:0];
	reg [7:0] 4Y [29:0];
	reg [7:0] 5Y [39:0];
	reg [7:0] 6Y [41:0];
	reg [7:0] 7Y [25:0];
	reg [7:0] 8Y [43:0];
	reg [7:0] 9Y [33:0];
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
	//// character 0
	0X[0] = x_coord ;
	0Y[0] = y_coord ;
	0X[1] = x_coord + 7'b0000001;
	0Y[1] = y_coord ;
	0X[2] = x_coord + 7'b0000010;
	0Y[2] = y_coord ;
	0X[3] = x_coord + 7'b0000011;
	0Y[3] = y_coord ;
	0X[4] = x_coord + 7'b0000100;
	0Y[4] = y_coord ;
	0X[5] = x_coord + 7'b0000101;
	0Y[5] = y_coord ;
	0X[6] = x_coord ;
	0Y[6] = y_coord + 7'b0000001;
	0X[7] = x_coord + 7'b0000001;
	0Y[7] = y_coord + 7'b0000001;
	0X[8] = x_coord + 7'b0000010;
	0Y[8] = y_coord + 7'b0000001;
	0X[9] = x_coord + 7'b0000011;
	0Y[9] = y_coord + 7'b0000001;
	0X[10] = x_coord + 7'b0000100;
	0Y[10] = y_coord + 7'b0000001;
	0X[11] = x_coord + 7'b0000101;
	0Y[11] = y_coord + 7'b0000001;
	0X[12] = x_coord ;
	0Y[12] = y_coord + 7'b0000010;
	0X[13] = x_coord + 7'b0000001;
	0Y[13] = y_coord + 7'b0000010;
	0X[14] = x_coord + 7'b0000100;
	0Y[14] = y_coord + 7'b0000010;
	0X[15] = x_coord + 7'b0000101;
	0Y[15] = y_coord + 7'b0000010;
	0X[16] = x_coord ;
	0Y[16] = y_coord + 7'b0000011;
	0X[17] = x_coord + 7'b0000001;
	0Y[17] = y_coord + 7'b0000011;
	0X[18] = x_coord + 7'b0000100;
	0Y[18] = y_coord + 7'b0000011;
	0X[19] = x_coord + 7'b0000101;
	0Y[19] = y_coord + 7'b0000011;
	0X[20] = x_coord ;
	0Y[20] = y_coord + 7'b0000100;
	0X[21] = x_coord + 7'b0000001;
	0Y[21] = y_coord + 7'b0000100;
	0X[22] = x_coord + 7'b0000100;
	0Y[22] = y_coord + 7'b0000100;
	0X[23] = x_coord + 7'b0000101;
	0Y[23] = y_coord + 7'b0000100;
	0X[24] = x_coord ;
	0Y[24] = y_coord + 7'b0000101;
	0X[25] = x_coord + 7'b0000001;
	0Y[25] = y_coord + 7'b0000101;
	0X[26] = x_coord + 7'b0000100;
	0Y[26] = y_coord + 7'b0000101;
	0X[27] = x_coord + 7'b0000101;
	0Y[27] = y_coord + 7'b0000101;
	0X[28] = x_coord ;
	0Y[28] = y_coord + 7'b0000110;
	0X[29] = x_coord + 7'b0000001;
	0Y[29] = y_coord + 7'b0000110;
	0X[30] = x_coord + 7'b0000010;
	0Y[30] = y_coord + 7'b0000110;
	0X[31] = x_coord + 7'b0000011;
	0Y[31] = y_coord + 7'b0000110;
	0X[32] = x_coord + 7'b0000100;
	0Y[32] = y_coord + 7'b0000110;
	0X[33] = x_coord + 7'b0000101;
	0Y[33] = y_coord + 7'b0000110;
	0X[34] = x_coord ;
	0Y[34] = y_coord + 7'b0000111;
	0X[35] = x_coord + 7'b0000001;
	0Y[35] = y_coord + 7'b0000111;
	0X[36] = x_coord + 7'b0000010;
	0Y[36] = y_coord + 7'b0000111;
	0X[37] = x_coord + 7'b0000011;
	0Y[37] = y_coord + 7'b0000111;
	0X[38] = x_coord + 7'b0000100;
	0Y[38] = y_coord + 7'b0000111;
	0X[39] = x_coord + 7'b0000101;
	0Y[39] = y_coord + 7'b0000111;

	//// character 1
	1X[0] = x_coord ;
	1Y[0] = y_coord ;
	1X[1] = x_coord + 7'b0000001;
	1Y[1] = y_coord ;
	1X[2] = x_coord ;
	1Y[2] = y_coord + 7'b0000001;
	1X[3] = x_coord + 7'b0000001;
	1Y[3] = y_coord + 7'b0000001;
	1X[4] = x_coord ;
	1Y[4] = y_coord + 7'b0000010;
	1X[5] = x_coord + 7'b0000001;
	1Y[5] = y_coord + 7'b0000010;
	1X[6] = x_coord ;
	1Y[6] = y_coord + 7'b0000011;
	1X[7] = x_coord + 7'b0000001;
	1Y[7] = y_coord + 7'b0000011;
	1X[8] = x_coord ;
	1Y[8] = y_coord + 7'b0000100;
	1X[9] = x_coord + 7'b0000001;
	1Y[9] = y_coord + 7'b0000100;
	1X[10] = x_coord ;
	1Y[10] = y_coord + 7'b0000101;
	1X[11] = x_coord + 7'b0000001;
	1Y[11] = y_coord + 7'b0000101;
	1X[12] = x_coord ;
	1Y[12] = y_coord + 7'b0000110;
	1X[13] = x_coord + 7'b0000001;
	1Y[13] = y_coord + 7'b0000110;
	1X[14] = x_coord ;
	1Y[14] = y_coord + 7'b0000111;
	1X[15] = x_coord + 7'b0000001;
	1Y[15] = y_coord + 7'b0000111;

	//// character 2
	2X[0] = x_coord ;
	2Y[0] = y_coord ;
	2X[1] = x_coord + 7'b0000001;
	2Y[1] = y_coord ;
	2X[2] = x_coord + 7'b0000010;
	2Y[2] = y_coord ;
	2X[3] = x_coord + 7'b0000011;
	2Y[3] = y_coord ;
	2X[4] = x_coord + 7'b0000100;
	2Y[4] = y_coord ;
	2X[5] = x_coord + 7'b0000101;
	2Y[5] = y_coord ;
	2X[6] = x_coord ;
	2Y[6] = y_coord + 7'b0000001;
	2X[7] = x_coord + 7'b0000001;
	2Y[7] = y_coord + 7'b0000001;
	2X[8] = x_coord + 7'b0000010;
	2Y[8] = y_coord + 7'b0000001;
	2X[9] = x_coord + 7'b0000011;
	2Y[9] = y_coord + 7'b0000001;
	2X[10] = x_coord + 7'b0000100;
	2Y[10] = y_coord + 7'b0000001;
	2X[11] = x_coord + 7'b0000101;
	2Y[11] = y_coord + 7'b0000001;
	2X[12] = x_coord + 7'b0000100;
	2Y[12] = y_coord + 7'b0000010;
	2X[13] = x_coord + 7'b0000101;
	2Y[13] = y_coord + 7'b0000010;
	2X[14] = x_coord ;
	2Y[14] = y_coord + 7'b0000011;
	2X[15] = x_coord + 7'b0000001;
	2Y[15] = y_coord + 7'b0000011;
	2X[16] = x_coord + 7'b0000010;
	2Y[16] = y_coord + 7'b0000011;
	2X[17] = x_coord + 7'b0000011;
	2Y[17] = y_coord + 7'b0000011;
	2X[18] = x_coord + 7'b0000100;
	2Y[18] = y_coord + 7'b0000011;
	2X[19] = x_coord + 7'b0000101;
	2Y[19] = y_coord + 7'b0000011;
	2X[20] = x_coord ;
	2Y[20] = y_coord + 7'b0000100;
	2X[21] = x_coord + 7'b0000001;
	2Y[21] = y_coord + 7'b0000100;
	2X[22] = x_coord + 7'b0000010;
	2Y[22] = y_coord + 7'b0000100;
	2X[23] = x_coord + 7'b0000011;
	2Y[23] = y_coord + 7'b0000100;
	2X[24] = x_coord + 7'b0000100;
	2Y[24] = y_coord + 7'b0000100;
	2X[25] = x_coord + 7'b0000101;
	2Y[25] = y_coord + 7'b0000100;
	2X[26] = x_coord ;
	2Y[26] = y_coord + 7'b0000101;
	2X[27] = x_coord + 7'b0000001;
	2Y[27] = y_coord + 7'b0000101;
	2X[28] = x_coord ;
	2Y[28] = y_coord + 7'b0000110;
	2X[29] = x_coord + 7'b0000001;
	2Y[29] = y_coord + 7'b0000110;
	2X[30] = x_coord + 7'b0000010;
	2Y[30] = y_coord + 7'b0000110;
	2X[31] = x_coord + 7'b0000011;
	2Y[31] = y_coord + 7'b0000110;
	2X[32] = x_coord + 7'b0000100;
	2Y[32] = y_coord + 7'b0000110;
	2X[33] = x_coord + 7'b0000101;
	2Y[33] = y_coord + 7'b0000110;
	2X[34] = x_coord ;
	2Y[34] = y_coord + 7'b0000111;
	2X[35] = x_coord + 7'b0000001;
	2Y[35] = y_coord + 7'b0000111;
	2X[36] = x_coord + 7'b0000010;
	2Y[36] = y_coord + 7'b0000111;
	2X[37] = x_coord + 7'b0000011;
	2Y[37] = y_coord + 7'b0000111;
	2X[38] = x_coord + 7'b0000100;
	2Y[38] = y_coord + 7'b0000111;
	2X[39] = x_coord + 7'b0000101;
	2Y[39] = y_coord + 7'b0000111;

	//// character 3
	3X[0] = x_coord ;
	3Y[0] = y_coord ;
	3X[1] = x_coord + 7'b0000001;
	3Y[1] = y_coord ;
	3X[2] = x_coord + 7'b0000010;
	3Y[2] = y_coord ;
	3X[3] = x_coord + 7'b0000011;
	3Y[3] = y_coord ;
	3X[4] = x_coord + 7'b0000100;
	3Y[4] = y_coord ;
	3X[5] = x_coord + 7'b0000101;
	3Y[5] = y_coord ;
	3X[6] = x_coord ;
	3Y[6] = y_coord + 7'b0000001;
	3X[7] = x_coord + 7'b0000001;
	3Y[7] = y_coord + 7'b0000001;
	3X[8] = x_coord + 7'b0000010;
	3Y[8] = y_coord + 7'b0000001;
	3X[9] = x_coord + 7'b0000011;
	3Y[9] = y_coord + 7'b0000001;
	3X[10] = x_coord + 7'b0000100;
	3Y[10] = y_coord + 7'b0000001;
	3X[11] = x_coord + 7'b0000101;
	3Y[11] = y_coord + 7'b0000001;
	3X[12] = x_coord + 7'b0000100;
	3Y[12] = y_coord + 7'b0000010;
	3X[13] = x_coord + 7'b0000101;
	3Y[13] = y_coord + 7'b0000010;
	3X[14] = x_coord ;
	3Y[14] = y_coord + 7'b0000011;
	3X[15] = x_coord + 7'b0000001;
	3Y[15] = y_coord + 7'b0000011;
	3X[16] = x_coord + 7'b0000010;
	3Y[16] = y_coord + 7'b0000011;
	3X[17] = x_coord + 7'b0000011;
	3Y[17] = y_coord + 7'b0000011;
	3X[18] = x_coord + 7'b0000100;
	3Y[18] = y_coord + 7'b0000011;
	3X[19] = x_coord + 7'b0000101;
	3Y[19] = y_coord + 7'b0000011;
	3X[20] = x_coord ;
	3Y[20] = y_coord + 7'b0000100;
	3X[21] = x_coord + 7'b0000001;
	3Y[21] = y_coord + 7'b0000100;
	3X[22] = x_coord + 7'b0000010;
	3Y[22] = y_coord + 7'b0000100;
	3X[23] = x_coord + 7'b0000011;
	3Y[23] = y_coord + 7'b0000100;
	3X[24] = x_coord + 7'b0000100;
	3Y[24] = y_coord + 7'b0000100;
	3X[25] = x_coord + 7'b0000101;
	3Y[25] = y_coord + 7'b0000100;
	3X[26] = x_coord + 7'b0000100;
	3Y[26] = y_coord + 7'b0000101;
	3X[27] = x_coord + 7'b0000101;
	3Y[27] = y_coord + 7'b0000101;
	3X[28] = x_coord ;
	3Y[28] = y_coord + 7'b0000110;
	3X[29] = x_coord + 7'b0000001;
	3Y[29] = y_coord + 7'b0000110;
	3X[30] = x_coord + 7'b0000010;
	3Y[30] = y_coord + 7'b0000110;
	3X[31] = x_coord + 7'b0000011;
	3Y[31] = y_coord + 7'b0000110;
	3X[32] = x_coord + 7'b0000100;
	3Y[32] = y_coord + 7'b0000110;
	3X[33] = x_coord + 7'b0000101;
	3Y[33] = y_coord + 7'b0000110;
	3X[34] = x_coord ;
	3Y[34] = y_coord + 7'b0000111;
	3X[35] = x_coord + 7'b0000001;
	3Y[35] = y_coord + 7'b0000111;
	3X[36] = x_coord + 7'b0000010;
	3Y[36] = y_coord + 7'b0000111;
	3X[37] = x_coord + 7'b0000011;
	3Y[37] = y_coord + 7'b0000111;
	3X[38] = x_coord + 7'b0000100;
	3Y[38] = y_coord + 7'b0000111;
	3X[39] = x_coord + 7'b0000101;
	3Y[39] = y_coord + 7'b0000111;

	//// character 4
	4X[0] = x_coord ;
	4Y[0] = y_coord ;
	4X[1] = x_coord + 7'b0000001;
	4Y[1] = y_coord ;
	4X[2] = x_coord + 7'b0000100;
	4Y[2] = y_coord ;
	4X[3] = x_coord + 7'b0000101;
	4Y[3] = y_coord ;
	4X[4] = x_coord ;
	4Y[4] = y_coord + 7'b0000001;
	4X[5] = x_coord + 7'b0000001;
	4Y[5] = y_coord + 7'b0000001;
	4X[6] = x_coord + 7'b0000100;
	4Y[6] = y_coord + 7'b0000001;
	4X[7] = x_coord + 7'b0000101;
	4Y[7] = y_coord + 7'b0000001;
	4X[8] = x_coord ;
	4Y[8] = y_coord + 7'b0000010;
	4X[9] = x_coord + 7'b0000001;
	4Y[9] = y_coord + 7'b0000010;
	4X[10] = x_coord + 7'b0000100;
	4Y[10] = y_coord + 7'b0000010;
	4X[11] = x_coord + 7'b0000101;
	4Y[11] = y_coord + 7'b0000010;
	4X[12] = x_coord ;
	4Y[12] = y_coord + 7'b0000011;
	4X[13] = x_coord + 7'b0000001;
	4Y[13] = y_coord + 7'b0000011;
	4X[14] = x_coord + 7'b0000010;
	4Y[14] = y_coord + 7'b0000011;
	4X[15] = x_coord + 7'b0000011;
	4Y[15] = y_coord + 7'b0000011;
	4X[16] = x_coord + 7'b0000100;
	4Y[16] = y_coord + 7'b0000011;
	4X[17] = x_coord + 7'b0000101;
	4Y[17] = y_coord + 7'b0000011;
	4X[18] = x_coord ;
	4Y[18] = y_coord + 7'b0000100;
	4X[19] = x_coord + 7'b0000001;
	4Y[19] = y_coord + 7'b0000100;
	4X[20] = x_coord + 7'b0000010;
	4Y[20] = y_coord + 7'b0000100;
	4X[21] = x_coord + 7'b0000011;
	4Y[21] = y_coord + 7'b0000100;
	4X[22] = x_coord + 7'b0000100;
	4Y[22] = y_coord + 7'b0000100;
	4X[23] = x_coord + 7'b0000101;
	4Y[23] = y_coord + 7'b0000100;
	4X[24] = x_coord + 7'b0000100;
	4Y[24] = y_coord + 7'b0000101;
	4X[25] = x_coord + 7'b0000101;
	4Y[25] = y_coord + 7'b0000101;
	4X[26] = x_coord + 7'b0000100;
	4Y[26] = y_coord + 7'b0000110;
	4X[27] = x_coord + 7'b0000101;
	4Y[27] = y_coord + 7'b0000110;
	4X[28] = x_coord + 7'b0000100;
	4Y[28] = y_coord + 7'b0000111;
	4X[29] = x_coord + 7'b0000101;
	4Y[29] = y_coord + 7'b0000111;

	//// character 5
	5X[0] = x_coord ;
	5Y[0] = y_coord ;
	5X[1] = x_coord + 7'b0000001;
	5Y[1] = y_coord ;
	5X[2] = x_coord + 7'b0000010;
	5Y[2] = y_coord ;
	5X[3] = x_coord + 7'b0000011;
	5Y[3] = y_coord ;
	5X[4] = x_coord + 7'b0000100;
	5Y[4] = y_coord ;
	5X[5] = x_coord + 7'b0000101;
	5Y[5] = y_coord ;
	5X[6] = x_coord ;
	5Y[6] = y_coord + 7'b0000001;
	5X[7] = x_coord + 7'b0000001;
	5Y[7] = y_coord + 7'b0000001;
	5X[8] = x_coord + 7'b0000010;
	5Y[8] = y_coord + 7'b0000001;
	5X[9] = x_coord + 7'b0000011;
	5Y[9] = y_coord + 7'b0000001;
	5X[10] = x_coord + 7'b0000100;
	5Y[10] = y_coord + 7'b0000001;
	5X[11] = x_coord + 7'b0000101;
	5Y[11] = y_coord + 7'b0000001;
	5X[12] = x_coord ;
	5Y[12] = y_coord + 7'b0000010;
	5X[13] = x_coord + 7'b0000001;
	5Y[13] = y_coord + 7'b0000010;
	5X[14] = x_coord ;
	5Y[14] = y_coord + 7'b0000011;
	5X[15] = x_coord + 7'b0000001;
	5Y[15] = y_coord + 7'b0000011;
	5X[16] = x_coord + 7'b0000010;
	5Y[16] = y_coord + 7'b0000011;
	5X[17] = x_coord + 7'b0000011;
	5Y[17] = y_coord + 7'b0000011;
	5X[18] = x_coord + 7'b0000100;
	5Y[18] = y_coord + 7'b0000011;
	5X[19] = x_coord + 7'b0000101;
	5Y[19] = y_coord + 7'b0000011;
	5X[20] = x_coord ;
	5Y[20] = y_coord + 7'b0000100;
	5X[21] = x_coord + 7'b0000001;
	5Y[21] = y_coord + 7'b0000100;
	5X[22] = x_coord + 7'b0000010;
	5Y[22] = y_coord + 7'b0000100;
	5X[23] = x_coord + 7'b0000011;
	5Y[23] = y_coord + 7'b0000100;
	5X[24] = x_coord + 7'b0000100;
	5Y[24] = y_coord + 7'b0000100;
	5X[25] = x_coord + 7'b0000101;
	5Y[25] = y_coord + 7'b0000100;
	5X[26] = x_coord + 7'b0000100;
	5Y[26] = y_coord + 7'b0000101;
	5X[27] = x_coord + 7'b0000101;
	5Y[27] = y_coord + 7'b0000101;
	5X[28] = x_coord ;
	5Y[28] = y_coord + 7'b0000110;
	5X[29] = x_coord + 7'b0000001;
	5Y[29] = y_coord + 7'b0000110;
	5X[30] = x_coord + 7'b0000010;
	5Y[30] = y_coord + 7'b0000110;
	5X[31] = x_coord + 7'b0000011;
	5Y[31] = y_coord + 7'b0000110;
	5X[32] = x_coord + 7'b0000100;
	5Y[32] = y_coord + 7'b0000110;
	5X[33] = x_coord + 7'b0000101;
	5Y[33] = y_coord + 7'b0000110;
	5X[34] = x_coord ;
	5Y[34] = y_coord + 7'b0000111;
	5X[35] = x_coord + 7'b0000001;
	5Y[35] = y_coord + 7'b0000111;
	5X[36] = x_coord + 7'b0000010;
	5Y[36] = y_coord + 7'b0000111;
	5X[37] = x_coord + 7'b0000011;
	5Y[37] = y_coord + 7'b0000111;
	5X[38] = x_coord + 7'b0000100;
	5Y[38] = y_coord + 7'b0000111;
	5X[39] = x_coord + 7'b0000101;
	5Y[39] = y_coord + 7'b0000111;

	//// character 6
	6X[0] = x_coord ;
	6Y[0] = y_coord ;
	6X[1] = x_coord + 7'b0000001;
	6Y[1] = y_coord ;
	6X[2] = x_coord + 7'b0000010;
	6Y[2] = y_coord ;
	6X[3] = x_coord + 7'b0000011;
	6Y[3] = y_coord ;
	6X[4] = x_coord + 7'b0000100;
	6Y[4] = y_coord ;
	6X[5] = x_coord + 7'b0000101;
	6Y[5] = y_coord ;
	6X[6] = x_coord ;
	6Y[6] = y_coord + 7'b0000001;
	6X[7] = x_coord + 7'b0000001;
	6Y[7] = y_coord + 7'b0000001;
	6X[8] = x_coord + 7'b0000010;
	6Y[8] = y_coord + 7'b0000001;
	6X[9] = x_coord + 7'b0000011;
	6Y[9] = y_coord + 7'b0000001;
	6X[10] = x_coord + 7'b0000100;
	6Y[10] = y_coord + 7'b0000001;
	6X[11] = x_coord + 7'b0000101;
	6Y[11] = y_coord + 7'b0000001;
	6X[12] = x_coord ;
	6Y[12] = y_coord + 7'b0000010;
	6X[13] = x_coord + 7'b0000001;
	6Y[13] = y_coord + 7'b0000010;
	6X[14] = x_coord ;
	6Y[14] = y_coord + 7'b0000011;
	6X[15] = x_coord + 7'b0000001;
	6Y[15] = y_coord + 7'b0000011;
	6X[16] = x_coord + 7'b0000010;
	6Y[16] = y_coord + 7'b0000011;
	6X[17] = x_coord + 7'b0000011;
	6Y[17] = y_coord + 7'b0000011;
	6X[18] = x_coord + 7'b0000100;
	6Y[18] = y_coord + 7'b0000011;
	6X[19] = x_coord + 7'b0000101;
	6Y[19] = y_coord + 7'b0000011;
	6X[20] = x_coord ;
	6Y[20] = y_coord + 7'b0000100;
	6X[21] = x_coord + 7'b0000001;
	6Y[21] = y_coord + 7'b0000100;
	6X[22] = x_coord + 7'b0000010;
	6Y[22] = y_coord + 7'b0000100;
	6X[23] = x_coord + 7'b0000011;
	6Y[23] = y_coord + 7'b0000100;
	6X[24] = x_coord + 7'b0000100;
	6Y[24] = y_coord + 7'b0000100;
	6X[25] = x_coord + 7'b0000101;
	6Y[25] = y_coord + 7'b0000100;
	6X[26] = x_coord ;
	6Y[26] = y_coord + 7'b0000101;
	6X[27] = x_coord + 7'b0000001;
	6Y[27] = y_coord + 7'b0000101;
	6X[28] = x_coord + 7'b0000100;
	6Y[28] = y_coord + 7'b0000101;
	6X[29] = x_coord + 7'b0000101;
	6Y[29] = y_coord + 7'b0000101;
	6X[30] = x_coord ;
	6Y[30] = y_coord + 7'b0000110;
	6X[31] = x_coord + 7'b0000001;
	6Y[31] = y_coord + 7'b0000110;
	6X[32] = x_coord + 7'b0000010;
	6Y[32] = y_coord + 7'b0000110;
	6X[33] = x_coord + 7'b0000011;
	6Y[33] = y_coord + 7'b0000110;
	6X[34] = x_coord + 7'b0000100;
	6Y[34] = y_coord + 7'b0000110;
	6X[35] = x_coord + 7'b0000101;
	6Y[35] = y_coord + 7'b0000110;
	6X[36] = x_coord ;
	6Y[36] = y_coord + 7'b0000111;
	6X[37] = x_coord + 7'b0000001;
	6Y[37] = y_coord + 7'b0000111;
	6X[38] = x_coord + 7'b0000010;
	6Y[38] = y_coord + 7'b0000111;
	6X[39] = x_coord + 7'b0000011;
	6Y[39] = y_coord + 7'b0000111;
	6X[40] = x_coord + 7'b0000100;
	6Y[40] = y_coord + 7'b0000111;
	6X[41] = x_coord + 7'b0000101;
	6Y[41] = y_coord + 7'b0000111;

	//// character 7
	7X[0] = x_coord ;
	7Y[0] = y_coord ;
	7X[1] = x_coord + 7'b0000001;
	7Y[1] = y_coord ;
	7X[2] = x_coord + 7'b0000010;
	7Y[2] = y_coord ;
	7X[3] = x_coord + 7'b0000011;
	7Y[3] = y_coord ;
	7X[4] = x_coord + 7'b0000100;
	7Y[4] = y_coord ;
	7X[5] = x_coord + 7'b0000101;
	7Y[5] = y_coord ;
	7X[6] = x_coord ;
	7Y[6] = y_coord + 7'b0000001;
	7X[7] = x_coord + 7'b0000001;
	7Y[7] = y_coord + 7'b0000001;
	7X[8] = x_coord + 7'b0000010;
	7Y[8] = y_coord + 7'b0000001;
	7X[9] = x_coord + 7'b0000011;
	7Y[9] = y_coord + 7'b0000001;
	7X[10] = x_coord + 7'b0000100;
	7Y[10] = y_coord + 7'b0000001;
	7X[11] = x_coord + 7'b0000101;
	7Y[11] = y_coord + 7'b0000001;
	7X[12] = x_coord ;
	7Y[12] = y_coord + 7'b0000010;
	7X[13] = x_coord + 7'b0000001;
	7Y[13] = y_coord + 7'b0000010;
	7X[14] = x_coord + 7'b0000100;
	7Y[14] = y_coord + 7'b0000010;
	7X[15] = x_coord + 7'b0000101;
	7Y[15] = y_coord + 7'b0000010;
	7X[16] = x_coord + 7'b0000100;
	7Y[16] = y_coord + 7'b0000011;
	7X[17] = x_coord + 7'b0000101;
	7Y[17] = y_coord + 7'b0000011;
	7X[18] = x_coord + 7'b0000100;
	7Y[18] = y_coord + 7'b0000100;
	7X[19] = x_coord + 7'b0000101;
	7Y[19] = y_coord + 7'b0000100;
	7X[20] = x_coord + 7'b0000100;
	7Y[20] = y_coord + 7'b0000101;
	7X[21] = x_coord + 7'b0000101;
	7Y[21] = y_coord + 7'b0000101;
	7X[22] = x_coord + 7'b0000100;
	7Y[22] = y_coord + 7'b0000110;
	7X[23] = x_coord + 7'b0000101;
	7Y[23] = y_coord + 7'b0000110;
	7X[24] = x_coord + 7'b0000100;
	7Y[24] = y_coord + 7'b0000111;
	7X[25] = x_coord + 7'b0000101;
	7Y[25] = y_coord + 7'b0000111;

	//// character 8
	8X[0] = x_coord ;
	8Y[0] = y_coord ;
	8X[1] = x_coord + 7'b0000001;
	8Y[1] = y_coord ;
	8X[2] = x_coord + 7'b0000010;
	8Y[2] = y_coord ;
	8X[3] = x_coord + 7'b0000011;
	8Y[3] = y_coord ;
	8X[4] = x_coord + 7'b0000100;
	8Y[4] = y_coord ;
	8X[5] = x_coord + 7'b0000101;
	8Y[5] = y_coord ;
	8X[6] = x_coord ;
	8Y[6] = y_coord + 7'b0000001;
	8X[7] = x_coord + 7'b0000001;
	8Y[7] = y_coord + 7'b0000001;
	8X[8] = x_coord + 7'b0000010;
	8Y[8] = y_coord + 7'b0000001;
	8X[9] = x_coord + 7'b0000011;
	8Y[9] = y_coord + 7'b0000001;
	8X[10] = x_coord + 7'b0000100;
	8Y[10] = y_coord + 7'b0000001;
	8X[11] = x_coord + 7'b0000101;
	8Y[11] = y_coord + 7'b0000001;
	8X[12] = x_coord ;
	8Y[12] = y_coord + 7'b0000010;
	8X[13] = x_coord + 7'b0000001;
	8Y[13] = y_coord + 7'b0000010;
	8X[14] = x_coord + 7'b0000100;
	8Y[14] = y_coord + 7'b0000010;
	8X[15] = x_coord + 7'b0000101;
	8Y[15] = y_coord + 7'b0000010;
	8X[16] = x_coord ;
	8Y[16] = y_coord + 7'b0000011;
	8X[17] = x_coord + 7'b0000001;
	8Y[17] = y_coord + 7'b0000011;
	8X[18] = x_coord + 7'b0000010;
	8Y[18] = y_coord + 7'b0000011;
	8X[19] = x_coord + 7'b0000011;
	8Y[19] = y_coord + 7'b0000011;
	8X[20] = x_coord + 7'b0000100;
	8Y[20] = y_coord + 7'b0000011;
	8X[21] = x_coord + 7'b0000101;
	8Y[21] = y_coord + 7'b0000011;
	8X[22] = x_coord ;
	8Y[22] = y_coord + 7'b0000100;
	8X[23] = x_coord + 7'b0000001;
	8Y[23] = y_coord + 7'b0000100;
	8X[24] = x_coord + 7'b0000010;
	8Y[24] = y_coord + 7'b0000100;
	8X[25] = x_coord + 7'b0000011;
	8Y[25] = y_coord + 7'b0000100;
	8X[26] = x_coord + 7'b0000100;
	8Y[26] = y_coord + 7'b0000100;
	8X[27] = x_coord + 7'b0000101;
	8Y[27] = y_coord + 7'b0000100;
	8X[28] = x_coord ;
	8Y[28] = y_coord + 7'b0000101;
	8X[29] = x_coord + 7'b0000001;
	8Y[29] = y_coord + 7'b0000101;
	8X[30] = x_coord + 7'b0000100;
	8Y[30] = y_coord + 7'b0000101;
	8X[31] = x_coord + 7'b0000101;
	8Y[31] = y_coord + 7'b0000101;
	8X[32] = x_coord ;
	8Y[32] = y_coord + 7'b0000110;
	8X[33] = x_coord + 7'b0000001;
	8Y[33] = y_coord + 7'b0000110;
	8X[34] = x_coord + 7'b0000010;
	8Y[34] = y_coord + 7'b0000110;
	8X[35] = x_coord + 7'b0000011;
	8Y[35] = y_coord + 7'b0000110;
	8X[36] = x_coord + 7'b0000100;
	8Y[36] = y_coord + 7'b0000110;
	8X[37] = x_coord + 7'b0000101;
	8Y[37] = y_coord + 7'b0000110;
	8X[38] = x_coord ;
	8Y[38] = y_coord + 7'b0000111;
	8X[39] = x_coord + 7'b0000001;
	8Y[39] = y_coord + 7'b0000111;
	8X[40] = x_coord + 7'b0000010;
	8Y[40] = y_coord + 7'b0000111;
	8X[41] = x_coord + 7'b0000011;
	8Y[41] = y_coord + 7'b0000111;
	8X[42] = x_coord + 7'b0000100;
	8Y[42] = y_coord + 7'b0000111;
	8X[43] = x_coord + 7'b0000101;
	8Y[43] = y_coord + 7'b0000111;	

	//// character 9
	9X[0] = x_coord ;
	9Y[0] = y_coord ;
	9X[1] = x_coord + 7'b0000001;
	9Y[1] = y_coord ;
	9X[2] = x_coord + 7'b0000010;
	9Y[2] = y_coord ;
	9X[3] = x_coord + 7'b0000011;
	9Y[3] = y_coord ;
	9X[4] = x_coord + 7'b0000100;
	9Y[4] = y_coord ;
	9X[5] = x_coord + 7'b0000101;
	9Y[5] = y_coord ;
	9X[6] = x_coord ;
	9Y[6] = y_coord + 7'b0000001;
	9X[7] = x_coord + 7'b0000001;
	9Y[7] = y_coord + 7'b0000001;
	9X[8] = x_coord + 7'b0000010;
	9Y[8] = y_coord + 7'b0000001;
	9X[9] = x_coord + 7'b0000011;
	9Y[9] = y_coord + 7'b0000001;
	9X[10] = x_coord + 7'b0000100;
	9Y[10] = y_coord + 7'b0000001;
	9X[11] = x_coord + 7'b0000101;
	9Y[11] = y_coord + 7'b0000001;
	9X[12] = x_coord ;
	9Y[12] = y_coord + 7'b0000010;
	9X[13] = x_coord + 7'b0000001;
	9Y[13] = y_coord + 7'b0000010;
	9X[14] = x_coord + 7'b0000100;
	9Y[14] = y_coord + 7'b0000010;
	9X[15] = x_coord + 7'b0000101;
	9Y[15] = y_coord + 7'b0000010;
	9X[16] = x_coord ;
	9Y[16] = y_coord + 7'b0000011;
	9X[17] = x_coord + 7'b0000001;
	9Y[17] = y_coord + 7'b0000011;
	9X[18] = x_coord + 7'b0000010;
	9Y[18] = y_coord + 7'b0000011;
	9X[19] = x_coord + 7'b0000011;
	9Y[19] = y_coord + 7'b0000011;
	9X[20] = x_coord + 7'b0000100;
	9Y[20] = y_coord + 7'b0000011;
	9X[21] = x_coord + 7'b0000101;
	9Y[21] = y_coord + 7'b0000011;
	9X[22] = x_coord ;
	9Y[22] = y_coord + 7'b0000100;
	9X[23] = x_coord + 7'b0000001;
	9Y[23] = y_coord + 7'b0000100;
	9X[24] = x_coord + 7'b0000010;
	9Y[24] = y_coord + 7'b0000100;
	9X[25] = x_coord + 7'b0000011;
	9Y[25] = y_coord + 7'b0000100;
	9X[26] = x_coord + 7'b0000100;
	9Y[26] = y_coord + 7'b0000100;
	9X[27] = x_coord + 7'b0000101;
	9Y[27] = y_coord + 7'b0000100;
	9X[28] = x_coord + 7'b0000100;
	9Y[28] = y_coord + 7'b0000101;
	9X[29] = x_coord + 7'b0000101;
	9Y[29] = y_coord + 7'b0000101;
	9X[30] = x_coord + 7'b0000100;
	9Y[30] = y_coord + 7'b0000110;
	9X[31] = x_coord + 7'b0000101;
	9Y[31] = y_coord + 7'b0000110;
	9X[32] = x_coord + 7'b0000100;
	9Y[32] = y_coord + 7'b0000111;
	9X[33] = x_coord + 7'b0000101;
	9Y[33] = y_coord + 7'b0000111;

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
				if (counter < 39) begin
					x_out = 0X[counter];
					y_out = 0Y[counter][6:0];
				end
				else begin
					counter = 0;
					x_out = 0X[0];
					y_out = 0Y[0][6:0];
				end
			end
			C1: begin
				if (counter < 15) begin
					x_out = 1X[counter];
					y_out = 1Y[counter][6:0];
				end
				else begin
					counter = 0;
					x_out = 1X[0];
					y_out = 1Y[0][6:0];
				end
			end
			C2: begin
				if (counter < 39) begin
					x_out = 2X[counter];
					y_out = 2Y[counter][6:0];
				end
				else begin
					counter = 0;
					x_out = 2X[0];
					y_out = 2Y[0][6:0];
				end
			end
			C3: begin
				if (counter < 39) begin
					x_out = 3X[counter];
					y_out = 3Y[counter][6:0];
				end
				else begin
					counter = 0;
					x_out = 3X[0];
					y_out = 3Y[0][6:0];
				end
			end
			C4: begin
				if (counter < 29) begin
					x_out = 4X[counter];
					y_out = 4Y[counter][6:0];
				end
				else begin
					counter = 0;
					x_out = 4X[0];
					y_out = 4Y[0][6:0];
				end
			end
			C5: begin
				if (counter < 39) begin
					x_out = 5X[counter];
					y_out = 5Y[counter][6:0];
				end
				else begin
					counter = 0;
					x_out = 5X[0];
					y_out = 5Y[0][6:0];
				end
			end
			C6: begin
				if (counter < 41) begin
					x_out = 6X[counter];
					y_out = 6Y[counter][6:0];
				end
				else begin
					counter = 0;
					x_out = 6X[0];
					y_out = 6Y[0][6:0];
				end
			end
			C7: begin
				if (counter < 25) begin
					x_out = 7X[counter];
					y_out = 7Y[counter][6:0];
				end
				else begin
					counter = 0;
					x_out = 7X[0];
					y_out = 7Y[0][6:0];
				end
			end
			C8: begin
				if (counter < 43) begin
					x_out = 8X[counter];
					y_out = 8Y[counter][6:0];
				end
				else begin
					counter = 0;
					x_out = 8X[0];
					y_out = 8Y[0][6:0];
				end
			end
			C9: begin
				if (counter < 33) begin
					x_out = 9X[counter];
					y_out = 9Y[counter][6:0];
				end
				else begin
					counter = 0;
					x_out = 9X[0];
					y_out = 9Y[0][6:0];
				end
			end
			CJ: begin
				if (counter < 23) begin
					x_out = JX[counter];
					y_out = JY[counter][6:0];
				end
				else begin
					counter = 0;
					x_out = JX[0];
					y_out = JY[0][6:0];
				end
			end
			CQ: begin
				if (counter < 37) begin
					x_out = QX[counter];
					y_out = QY[counter][6:0];
				end
				else begin
					counter = 0;
					x_out = QX[0];
					y_out = QY[0][6:0];
				end
			end
			CK: begin
				if (counter < 31) begin
					x_out = KX[counter];
					y_out = KY[counter][6:0];
				end
				else begin
					counter = 0;
					x_out = KX[0];
					y_out = KY[0][6:0];
				end
			end
			CH: begin
				if (counter < 35) begin
					x_out = HX[counter];
					y_out = HY[counter][6:0];
				end
				else begin
					counter = 0;
					x_out = HX[0];
					y_out = HY[0][6:0];
				end
			end
			CC: begin
				if (counter < 31) begin
					x_out = CX[counter];
					y_out = CY[counter][6:0];
				end
				else begin
					counter = 0;
					x_out = CX[0];
					y_out = CY[0][6:0];
				end
			end
			CS: begin
				if (counter < 37) begin
					x_out = SX[counter];
					y_out = SY[counter][6:0];
				end
				else begin
					counter = 0;
					x_out = SX[0];
					y_out = SY[0][6:0];
				end
			end
			CD: begin
				if (counter < 37) begin
					x_out = DX[counter];
					y_out = DY[counter][6:0];
				end
				else begin
					counter = 0;
					x_out = DX[0];
					y_out = DY[0][6:0];
				end
			end
	end


endmodule
