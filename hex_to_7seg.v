`timescale 1ns / 1ps
/***********************************************************************************
* 
* Designer: Hung Le, Justin Maeder
* Email: 	hungx92@yahoo.com, Justin_maeder@hotmail.com
* Filename: hex_to_7seg.v
* Date:		May 07, 2018
* Version:	14.7
*
* Purpose:   This module is a deoder from hex to the 7 segment display. A case
*			 statement is used to enable specific segment depending on the input of 
*			 hex numbers. The 7 segment are names a-g and can be turned on by driving
*			 that segment with a binary 0. The outputs of the hex_to_7segment module 
*			 (a-g) are represented by the following pattern:
*						a
*				  	  ---
*				 f |		| b
*					|	g	|
*					  ---
*				 e |		| c
*					|	d	|
*					  ---
*				
***********************************************************************************/

module hex_to_7seg(hex, a, b, c, d, e, f, g);
	input [3:0] hex;
	output reg a,b,c,d,e,f,g; //instatiate the segments
	
	always @ (*)
		case(hex)
			4'h0: {a,b,c,d,e,f,g} = 7'b0000001;//display 0 
			4'h1: {a,b,c,d,e,f,g} = 7'b1001111;//display 1
			4'h2: {a,b,c,d,e,f,g} = 7'b0010010;//display 2
			4'h3: {a,b,c,d,e,f,g} = 7'b0000110;//display 3
			
			4'h4: {a,b,c,d,e,f,g} = 7'b1001100;//display 4
			4'h5: {a,b,c,d,e,f,g} = 7'b0100100;//display 5
			4'h6: {a,b,c,d,e,f,g} = 7'b0100000;//display 6
			4'h7: {a,b,c,d,e,f,g} = 7'b0001111;//display 7
			
			4'h8: {a,b,c,d,e,f,g} = 7'b0000000;//display 8
			4'h9: {a,b,c,d,e,f,g} = 7'b0001100;//display 9
			4'hA: {a,b,c,d,e,f,g} = 7'b0001000;//display A
			4'hB: {a,b,c,d,e,f,g} = 7'b1100000;//display b
			
			4'hC: {a,b,c,d,e,f,g} = 7'b0110001;//display c
			4'hD: {a,b,c,d,e,f,g} = 7'b1000010;//display d
			4'hE: {a,b,c,d,e,f,g} = 7'b0110000;//display E
			4'hF: {a,b,c,d,e,f,g} = 7'b0111000;//display F
			
			default {a,b,c,d,e,f,g} = 7'b0110110;
		endcase 
endmodule 