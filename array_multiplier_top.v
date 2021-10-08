`define SS_IBITS	4
`define SS_OBITS	8

module array_multiplier_top
	#(
		parameter SIZE = 4
	) (
		input [SIZE-1:0] i_A, 					// binary input A, connect to SW7-4
		input [SIZE-1:0] i_B,					// binary input B, connect to SW3-0
		output [`SS_OBITS-1:0] o_h2_A,
		output [`SS_OBITS-1:0] o_h0_B,
		output [`SS_OBITS-1:0] o_h4_R,
		output [`SS_OBITS-1:0] o_h5_R
	);
		
	wire [(SIZE*2-1):0] w_R;
	
	array_multiplier a (
			.i_A(i_A),
			.i_B(i_B),
			.o_R(w_R)
		);
		
	seven_segment hex2 // for A
		(
			.i_binary(i_A),
			.o_ss(o_h2_A)
		);
		
	seven_segment hex0 // for B
		(
			.i_binary(i_B),
			.o_ss(o_h0_B)
		);
		
	seven_segment hex4 // low R
		(
			.i_binary(w_R[3:0]),
			.o_ss(o_h4_R)
		);
	seven_segment hex5 // high R
		(
			.i_binary(w_R[7:4]),
			.o_ss(o_h5_R)
		);
	
endmodule


module seven_segment(
	input wire [`SS_IBITS-1:0] i_binary,
	output reg [`SS_OBITS-1:0] o_ss
);

	always @(*)
	begin
		case (i_binary)
			0 : o_ss = 8'b1100_0000;
			1 : o_ss = 8'b1111_1001;
			2 : o_ss = 8'b1010_0100;
			3 : o_ss = 8'b1011_0000;
			4 : o_ss = 8'b1001_1001;
			5 : o_ss = 8'b1001_0010;
			6 : o_ss = 8'b1000_0010;
			7 : o_ss = 8'b1111_1000;
			8 : o_ss = 8'b1000_0000;
			9 : o_ss = 8'b1001_0000;
			10: o_ss = 8'b1000_1000; // A
			11: o_ss = 8'b0000_0000; // B (will include . to be distinguished from 8)
			12: o_ss = 8'b1100_0110; // C
			13: o_ss = 8'b0100_0000; // D (will include . to be distinguished from 0)
			14: o_ss = 8'b1000_0110; // E
			15: o_ss = 8'b1000_1110; // F
			default : o_ss = 8'b0111_1111;
		endcase
	end

endmodule
