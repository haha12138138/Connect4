`timescale 1ns / 1ps

module top_STM (
	 input rst_n
	,input clk
	,input usr_en
	,input display_finish
	,input edit_finish
	,input check_finish
	,input check_4
	,output reg edit_en
	,output reg display_en
	,output reg check_en
    ,output reg[2:0] row_addr_sel
);
reg[2:0] state;
reg[2:0] next_state;
/*
wire display_finish;
wire edit_finish;
wire check_4;
wire check_finish;
reg edit_en;
reg display_en;
reg check_en;
reg[2:0] row_addr_sel;*/
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
	case(state)
	0:
	begin
		next_state=(usr_en&display_finish)?1:0;
	end
	1:
	begin
		next_state=(edit_finish)?2:1;
	end
	2:
	begin
		next_state=(check_4)?3:(check_finish)?4:2;
	end
	3:
	begin
		next_state=3;
	end
	4:
	begin
		next_state=(!usr_en)?0:4;
	end
	default:
	begin
		next_state=0;
	end
	endcase
end // always
always @ (*)
begin
	case(state)
	0:
	begin
		 edit_en=0;
		 display_en=~(usr_en&display_finish);
		 check_en=0;
		 row_addr_sel=1;
	end
	1:
	begin
		 edit_en=~edit_finish;
		 display_en=0;
		 check_en=0;
		 row_addr_sel=2;
	end
	2:
	begin
		 edit_en=0;
		 display_en=0;
		 check_en=~(check_4|check_finish);
		 row_addr_sel=4;
	end
	3:
	begin
		 edit_en=0;
		 display_en=1;
		 check_en=0;
		 row_addr_sel=1;
	end
	4:
	begin
		edit_en=0;
		display_en=1;
		check_en=0;
		row_addr_sel=1;
	end
	default:
	begin
		edit_en=0;
		display_en=1;
		check_en=0;
		row_addr_sel=1;
	end
	endcase
end // always

endmodule     	