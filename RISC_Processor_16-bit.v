`timescale 1ns / 1ps
/***********************************************************************************
*
* Designer: Hung Le, Justin Maeder
* Email: 	hungx92@yahoo.com, Justin_maeder@hotmail.com
* Filename: RISC_Processor_16bit.v
* Date:		May 07, 2018
* Version:	14.7
*
* Purpose: This RISC_Processor module instantiates an execution unut and a control
*				unit. The execution unit will take inputs from the control unit.
*				The outputs an 16 bit address, data, and an 8 bit status. It will 
*				take a 16 bit input from ram. The first 7 bits of the input data is
*				the opcode and the other 9 are divided to 3 different register  
*				numbers. The cu will output different control signals to the execution
*				depending on the opcode.  
*
***********************************************************************************/
module RISC_Processor(clk, reset, Address, D_in, D_out, mw_en, Status);
	// input & output declaration
	input 		  clk, reset;
	input  [15:0] D_in;
	output 		  mw_en;
	output [15:0] Address, D_out;
	output  [7:0] Status;
	
	// wire declaration
	wire 		   rw_en, s_sel, adr_sel, ir_ld, pc_ld, pc_inc, pc_sel, C, N, Z;
	wire [2:0]  W_Adr, R_Adr, S_Adr;
	wire [3:0]  Alu_Op;
	wire [15:0] IR_out;
	
	CPU_EU  CPU_EU0(.clk(clk),
						 .reset(reset), 
						 .W_Adr(W_Adr),    //3-bit write
						 .R_Adr(R_Adr),    //3-bit read
						 .S_Adr(S_Adr),    //3-bit read
						 .Alu_Op(Alu_Op),  //4-bit op for alu
						 .adr_sel(adr_sel),//select reg_out or pc_out
						 .s_sel(s_sel),    //select ds or s_adr
						 .pc_ld(pc_ld),    //load pc
						 .pc_inc(pc_inc),  //increment pc
						 .reg_w_en(rw_en), //write enable reg file
						 .ir_ld(ir_ld),    //load ir reg
						 .D_in(D_in), 	    //data from ram
						 .Address(Address),//address output to ram  
						 .D_out(D_out),    //output of alu
						 .IR_out(IR_out),  //intruction to cu 
						 .pc_sel(pc_sel),  //address increment or jump 
						 .C(C),			    //carry
						 .N(N),			    //negative
						 .Z(Z));		   	 //zero

						 //inputs
	cu 			cu0(.clk(clk),
						 .reset(reset), 
						 .IR(IR_out),	    //16 bit instruction 
						 .N(N),			    //negative
						 .Z(Z),			    //zero
						 .C(C),			    //carry
						 
						 //output controls to cpu eu 
						 .W_Adr(W_Adr),	   
						 .R_Adr(R_Adr),	   	
						 .S_Adr(S_Adr),	   
						 .adr_sel(adr_sel),
						 .s_sel(s_sel),
						 .pc_ld(pc_ld),
						 .pc_inc(pc_inc),
						 .pc_sel(pc_sel),
						 .ir_ld(ir_ld),
						 .mw_en(mw_en),
						 .rw_en(rw_en),
						 .alu_op(Alu_Op),  
						 .status(Status)); //8-bit status flag. 				 
	
endmodule
