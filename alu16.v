`timescale 1ns / 1ps
/***********************************************************************************
*
* Designer: Hung Le, Justin Maeder
* Email: 	hungx92@yahoo.com, Justin_maeder@hotmail.com
* Filename: alu16.v
* Date:		May 07, 2018
* Version:	14.7
*
* Purpose:  This module performs 16 bit operations on two inputs(R&S) using the 
*				operation selector (ALU_OP). The 4 bit ALU_OP allows for 16 unique 
*				operations. This module supports 13 operations: Passing data, increment,
*				decrement, add, subtract, shift left/right, logic and/or/xor/not/negation.
*				It outputs a 16 bit value, a carry, zero, and negative signals. The 
*				default for the function is to pass the S input. 
*
***********************************************************************************/
module alu16(R, S, ALU_OP, Y, N, Z, C);
	input  	  	[15:0] 	R, S;
	input	  		[3:0] 	ALU_OP;
	output reg 	[15:0] 	Y;
	output reg 				N, Z, C;
	
	always @ (R, S, ALU_OP) begin
		case (ALU_OP)
			4'b0000:		{C,Y} = {1'b0,S};			// pass S
			4'b0001:		{C,Y} = {1'b0,R};			// pass R
			4'b0010:		{C,Y} = S + 1;				// increment S
			4'b0011:		{C,Y} = S - 1;				// decrement S
			4'b0100:		{C,Y} = R + S;				// add
			4'b0101:		{C,Y} = R - S;				// subtract
			4'b0110:		begin							// right shift S (logic)
								C = S[0];				//		LSB gets saved into carry out
								Y = S >> 1;				//		{C,4} = {S[0], 1'b0, S[15:1]}
							end
			4'b0111:		begin							// left shift S (logic)
								C = S[15];				//		MSB gets saved into carry out
								Y = S << 1;				//		{C,4} = {S[15], S[14:0], 1'b0}
							end
			4'b1000:		{C,Y} = {1'b0, R & S};  // logic and
			4'b1001:		{C,Y} = {1'b0, R | S};  // logic or
			4'b1010:		{C,Y} = {1'b0, R ^ S};  // logic xor
			4'b1011:		{C,Y} = {1'b0, ~S};     // logic not S (1's comp)
			4'b1100:		{C,Y} = 0 - S;  			// negate S 	(2's comp)
			default:		{C,Y} = {1'b0, S};		// pass S for default
		endcase
		
		//handle last two status flags
		N = Y[15];										// Negative value based on MSB
		if (Y == 16'b0)
			Z = 1'b1;									// Zero-value flag
		else
			Z = 1'b0;
	
	end	// end - always
	
endmodule 