`timescale 1ns / 1ps
/***********************************************************************************
* 
* Designer: Hung Le, Justin Maeder
* Email: 	hungx92@yahoo.com, Justin_maeder@hotmail.com
* Filename: ad_mux.v
* Date:		May 07, 2018
* Version:	14.7
*
* Purpose:   This mux chooses data from the input of switches and address sequencer.
*			 The select is from pixel controller state machine. It will chose the data 
*  		 corresponding to each state(anode). 
*	
***********************************************************************************/

module ad_mux(sel, D, Y);
	input   		[2:0] sel; 
	input  	  [31:0] D;
	output reg  [3:0] Y; 
	
	always @ (*)
		case(sel) 
			3'b000: Y = D  [3:0]; // seg0
			3'b001: Y = D  [7:4]; // seg1
			3'b010: Y = D [11:8]; // seg2
			3'b011: Y = D[15:12]; // seg3
			
			3'b100: Y = D[19:16]; // seg4
			3'b101: Y = D[23:20]; // seg5
			3'b110: Y = D[27:24]; // seg6
			3'b111: Y = D[31:28]; // seg7
			
			default:Y = D  [3:0]; // seg0 - default
		endcase
endmodule
