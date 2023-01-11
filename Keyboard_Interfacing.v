`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/15/2020 04:17:48 PM
// Design Name: 
// Module Name: Keyboard_Interfacing
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module new1(VGA_clk,KB_clk,KB_data,code);
  input VGA_clk;
  input KB_clk;
  input KB_data;
  reg [30:0]count;
  output reg [7:0] code;           
  reg Q0, Q1;
  reg [1:0]c,p;
  reg [10:0] shreg;
  //reg [7:0] code;
  wire endbit;
  initial
  begin
  c=0;
  end
  assign endbit = ~shreg[0];
  assign shift = Q1 & ~Q0;

  always @ (posedge VGA_clk) 
  begin
    Q0 <= KB_clk;
    Q1 <= Q0;
    shreg <= (endbit) ? 11'h7FF : shift ? {KB_data, shreg[10:1]} : shreg;
    if (endbit && c==0 )
      begin
      code <= shreg[8:1];
      c<=1;
      end
    if(endbit && c==1)
      begin
        code<=0;
        c<=0;
      end
    else
            count=count+1'b1;
            
  end   
endmodule
