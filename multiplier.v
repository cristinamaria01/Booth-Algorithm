`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:14:26 11/08/2019 
// Miulescu Cristina-Maria , 333 AB

module decoder(output reg[7:0] out, input[14:0] x);

	reg       semn_x;						     // semnele lui x si y
	reg [7:0] first_digit_x; 			    // cifra zecilor de pe afisajul ledului
	reg [7:0] second_digit_x;	         // cifra unitatilor de pe afisajul ledului
	reg [7:0] out_x;
	reg [7:0] 	  x1, x2;				 // valoarea pe 8 biti a cifrei zecilor si unitatilor
	
		always@ (*) begin
		 semn_x = x[14];
		 first_digit_x = x[13:7];
		 second_digit_x = x[6:0];
		
		case(first_digit_x)
			7'b1111110 : x1 = 8'b00000000;	// 0
			7'b0110000 : x1 = 8'b00000001;	// 1
			7'b1101101 : x1 = 8'b00000010;	// 2
			7'b1111001 : x1 = 8'b00000011; 	// 3
			7'b0110011 : x1 = 8'b00000100; 	// 4
			7'b1011011 : x1 = 8'b00000101;	// 5
			7'b1011111 : x1 = 8'b00000110; 	// 6
			7'b1110000 : x1 = 8'b00000111; 	// 7
			7'b1111111 : x1 = 8'b00001000; 	// 8
			7'b1111011 : x1 = 8'b00001001; 	// 9
		endcase
		
		case(second_digit_x)
			7'b1111110 : x2 = 8'b00000000;	// 0
			7'b0110000 : x2 = 8'b00000001;	// 1
			7'b1101101 : x2 = 8'b00000010;	// 2
			7'b1111001 : x2 = 8'b00000011; 	// 3
			7'b0110011 : x2 = 8'b00000100; 	// 4
			7'b1011011 : x2 = 8'b00000101;	// 5
			7'b1011111 : x2 = 8'b00000110; 	// 6
			7'b1110000 : x2 = 8'b00000111; 	// 7
			7'b1111111 : x2 = 8'b00001000; 	// 8
			7'b1111011 : x2 = 8'b00001001; 	// 9
		endcase
		
		// Scriu in binar
		if(semn_x == 0)begin
				out_x = (x1<<1) + (x1<<3) + x2;
				end
				else begin
			out_x = ~((x1<<1) + (x1<<3) + x2) + 1'b1 ;
		end
		out = out_x;
		end

endmodule

module booth(out, in1, in2);

parameter width = 8;

input  	[width-1:0]   in1; //multiplicand
input  	[width-1:0]   in2; //multiplier
output  [2*width-1:0] out; // product


/*write your code here*/
reg     [2*width:0] p;
integer i;

assign out = p[2*width:1];

always@ (in1 or in2) begin
    p = {{width{1'b0}}, in2, 1'b0};
    for(i = 0; i < width; i = i + 1) begin
        case(p[1:0])
            2'b01: p[2*width:width+1] = p[2*width:width+1] + in1;
            2'b10: p[2*width:width+1] = p[2*width:width+1] - in1;
            default: p[2*width:width+1] = p[2*width:width+1] + {width{1'b0}};
        endcase
        p = {p[2*width], p} >> 1;
    end
end

endmodule
	
	module multiplier(
	output[14:0] product,
	input[14:0] x,
	input[14:0] y
    );
	
	
	wire [7:0]      data_x, data_y;					     // valoarea in binar a lui x si y
	wire [15:0] prod;
	
	
	decoder d1(data_x, x);									// decodificam pe x de pe afisajul digital
	decoder d2(data_y, y);									// decodificam pe y de pe afisajul digital

	booth b(prod, data_x, data_y);						// aplicam algoritmul lui booth
	
	assign product = prod[14:0];							// ne intereseaza doar primii 14 biti din rezultat

endmodule
