`timescale 1ns / 1ps
/***********************************************************************************
* 
* Designer: Hung Le, Justin Maeder
* Email: 	hungx92@yahoo.com, Justin_maeder@hotmail.com
* Filename: pixel_clk.v
* Date:		May 07, 2018
* Version:	14.7
*
* Purpose: This module provides a clock output of 480hz by counting the incoming 
*			 clock 104166 times. 
*				
***********************************************************************************/

module pixel_clk(clk_in, reset, clk_out);
	input 	clk_in, reset; 
	output 	clk_out;
	reg 		clk_out; 
	integer 	i;
	
	//***************************************************************
	// The following verilog code will "divide" an incoming clock
	//	by the 32-bit dedcimal value specified in the "if condition"
	// 
	// The value of the counter that counts the incoming clock ticks
	// is equal to [ (Incoming Freq / Outgoing Freg) / 2 ]
	//***************************************************************
	
	always @(posedge clk_in, posedge reset)
		if (reset == 1'b1) begin
			i = 0;
			clk_out = 0;   
		end
		else begin 
			i = i + 1;
			if (i >= 104166) begin // x = (100MHz / 480Hz) /2 
				clk_out = ~clk_out;
				i = 0; 
			end
		end
endmodule
