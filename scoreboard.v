`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/14/2020 05:49:38 PM
// Design Name: 
// Module Name: scoreboard
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


module score_display( input clk,output reg [3:0]R, output reg [3:0]G,output reg [3:0] B, output HS,output VS);
wire [10:0]hcount,vcount;
wire clk_25;
reg [7:1] seg1,seg2,seg3;     //segments
reg [1:7] sel[0:9];//ROM
wire blank;
reg [9:0]c1;
reg [3:0]x[1:0];
reg [9:0] counter;
reg [30:0] c;	    //To count score
reg  [3:0] d1,d2,d3;       //Binary Coded Decimals
clk_wiz_0 instance_name
   (
   // Clock in ports
    .clk_in1(clk),      // input clk_in1
    // Clock out ports
    .clk_out1(clk_25));
initial
begin
counter=0;
c=0;
d1=0;
d2=0;
d3=0;
sel[0] =7'b1110111;
sel[1] =7'b0010010;
sel[2] =7'b1011101;
sel[3] =7'b1011011;
sel[4] =7'b0111010;
sel[5] =7'b1101011;
sel[6] =7'b1101111;
sel[7] =7'b1010010;
sel[8] =7'b1111111;
sel[9] =7'b1111011;
end
integer i;
always @(posedge clk_25)
begin
     if(c<10000000)
      begin
        counter<=counter;
        d1<=d1;
        d2<=d2;
        d3<=d3;
        c<=c+1;
      end
     else
      begin
         c<=0;
          d1<= (counter%10);
          d2<= (counter<80) ? (((counter/10)%10)-2) : (((counter/10)%10));
          d3<= (counter/100);
         counter=counter+1'b1; 
      end
        
////////////////////////////////// segement 1 /////////////////////////

     seg1[1]<=(sel[d1][1] && hcount>=570 && hcount <=590 && vcount>=100 && vcount<=104 && ~blank);
     seg1[2]<=(sel[d1][2] && hcount>=570 && hcount <=575 && vcount>=105 && vcount<=114 && ~blank); 
     seg1[3]<=(sel[d1][3] && hcount>=585 && hcount <=590 && vcount>=105 && vcount<=114 && ~blank); 
     seg1[4]<=(sel[d1][4] && hcount>=570 && hcount <=590 && vcount>=115 && vcount<=119 && ~blank); 
     seg1[5]<=(sel[d1][5] && hcount>=570 && hcount <=575 && vcount>=120 && vcount<=129 && ~blank); 
     seg1[6]<=(sel[d1][6] && hcount>=585 && hcount <=590 && vcount>=120 && vcount<=129 && ~blank); 
     seg1[7]<=(sel[d1][7] && hcount>=570 && hcount <=590 && vcount>=130 && vcount<=134 && ~blank); 

     ////////////////////////////////// segement 2 /////////////////////////
     
     seg2[1]<=(sel[d2][1] && hcount>=540 && hcount <=560 && vcount>=100 && vcount<=104 && ~blank); 
     seg2[2]<=(sel[d2][2] && hcount>=540 && hcount <=545 && vcount>=105 && vcount<=114 && ~blank); 
     seg2[3]<=(sel[d2][3] && hcount>=555 && hcount <=560 && vcount>=105 && vcount<=114 && ~blank); 
     seg2[4]<=(sel[d2][4] && hcount>=540 && hcount <=560 && vcount>=115 && vcount<=119 && ~blank); 
     seg2[5]<=(sel[d2][5] && hcount>=540 && hcount <=545 && vcount>=120 && vcount<=129 && ~blank); 
     seg2[6]<=(sel[d2][6] && hcount>=555 && hcount <=560 && vcount>=120 && vcount<=129 && ~blank); 
     seg2[7]<=(sel[d2][7] && hcount>=540 && hcount <=560 && vcount>=130 && vcount<=134 && ~blank); 

end
always @(posedge clk_25)
begin
    if( (| seg1) || ( | seg2) || ( | seg3))
        begin
            R<=4'hf;
            G<=4'hf;
            B<=4'hf;
        end
    else
        begin
            R<=0;
            G<=0;
            B<=0;
        end
end
vga_controller u1(clk_25,HS,VS,hcount,vcount,blank);   
endmodule
