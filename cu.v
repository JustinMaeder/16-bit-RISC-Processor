`timescale 1ps / 100fs
/***********************************************************************************
*
* Designer: Hung Le, Justin Maeder
* Email: 	hungx92@yahoo.com, Justin_maeder@hotmail.com
* Filename: cu.v
* Date:		May 07, 2018
* Version:	14.7
*
* Purpose: The purpose of the control unit or "cu" is to implement a Moore finate
*			  state machine that has states to reset, fetch, decode, and executes 
*			  16 different instructions and 1 illegal op. The cu is considered the
*			  "braun" for the cpu_eu or "brain." In the cu, the control signals for the
*			  CPU_EU and memory (256x16) are a function of the present state. 	  
*			  
***********************************************************************************/

//******************************************************************* 
module cu (clk, reset, IR, N, Z, C,			// control unit inputs
			  W_Adr, R_Adr, S_Adr,				// these are
			  adr_sel, s_sel,						// the control
			  pc_ld, pc_inc, pc_sel, ir_ld,	//		word output
			  mw_en, rw_en, alu_op,				//			fields
			  status);								// LED outputs
//*******************************************************************

	input			 clk, reset;						 //clock and reset
	input [15:0] IR;									 //instruction register input
	input			 N, Z, C;							 //datapath status inputs
	output [2:0] W_Adr, R_Adr, S_Adr;			 //register file address outputs
	output		 adr_sel, s_sel;					 //mux select outputs
	output		 pc_ld, pc_inc, pc_sel, ir_ld; //pc load, pcinc, pc select, ir load
	output		 mw_en, rw_en;						 //memory_write, register_file write
	output [3:0] alu_op;								 //ALU opcode output
	output [7:0] status;								 //8 LED outputs-displays current state
	 

	/****************************
	*	data structures	*
	****************************/

	reg	[2:0] W_Adr, R_Adr, S_Adr;	//these 12
	reg			adr_sel, s_sel;		// fields
	reg			pc_ld, pc_inc;			// make up
	reg			pc_sel, ir_ld;			//	the
	reg			mw_en, rw_en;			//	control word
	reg	[3:0] alu_op;					//	of the control unit
	reg	[4:0] state;					// present state register
	reg	[4:0] nextstate;				// next state register
	reg	[7:0] status;					// LED status/state outputs
	reg			ps_N, ps_Z, ps_C;		// present state flags register
	reg			ns_N, ns_Z, ns_C;		// next state flags register

	parameter	RESET=0, FETCH=1, DECODE=2,
					ADD=3,	SUB=4,	CMP=5,	MOV=6, INC=7,	DEC=8,	SHL=9,	SHR=10, 
					LD_=11,	STO=12,	LDI=13,  JE=14, JNE=15,	JC=16,	JMP=17, HALT=18,
					ILLEGAL_OP=31;

	/*********************************
	*	301 Control Unit Sequencer *
	*********************************/

	// synchronous state register assignment 
	always @(posedge clk or posedge reset)
		if (reset) state = RESET; 
		else 		  state = nextstate;

	// synchronous flags register assignment 
	always @(posedge clk or posedge reset)
		if (reset) {ps_N,ps_Z,ps_C} = 3'b0; 
		else		  {ps_N,ps_Z,ps_C} = {ns_N,ns_Z,ns_C};

	// combinational logic section for both next state logic
	// and control word outputs for cpu_execution_unit and memory 
	always @( state )
		case ( state )
			//Default Control Word Values -- LED pattern = 1111_111
			RESET: begin	 
				W_Adr	= 3'b000; R_Adr = 3'b000; S_Adr = 3'b000; adr_sel = 1'b0;
				s_sel = 1'b0; pc_ld	= 1'b0; pc_inc = 1'b0;	pc_sel=1'b0; ir_ld = 1'b0;
				mw_en	= 1'b0;	rw_en = 1'b0;	alu_op = 4'b0000;
				{ns_N,ns_Z,ns_C} = 3'b0; 
				status = 8'hFF; 
				nextstate = FETCH;
			end

			//IR <-- M[PC],	PC<--PC+1 -- LED pattern = 1000_000 
			FETCH: begin
				W_Adr	= 3'b000; R_Adr = 3'b000; S_Adr = 3'b000; adr_sel = 1'b0;
				s_sel = 1'b0; pc_ld	= 1'b0; pc_inc = 1'b1;	pc_sel=1'b0; ir_ld = 1'b1;
				mw_en	= 1'b0;	rw_en = 1'b0;	alu_op = 4'b0000;
				{ns_N,ns_Z,ns_C}={ps_N,ps_Z,ps_C}; 
				status = 8'h80;//flags remain the same status=8'h80;
				nextstate = DECODE; 
			end
		 
			//Default Control Word, NS<--case( IR[15:9] ) -- LED pattern = 1100_0000 
			DECODE: begin
				W_Adr	= 3'b000; R_Adr = 3'b000; S_Adr = 3'b000; 
				adr_sel = 1'b0; s_sel = 1'b0; 
				pc_ld = 1'b0;  pc_inc = 1'b0; pc_sel = 1'b0; ir_ld = 1'b0;
				mw_en	= 1'b0;   rw_en = 1'b0; alu_op = 4'b0000;
				{ns_N,ns_Z,ns_C}={ps_N,ps_Z,ps_C};
				status = 8'hC0; // flags remain the same status=8'hC0;
				case ( IR[15:9] )
					7'h70:	nextstate = ADD;
					7'h71:	nextstate = SUB;
					7'h72:	nextstate = CMP;
					7'h73:	nextstate = MOV;
					7'h74:	nextstate = SHL;
					7'h75:	nextstate = SHR;
					7'h76:	nextstate = INC;
					7'h77:	nextstate = DEC;
					7'h78:	nextstate = LD_;
					7'h79:	nextstate = STO;
					7'h7a:	nextstate = LDI;
					7'h7b:	nextstate = HALT;
					7'h7c:	nextstate = JE;
					7'h7d:	nextstate = JNE;
					7'h7e:	nextstate = JC;
					7'h7f:	nextstate = JMP;
					default: nextstate = ILLEGAL_OP; 
				endcase
			end

			//R[ir(8:6)]<--R[ir(5:3)]+R[ir(2:0)]-–LED pattern={ps_N,ps_Z,ps_C,5’b00000}
			ADD: begin
				W_Adr		= IR[8:6]; R_Adr = IR[5:3]; S_Adr = IR[2:0]; 
				adr_sel  = 1'b0;    s_sel = 1'b0;
				pc_ld		= 1'b0;   pc_inc = 1'b0;	pc_sel = 1'b0; ir_ld = 1'b0;
				mw_en		= 1'b0;	  rw_en = 1'b1;	alu_op = 4'b0100;
				{ns_N,ns_Z,ns_C} = {N,Z,C}; 
				
				status = {ps_N,ps_Z,ps_C,5'b00000};
				nextstate = FETCH;	// go back to fetch 
			end //done

			//R[ir(8:6)]<--R[ir(5:3)]-R[ir(2:0)]--LED pattern={ps_N,ps_Z,ps_C,5'b00001}
			SUB: begin
				W_Adr		= IR[8:6]; R_Adr = IR[5:3]; S_Adr = IR[2:0]; 
				adr_sel  = 1'b0;    s_sel = 1'b0; 
				pc_ld		= 1'b0;	 pc_inc = 1'b0;	pc_sel = 1'b0; ir_ld = 1'b0;
				mw_en		= 1'b0;	  rw_en = 1'b1;	alu_op = 4'b0101;
				{ns_N,ns_Z,ns_C} = {N,Z,C}; 
				
				status = {ps_N,ps_Z,ps_C,5'b00001};
				nextstate = FETCH;	// go back to fetch 
			end //done

			//R[ir(5:3)] - R[ir(2:0)] -- LED pattern = {ps_N,ps_Z,ps_C,5'b00010}
			CMP: begin
				W_Adr		= 3'b000; R_Adr = IR[5:3]; S_Adr = IR[2:0]; 
				adr_sel 	= 1'b0;   s_sel = 1'b0; 
				pc_ld		= 1'b0;  pc_inc = 1'b0;	  pc_sel = 1'b0; ir_ld = 1'b0;
				mw_en		= 1'b0;	 rw_en = 1'b0;	  alu_op = 4'b0101;
				{ns_N,ns_Z,ns_C} = {N,Z,C}; 
				
				status = {ps_N,ps_Z,ps_C,5'b00010};
				nextstate = FETCH;	// go back to fetch 
			end //done

			//R[ir(8:6)]<--R[ir(2:0)] -- LED pattern = {ns_N,ns_Z,ns_C,5'b00011}
			MOV: begin
				W_Adr		= IR[8:6]; R_Adr = 3'b000; S_Adr = IR[2:0]; 
				adr_sel  = 1'b0; 	  s_sel = 1'b0; 
				pc_ld		= 1'b0; 	 pc_inc = 1'b0;  pc_sel = 1'b0; ir_ld = 1'b0;
				mw_en		= 1'b0;	  rw_en = 1'b1;  alu_op = 4'b0000;
				{ns_N,ns_Z,ns_C} = {ps_N,ps_Z,ps_C};
				
				status = {ps_N,ps_Z,ps_C,5'b00011};
				nextstate = FETCH;	// go back to fetch 
			end // done

			//R[ir(8:6)]<--R[ir(2:0)] << 1 -- LED pattern = {ps_N,ps_Z,ps_C,5'b00100}
			SHL: begin
				W_Adr		= IR[8:6]; R_Adr = 3'b000; S_Adr = IR[2:0];
				adr_sel	= 1'b0; 	  s_sel = 1'b0; 
				pc_ld		= 1'b0;   pc_inc = 1'b0;  pc_sel = 1'b0; ir_ld = 1'b0;
				mw_en		= 1'b0;	  rw_en = 1'b1;  alu_op = 4'b0111;
				{ns_N,ns_Z,ns_C} = {N,Z,C}; 
				
				status = {ps_N,ps_Z,ps_C,5'b00100};
				nextstate = FETCH;	// go back to fetch 
			end // done

			//R[ir(8:6)]<--R[ir(2:0)] >> 1 -- LED pattern = {ps_N,ps_Z,ps_C,5'b00101}
			SHR: begin
				W_Adr		= IR[8:6]; R_Adr = 3'b000; S_Adr = IR[2:0]; 
				adr_sel  = 1'b0; 	  s_sel = 1'b0;
				pc_ld		= 1'b0;   pc_inc = 1'b0;  pc_sel = 1'b0; 		ir_ld = 1'b0;
				mw_en		= 1'b0;	  rw_en = 1'b1;  alu_op = 4'b0110;
				{ns_N,ns_Z,ns_C} = {N,Z,C}; 
				
				status = {ps_N,ps_Z,ps_C,5'b00101};
				nextstate = FETCH;	// go back to fetch 
			end // done

			//R[ir(8:6)]<--R[ir(2:0)] + 1 -- LED pattern = {ps_N,ps_Z,ps_C,5'b00110}
			INC: begin
				W_Adr		= IR[8:6]; R_Adr = 3'b000;  S_Adr = IR[2:0]; 
				adr_sel  = 1'b0;    s_sel = 1'b0; 
				pc_ld	   = 1'b0;   pc_inc = 1'b0;	pc_sel = 1'b0; 	ir_ld = 1'b0;
				mw_en	   = 1'b0;	  rw_en = 1'b1;	alu_op = 4'b0010;
				{ns_N,ns_Z,ns_C} = {N,Z,C}; 
				
				status = {ps_N,ps_Z,ps_C,5'b00110};
				nextstate = FETCH;	// go back to fetch 
			end // done
			
			//R[ir(8:6)]<--R[ir(2:0)] - 1 -- LED pattern = {ps_N,ps_Z,ps_C,5'b00111}
			DEC: begin
				W_Adr		= IR[8:6]; R_Adr = 3'b000;  S_Adr = IR[2:0];
				adr_sel  = 1'b0; 	  s_sel = 1'b0; 
				pc_ld		= 1'b0;   pc_inc = 1'b0;	pc_sel = 1'b0; ir_ld = 1'b0;
				mw_en		= 1'b0;	  rw_en = 1'b1;	alu_op = 4'b0011;
				{ns_N,ns_Z,ns_C} = {N,Z,C}; 
				
				status = {ps_N,ps_Z,ps_C,5'b00111};
				nextstate = FETCH;	// go back to fetch 
			end // done

			//R[ir(8:6)]<--M[ R[ir(2:0)] ] -- LED pattern = {ps_N,ps_Z,ps_C,5'b01000}
			LD_: begin
				W_Adr		= IR[8:6]; R_Adr   = IR[2:0]; S_Adr  = 3'b000; 
				adr_sel  = 1'b1;    s_sel 	 = 1'b1; 
				pc_ld		= 1'b0;    pc_inc  = 1'b0;		pc_sel = 1'b0;    ir_ld = 1'b0;
				mw_en		= 1'b0;	  rw_en   = 1'b1;	   alu_op = 4'b0000;
				{ns_N,ns_Z,ns_C} = {ps_N,ps_Z,ps_C}; 
				
				status = {ps_N,ps_Z,ps_C,5'b01000};
				nextstate = FETCH;	// go back to fetch 
			end // done

			// M[ R[ir(8:6)] ]<--R[ir(2:0)] -- LED pattern = {ps_N,ps_Z,ps_C,5'b01001}
			STO: begin
				W_Adr		= 3'b000; R_Adr = IR[8:6]; S_Adr = IR[2:0]; 
				adr_sel  = 1'b1;   s_sel = 1'b0;
				pc_ld		= 1'b0;  pc_inc = 1'b0;	  pc_sel = 1'b0; 			ir_ld = 1'b0;
				mw_en		= 1'b1; 	 rw_en = 1'b0;	  alu_op = 4'b0000;
				{ns_N,ns_Z,ns_C} = {ps_N,ps_Z,ps_C}; 
				
				status = {ps_N,ps_Z,ps_C,5'b01001};
				nextstate = FETCH;	// go back to fetch 
			end // done

			//R[ir(8:6)]<--M[PC], PC<--PC + 1 -- LED pattern={ps_N,ps_Z,ps_C,5'b01010}
			LDI: begin
				W_Adr		= IR[8:6]; R_Adr = 3'b000;  S_Adr = 3'b000; 
				adr_sel  = 1'b0; 	  s_sel = 1'b1;
				pc_ld		= 1'b0;   pc_inc = 1'b1;	pc_sel = 1'b0;       ir_ld = 1'b0;
				mw_en		= 1'b0;	  rw_en = 1'b1;	alu_op = 4'b0000;
				{ns_N,ns_Z,ns_C} = {ps_N,ps_Z,ps_C}; 
				
				status = {ps_N,ps_Z,ps_C,5'b01010};
				nextstate = FETCH;	// go back to fetch 
			end // done
			
//if (ps_Z=1) PC<--PC+se_IR[7:0] else PC<--PC--LED pattern={ps_N,ps_Z,ps_C,5'b01100}
			JE: begin
				W_Adr		= 3'b000; R_Adr = 3'b000; S_Adr = 3'b000; 
				adr_sel  = 1'b0;   s_sel = 1'b0;
				pc_ld		= ps_Z; 	pc_inc = 1'b0;	 pc_sel = 1'b0; ir_ld = 1'b1;
				mw_en		= 1'b0;	 rw_en = 1'b0;	 alu_op = 4'b0000;
				{ns_N,ns_Z,ns_C} = {ps_N, ps_Z, ps_C}; 
				 
				status = {ps_N,ps_Z,ps_C,5'b01100};
				nextstate = FETCH; 
			end

//if (ps_Z=0) PC<--PC+se_IR[7:0] else PC<--PC--LED pattern={ps_N,ps_Z,ps_C,5'b01101}
			JNE: begin
				W_Adr		= 3'b000; R_Adr = 3'b000; S_Adr = 3'b000; 
				adr_sel  = 1'b0;   s_sel = 1'b0;
				pc_ld	   = ~ps_Z; pc_inc = 1'b0;	 pc_sel = 1'b0; ir_ld = 1'b1;//0
				mw_en	   = 1'b0;	 rw_en = 1'b0;	 alu_op = 4'b0000;
				{ns_N,ns_Z,ns_C} = {ps_N, ps_Z, ps_C};
					
				status = {ps_N,ps_Z,ps_C,5'b01101};
				nextstate = FETCH; 
			end

//if (ps_C=1) PC<--PC+se_IR[7:0] else PC<--PC--LED pattern={ps_N,ps_Z,ps_C,5'b01110}
			JC: begin
				W_Adr		= 3'b000; R_Adr = 3'b000; S_Adr = 3'b000; 
				adr_sel  = 1'b0;   s_sel = 1'b0;
				pc_ld	   = ps_C; 	pc_inc = 1'b0;	 pc_sel = 1'b0; ir_ld = 1'b1;
				mw_en	   = 1'b0;	 rw_en = 1'b0;	 alu_op = 4'b0000;
				{ns_N,ns_Z,ns_C} = {ps_N, ps_Z, ps_C}; 
				
				status = {ps_N,ps_Z,ps_C,5'b01110};
				nextstate = FETCH; 
			end

			// PC<--R[ir(2:0)] -- LED pattern = {ps_N,ps_Z,ps_C,5'b01111}
			JMP: begin
				W_Adr		= 3'b000; R_Adr = IR[2:0]; S_Adr = 3'b000;
				adr_sel 	= 1'b1; 	 s_sel = 1'b0;
				pc_ld		= 1'b1; 	pc_inc = 1'b0;	 pc_sel = 1'b1; ir_ld = 1'b0;
				mw_en		= 1'b0;	 rw_en = 1'b0;	 alu_op = 4'b0001;
				{ns_N,ns_Z,ns_C} = {ps_N, ps_Z, ps_C}; 
				status = {ps_N,ps_Z,ps_C,5'b01111};
				nextstate = FETCH; 
			end

			// Default Control Word Values -- LED pattern = {ps_N,ps_Z,ps_C,5'b01011}
			HALT: begin
				W_Adr		= 3'b000; R_Adr = 3'b000; S_Adr = 3'b000; 
				adr_sel  = 1'b0; 	 s_sel = 1'b0;
				pc_ld	   = 1'b0; 	pc_inc = 1'b0;	 pc_sel = 1'b0; ir_ld = 1'b0;
				mw_en	   = 1'b0;	 rw_en = 1'b0;	 alu_op = 4'b0000;
				{ns_N,ns_Z,ns_C} = {ps_N,ps_Z,ps_C}; 
				status = {ps_N,ps_Z,ps_C,5'b01011};
				nextstate = HALT;	// loop here forever 
			end

			// Default Control Word Values -- LED pattern = 1111_0000
			ILLEGAL_OP:	begin
				W_Adr		= 3'b000; R_Adr = 3'b000; S_Adr = 3'b000; 
				adr_sel 	= 1'b0;  s_sel  = 1'b0;
				pc_ld		= 1'b0; 	pc_inc = 1'b0;	 pc_sel = 1'b0; ir_ld = 1'b0;
				mw_en		= 1'b0;	 rw_en = 1'b0;	 alu_op = 4'b0000;
				{ns_N,ns_Z,ns_C} = 3'b000; 
				status = {8'b1111_0000};
				nextstate = ILLEGAL_OP;	// loop here forever 
			end		
		endcase 
endmodule 