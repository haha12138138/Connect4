`timescale 1ns / 1ps

module check_statemachine (
	 input rst_n
	,input clk
	,input check_en
	,input[15:0] ram_r_val
	,output reg [2:0] check_addr
	,output reg  check_r_en
	,output   check_4
	,output   G_WIN
	,output  O_WIN
	,output reg  finished
);
reg[3:0] cnt1;
reg[2:0] cnt2;
reg sub_rst;
reg[2:0]bit_band;

assign  check_4= G_WIN|O_WIN;
wire[7:0] sub_data;
assign sub_data = ram_r_val[(bit_band<<1)+:8];
check_grid check_grid(rst_n,clk,check_en,sub_data,
					  sub_rst,G_WIN,O_WIN);
always @(negedge rst_n or posedge clk)
begin
	if(!rst_n) 
	begin
		cnt1<=0;
	end
	else if (!check_en)
	begin
		cnt1<=0;
	end
	else 
	begin
		cnt1<=(sub_rst)?0:cnt1+1;
	end
end 
always @ (posedge clk or negedge rst_n)
begin
	if(~rst_n)
	begin
		cnt2<=0;
	end
	else if (!check_en|finished)
	begin
		cnt2<=0;
	end
	else
	begin
		cnt2<=(sub_rst)?cnt2+1:cnt2;
	end
end
always @ (*)
begin
	sub_rst=(cnt1==8);
	bit_band=cnt2;
	finished=(cnt2==4)&sub_rst;
	check_addr=cnt1;
	check_r_en=(~sub_rst)&check_en;
end // always


endmodule     	