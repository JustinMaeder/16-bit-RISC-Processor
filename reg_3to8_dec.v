`timescale 1ns / 1ps
/***********************************************************************************
*
* Designer: Hung Le, Justin Maeder
* Email: 	hungx92@yahoo.com, Justin_maeder@hotmail.com
* Filename: reg_3to8_dec.v
* Date:		May 07, 2018
* Version:	14.7
*
* Purpose:  This module contains a 3_to_8 decoder. On the positive edge of enable
*				or positive edge of 3-bit data-in, a case statement is used to decode
*			   3-bit input to 8-bit "Walking 1's".
*
***********************************************************************************/

module reg_3to8_dec(in, en, Y);
	input  		     en;
	input  	  [2:0] in;						// 3-bit input
	output reg [7:0] Y;						// 8-bit output; internal variable
	
	always @ (en,in) begin
		Y=0;
		if (en) begin
			case (in)							// Check all of the 8 combinations
			  3'b000  : Y = 8'b00000001;
			  3'b001  : Y = 8'b00000010;
			  3'b010  : Y = 8'b00000100;
			  3'b011  : Y = 8'b00001000;
			  3'b100  : Y = 8'b00010000;
			  3'b101  : Y = 8'b00100000;
			  3'b110  : Y = 8'b01000000;
			  3'b111  : Y = 8'b10000000;
			  default : Y = 8'b00000000;  // Default case value to make sure latches
			endcase								// 	aren't created
		end	// end-if
	end		// end-always block
endmodule
