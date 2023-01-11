`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/15/2020 04:22:49 PM
// Design Name: 
// Module Name: Jumping_Dinosaur_using_keyboard
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
module multiple_jumps(input clk,input KB_clk,input KB_data, output reg [3:0]R, output reg [3:0]G,output reg [3:0] B, output HS,VS );
reg [4:0] rom_addr;
reg [5:0] rom_col;
reg [33:0] rom_data;
wire [10:0] hcount,vcount;
wire blank,clk_25;
reg [10:0] ball_left,ball_right,ball_up,ball_down;
reg square_ballon,rom_bit;
reg [19:0]slow_count;
reg slow_clk;
wire [7:0]keycode;
reg [8:0]c,t;
reg [22:0]lm;
reg p;
initial
begin
c=0;
t=0;
p=1;
lm=0;//leg movement
ball_left=320;
ball_right =354;
ball_up =291;
ball_down =321;
end
clk_wiz_0 instance_name
   (
   // Clock in ports
    .clk_in1(clk),      // input clk_in1
    // Clock out ports
    .clk_out1(clk_25));   
new1 KB(clk_25,KB_clk,KB_data,keycode);
always @(posedge clk)
begin
     slow_count=slow_count+1;
     slow_clk=slow_count[19];
end
 always@(posedge slow_clk) 
begin 
       if ( keycode==8'h29 && p ) //up
       begin
              //ball_up=300-200;
              //ball_down=313-213;
		if(c<80)
			begin
			ball_up=ball_up-1;
			ball_down=ball_down-1;
			c=c+1;
			end
		if(c>=80 && c<159)
			begin
			ball_up=ball_up+1;
			ball_down=ball_down+1;
			c=c+1;
			end
		if(c>=159)
			begin
			ball_up=291;
			ball_down=321;
			c=0;
			p=0;
			end

       end
     else if( keycode==0  && ~p )//down
       begin
              //ball_up=200;
              //ball_down=213;
		if(t<80)
			begin
			ball_up=ball_up-1;
			ball_down=ball_down-1;
			t=t+1;
			end
		if(t>=80 && t<159)
			begin
			ball_up=ball_up+1;
			ball_down=ball_down+1;
			t=t+1;
			end
		if(t>=159)
			begin
			ball_up=291;
			ball_down=321;
			t=0;
			p=1;
			end

       end
         
end
always @(posedge clk_25)
begin
case(rom_addr)
5'd0:rom_data =34'b0000000000000000000000000000000000;     
5'd1:rom_data =34'b0000000000000000000001111111110000;        
5'd2:rom_data =34'b0000000000000000000011111111111000;     
5'd3:rom_data =34'b0000000000000000000011100111111000;     
5'd4:rom_data =34'b0000000000000000000011100111111000;     
5'd5:rom_data =34'b0000011000000000000111111111101000;         
5'd6:rom_data =34'b0000011000000000000111110000000000;        
5'd7:rom_data =34'b0000011100000000001111111111110000;         
5'd8:rom_data =34'b0000011100000000011111111000000000;         
5'd9:rom_data =34'b0000011100000000111111111000000000;
5'd10:rom_data =34'b0000111100000001111111111000000000;  
5'd11:rom_data =34'b0000111100000111111111111110000000;  
5'd12:rom_data =34'b0000011111000111111111111111000000;  
5'd13:rom_data =34'b0000011111111111111111110011100000;  
5'd14:rom_data =34'b0000001111111111111111110000000000;  
5'd15:rom_data =34'b0000000111111111111111110000000000;  
5'd16:rom_data =34'b0000000011111111111111100000000000;  
5'd17:rom_data =34'b0000000011111111111111000000000000;  
5'd18:rom_data =34'b0000000011111111111111000000000000;   //////////// lm leg movement
5'd19:rom_data =34'b0000000011111111111100000000000000;
5'd20:rom_data =34'b0000000011111100111100000000000000;
5'd21:rom_data =34'b0000000001100000001110000000000000;
5'd22:rom_data =34'b0000000001100000001100000000000000;
5'd23:rom_data =34'b0000000001100000001100000000000000;  
5'd24:rom_data =lm[22]? 34'b0000000011111000001100000000000000:34'b0000000001100000000111110000000000;  
5'd25:rom_data =lm[22]? 34'b0000000001111100001100000000000000:34'b0000000001100000000011111000000000;  
5'd26:rom_data =lm[22]? 34'b0000000000000000001100000000000000:34'b0000000001100000000000000000000000;  
5'd27:rom_data =lm[22]? 34'b0000000000000000001100000000000000:34'b0000000001100000000000000000000000;  
5'd28:rom_data =lm[22]? 34'b0000000000000000001111100000000000:34'b0000000001111100000000000000000000;  
5'd29:rom_data =lm[22]? 34'b0000000000000000001111100000000000:34'b0000000001111100000000000000000000;
endcase              
end
always@(posedge clk_25)
 begin
      lm=lm+1;/////to invert leg movements every time
      square_ballon = ( (hcount >= ball_left) && (hcount <= ball_right) && (vcount >= ball_up) && (vcount <= ball_down));
       rom_addr = vcount[4:0]- ball_up[4:0];
       rom_col =33-( hcount[5:0] - ball_left[5:0]);
       rom_bit =rom_data[rom_col];
       if(square_ballon && rom_bit)
                 begin
                    R <= 4'b1111;
                    G <= 4'b1111;
                    B <= 4'b0000;
             end
           else
                begin
                    R <= 4'b0000;
                    G<= 4'b0000;
                    B<= 4'b1111;
                end 
  end
vga_controller u1(clk_25,HS,VS,hcount,vcount,blank);      
endmodule

