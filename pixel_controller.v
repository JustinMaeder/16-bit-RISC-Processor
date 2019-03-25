`timescale 1ns / 1ps
/***********************************************************************************
* 
* Designer: Hung Le, Justin Maeder
* Email: 	hungx92@yahoo.com, Justin_maeder@hotmail.com
* Filename: pixel_controller.v
* Date:		May 07, 2018
* Version:	14.7
*
* Purpose:   This module is a Mealy FSM that has no input and will continuously go
*			 through each state starting from state 0 to state 7. Each state will 
*			 enable the anode and its corresponding state in 3 bits. 
*			 
***********************************************************************************/

module pixel_controller(clk, reset, anode,seg_sel);
	input clk, reset;
	output reg [7:0] anode;
	output reg [2:0] seg_sel; 
	
	//**************************************************
	// Next State Combinational Logic Block 
	//**************************************************
	reg [3:0] PS, NS; 
	always @ ( PS ) 
		case (PS) 
			3'b_000: NS = 3'b_001;
			3'b_001: NS = 3'b_010;
			3'b_010: NS = 3'b_011;
			3'b_011: NS = 3'b_100;
			
			3'b_100: NS = 3'b_101;
			3'b_101: NS = 3'b_110;
			3'b_110: NS = 3'b_111;
			3'b_111: NS = 3'b_000;
			default: NS = 3'b_000;
		endcase
		
	//**************************************************
	// State Register Sequential Block
	//**************************************************
	always @ (posedge clk, posedge reset)
		if (reset == 1'b1)begin
			PS = 3'b000;
		end
		else begin 
			PS = NS; 
		end
	//**************************************************
	// Output Combinational Logic Block 
	//**************************************************			
	always @ (PS) 
		case (PS)
			3'b_000: {anode, seg_sel} = 11'b1111_1110_000;
			3'b_001: {anode, seg_sel} = 11'b1111_1101_001;
			3'b_010: {anode, seg_sel} = 11'b1111_1011_010;
			3'b_011: {anode, seg_sel} = 11'b1111_0111_011;
			
			3'b_100: {anode, seg_sel} = 11'b1110_1111_100;
			3'b_101: {anode, seg_sel} = 11'b1101_1111_101;
			3'b_110: {anode, seg_sel} = 11'b1011_1111_110;
			3'b_111: {anode, seg_sel} = 11'b0111_1111_111;
			
			default: {anode, seg_sel} = 11'b1111_1110_000;
		endcase 
endmodule
