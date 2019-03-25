`timescale 1ns / 1ps
/***********************************************************************************
*
* Designer: Hung Le, Justin Maeder
* Email: 	hungx92@yahoo.com, Justin_maeder@hotmail.com
* Filename: CPU_EU.v
* Date:		May 07, 2018
* Version:	14.7
*
* Purpose: The purpose of the 16-bit CPU_EU wrapper is to combine the integer 
*			  datapath, program counter registers and 2-to-1 pc-mux, an address 2-to-1
*			  mux, a sign extension function and 16-bit add 2-to-1 mux. The address
*			  and D_out are 16-bit outputs that will connect to memory. D_in is the
*			  only 16-bit wrapper input come from the output of Memory. The CPU_EU
*			  module will output a flag if a value that is produced is either negative,
*			  zero, or contains a carry.
*				
***********************************************************************************/

module CPU_EU(clk, reset, W_Adr, R_Adr, S_Adr, Alu_Op,
				  adr_sel, s_sel,
				  pc_ld, pc_inc, reg_w_en, ir_ld, pc_sel, D_in,
				  Address, D_out, IR_out, C, N, Z);
	
	// input/output declarations
	input 		  clk, reset, adr_sel, s_sel, pc_ld, pc_inc, reg_w_en, ir_ld, pc_sel;
	input	 [2:0]  W_Adr, R_Adr, S_Adr; 
	input  [3:0]  Alu_Op;
	input  [15:0] D_in; 						  // Global input
	output [15:0] Address, D_out, IR_out; // Global outputs
	output 		  C, N, Z; 					  // flags
	
	// wire declarations
	wire [15:0] Reg_out, Alu_Out, PC_out, pc_mux_out, sign_ext, pc_for_jump;

	Integer_Datapath ID0 (.clk		(clk), 
								 .reset	(reset), 
								 .R_Adr	(R_Adr), 
								 .ALU_OP	(Alu_Op),  
								 .DS		(D_in),    //16bit input 
								 .W_En	(reg_w_en),//write to reg file  
								 .W_Adr	(W_Adr), 
								 .S_Adr	(S_Adr), 
								 .S_Sel	(s_sel), 
								 .C		(C), 
								 .N		(N), 
								 .Z		(Z), 
								 .Reg_Out(Reg_out),//address out to ram  
								 .Alu_Out(D_out)); //data out to ram 
								 
	assign sign_ext    = {{8{IR_out[7]}},IR_out[7:0]};    //sign extended to 16 bit 
	assign pc_for_jump = PC_out + sign_ext;                					
	assign pc_mux_out  = (pc_sel == 1'b1) ? D_out : pc_for_jump;//1 for data		
																					//0 for jump 	
	PC					  PC0 (.clk	  (clk), 
								 .reset (reset), 
								 .ld	  (pc_ld), 		//ld and in are mutually 
								 .inc	  (pc_inc), 	//exclusive
								 .Din	  (pc_mux_out), 
								 .Dout  (PC_out)),
								
						  IR0 (.clk	  (clk), 
								 .reset (reset), 
								 .ld	  (ir_ld), 
								 .inc	  (1'b0), 		//IR will never increment 
								 .Din	  (D_in), 
								 .Dout  (IR_out));   //16bit output 
								 
	assign Address = (adr_sel==1'b1) ? Reg_out : PC_out;							 
endmodule 