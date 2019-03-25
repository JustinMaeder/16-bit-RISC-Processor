`timescale 1ns / 1ps
/***********************************************************************************
*
* Designer: Hung Le, Justin Maeder
* Email: 	hungx92@yahoo.com, Justin_maeder@hotmail.com
* Filename: CPU_EU.v
* Date:		May 07, 2018
* Version:	14.7
*
* Purpose: The purpose of the program counter register is when inc is enabled, the
*			  value of Dout is incremented by 1. If load is enabled, Dout gets Din.
*			  Else if increment and load are both enabled or both disabled, Dout gets 
*			  Dout. If reset, Dout gets 16-bit 0's.
*				
***********************************************************************************/

module PC(clk, reset, ld, inc, Din, Dout);
	input 				clk, reset, ld, inc;
	input 	  [15:0] Din;
	output reg [15:0] Dout;
	
	always @(posedge clk, posedge reset) begin
		//if reset asserted, pc gets 0 
		if (reset == 1'b1) Dout <= 16'b0; 
		else
			case({ld,inc})
				2'b0_1:  Dout <= Dout + 1; //inc enable
				2'b1_0:  Dout <= Din;	   //load enable
				default: Dout <= Dout;     //both high or both low	
			endcase
	end
endmodule 