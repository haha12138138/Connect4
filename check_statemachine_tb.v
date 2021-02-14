`timescale 1ns / 1ps
module check_statemachine_tb;
reg rst_n;
reg clk;
reg check_en;
reg[15:0] ram_r_val;
wire[2:0] check_addr;
wire check_r_en;
wire   check_4;
wire finished;
check_statemachine check(rst_n,clk,check_en,ram_r_val,check_addr,
	 					 check_r_en,check_4,finished);
initial begin
	  rst_n=0;
	  #5 rst_n=1;
end // initial
initial begin
	clk=0;
	forever begin
	    #10 clk = ~clk;
	end // forever 
end // initial
integer i ;
always @ (*)
begin
	case (i)
	0:
	begin
		ram_r_val=16'h0290;
		check_en=0;
	end
	1:
	begin
		ram_r_val=16'h0290;
		check_en=1;
	end
	2:
	begin
		ram_r_val=16'h0090;
		check_en=1;
	end
	3:
	begin
		ram_r_val=16'h0010;
		check_en=1;
	end
	4:
	begin
		ram_r_val=16'h0010;
		check_en=1;
	end
	5:
	begin
		ram_r_val=16'h0000;
		check_en=1;
	end
	6:
	begin
		ram_r_val=16'h0000;
		check_en=0;
	end
	7:
	begin
		ram_r_val=16'h0000;
		check_en=0;
	end
	8:
	begin
		ram_r_val=16'h0000;
		check_en=0;
	end
	9:
	begin
		ram_r_val=16'h0000;
		check_en=finished;
	end
	10:
	begin
		$stop;
	end
	endcase
end // always

always @ (posedge clk or negedge rst_n)
begin
	if(~rst_n)
	begin
		i<=0;
	end
	else
	begin
		i<=i+1;
	end
end
endmodule