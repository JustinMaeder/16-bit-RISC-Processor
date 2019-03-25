`timescale 1ns / 1ps
/***********************************************************************************
*
* Designer: Hung Le, Justin Maeder
* Email: 	hungx92@yahoo.com, Justin_maeder@hotmail.com
* Filename: Top_Level.v
* Date:		May 07, 2018
* Version:	14.7
*
* Purpose:  This top level module instantiates the RISC processor and a 256x16 ram
*		   	module. The processor will output addresses and data to the ram
*				and taking in data from the ram. The address will be displayed on
*				left 4 pixels. The data at that address will be displayed on the
*				right 4 pixels. The RISC processor also outputs a status signal
*				displayed on the first 8 leds. The leds indicate which operation
*			 	the processor is executing. The clock of the processor comes
*				from a debounced button down. To read data from ram, a counter
*				module called dump mem is used to increment through each addresses.
*				Switch 0 is used to enable the dump mem module when user wants to
*				read data from ram. The clock of dump mem module comes from another
*				debounced button.
*				
***********************************************************************************/
module Top_Level(clk, reset,Dump_mem, step_clk, step_mem,
					  Anode, status, a,b,c,d,e,f,g);
	// input declaration
	input clk, reset, Dump_mem, step_clk, step_mem;
	output a,b,c,d,e,f,g;
	output [7:0] Anode ,status;
	
	// wire declaration
	wire clk_out, 		// clk to decbounce
		  step,			// debounce to RISC
		  mem_clk,		// debounce to ram
		  mw_en;			// RISC to RAM
	wire [15:0] Address, mem_counter, D_out, D_in, dump_mux;
	
	clk_500Hz				c0 (.clk_in(clk),
								 .reset(reset),
								 .clk_out(clk_out));//clock for debounce module
							 
	debounce			 	d0 (.clk(clk_out),
								 .reset(reset),
								 .Din(step_clk),
								 .Dout(step)), 	 //debounced signal to RISC
								 
							d1 (.clk(clk_out),
								 .reset(reset),
								 .Din(step_mem),
								 .Dout(mem_clk));//debounced signal to dump mem 
	
	RISC_Processor RISC0 (.clk(step),
								 .reset(reset),
								 .Address(Address), //address to ram 
								 .D_in(D_in),		//data from ram 
								 .D_out(D_out),		//data to ram 
								 .mw_en(mw_en),		//register write enable 
								 .Status(status));	//8 bit status signal 
										  
	PC				  dump_mem (.clk(mem_clk),
									.reset(reset),
									.ld(1'b0),		//0 ld - 1 inc
									.inc(1'b1),		//to only increment 
									.Din(16'b0),
									.Dout(mem_counter));
	
	assign dump_mux = (Dump_mem == 1'b1) ? mem_counter : Address; //mux to enable dump mem

	ram1					r0 (.clk(clk),
								 .we(mw_en),        	//ram write enable
								 .addr(dump_mux[7:0]),	//8bit address
								 .din(D_out),			//data write to ram
								 .dout(D_in));			//data read from ram 
								 
	Display_Controller DC0 (.clk	(clk), 
									.reset(reset), 
									.seg	({dump_mux, D_in}), //address = MSB, data = LSB
									.A		(Anode), 
									.a(a), .b(b), .c(c), .d(d), .e(e), .f(f), .g(g));
endmodule
