`define MULTIPLIER_SIZE	10
`define MAX_MULTIPLICANT 50
`define CLK_C	1
`define CLK_P	(`CLK_C*2)

`timescale 1ns / 1ns

module tb_array_multiplier();
	reg [`MULTIPLIER_SIZE-1:0] a, b;
	wire [`MULTIPLIER_SIZE*2-1:0] r;
	
	array_multiplier #(.SIZE(`MULTIPLIER_SIZE)) am (.i_A(a), .i_B(b), .o_R(r));	
	reg [10:0] i;
	
		
	initial
	begin
		a = 0; b = `MAX_MULTIPLICANT;
		for (i = 0; i < `MAX_MULTIPLICANT; i=i+1)
		begin
			#`CLK_P a = i; b = `MAX_MULTIPLICANT - i;
		end
	end
	
	initial begin
		$display("A		B		R");
		$monitor("%d	%d	%d", a, b, r);
	end
		
endmodule