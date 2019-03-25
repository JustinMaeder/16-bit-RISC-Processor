`timescale 1ns / 1ps
/***********************************************************************************
*
* Designer: Hung Le, Justin Maeder
* Email: 	hungx92@yahoo.com, Justin_maeder@hotmail.com
* Filename: reg16.v
* Date:		May 07, 2018
* Version:	14.7
*
* Purpose: This module is a 16 bit register that holds binary data. This register is
*			  modified to output two 16 bit serial data depending on the inputs DA
*			  and DB. The register will hold a value of zero when reset is active.
*			  Otherwise on the posedge of clock, it holds the current data or 
*			  load in data when ld signal is active. 
* 	
***********************************************************************************/
module reg16(clk, reset, ld, Din, DA, DB, oeA, oeB);
	
	input			  clk, reset, ld, oeA, oeB;
	input	 [15:0] Din;
	output [15:0] DA, DB;
	reg	 [15:0] Dout;
	
	// behavioral section for writing to the register
	always @ (posedge clk or posedge reset)
		if (reset)
			Dout <= 16'b0;
		else
			if (ld)
				  Dout <= Din;
			else Dout <= Dout;
			
	// conditional continuous assignments for reading the register
	assign DA = oeA ? Dout : 16'hz;
	assign DB = oeB ? Dout : 16'hz;

endmodule
