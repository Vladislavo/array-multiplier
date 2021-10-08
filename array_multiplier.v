// parameterized version 
module array_multiplier
	#(
		parameter SIZE = 4
	) (
		input [SIZE-1:0] i_A, i_B,
		output [(SIZE*2)-1:0] o_R
	);
	
	wire [SIZE*(SIZE-1)-1:0] w_sum;
	wire [(SIZE-1):0] w_and, w_o_C;
	
	
	assign w_and[(SIZE-1):0] = i_A & {SIZE{i_B[0]}};
	
	full_adder 
		#(
			.SIZE(SIZE)
		) fa_first (
			.i_A( w_and[(SIZE-1):0] >> 1 ),
			.i_B( i_A & {SIZE{i_B[1]}} ),
			.i_C(1'b0),
			.o_SUM(w_sum[(SIZE-1):0]),
			.o_C(w_o_C[0])
		);
		
	assign o_R[1:0] = { w_sum[0], w_and[0] };
	
	genvar i;
	generate
		for (i = 2; i < SIZE-1; i=i+1)
		begin : gen
			full_adder 
				#(
					.SIZE(SIZE)
				) fa (
					.i_A( { w_o_C[i-2], {(SIZE-1){1'b0}} } | w_sum[SIZE*(i-1)-1:SIZE*(i-2)] >> 1 ),
					.i_B( i_A & {SIZE{i_B[i]}} ),
					.i_C(1'b0),
					.o_SUM(w_sum[SIZE*i-1:SIZE*(i-1)]),
					.o_C(w_o_C[i-1])
				);
				
			assign o_R[i] = w_sum[SIZE*(i-1)];
		end
	endgenerate
	
	full_adder 
		#(
			.SIZE(SIZE)
		) fa_last (
			.i_A( { w_o_C[SIZE-3], {(SIZE-1){1'b0}} } | w_sum[SIZE*(SIZE-2)-1:SIZE*(SIZE-3)] >> 1 ),
			.i_B( i_A & {SIZE{i_B[SIZE-1]}} ),
			.i_C(1'b0),
			.o_SUM(w_sum[SIZE*(SIZE-1)-1:SIZE*(SIZE-2)]),
			.o_C(w_o_C[SIZE-2])
		);
	
	assign o_R[(SIZE*2)-1:(SIZE*2)-(SIZE+1)] = { w_o_C[SIZE-2], w_sum[SIZE*(SIZE-1)-1:SIZE*(SIZE-2)] };

endmodule


// non-parameterized version
`define MULTIPLIER_SIZE	4
module array_multiplier_n(
		input [`MULTIPLIER_SIZE-1:0] i_A, i_B,
		output [(`MULTIPLIER_SIZE*2)-1:0] o_R
	);
	localparam SIZE = `MULTIPLIER_SIZE;
	
	wire [SIZE-1:0] w_sum1, w_and1;
	wire w_o_C1;
	
	assign w_and1 = i_A & {SIZE{i_B[0]}};
	
	full_adder 
		#(
			.SIZE(SIZE)
		) fa0 (
			.i_A( w_and1 >> 1 ),
			.i_B( i_A & {SIZE{i_B[1]}} ),
			.i_C(0),
			.o_SUM(w_sum1),
			.o_C(w_o_C1)
		);
	
	
	
	wire [SIZE-1:0] w_sum2, w_and2;
	wire w_o_C2;
	
	assign w_and2 = i_A & {SIZE{i_B[2]}};
	
	full_adder 
		#(
			.SIZE(SIZE)
		) fa1 (
			.i_A( w_and2 ),
			.i_B( {w_o_C1, w_sum1 >> 1} ),
			.i_C(0),
			.o_SUM(w_sum2),
			.o_C(w_o_C2)
		);
		
	wire [SIZE-1:0] w_sum3, w_and3;
	wire w_o_C3;
	
	assign w_and3 = i_A & {SIZE{i_B[3]}};
	
	full_adder 
		#(
			.SIZE(SIZE)
		) fa2 (
			.i_A( w_and3 ),
			.i_B( {w_o_C2, w_sum2 >> 1} ),
			.i_C(0),
			.o_SUM(w_sum3),
			.o_C(w_o_C3)
		);

	
	assign o_R = {w_o_C3, w_sum3, w_sum2[0], w_sum1[0], w_and1[0]};
	
endmodule


module full_adder
	#(
		parameter SIZE = 4
	) (
		input [SIZE-1:0] i_A, i_B,
		input i_C,
		output [SIZE-1:0] o_SUM,
		output o_C
	);
	
	assign {o_C, o_SUM} = i_A + i_B + i_C;
	
endmodule
