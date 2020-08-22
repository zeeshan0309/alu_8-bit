// Code your testbench here
// or browse Examples
module t_alu;
  wire [7:0]alu_out;
  wire carry_out;
  reg [3:0] opCode;
  reg [7:0]in_a;
  reg [7:0]in_b;
  reg clk, rst;
  
  alu_8_bit M_UUT(alu_out, carry_out, in_a, in_b, opCode, clk, rst);
  
  always
    #5 clk = ~clk;
  
  initial
    begin
      $dumpfile("aluWAVE.vcd");
      $dumpvars(0, t_alu);
      $monitor($time, " in1=%b | in2=%b | opCode=%b || cr=%b  || out=%b", in_a, in_b, opCode, carry_out, alu_out);
      in_a=8'b0; in_b=8'b0; opCode=4'b0000; clk=1'b0;
      #10 in_a=8'b10101010; in_b=8'b01010101; opCode=4'b0000;
      #10 in_a=8'b10101010; in_b=8'b01010101; opCode=4'b0001;
      #10 in_a=8'b10101010; in_b=8'b01010101; opCode=4'b0010;
      #10 in_a=8'b10101010; in_b=8'b01010101; opCode=4'b0011;
      #10 in_a=8'b10101010; in_b=8'b01010101; opCode=4'b0100;
      #10 in_a=8'b10101010; in_b=8'b01010101; opCode=4'b0101;
      #10 in_a=8'b10101010; in_b=8'b01010101; opCode=4'b0110;
      #10 in_a=8'b10101010; in_b=8'b01010101; opCode=4'b0111;
      #10 in_a=8'b10101010; in_b=8'b01010101; opCode=4'b1000;
      #10 in_a=8'b10101010; in_b=8'b01010101; opCode=4'b1001;
      #10 in_a=8'b10101010; in_b=8'b01010101; opCode=4'b1010;
      #10 in_a=8'b11100011; in_b=8'b01111101; opCode=4'b0000;
      #10 opCode=4'b0001;
      #10 in_a=8'b01111101; in_b=8'b11100011; opCode=4'b0101;
      #10 in_a=8'b11100011; in_b=8'b11100011; opCode=4'b0101;
      #10 opCode=4'b1001;
      #20 $finish;
    end
endmodule