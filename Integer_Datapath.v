`timescale 1ns / 1ps
/***********************************************************************************
*
* Designer: Hung Le, Justin Maeder
* Email: 	hungx92@yahoo.com, Justin_maeder@hotmail.com
* Filename: Integer_Datapath.v
* Date:		May 07, 2018
* Version:	14.7
*
* Purpose:  This module instantiates a register file, 2-1 mux, and alu16 .The register
*				file allows storage for the outputs of the alu. The register file outputs 
*			   R & S. The S output goes into 2-1 mux along with DS(another 16 bit input)
*				which comes externally. This is a syncronous module so all operations are
*				done on the positive edge of the clock and when WE is active. 
*				
*
***********************************************************************************/
module Integer_Datapath(clk, reset, R_Adr, ALU_OP, DS, W_En, W_Adr, S_Adr, S_Sel, 
								C, N, Z, Reg_Out, Alu_Out);
	
	//variable instantiation
	input 		  clk, reset, W_En, S_Sel;
	input   [2:0] W_Adr, R_Adr, S_Adr;
	input   [3:0] ALU_OP;
	input	 [15:0] DS;
	
	output 		  C, N, Z;
	output [15:0] Reg_Out, Alu_Out;
	
	wire   [15:0] S, mux_out;
	
	Register_File	Reg_file0(.clk(clk),
									 .reset(reset),
									 .W(Alu_Out),		//4bit op code
									 .W_Adr(W_Adr),
									 .we(W_En),			//write enable
									 .R_Adr(R_Adr),
									 .S_Adr(S_Adr),
									 .R(Reg_Out),		//outputs
									 .S(S));			   //outputs
	
	assign mux_out = (S_Sel ==1'b1)? DS : S; //1 for DS
														  //0 for S 
									 
	alu16				alu0		(.R(Reg_Out),    //16bit input
									 .S(mux_out),	  //16bit input
									 .ALU_OP(ALU_OP),//4bit op code
									 .Y(Alu_Out),    //16bit output 
									 .N(N),			  //negative
									 .Z(Z),			  //zero
									 .C(C));			  //carry 
									 

endmodule 