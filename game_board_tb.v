`timescale 1ns / 1ps
module game_board_tb;
reg rst_n;
reg clk;
/*main*/
wire [2:0] row_addr_sel;//one hot code// from main statemachine
wire edit_en;
wire display_en;
wire check_en;
/*other FSM*/


/*usr->put*/

/*put->ram*/
wire [2:0] put_row_addr;
wire [2:0] col_addr;
wire [1:0] put_chip_data;
wire put_r_en;
wire ram_w_en;
/*put->main*/
wire edit_finish;
/*ram->put ->dis*/
wire[15:0] output_data;
/*DISPLAY*/
/*->ram*/
wire disply_r_en;
wire [2:0] display_addr;
/*-> usr*/
wire [7:0]led_addr;
wire [15:0]led_data;
/*-> main*/
wire display_finish;
/*CHECK*/
wire [2:0] check_addr;
wire check_r_en;
/*->main*/
wire check_finish;
wire check_4;
wire G_WIN;
wire O_WIN;
reg usr_en;
reg [2:0]G;
reg [2:0]O;
game_board BOARD(rst_n,clk,check_addr,put_row_addr,
				 display_addr,row_addr_sel,col_addr,
				 put_chip_data, check_r_en,put_r_en,
				 disply_r_en,ram_w_en,output_data);//RAM
edit_statemachine EDIT_STM(rst_n,clk,edit_en,G,O,
						   output_data,put_chip_data,
						   col_addr,put_r_en,
						   put_row_addr,ram_w_en,
						   edit_finish);
showboard_statemachine SHOW_STM(rst_n,clk,display_en,
								output_data,disply_r_en,
								display_addr,led_addr,
								led_data,display_finish);
check_statemachine check(rst_n,clk,check_en,output_data,
						 check_addr,check_r_en,check_4,
						 G_WIN,O_WIN,check_finish);

top_STM top(rst_n,clk,usr_en,display_finish,edit_finish,
			check_finish,check_4,edit_en,display_en,check_en,
			row_addr_sel);

initial begin
	clk=0;
	forever begin
	    #10 clk = ~clk;
	end // forever 
end // initial
initial begin
	rst_n=0;
	usr_en=0;
	#5 rst_n=1;
	/*const stimuli*/
end // initial

integer i;
always @ (*)
begin
	case(i)
	0:
	begin
		G=0;
		O=0;

	end
	1:
	begin
		G=2;
		O=1;

	end
	4:
	begin
		G=1;
		O=2;

	end
	8:
	begin
		G=3;
		O=2;

	end
	12:
	begin

	end
	20:
	begin
		$stop;
	end
	endcase
end // always
always @ (negedge clk or negedge rst_n)
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
	