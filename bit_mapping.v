`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/15/2020 04:03:18 PM
// Design Name: 
// Module Name: bit_mapping
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

module bit_map(input clk, output reg [3:0]R, output reg [3:0]G,output reg [3:0] B, output HS,VS );
reg [3:0] rom_addr;
reg [5:0] rom_col;
reg [19:0] rom_data;
wire [10:0] hcount,vcount;
wire blank,clk_25;
reg [10:0] ball_left,ball_right,ball_up,ball_down;
reg square_ballon,rom_bit;

initial
begin
ball_left=300;
ball_right =320;
ball_up =200;
ball_down =216;
end
clk_wiz_0 instance_name
   (
   // Clock in ports
    .clk_in1(clk),      // input clk_in1
    // Clock out ports
    .clk_out1(clk_25));    
always@(posedge clk_25)
begin

case(rom_addr)
    4'd0:rom_data =20'b00000000000000000000;     
    4'd1:rom_data =20'b00000000000010000000;        
    4'd2:rom_data =20'b00010000000111000000;     
    4'd3:rom_data =20'b00111000000111000000;     
    4'd4:rom_data =20'b00111000000111000000;     
    4'd5:rom_data =20'b00111000000111000000;         
    4'd6:rom_data =20'b00111111111111000000;        
    4'd7:rom_data =20'b00011111111110000000;         
    4'd8:rom_data =20'b00000011100000000000;         
    4'd9:rom_data =20'b00000011100000000000;          
   4'd10:rom_data =20'b00000011100000000000;          
   4'd11:rom_data =20'b00000011100000000000;          
   4'd12:rom_data =20'b00000000000000000000;          
   4'd13:rom_data =20'b00000000000000000000;          
   4'd14:rom_data =20'b00000000000000000000;          
   4'd15:rom_data =20'b00000000000000000000;          
endcase

end

always@(posedge clk_25)
     begin
      square_ballon = ( (hcount >= ball_left) && (hcount <= ball_right) && (vcount >= ball_up) && (vcount <= ball_down));
       rom_addr = vcount[3:0]- ball_up[3:0];
       rom_col =19-( hcount[5:0] - ball_left[5:0]);
       rom_bit =rom_data[rom_col];
       
       if(square_ballon && rom_bit)
           begin
             R <= 4'b1111;
             G <= 4'b0000;
             B <= 4'b0000;
           end
       else
           begin
              R <= 4'b0000;
              G <= 4'b1111;
              B <= 4'b1111;
       end
           
      end
vga_controller u1(clk_25,HS,VS,hcount,vcount,blank);      
  
endmodule
