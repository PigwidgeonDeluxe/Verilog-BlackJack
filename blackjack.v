module blackjack(SW, KEY, LEDR,HEX1,HEX4,
		CLOCK_50,//	On Board 50 MHz
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B,   						//	VGA Blue[9:0]
		);
	// helper function to do conversions****************
	function [5:0] trunc_7_to_6(input [6:0] val7);
	trunc_7_to_6 = val7[6:0];
	endfunction
	//****************************************************
	//VGA stuff***********************************************
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;  
	// ******************************************************************
    input [19:0] SW;
    input [4:0] KEY;
    output [9:0] LEDR;
	 reg [2:0]roundcount = 3'b000;
    wire p1, p2,done,total, clock, resetn, out_light;
	 reg [3:0]player1card = 1'b0;
	 reg [4:0]player1total = 5'b00000;
	 reg [2:0]player1score = 3'b000;
	 reg [3:0]player2card = 1'b0;
	 reg [4:0]player2total = 5'b0000;
	 reg [2:0]player2score = 3'b000;
	 //reg [6:0]outputcard;
	 reg [6:0]getcard = 6'b000000;
	 reg [6:0]getcard2 = 6'b000000;
    reg [3:0] y_Q, Y_D; // y_Q represents current state, Y_D represents next state
    reg [5:0] RESET = 5'b000000;
    localparam A = 4'b0000, B = 4'b0001, C = 4'b0010, D = 4'b0011, E = 4'b0100, F = 4'b0101, G = 4'b0110,H = 4'b0111;
    wire [6:0]outputcard;
	 wire [6:0]outputcard2;
    assign P1 = SW[1];
	 assign P2 = SW[19];
    assign clock = ~KEY[0];
	 
	 output [7:0] HEX1;
	 output [7:0] HEX4;
	 
	 
	input			CLOCK_50;
//outside module initiation *****************************************************************************************************
	drawcard drawacard(
				.draw(getcard),
				.drawncard(outputcard)
				);
	drawcard2 drawacard2(
				.draw(getcard2),
				.drawncard(outputcard2)
				);				
hex_display myhex1(
					.IN((player2total)),
					.OUT(HEX1)
					);
