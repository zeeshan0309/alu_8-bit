// ALU design, positive clock edge triggred
/* opCodes and their functions
        0000	a+b;
        0001	a-b;
        0010	left shift a, a<<1;
        0011	right shift a, a>>1;
        0100	ring shift a left by 1;
        0101	ring shift a right by 1;
        0110	a AND b;
        0111	a OR b;
        1000	a XOR b;
        1001	equal
        1010	unused
        1011	unused
        1100	unused
        1101	unused
        1110	unused
        1111	unused
       
   unused opCodes can be suitably utilized for other
   operations, as per requirement
*/
module alu_8_bit(alu_out, carry_out, in_a, in_b, opCode, clk, rst);
  output reg [7:0]alu_out;
  output reg carry_out;
  input [7:0] in_a;
  input [7:0] in_b;
  input [3:0] opCode;
  input clk, rst;			//positive clock edge sensitive
  							//negative logic asynchronous reset	
  wire [7:0] add_out;
  wire [7:0] subt_out;
  wire [7:0] l_sh_out;
  wire [7:0] r_sh_out;
  wire [7:0] rng_l_out;
  wire [7:0] rng_r_out;
  wire [7:0] band_out;
  wire [7:0] bor_out;
  wire [7:0] bxor_out;
  wire [7:0] equl_out;
  
  wire [7:0] alu_out_temp;
  wire carry_temp;
  
  wire [9:0] carry;
  
  add_8_bit M0(add_out, carry[0], in_a, in_b);
  sub_8_bit M1(subt_out, carry[1], in_a, in_b);
  left_shft M2(l_sh_out, carry[2], in_a);
  right_shft M3(r_sh_out, carry[3], in_a);
  ring_lt M4(rng_l_out, carry[4], in_a);
  ring_rt M5(rng_r_out, carry[5], in_a);
  bitw_and M6(band_out, carry[6], in_a, in_b);
  bitw_or M7(bor_out, carry[7], in_a, in_b);
  bitw_xor M8(bxor_out, carry[8], in_a, in_b);
  equl M9(equl_out, carry[9], in_a, in_b);
  
  mux_8bit M10(alu_out_temp, opCode, add_out, subt_out, l_sh_out, r_sh_out, rng_l_out, rng_r_out, band_out, bor_out, bxor_out, equl_out, 8'b0, 8'b0, 8'b0, 8'b0, 8'b0, 8'b0);
  
  mux_1bit M11(carry_temp, opCode, carry[0], carry[1], carry[2], carry[3], carry[4], carry[5], carry[6], carry[7], carry[8], carry[9], 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
  
  always@(posedge clk, negedge rst) begin
    if(!rst) begin
      alu_out <= 8'b0;
      carry_out <= 1'b0;
    end
    else begin
      alu_out <= alu_out_temp;
      carry_out <= carry_temp;
    end
  end
  
endmodule

module add_8_bit(out, cr, in1, in2);		//8-bit adder
  output reg [7:0]out;
  output reg cr;
  input [7:0]in1;
  input [7:0]in2;
  reg [8:0] total;
  
  always@(*) begin
    total[8:0] <= in1 + in2;
    cr <= total[8];
    out[7:0] <= total[7:0];
  end
endmodule

module sub_8_bit(out, cr, in1, in2);		//8-bit subtractor
  output reg [7:0]out;
  output reg cr;
  input [7:0]in1;
  input [7:0]in2;
  
  reg [7:0]neg_in2;
  
  always@(*) begin
    neg_in2 <= ~(in2)+8'b00000001;
    out <= in1 + neg_in2;
    cr <= (in1>in2 || in1==in2)?0:1;
  end
endmodule


module left_shft(out, cr, in);		//left shifting operator
  output reg [7:0]out;
  output reg cr;
  input [7:0] in;
  
  always@(*) begin
    out[7:0] <= {in[6:0], 1'b0};
    cr <= 1'b0;
  end
endmodule

module right_shft(out, cr, in);		//right shifting operator
  output reg [7:0]out;
  output reg cr;
  input [7:0] in;
  
  always@(*) begin
    out[7:0] <= {1'b0, in[7:1]};
    cr <= 1'b0;
  end
endmodule

module ring_rt(out, cr, in);		//1-bit right Ring shifter
  output reg[7:0] out;
  output reg cr;
  input [7:0] in;
  
  always@(*) begin
    out[7:0] <= {in[0], in[7:1]};
    cr <= 1'b0;
  end
endmodule

module ring_lt(out, cr, in);		//1-bit left Ring shifter
  output reg [7:0] out;
  output reg cr;
  input [7:0] in;
  
  always@(*) begin
    out[7:0] <= {in[6:0], in[7]};
    cr <= 1'b0;
  end
endmodule

module bitw_and(out, cr, in1, in2);		//8-bit bitwise AND 
  output reg [7:0] out;
  output reg cr;
  input [7:0] in1;
  input [7:0] in2;
  
  always@(*) begin
    out <= in1 & in2;
    cr <= 1'b0;
  end
endmodule

module bitw_or(out, cr, in1, in2);		//8-bit bitwise OR
  output reg [7:0] out;
  output reg cr;
  input [7:0] in1;
  input [7:0] in2;
  
  always@(*) begin
    out <= in1 & in2;
    cr <= 1'b0;
  end
endmodule

module bitw_xor(out, cr, in1, in2);		//8-bit XOR
  output reg [7:0] out;
  output reg cr;
  input [7:0] in1;
  input [7:0] in2;
  
  always@(*) begin
    out <= in1 ^ in2;
    cr <= 1'b0;
  end
endmodule

module equl(out, cr, in1, in2);		//8-bit equality checker
  output reg [7:0] out;
  output reg cr;
  input [7:0] in1;
  input [7:0] in2;
  
  always@(*) begin
    out <= (in1==in2)?8'b00000001:8'b00000000;
    cr <= 1'b0;
  end
endmodule

module mux_8bit(out, sel, I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11, I12, I13, I14, I15);				//8-bit 16:1 MUX
  output reg [7:0] out;
  input [3:0]sel;
  input [7:0]I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11, I12, I13, I14, I15;
  
  always@(*) begin
    case(sel)
      4'b0000: out <= I0;
      4'b0001: out <= I1;
      4'b0010: out <= I2;
      4'b0011: out <= I3;
      4'b0100: out <= I4;
      4'b0101: out <= I5;
      4'b0110: out <= I6;
      4'b0111: out <= I7;
      4'b1000: out <= I8;
      4'b1001: out <= I9;
      4'b1010: out <= I10;
      4'b1011: out <= I11;
      4'b1100: out <= I12;
      4'b1101: out <= I13;
      4'b1110: out <= I14;
      4'b1111: out <= I15;
    endcase
  end
endmodule
           
module mux_1bit(out, sel, I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11, I12, I13, I14, I15);				//1 bit 16:1 MUX
  output reg out;
  input [3:0]sel;
  input I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11, I12, I13, I14, I15;
  
  always@(*) begin
    case(sel)
      4'b0000: out <= I0;
      4'b0001: out <= I1;
      4'b0010: out <= I2;
      4'b0011: out <= I3;
      4'b0100: out <= I4;
      4'b0101: out <= I5;
      4'b0110: out <= I6;
      4'b0111: out <= I7;
      4'b1000: out <= I8;
      4'b1001: out <= I9;
      4'b1010: out <= I10;
      4'b1011: out <= I11;
      4'b1100: out <= I12;
      4'b1101: out <= I13;
      4'b1110: out <= I14;
      4'b1111: out <= I15;
    endcase
  end
endmodule