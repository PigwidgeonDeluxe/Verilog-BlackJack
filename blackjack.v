module blackjack(SW, KEY, LEDR);

    input [9:0] SW;
    input [3:0] KEY;
    output [9:0] LEDR;
	 reg [2:0]roundcount = 3'b000;
    wire p1, p2,done,total, clock, resetn, out_light;
	 reg [3:0]player1card;
	 reg [4:0]player1total = 5'b00000;
	 reg [2:0]player1score = 3'b000;
	 reg [3:0]player2card;
	 reg [4:0]player2total = 5'b0000;
	 reg [2:0]player2score = 3'b000;
	 reg [6:0]outputcard;
	 wire getcard = 1'b0;
    reg [3:0] y_Q, Y_D; // y_Q represents current state, Y_D represents next state
    
    localparam A = 4'b0000, B = 4'b0001, C = 4'b0010, D = 4'b0011, E = 4'b0100, F = 4'b0101, G = 4'b0110,H = 4'b0111;
    wire [6:0]outputcard;
    assign p1 = SW[1];
	 assign p2 = SW[19];
    assign clock = ~KEY[0];
//    assign resetn = SW[0];

    //State table
    //The state table should only contain the logic for state transitions
    //Do not mix in any output logic. The output logic should be handled separately.
    //This will make it easier to read, modify and debug the code.
    always@(*)
    begin: state_table
        case (y_Q)
		  // both people will draw one card
            A: begin
                   if (P1 && P2) Y_D <= A ;
                   else if (P1 && !P2) Y_D <= C;
						 else if (!P1 && P2) Y_D <= D;
						 else Y_D <= H;
               end
 /*           B: begin
                   if (P1 && P2) Y_D <= B;
                   else if (P1 && !P2) Y_D <= C;
						 else if (!P1 && P2) Y_D <= D;
						 else Y_D <= H;
               end */
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
 /*           E:begin
						if (done) 
						begin
						Y_D <= C;
						done = 1'b0;
						end 
				  end
            F:begin
						if (done) 
						begin
						Y_D <= D;
						done = 1'b0;
						end 
				  end
            G:begin
						if (done) 
						begin
						Y_D <= B;
						done = 1'b0;
						end 
				  end */
				//endscreen
				H:begin
						if (~KEY[4])
							begin
								Y_D <= A;
								roundcount = roundcount + 1;
							end
				  end
            default: Y_D = A;
        endcase
    end // state_table
	drawcard drawacard(
				.draw(getcard),
				.drawncard(outputcard)
				);
    // State Registers
    always @(posedge clock)
    begin: state_FFs
        else if(Y_Q = A)
		  begin
		  //draw 2 cards
				draw = 1'b1;
				player1card <= outputcard;
				draw = 1'b1;
				player2card <= outputcard;
				player1total = player1total + player1card;
				player2total = player2total + player2card;				
            y_Q <= Y_D;
				// if both players go over 21 end the game
				if(player2total > 5'b10101 || player1total >5'b10101)
				begin
				player1total = 5'b00000;
				player2total = 5'b00000;
				y_Q <= H;
				end
				else if (player2total > 5'b10101) y_Q <= C;
				else if (player2total > 5'b10101) y_Q <= D;
				else y_Q <= Y_D;
		  end
		  else if(Y_Q = C)
		  begin
		  //draw for player 1 
				draw = 1'b1;
				player1card <= outputcard;
				player1total = player1total + player1card;
				if(player1total > 5'b10101)
				begin
				// if both player1 go over 21 end the game
				player1total = 5'b00000;
				player2total = 5'b00000;
				player2score = player2score + 1'b1;
				y_Q <= H;
				end
				else y_Q <= Y_D;
		  end
		  else if(Y_Q = D)
		  begin
		  //draw for player 2
				draw = 1'b1;
				player2card <= outputcard;
				player2total = player2total + player2card;
				// if player 2 goes over 21
				if(player2total > 5'b10101)
				begin
				player1total = 5'b00000;
				player2total = 5'b00000;
				player1score = player1score + 1'b1;
				y_Q <= H;
				end
				else y_Q <= Y_D;
		  end
		  else if(Y_Q = H)
		  begin
            y_Q <= Y_D;
		  end
    end // state_FFS

    // Output logic
endmodule



module drawcard(draw, drawncard);
	input draw; // whether to draw a card
	output reg [6:0] drawncard; // the current drawn card value
	
	// could not get pseudo random number generator to work, temp solution
	// array of random numbers 0-51
	reg randomcard [103:0];
	initial
	begin
	randomcard[0] =  23;
	randomcard[1] = 27;
	randomcard[2] = 14;
	randomcard[3] = 13;
	randomcard[4] = 31;
	randomcard[5] = 40;
	randomcard[6] = 22;
	randomcard[7] = 16;
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

	randomcard[52] = 21;
	randomcard[53] = 4;
	randomcard[54] =  8;
	randomcard[55] = 16;
	randomcard[56] = 32;
	randomcard[57] = 43;
	randomcard[58] = 34;
	randomcard[59] = 18;
	randomcard[60] = 36;
	randomcard[61] = 51;
	randomcard[62] = 46;
	randomcard[63] = 14;
	randomcard[64] =  0;
	randomcard[65] = 27;
	randomcard[66] = 41;
	randomcard[67] = 26;
	randomcard[68] = 30;
	randomcard[69] = 40;
	randomcard[70] =  3;
	randomcard[71] =  9;
	randomcard[72] = 23;
	randomcard[73] =  6;
	randomcard[74] = 49;
	randomcard[75] = 48;
	randomcard[76] = 10;
	randomcard[77] = 31;
	randomcard[78] = 12;
	randomcard[79] = 39;
	randomcard[80] = 33;
	randomcard[81] = 24;
	randomcard[82] = 19;
	randomcard[83] = 50;
	randomcard[84] = 11;
	randomcard[85] = 15;
	randomcard[86] = 47;
	randomcard[87] =  5;
	randomcard[88] = 45;
	randomcard[89] = 29;
	randomcard[90] =  1;
	randomcard[91] = 38;
	randomcard[92] = 17;
	randomcard[93] = 37;
	randomcard[94] = 42;
	randomcard[95] = 28;
	randomcard[96] =  2;
	randomcard[97] = 44;
	randomcard[98] = 35;
	randomcard[99] =  7;
	randomcard[100] = 13;
	randomcard[101] = 25;
	randomcard[102] = 20;
	randomcard[103] = 22;
	end
	
	reg [6:0] counter = 0;
	
	always @(draw) // whenever we want to draw a card
	begin
		drawncard = randomcard[counter];
		counter = counter + 1; // increment counter
		if (counter > 103)
			counter = 0;
		draw = 1'b0;
	end
endmodule