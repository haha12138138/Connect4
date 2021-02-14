`timescale 1ns / 1ps

module check_grid (
	 input rst_n
	,input clk
	,input check_en
	,input [7:0] sub_data
	,input sub_rst

	,output G_WIN
	,output O_WIN
);
reg [7:0] a[3:0];
integer i ;
always @(negedge rst_n or posedge clk)
begin
	if(!rst_n)
	begin
		for(i=0;i<4;i=i+1)
		begin
			a[i]<=0;
		end
	end
	else if(sub_rst)
	begin
		for(i=0;i<4;i=i+1)
		begin
			a[i]<=0;
		end
	end
	else 
	begin
		a[0]<=(check_en)?sub_data:a[0];
		for(i=1;i<4;i=i+1)
		begin
			a[i]<=(check_en)?a[i-1]:a[i];
		end
	end
end 
wire [6:0]G_WIN_TEMP;
wire [6:0]O_WIN_TEMP;
check_slice slice0({a[0][0],a[0][2],a[0][4],a[0][6]},
				   {a[0][1],a[0][3],a[0][5],a[0][7]},
				   G_WIN_TEMP[0],O_WIN_TEMP[0]);// first row

check_slice slice1({a[0][0],a[1][0],a[2][0],a[3][0]},
				   {a[0][1],a[1][1],a[2][1],a[3][1]},
				   G_WIN_TEMP[1],O_WIN_TEMP[1]);//first col

check_slice slice2({a[0][2],a[1][2],a[2][2],a[3][2]},
				   {a[0][3],a[1][3],a[2][3],a[3][3]},
				   G_WIN_TEMP[2],O_WIN_TEMP[2]);

check_slice slice3({a[0][4],a[1][4],a[2][4],a[3][4]},
				   {a[0][5],a[1][5],a[2][5],a[3][5]},
				   G_WIN_TEMP[3],O_WIN_TEMP[3]);

check_slice slice4({a[0][6],a[1][6],a[2][6],a[3][6]},
				   {a[0][7],a[1][7],a[2][7],a[3][7]},
				   G_WIN_TEMP[4],O_WIN_TEMP[4]);

check_slice slice5({a[0][0],a[1][2],a[2][4],a[3][6]},
				   {a[0][1],a[1][3],a[2][5],a[3][7]},
				   G_WIN_TEMP[5],O_WIN_TEMP[5]);// left->right

check_slice slice6({a[0][6],a[1][4],a[2][2],a[3][0]},
				   {a[0][7],a[1][5],a[2][3],a[3][1]},
				   G_WIN_TEMP[6],O_WIN_TEMP[6]);// right->left

assign G_WIN=|G_WIN_TEMP;

assign O_WIN=|O_WIN_TEMP ;

//assign check_4 = G_WIN|O_WIN ;
endmodule     	