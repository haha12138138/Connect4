`timescale 1ns / 1ps

module showboard_statemachine (
	 input rst_n
	,input clk
	,input display_en
	,input [15:0] display_data_i
	,output reg disply_r_en
	,output reg [2:0] display_addr
	,output reg [7:0] row_addr
	,output reg [15:0]display_data_o
	,output reg display_finish
);
reg[2:0]state;
reg[2:0]next_state;
always @(negedge rst_n or posedge clk)
begin
	if(!rst_n) 
		 state<=0 ;
	else 
	begin
		state<=next_state;
	end
end 
always @ (*)
begin
	if(display_en)
	begin
		next_state=state+1;
	end
	else
	begin
		next_state=0;
	end
end // always
always @ (*)
begin
	row_addr=(1<<state);
	display_data_o=(display_en)?display_data_i:0;
end // always
always @ (*)
begin
	disply_r_en=display_en;
	display_addr=state;
	display_finish=(state==7);
end // always


endmodule     	