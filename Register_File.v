`timescale 1ns / 1ps
/***********************************************************************************
*
* Designer: Hung Le, Justin Maeder
* Email: 	hungx92@yahoo.com, Justin_maeder@hotmail.com
* Filename: Register_File.v
* Date:		May 07, 2018
* Version:	14.7
*
* Purpose: This Register_File wrapper module is used to put together eight instances
*			  of a 16-bit register, and three instances of a 3-to-8 decoder: W_Adr,
*			  R_Adr, and S_Adr. Control signals are active-high. Outputs R and S are 
*			  16-bit wide. Only the W_Adr decoder can be enabled or disabled. While   
*			  R_Adr and S_Adr are always enabled. 
*
***********************************************************************************/

module Register_File(clk, reset, W, W_Adr, we, R_Adr, S_Adr, R, S);

//variable instantiation
	input clk, reset, we;					// Wrapper global inputs
	input  [15:0] W;							// 16-bit data input
	input  [2:0]  W_Adr, R_Adr, S_Adr;	// 3-bit 3-to-8 decoder inputs

	output [15:0] R, S;						// Wrapper global outputs
	
	wire [7:0] ld, oeA, oeB;				// 8-bit wire from 3-8 decoder to 16-bit reg
	
	// Three instances of 3-to-8 decoders
	reg_3to8_dec w_adr(.in(W_Adr),		// Inputs written with the data on 16-bit W
						    .en(we),			// 	data input when (we) is asserted.
						    .Y(ld)),
						  
					 r_adr(.in(R_Adr),		// Contents of R data port addressed
						    .en(1'b1),
						    .Y(oeA)),
						 
					 s_adr(.in(S_Adr),		// Contents of S data port addressed
						    .en(1'b1),
						    .Y(oeB));	
							 
	// Eight instances of a 16-bit register
	reg16 			 R7(.clk(clk), 
							 .reset(reset), 
							 .ld(ld[7]), 
							 .Din(W), 
							 .DA(R), 
							 .DB(S), 
							 .oeA(oeA[7]), 
							 .oeB(oeB[7])),
							
						 R6(.clk(clk), 
							 .reset(reset), 
							 .ld(ld[6]), 
							 .Din(W), 
							 .DA(R), 
							 .DB(S), 
							 .oeA(oeA[6]), 
							 .oeB(oeB[6])),
							
						 R5(.clk(clk), 
							 .reset(reset), 
							 .ld(ld[5]), 
							 .Din(W), 
							 .DA(R), 
							 .DB(S), 
							 .oeA(oeA[5]), 
							 .oeB(oeB[5])),
							
						 R4(.clk(clk), 
							 .reset(reset), 
							 .ld(ld[4]), 
							 .Din(W), 
							 .DA(R), 
							 .DB(S), 
							 .oeA(oeA[4]), 
							 .oeB(oeB[4])),
							
						 R3(.clk(clk), 
							 .reset(reset), 
							 .ld(ld[3]), 
							 .Din(W), 
							 .DA(R), 
							 .DB(S), 
							 .oeA(oeA[3]), 
							 .oeB(oeB[3])),
							
						 R2(.clk(clk), 
							 .reset(reset), 
							 .ld(ld[2]), 
							 .Din(W), 
							 .DA(R), 
							 .DB(S), 
							 .oeA(oeA[2]), 
							 .oeB(oeB[2])),
							
						 R1(.clk(clk), 
							 .reset(reset), 
							 .ld(ld[1]), 
							 .Din(W), 
							 .DA(R), 
							 .DB(S), 
							 .oeA(oeA[1]), 
							 .oeB(oeB[1])),
							
						 R0(.clk(clk), 
							 .reset(reset), 
							 .ld(ld[0]), 
							 .Din(W), 
							 .DA(R), 
							 .DB(S), 
							 .oeA(oeA[0]), 
							 .oeB(oeB[0]));	
endmodule 