`timescale 1ns / 1ps

module game_board (
	 input rst_n
	,input clk
	,input [2:0] check_addr
	,input [2:0] put_chip_addr
	,input [2:0] display_addr
	,input [2:0] row_addr_sel//one hot code
	,input [2:0] col_addr
	,input [1:0] put_chip_data
	,input check_r_en
	,input put_r_en
	,input disply_r_en
	,input ram_w_en
	,output reg [15:0] output_data
);
reg[15:0] ram[7:0];
reg[2:0] row_addr;
reg[3:0] put_chip_state;
reg[2:0] next_state;
integer i;
reg[3:0] col_w_addrl;
always @ (*)
begin
	col_w_addrl=(col_addr<<1);
end // always
always @ (*)
begin
	case(row_addr_sel)
	1:
	begin
		row_addr=display_addr;
	end
	2:
	begin
		row_addr=put_chip_addr;
	end
	4:
	begin
		row_addr=check_addr;
	end
	default:
	begin
		row_addr=display_addr;
	end
	endcase
end // always

always @ (*)
begin
	output_data=(check_r_en|put_r_en|disply_r_en)?ram[row_addr]:0;
end // always

always @(negedge rst_n or posedge clk)
begin
	if(!rst_n) 
	begin
		for(i=0;i<8;i=i+1)
		begin
			ram[i]<=0;
		end
	end
	else 
	begin
		if(ram_w_en)
		begin
			ram[row_addr][col_w_addrl+:2]<=put_chip_data;
		end
	end
end 

endmodule     	