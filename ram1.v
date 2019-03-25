`timescale 1ns / 1ps
/***********************************************************************************
*
* Designer: Hung Le, Justin Maeder
* Email: 	hungx92@yahoo.com, Justin_maeder@hotmail.com
* Filename: ram1.v
* Date:		May 07, 2018
* Version:	14.7
*
* Purpose: This module instantiates the ram_256x16.veo file. This module will
*			  provide a read/write width of 16 bits and a depth of 256 address
*			  lines. This creates Single Port Block RAM. The value decrements
*			  as the memory address increments starting with value 55FFh at
*			  memory address 00h. 
*				
***********************************************************************************/

module ram1(clk, we, addr, din, dout);

	input			  clk, we;
	input	  [7:0] addr;
	input  [15:0] din;
	output [15:0] dout;

ram_256x16a dut (
	.clka(clk),
	.wea(we),
	.addra(addr),		// Bus  [7:0]
	.dina(din),			// Bus [15:0]
	.douta(dout));		// Bus [15:0]

endmodule
