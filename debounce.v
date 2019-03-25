`timescale 1ns / 1ps
/***********************************************************************************
*
* Designer: Hung Le, Justin Maeder
* Email: 	hungx92@yahoo.com, Justin_maeder@hotmail.com
* Filename: debounce.v
* Date:		May 07, 2018
* Version:	14.7
*
* Purpose: This module takes in a 500hz clock and waits for stabilization
*			  (about 20 ms) in the switch input Din. We can "wait" for this 
*          stabilization by sampling the inputs for when they are at a stable logic
*			  level 1. This module samples a 10 bit set. It will output a 1 when the
*			  MSB is 0 and the rest are 1 which produces a one-shot pulse.
*			  
***********************************************************************************/

module debounce(clk, reset, Din, Dout);
	input clk, reset, Din; 
	output Dout;
	wire Dout;
	
	reg q9, q8, q7, q6, q5, q4, q3, q2, q1, q0; // sample of 10 bits
	
	always @ (posedge clk or posedge reset)
		if (reset == 1'b1)//if reset is asserted all the bits will be 0 
			{q9, q8, q7, q6, q5, q4, q3, q2, q1, q0} <= 10'b0;
		
		else begin //else continue shifting in new samples one bit a time
			q9 <= q8; q8 <= q7; q7 <= q6; q6 <= q5; q5<= q4;
			q4 <= q3; q3 <= q2; q2 <= q1; q1 <= q0; q0<= Din;
		end
		
	// q9 is inverted, this will give us an output that is only 1 bit long
	//		when the MSB of the sample is 0 and the rest are 1. 
	assign Dout = !q9 & q8 & q7 & q6 & q5 & q4 & q3 & q2 & q1 & q0; 
	

endmodule 