hex_display myhex4(
					.IN((player1total)),
					.OUT(HEX4)
					);
		
	 drawui display (
		.LSCORE_1(5'b00000), // input character values
		.LSCORE_2(5'b00000),
		.LSCORE_3({2'b00,player1score}),
		.RSCORE_1(5'b00000),
		.RSCORE_2(5'b00000),
		.RSCORE_3({2'b00,player2score}),
		.LCARD_1(trunc_7_to_6(player1card/13)),
		.LCARD_2(trunc_7_to_6(player1card%13)),
		.RCARD_1(trunc_7_to_6(player2card/13)),
		.RCARD_2(trunc_7_to_6(player2card%13)),
		.LTOTAL_1(({1'b0,(player1total/10)})),
		.LTOTAL_2(({1'b0,(player1total%10)})),
		.RTOTAL_1(({1'b0,(player2total/10)})),
		.RTOTAL_2(({1'b0,(player2total%10)})), 
		.CLOCK_50(CLOCK_50),//	On Board 50 MHz),//	On Board 50 MHz
		// The ports below are for the VGA output.  Do not change.
		.VGA_R(VGA_R),
		.VGA_G(VGA_G),
		.VGA_B(VGA_B),
		.VGA_HS(VGA_HS),
		.VGA_VS(VGA_VS),
		.VGA_BLANK_N(VGA_BLANK_N),
		.VGA_SYNC_N(VGA_SYNC_N),
		.VGA_CLK(VGA_CLK),
		.RESET(RESET)
		);
//*******************************************************************************************************************************
    //State table
    //The state table should only contain the logic for state transitions
    //Do not mix in any output logic. The output logic should be handled separately.
    //This will make it easier to read, modify and debug the code
    always@(*)
    begin: state_table
        case (y_Q)
		  // both people will draw one card
            A: begin
                   if (P1 && P2) Y_D <= A;
                   else if (P1 && !P2) Y_D <= C;
						 else if (!P1 && P2) Y_D <= D;
						 else Y_D <= H;
               end
			// player1 draws
            C:  begin
                    if (P1) Y_D <= C;
						 else if (!P1) Y_D <= H;
               end
			// player2 draws
            D: begin
                    if (P2) Y_D <= D;
						 else if (!P2) Y_D <= H;
               end
				H:begin
						if (~KEY[3])
							begin
								Y_D <= A;
								roundcount = roundcount + 1;
							end
				  end
            default: Y_D = A;
        endcase
    end // state_table
	 // state arrangement ***************************************************************
    always @(posedge clock)
    begin: state_FFs
        if(y_Q == A)
		  begin
		  //draw 2 cards
				getcard <= getcard +1;
				player1card <= outputcard;
				getcard2 <= getcard2 + 1;
				player2card <= outputcard2;
				player1total <= player1total + ({3'b000,player1card} % 13);
				player2total <= player2total + ({3'b000,player2card} % 13);			
				RESET <= RESET + 1;
				// if both players go over 21 end the game
				if(player2total > 21 && player1total > 21) begin
					player1total <= 0;
					player2total <= 0;
					y_Q <= H;
					end
				else if (player2total > 21) y_Q <= C;
				else if (player1total > 21) y_Q <= D;
				else y_Q <= Y_D;

		  end
		  else if(y_Q == C)
		  begin
		  //draw for player 1
				getcard <= getcard + 1;
				player1card <= outputcard;
				player1total <= player1total + ({3'b000,player1card} % 13);
				RESET <= RESET + 1;
				if(player1total > 21)begin
				// if both player1 go over 21 end the game
					if(player2total <= 21) player2score = player2score + 1;
					player1total <= 0;
					player2total <= 0;
					y_Q <= H;
				end
				else y_Q <= Y_D;
		  end
		  else if(y_Q == D)
		  begin
		  //draw for player 2
				getcard2 <= getcard2 + 1;
				player2card <= outputcard2;
				player2total <= player2total + ({3'b000,player2card} % 13);
				RESET = RESET + 1;
				// if player 2 goes over 21
				if(player2total > 21)
				begin
				if(player1total <= 21) player1score = player1score + 1;
				player1total <= 0;
				player2total <= 0;
				y_Q <= H;
				end
				else y_Q <= Y_D;
		  end
		  else if(y_Q == H)
		  begin
		  // NEED AN IF STAEMENT HERE TO CHECK THE TOTALS
            y_Q <= Y_D;
		  end
    end // state_FFS
endmodule



module drawcard(draw, drawncard);
	input [6:0]draw; // whether to draw a card
	output reg [6:0] drawncard; // the current drawn card value
	
	// could not get pseudo random number generator to work, temp solution
	// array of random numbers 0-51
	reg [6:0] randomcard [103:0];
	//initial
	//begin
	always @(draw) // whenever we want to draw a card
	begin
	randomcard[0] = 5;
	randomcard[1] = 2;
	randomcard[2] = 19;
	randomcard[3] = 12; 
	randomcard[4] = 14;
	randomcard[5] = 13;
	randomcard[6] = 1;
	randomcard[7] = 25;
	randomcard[8] = 28;
	randomcard[9] = 32;
	randomcard[10] = 35;
	randomcard[11] = 34;
	randomcard[12] = 15;
	randomcard[13] = 24;
	randomcard[14] = 12;
	randomcard[15] = 20;
	randomcard[16] = 47;
	randomcard[17] =  1;
	randomcard[18] = 42;
	randomcard[19] = 50;
	randomcard[20] = 49;
	randomcard[21] =  0;
	randomcard[22] = 41;
	randomcard[23] = 17;
	randomcard[24] =  6;
	randomcard[25] = 21;
	randomcard[26] = 45;
	randomcard[27] = 43;
	randomcard[28] = 18;
	randomcard[29] =  8;
	randomcard[30] = 37;
	randomcard[31] = 29;
	randomcard[32] = 10;
	randomcard[33] = 39;
	randomcard[34] = 44;
	randomcard[35] = 26;
	randomcard[36] = 11;
	randomcard[37] = 25;
	randomcard[38] =  5;
	randomcard[39] = 30;
	randomcard[40] = 36;
	randomcard[41] = 33;
	randomcard[42] = 46;
	randomcard[43] =  9;
	randomcard[44] =  3;
	randomcard[45] =  7;
	randomcard[46] =  2;
	randomcard[47] = 51;
	randomcard[48] =  4;
	randomcard[49] = 38;
	randomcard[50] = 19;
	randomcard[51] = 48; // new deck starts after this line
	//end
	

		drawncard <= randomcard[draw];
	end
endmodule

module drawcard2(draw, drawncard);
	input [6:0]draw; // whether to draw a card
	output reg [6:0] drawncard; // the current drawn card value
	
	// could not get pseudo random number generator to work, temp solution
	// array of random numbers 0-51
	reg [6:0] randomcard [103:0];
	//initial
	//begin
	always @(draw) // whenever we want to draw a card
	begin
	randomcard[0] = 1;
	randomcard[1] = 2;
	randomcard[2] = 3;
	randomcard[3] = 4;
	randomcard[4] = 5;
	randomcard[5] = 6;
	randomcard[6] = 15;
	randomcard[7] = 2;
	randomcard[8] = 28;
	randomcard[9] = 32;
	randomcard[10] = 35;
	randomcard[11] = 34;
	randomcard[12] = 15;
	randomcard[13] = 24;
	randomcard[14] = 12;
	randomcard[15] = 20;
	randomcard[16] = 47;
	randomcard[17] =  1;
	randomcard[18] = 42;
	randomcard[19] = 50;
	randomcard[20] = 49;
	randomcard[21] =  0;
	randomcard[22] = 41;
	randomcard[23] = 17;
	randomcard[24] =  6;
	randomcard[25] = 21;
	randomcard[26] = 45;
	randomcard[27] = 43;
	randomcard[28] = 18;
	randomcard[29] =  8;
	randomcard[30] = 37;
	randomcard[31] = 29;
	randomcard[32] = 10;
	randomcard[33] = 39;
	randomcard[34] = 44;
	randomcard[35] = 26;
	randomcard[36] = 11;
	randomcard[37] = 25;
	randomcard[38] =  5;
	randomcard[39] = 30;
	randomcard[40] = 36;
	randomcard[41] = 33;
	randomcard[42] = 46;
	randomcard[43] =  9;
	randomcard[44] =  3;
	randomcard[45] =  7;
	randomcard[46] =  2;
	randomcard[47] = 51;
	randomcard[48] =  4;
	randomcard[49] = 38;
	randomcard[50] = 19;
	randomcard[51] = 48; // new deck starts after this line
	//end

		drawncard <= randomcard[draw];
	end
endmodule



module hex_display(IN, OUT);
    input [3:0] IN;
	 output reg [7:0] OUT;
	 
	 always @(*)
	 begin
		case(IN[3:0])
			4'b0000: OUT = 7'b1000000;
			4'b0001: OUT = 7'b1111001;
			4'b0010: OUT = 7'b0100100;
			4'b0011: OUT = 7'b0110000;
			4'b0100: OUT = 7'b0011001;
			4'b0101: OUT = 7'b0010010;
			4'b0110: OUT = 7'b0000010;
			4'b0111: OUT = 7'b1111000;
			4'b1000: OUT = 7'b0000000;
			4'b1001: OUT = 7'b0011000;
			4'b1010: OUT = 7'b0001000;
			4'b1011: OUT = 7'b0000011;
			4'b1100: OUT = 7'b1000110;
			4'b1101: OUT = 7'b0100001;
			4'b1110: OUT = 7'b0000110;
			4'b1111: OUT = 7'b0001110;
			
			default: OUT = 7'b0111111;
		endcase

	end
endmodule