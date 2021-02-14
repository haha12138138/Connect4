`timescale 1ns / 1ps

module check_slice (
	 input [3:0] a 
	,input [3:0] b
	,output  G_check_4
	,output  O_check_4
);
assign G_check_4 = (&a)&(&(~b));
assign O_check_4 = (&b)&(&(~a));
endmodule