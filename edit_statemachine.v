`timescale 1ns / 1ps

module edit_statemachine (
	 input rst_n
	,input clk
	,input edit_en
	,input [2:0] G
	,input [2:0] O
	,input [15:0] ram_r_val
	,output reg [1:0]put_chip_data
	,output reg [2:0] col_addr_o
	,output reg put_r_en
	,output reg [2:0]put_chip_addr
	,output reg ram_w_en
	,output reg finish
);
reg[3:0]state;
reg[3:0]next_state;
reg[3:0]col_addr;
reg sel;
reg cell_is_empty;
always @ (*)
begin
	put_chip_data=(sel)?1:2;
end // always

always @ (posedge clk or negedge rst_n)
begin
	if(~rst_n)
	begin
		sel<=0;
	end
	else
	begin
		sel<=(finish)?~sel:sel;
	end
end
always @ (posedge clk or negedge rst_n)
begin
	if(! rst_n)
	begin
		col_addr<=0;
	end
	else
	begin
		col_addr<=(edit_en)?((sel)?G:O):col_addr;
	end
end // always
always @ (*)
begin
	cell_is_empty=ram_r_val[(col_addr<<1)+:2]==0;
end // always

always @(negedge rst_n or posedge clk)
begin
	if(!rst_n) 
		 state<= 10;
	else 
	begin
		state<=next_state;
	end
end 

always @ (*)
begin
	case(state)
	10:
	begin
		next_state=(edit_en)?0:10;
	end
	0,1,2,3,4,5,6:
	begin
		next_state=(cell_is_empty)?8:state+1;
	end
	7:
	begin
		next_state=(cell_is_empty)?8:9;
	end
	8://WB stage
	begin
		next_state=10;
	end
	9:
	begin
		next_state=10;
	end
	default:
	begin
		next_state=10;
	end
	endcase
end // always
always @ (*)
begin
	case(state)
	10:
	begin
		col_addr_o=col_addr;
		put_r_en=0;
		put_chip_addr=0;
		ram_w_en=0;
		finish=0;
	end
	0,1,2,3,4,5,6:
	begin
		col_addr_o=col_addr;
		put_r_en=1;
		put_chip_addr=state;
		ram_w_en=cell_is_empty;// critical path*****
		finish=0;
	end
	7:
	begin
		col_addr_o=col_addr;
		put_r_en=1;
		put_chip_addr=state;
		ram_w_en=cell_is_empty;
		finish=0;
	end
	8:
	begin
		col_addr_o=col_addr;
		put_r_en=1;
		put_chip_addr=0;
		ram_w_en=0;
		finish=1;
	end
	9:
	begin
		col_addr_o=col_addr;
		put_r_en=0;
		put_chip_addr=0;
		ram_w_en=0;
		finish=1;
	end
	default:
	begin
		next_state=10;
	end
	endcase
end // always


endmodule     	