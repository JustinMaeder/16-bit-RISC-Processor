`timescale 1ns / 1ps
/***********************************************************************************
*
* Designer: Hung Le, Justin Maeder
* Email: 	hungx92@yahoo.com, Justin_maeder@hotmail.com
* Filename: Display_Controller.v
* Date:		May 07, 2018
* Version:	14.7
*
* Purpose:   This module takes inputs of 32 bits of data and displays them on the
*			 anodes. The 32 bits are split into 8 segments each displaying on one 
*			 pixel. It does this by taking the 4 bits and translating it into the 
*			 7 segments, then enables the anode that the data is to go on. The 
*			 decision to display the correct data is made by an 8-1 mux. The pixels
*         turn on one at a time. A FSM is used to go through each anode by 
*			 continuously going through state 0 to state 7. State 0 corresponds to 
*			 anode 0 and state 7 corresponds to anode 7.  
* 			   
***********************************************************************************/

module Display_Controller(clk, reset, seg, A, a, b, c, d, e, f, g);
	input 		 clk, reset;
	input [31:0] seg; 
	
	output [7:0] A; 
	output a, b, c, d, e, f, g; 
	
	wire 		  clk_p;   //clk to pix controller
	wire [2:0] sel_mux; //pix contr. to mux
	wire [3:0] Y;       // mux to hex 
	
	pixel_clk 		  pClk0(.clk_in(clk), 
								  .reset(reset),
								  .clk_out(clk_p));
	
	pixel_controller pCon0(.clk(clk_p),
								  .reset(reset),
								  .anode(A),          // Turning on anodes
								  .seg_sel(sel_mux)); // The corresponding anodes number
	
	ad_mux 			  ad0  (.sel(sel_mux),  	 // Anode number
								  .D(seg),
								  .Y(Y));				 // Data for that anode 
	
	hex_to_7seg 	  ht7  (.hex(Y),				 // 4-bits 	
								  .a(a) ,
								  .b(b) ,
								  .c(c) ,
								  .d(d) ,
								  .e(e) , 
								  .f(f) ,
								  .g(g)); 

endmodule
