`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/10/2020 03:11:16 PM
// Design Name: 
// Module Name: movement
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
module game_display(input clk,input KB_clk,input KB_data, output reg [3:0]R, output reg [3:0]G,output reg [3:0] B, output HS,VS );
wire [10:0] hcount,vcount;//pixel scaning locations
wire blank,clk_25;//
 //address to access for dinosaur
 reg [4:0] rom_addr;
reg [5:0] rom_col;
reg [33:0] rom_data;
reg [10:0] ball_left,ball_right,ball_up,ball_down;//for dinosaur location coordinates
reg square_ballon,rom_bit;
// Keyboard Interfacing
reg [19:0]slow_count;
reg slow_clk,enter2;
wire [7:0]keycode;
// count to change score
reg [8:0]c,t;
reg [22:0]lm;//leg movement
///////////////////////////// for obstacles
reg a5;
reg [4:0] rom_addr1,rom_addr2;                                                  
reg [4:0] rom_col1;                                                             
reg [5:0]rom_col2;                                                              
reg [19:0] rom_data1;                                                           
reg [35:0]rom_data2;                                                                                                                                                                             
reg [30:0]count1;                                                               
reg s1,s2;                                                                      
reg [10:0] ball_left1,ball_right1,ball_up1,ball_down1,ball_left2,ball_right2;   
reg square_ballon1,square_ballon2,rom_bit1,rom_bit2;                            
/////////////////////////////////////GAME OVER/////////
reg [160:0]rom_data3;
reg [3:0]rom_addr3;
reg rom_bit3,square_ballon3,blink;
reg [7:0]rom_col3;
reg [10:0] ball_left3,ball_right3,ball_up3,ball_down3;
reg [24:0]count3;
reg vc,ab,abc;
//////////////////////////////line
reg [1:0]rom_addr4;
reg [639:0]rom_data4;
reg [9:0]rom_col4;
reg square_ballon4,rom_bit4;
reg [10:0] ball_left4,ball_right4,ball_up4,ball_down4;  
///////////////////clouds
reg [2:0]rom_addr5;                                       
reg [23:0]rom_data5;                                     
reg [4:0]rom_col5;                                        
reg square_ballon5,rom_bit5;                              
reg [10:0] ball_left5,ball_right5,ball_up5,ball_down5;    
reg [2:0]rom_addr6;                                       
reg [23:0]rom_data6;                                      
reg [4:0]rom_col6;      
reg [2:0]rom_addr7;  
reg [23:0]rom_data7; 
reg [4:0]rom_col7;                                     
reg square_ballon6,rom_bit6,square_ballon7,rom_bit7;                              
reg [10:0] ball_left6,ball_right6,ball_up6,ball_down6,ball_up7,ball_left7,ball_down7,ball_right7;    
reg a,b;
reg p,cd,start1,enter,enter1,cde;
/////Score_timer
reg [7:1] seg1,seg2,seg3,seg21,seg22,seg23;     //segments                     
reg [1:7] sel[0:9];//ROM                                                                                     
reg [9:0]c1,r;                                                 
reg [3:0]x[1:0];                                             
reg [9:0] counter,counterh;                                           
reg [30:0] c8;	    //To count score                           
reg  [3:0] d1,d2,d3,dh1,dh2,dh3;   //binary coded decimal 
reg a6;
initial                     
begin                       
counter=0; enter=0;cd=1;start1=0;             
c8=0;  r=0;     cde=0;   enter1=0;              
d1=0;                       
d2=0;                       
d3=0;  
//// Rom to blink 7-segment with respect to numbers               
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
////////
initial
begin
c=0;
t=0;
p=1;
vc=0;
lm=0;//leg movement
ball_left=200;
ball_right =234;
ball_up =291;
ball_down =321;  
blink=0;
count3=0;            
ball_left1=500;   //cactus 1 
ball_right1=520;   
ball_left2=604;    //cactus 2
ball_right2 =640;  
ball_up1 =301;     
ball_down1 =321;   
count1=0;          
 ball_left3=240;    //game over   
ball_right3 =401;     
ball_up3 =150;        
ball_down3 =165;    
ball_left4=2;  //line
ball_right4 =640; 
ball_up4 =321;    
ball_down4 =325; 
ball_left5=300;     //cloud1
ball_right5 =324; 
ball_up5=210;    
ball_down5 =217;  
ball_left6=550;     //cloud 2
ball_right6 =574; 
ball_up6 =180;    
ball_down6 =187; 
ball_up7=200;      //cloud3
ball_left7=50;
ball_right7=74;
ball_down7=207;
counterh=0;dh1=0;dh2=0;dh3=0;
a6=0;
 end    
//////////////////////////////////////// to convert 100MHz to 25MHz  
clk_wiz_0 instance_name
   (
   // Clock in ports
    .clk_in1(clk),      // input clk_in1
    // Clock out ports
    .clk_out1(clk_25));  
// Keyboard Instantiation 
new1 KB(clk_25,KB_clk,KB_data,keycode);

/////////////////////////////////// Generation of clock to synchronise keyboard and VGA
always @(posedge clk)
begin
     slow_count=slow_count+1;
     slow_clk=slow_count[19];
end

// Assinging operations to perform while pressing space key /////////////////////////////////////////////////////////////////////////////////////////////////
 always@(posedge slow_clk) 
begin 
       /////
        if(keycode==8'h5a)
        begin
        enter=1;
        end
        else
        enter=0;
       if ( keycode==8'h29 && p ) //up
       begin
         enter=0;enter2=1;
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
        enter=0;enter2=0;
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
//////////////////////////////// bitmapping of obstacles /////////////////////////////////////////////////////////////////////////////////////////////////
case(rom_addr1)                                                        
    5'd0:rom_data1 =20'b000000000000000000;                            
    5'd1:rom_data1 =20'b000000001000000000;                            
    5'd2:rom_data1 =20'b000000011100000000;                            
    5'd3:rom_data1 =20'b001000011100000100;                            
    5'd4:rom_data1 =20'b011100011100001110;                            
    5'd5:rom_data1 =20'b011100011100001110;                            
    5'd6:rom_data1 =20'b011100011100001110;                            
    5'd7:rom_data1 =20'b011100011100001110;                            
    5'd8:rom_data1 =20'b001110011100011100;                            
    5'd9:rom_data1 =20'b000111111111110000;                            
   5'd10:rom_data1 =20'b000011111111110000;                            
   5'd11:rom_data1 =20'b000001111111000000;                            
   5'd12:rom_data1 =20'b000000111110000000;                            
   5'd13:rom_data1 =20'b000000011100000000;                            
   5'd14:rom_data1 =20'b000000011100000000;                            
   5'd15:rom_data1 =20'b000000011100000000;                            
   5'd16:rom_data1 =20'b000000011100000000;                            
   5'd17:rom_data1 =20'b000000011100000000;                            
   5'd18:rom_data1 =20'b000000011100000000;                            
   5'd19:rom_data1 =20'b000000011100000000;                            
   5'd20:rom_data1 =20'b000000011100000000;                                                                                               
endcase                                                                
case(rom_addr2)                                                        
    5'd0:rom_data2 =36'b00000000000000000000000000000000000;           
    5'd1:rom_data2 =36'b00000000100000000000000001000000000;           
    5'd2:rom_data2 =36'b00000001110000000000000011100000000;           
    5'd3:rom_data2 =36'b00100001110000010001000011100000100;           
    5'd4:rom_data2 =36'b01110001110000111011100011100001110;           
    5'd5:rom_data2 =36'b01110001110000111011100011100001110;           
    5'd6:rom_data2 =36'b01110001110000111011100011100001110;           
    5'd7:rom_data2 =36'b01110001110000111011100011100001110;           
    5'd8:rom_data2 =36'b00111001110001110001110011100011100;           
    5'd9:rom_data2 =36'b00011111111111000000111111111110000;           
   5'd10:rom_data2 =36'b00001111111111000000011111111110000;           
   5'd11:rom_data2 =36'b00000111111100000000001111111000000;           
   5'd12:rom_data2 =36'b00000011111000000000000111110000000;           
   5'd13:rom_data2 =36'b00000001110000000000000011100000000;           
   5'd14:rom_data2 =36'b00000001110000000000000011100000000;           
   5'd15:rom_data2 =36'b00000001110000000000000011100000000;           
   5'd16:rom_data2 =36'b00000001110000000000000011100000000;           
   5'd17:rom_data2 =36'b00000001110000000000000011100000000;           
   5'd18:rom_data2 =36'b00000001110000000000000011100000000;           
   5'd19:rom_data2 =36'b00000001110000000000000011100000000;           
   5'd20:rom_data2 =36'b00000001110000000000000011100000000;           
                                                                    
endcase   
//////////////////////////////// bitmapping of gameover /////////////////////////////////////////////////////////////////////////////////////////////////
case(rom_addr3)                                                                                                                                                                            
    5'd0:rom_data3=161'b0000000011111111000000000000011100000000011110000000000011110001111111111110000000000000000000111111111000001110000000000011100001111111111110001111111111100000;  
    5'd1:rom_data3=161'b0000011111111111100000000000111110000000011111000000000111110001111111111110000000000000000011111111111100011100000000000111000001111111111100011111111111110000;  
    5'd2:rom_data3=161'b0000111000000000000000000001110111000000011101100000001101110001111000000000000000000000000011100000001110000111000000000111000001110000000000001110000000111000;  
    5'd3:rom_data3=161'b0001110000000000000000000011100011100000011100111000111001110001111000000000000000000000000011100000001110000111000000000111000001110000000000001110000000111000;  
    5'd4:rom_data3=161'b0011100000000000000000000111000001110000011100011111110001110001111000000000000000000000000011100000001110000011100000001110000001110000000000001110000001110000;  
    5'd5:rom_data3=161'b0111000000111111111100001100000000111000011100000111100001110001111000000000000000000000000011100000001110000011100000001110000001110000000000001110000001110000;  
    5'd6:rom_data3=161'b0111000000111111111100011111111111111100011100000000000001110001111111111110000000000000000011100000001110000001110000011100000001111111111110001111111111100000;  
    5'd7:rom_data3=161'b0111000000000111001100011111111111111100011100000000000001110001111111111110000000000000000011100000001110000001110000011100000001111111111110001111111111000000;  
    5'd8:rom_data3=161'b0111000000001110001100011100000000011100011100000000000001110001110000000000000000000000000011100000001110000000111000111000000001110000000000001110000111000000;  
    5'd9:rom_data3=161'b0111000000011100001100011100000000011100011100000000000001110001110000000000000000000000000011100000001110000000111000111000000001110000000000001110000011100000;  
   5'd10:rom_data3=161'b0011100000011100001100011100000000011100011100000000000001110001110000000000000000000000000011100000001110000000011101110000000001110000000000001110000001110000;  
   5'd11:rom_data3=161'b0001111111111000001100011100000000011100011100000000000001110001111111111110000000000000000001111111111100000000011101110000000001111111111110001110000000111000;  
   5'd12:rom_data3=161'b0000111111110000000110011100000000011100011100000000000001110001111111111110000000000000000000111111111000000000001111100000000001111111111110001110000000111000;  
   5'd13:rom_data3=161'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;  
   5'd14:rom_data3=161'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;  
   5'd15:rom_data3=161'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;  
endcase

//////////////////////////////// bitmapping of line /////////////////////////////////////////////////////////////////////////////////////////////////
                                                                 
case(rom_addr4)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
  2'd0:rom_data4=640'b000000000000000000000000000000000000000000011111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
  2'd1:rom_data4=640'b000000000000000000000000000000000000000000100000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
  2'd2:rom_data4=640'b111111111111111111111111111111111111111111000000001111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111110000000110000000011111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111000000000010000000011111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111100000000001111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
  2'd3:rom_data4=640'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
  endcase 
//////////////////////////////// bitmapping of clouds    /////////////////////////////////////////////////////////////////////////////////////////////////
case(rom_addr5)                                                        
         5'd0:rom_data5 =24'b000000000000000000000000;                            
         5'd1:rom_data5 =24'b000000111001111000000000;                            
         5'd2:rom_data5 =24'b000001111111111100000000;                            
         5'd3:rom_data5 =24'b000011111111111110000000;                            
         5'd4:rom_data5 =24'b011111111111111111111000;                            
         5'd5:rom_data5 =24'b011111111111111111111100;                            
         5'd6:rom_data5 =24'b000111111111111111100000;                            
         5'd7:rom_data5 =24'b000001111111111111000000;                                                                                                                                                                                                                                                                                                                                                                                                                                  
     endcase   
 case(rom_addr6)                                              
          5'd0:rom_data6 =24'b000000000000000000000000;        
          5'd1:rom_data6 =24'b000000011100111100000000;        
          5'd2:rom_data6 =24'b000000111111111110000000;        
          5'd3:rom_data6 =24'b000001111111111111100000;        
          5'd4:rom_data6 =24'b001111111111111111111111;        
          5'd5:rom_data6 =24'b001111111111111111111111;        
          5'd6:rom_data6 =24'b000011111111111111111000;        
          5'd7:rom_data6 =24'b000000111111111111100000;        
endcase                                                  
 case(rom_addr7)                                                  
          5'd0:rom_data7 =24'b000000000000000000000000;           
          5'd1:rom_data7 =24'b000000011110011100000000;           
          5'd2:rom_data7 =24'b000000111111111110000000;           
          5'd3:rom_data7 =24'b000001111111111111100000;           
          5'd4:rom_data7 =24'b001111111111111111111111;           
          5'd5:rom_data7 =24'b001111111111111111111111;           
          5'd6:rom_data7 =24'b000011111111111111111000;           
          5'd7:rom_data7 =24'b000000111111111111100000;           
endcase                                                           
                                                                  
   //////////////////////////////// bitmapping of dragon  /////////////////////////////////////////////////////////////////////////////////////////////////                                                                                                                                                                                                                                  
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
      /// Locations to display Score on monitor
      
                ///////////////////////////////// segement 1 units place/////////////////////////
           seg1[1]<=(sel[d1][1] && hcount>=570 && hcount <=590 && vcount>=100 && vcount<=104 && ~blank);
           seg1[2]<=(sel[d1][2] && hcount>=570 && hcount <=575 && vcount>=105 && vcount<=114 && ~blank); 
           seg1[3]<=(sel[d1][3] && hcount>=585 && hcount <=590 && vcount>=105 && vcount<=114 && ~blank); 
           seg1[4]<=(sel[d1][4] && hcount>=570 && hcount <=590 && vcount>=115 && vcount<=119 && ~blank); 
           seg1[5]<=(sel[d1][5] && hcount>=570 && hcount <=575 && vcount>=120 && vcount<=129 && ~blank); 
           seg1[6]<=(sel[d1][6] && hcount>=585 && hcount <=590 && vcount>=120 && vcount<=129 && ~blank); 
           seg1[7]<=(sel[d1][7] && hcount>=570 && hcount <=590 && vcount>=130 && vcount<=134 && ~blank); 
      
           ////////////////////////////////// segement 2 10s place//////////////////////////
           
           seg2[1]<=(sel[d2][1] && hcount>=540 && hcount <=560 && vcount>=100 && vcount<=104 && ~blank); 
           seg2[2]<=(sel[d2][2] && hcount>=540 && hcount <=545 && vcount>=105 && vcount<=114 && ~blank); 
           seg2[3]<=(sel[d2][3] && hcount>=555 && hcount <=560 && vcount>=105 && vcount<=114 && ~blank); 
           seg2[4]<=(sel[d2][4] && hcount>=540 && hcount <=560 && vcount>=115 && vcount<=119 && ~blank); 
           seg2[5]<=(sel[d2][5] && hcount>=540 && hcount <=545 && vcount>=120 && vcount<=129 && ~blank); 
           seg2[6]<=(sel[d2][6] && hcount>=555 && hcount <=560 && vcount>=120 && vcount<=129 && ~blank); 
           seg2[7]<=(sel[d2][7] && hcount>=540 && hcount <=560 && vcount>=130 && vcount<=134 && ~blank); 
           
           //////////////////////////////////// segement 3 100s place//////////////////////////
           
           seg3[1]<=(sel[d3][1] && hcount>=510 && hcount <=530 && vcount>=100 && vcount<=104 && ~blank); 
           seg3[2]<=(sel[d3][2] && hcount>=510 && hcount <=515 && vcount>=105 && vcount<=114 && ~blank); 
           seg3[3]<=(sel[d3][3] && hcount>=525 && hcount <=530 && vcount>=105 && vcount<=114 && ~blank); 
           seg3[4]<=(sel[d3][4] && hcount>=510 && hcount <=530 && vcount>=115 && vcount<=119 && ~blank); 
           seg3[5]<=(sel[d3][5] && hcount>=510 && hcount <=515 && vcount>=120 && vcount<=129 && ~blank); 
           seg3[6]<=(sel[d3][6] && hcount>=525 && hcount <=530 && vcount>=120 && vcount<=129 && ~blank); 
           seg3[7]<=(sel[d3][7] && hcount>=510 && hcount <=530 && vcount>=130 && vcount<=134 && ~blank); 
           
    ////////////// Conversion  of digits to BCD
    
   
      if(c8<10000000)
           begin
             counter<=counter;
             d1<=d1;
             d2<=d2;
             d3<=d3;
             c8<=c8+1;
           end
          else
              begin
                c8<=0;
                d3=counter/100;     
                d2=(counter%100)/10;
                d1=(counter%100)%10;
                if((a|b) && (~start1))
                    begin 
                        counter=counter;
                        if(counterh<counter)
                            begin
                              counterh=counter;
                              dh1=d1;
                              dh2=d2;
                              dh3=d3;
                            end
                    end
                else if(enter1)
                    begin
                        counter=0;enter1=0;
                    end
               else
                    counter=counter+1;
       end
       //////high score /////////////////////////////////////////////////////////////////////////////////////////////////
       ///////////////////////////////// segement 1 units place/////////////////////////
                      seg21[1]<=(sel[dh1][1] && hcount>=170 && hcount <=190 && vcount>=100 && vcount<=104 && ~blank);
                      seg21[2]<=(sel[dh1][2] && hcount>=170 && hcount <=175 && vcount>=105 && vcount<=114 && ~blank); 
                      seg21[3]<=(sel[dh1][3] && hcount>=185 && hcount <=190 && vcount>=105 && vcount<=114 && ~blank); 
                      seg21[4]<=(sel[dh1][4] && hcount>=170 && hcount <=190 && vcount>=115 && vcount<=119 && ~blank); 
                      seg21[5]<=(sel[dh1][5] && hcount>=170 && hcount <=175 && vcount>=120 && vcount<=129 && ~blank); 
                      seg21[6]<=(sel[dh1][6] && hcount>=185 && hcount <=190 && vcount>=120 && vcount<=129 && ~blank); 
                      seg21[7]<=(sel[dh1][7] && hcount>=170 && hcount <=190 && vcount>=130 && vcount<=134 && ~blank); 
                
                      ////////////////////////////////// segement 2 10s place//////////////////////////
                      
                      seg22[1]<=(sel[dh2][1] && hcount>=140 && hcount <=160 && vcount>=100 && vcount<=104 && ~blank); 
                      seg22[2]<=(sel[dh2][2] && hcount>=140 && hcount <=145 && vcount>=105 && vcount<=114 && ~blank); 
                      seg22[3]<=(sel[dh2][3] && hcount>=155 && hcount <=160 && vcount>=105 && vcount<=114 && ~blank); 
                      seg22[4]<=(sel[dh2][4] && hcount>=140 && hcount <=160 && vcount>=115 && vcount<=119 && ~blank); 
                      seg22[5]<=(sel[dh2][5] && hcount>=140 && hcount <=145 && vcount>=120 && vcount<=129 && ~blank); 
                      seg22[6]<=(sel[dh2][6] && hcount>=155 && hcount <=160 && vcount>=120 && vcount<=129 && ~blank); 
                      seg22[7]<=(sel[dh2][7] && hcount>=140 && hcount <=160 && vcount>=130 && vcount<=134 && ~blank); 
                      
                      //////////////////////////////////// segement 3 100s place//////////////////////////
                      
                      seg23[1]<=(sel[dh3][1] && hcount>=110 && hcount <=130 && vcount>=100 && vcount<=104 && ~blank); 
                      seg23[2]<=(sel[dh3][2] && hcount>=110 && hcount <=115 && vcount>=105 && vcount<=114 && ~blank); 
                      seg23[3]<=(sel[dh3][3] && hcount>=125 && hcount <=130 && vcount>=105 && vcount<=114 && ~blank); 
                      seg23[4]<=(sel[dh3][4] && hcount>=110 && hcount <=130 && vcount>=115 && vcount<=119 && ~blank); 
                      seg23[5]<=(sel[dh3][5] && hcount>=110 && hcount <=115 && vcount>=120 && vcount<=129 && ~blank); 
                      seg23[6]<=(sel[dh3][6] && hcount>=125 && hcount <=130 && vcount>=120 && vcount<=129 && ~blank); 
                      seg23[7]<=(sel[dh3][7] && hcount>=110 && hcount <=130 && vcount>=130 && vcount<=134 && ~blank); 
 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      /////to invert leg movements every time
       if((a|b) && (~start1))
                         lm=lm;
                       else if(enter1)
                       lm=lm+1;
                         else
                        lm=lm+1;
      square_ballon = ( (hcount >= ball_left) && (hcount <= ball_right) && (vcount >= ball_up) && (vcount <= ball_down));
       rom_addr = vcount[4:0]- ball_up[4:0];
       rom_col =33-( hcount[5:0] - ball_left[5:0]);
       rom_bit =rom_data[rom_col];
        if(enter && cd)
        begin
          start1=1;enter1=1;
          end
          else if(enter2)
          start1=0;   
         else
         start1=0;
      square_ballon1 = ((hcount >= ball_left1) && (hcount <= ball_right1) && (vcount >= ball_up1) && (vcount <= ball_down1));                      
                 rom_addr1 = vcount[4:0]- ball_up1[4:0];                                                                                                     
                 rom_col1 =( hcount[4:0] - ball_left1[4:0]);                                                                                                 
                 rom_bit1 =rom_data1[rom_col1];                                                                                                              
              if((hcount==ball_right1) && (vcount==ball_down1))                                                                                              
                  begin                                                                                                                                  
                       if((a|b)&& ~start1)
                                  begin
                                 cd=1;
                                  ball_left1=ball_left1;
                                  ball_right1=ball_right1;
                                  end   
                                  else if(start1)
                                  begin
                                  cd=0;
                                  ball_left1=450;        
                                  ball_right1=470;
                                  end
                                  else
                                  begin
                                  ball_left1=ball_left1-1;      
                                 ball_right1=ball_right1-1;
                                  end                          
                                     if(ball_right1==0)            
                                         begin                     
                                            ball_left1=620;        
                                            ball_right1 =640;                                                                                                         
                                         end                                                                                                                          
                              end                                                                                                                                                       
      square_ballon2 = ((hcount >= ball_left2) && (hcount <= ball_right2) && (vcount >= ball_up1) && (vcount <= ball_down1));                       
             rom_addr2 = vcount[4:0]- ball_up1[4:0];                                                                                                
             rom_col2 =( hcount[5:0] - ball_left2[5:0]);                                                                                            
             rom_bit2 =rom_data2[rom_col2]; 
                                                                                                                 
          if((hcount==ball_right2) && (vcount==ball_down1))                                                                                         
              begin
                 if((a|b)&& ~start1)
                 begin
                 cd=1;
                 ball_left2=ball_left2;
                 ball_right2=ball_right2;
                 end   
                 else if(start1)
                 begin
                 cd=0;
                 ball_left2=604;        
                 ball_right2 =640;
                 end
                 else if((~(a|b) && (~start1)))
                 begin
                 ball_left2=ball_left2-1;      
                ball_right2 =ball_right2-1;
                 end                          
                    if(ball_right2==0)            
                        begin                     
                           ball_left2=604;        
                           ball_right2 =640;                                                                                                         
                        end                                                                                                                          
             end                             
  ////////////////////Game over /////////////////////////////////////////////////////////////////////////////////////////////////
     square_ballon3 = ((hcount >= ball_left3) && (hcount <= ball_right3) && (vcount >= ball_up3) && (vcount <= ball_down3));                       
            rom_addr3 = vcount[3:0]- ball_up3[3:0];                                                                                                
            rom_col3 =160-( hcount[7:0] - ball_left3[7:0]);                                                                                            
            rom_bit3 =rom_data3[rom_col3];    
        count3=count3+1;
        if(count3[24])
           blink=~blink;      
     ///////line /////////////////////////////////////////////////////////////////////////////////////////////////
      square_ballon4 = ((hcount >= ball_left4) && (hcount <= ball_right4) && (vcount >= ball_up4) && (vcount <= ball_down4));                       
                rom_addr4 = vcount[1:0]- ball_up4[1:0];                                                                                                
                rom_col4 =639-( hcount[9:0] - ball_left4[9:0]);                                                                                            
                rom_bit4 =rom_data4[rom_col4]; 
  ///////////////////////////clouds /////////////////////////////////////////////////////////////////////////////////////////////////
    square_ballon5 = ((hcount >= ball_left5) && (hcount <= ball_right5) && (vcount >= ball_up5) && (vcount <= ball_down5));  
              rom_addr5 = vcount[2:0]- ball_up5[2:0];                                                                        
              rom_col5 =( hcount[4:0] - ball_left5[4:0]);                                                                
              rom_bit5 =rom_data5[rom_col5];                                                                                 
   square_ballon6 = ((hcount >= ball_left6) && (hcount <= ball_right6) && (vcount >= ball_up6) && (vcount <= ball_down6));       
             rom_addr6 = vcount[2:0]- ball_up6[2:0];                                                                             
             rom_col6 =( hcount[4:0] - ball_left6[4:0]);                                                                         
             rom_bit6 =rom_data6[rom_col6];  
  square_ballon7 = ((hcount >= ball_left7) && (hcount <= ball_right7) && (vcount >= ball_up7) && (vcount <= ball_down7));       
             rom_addr7 = vcount[2:0]- ball_up7[2:0];                                                                             
                         rom_col7 =( hcount[4:0] - ball_left7[4:0]);                                                                         
                         rom_bit7 =rom_data7[rom_col7];                                                                                    
 
 
  //////////////////////game over condtions /////////////////////////////////////////////////////////////////////////////////////////////////

    
   a=((ball_left1==229 && ball_down1==321 && ball_down==321)||
     ((ball_left1==229)&&(ball_down>=302 && ball_down<=321))||
     (ball_down>=302 && ((ball_right-8)>=(ball_left1+2) && (ball_right-8)<=(ball_right1-1))) || 
     (ball_down>=302 && ((ball_left+8)>=(ball_left1+1) && (ball_left+8)<=(ball_right1-2))));
   b=((ball_left2==229 && ball_down1==321 && ball_down==321)||
     ((ball_left2==229)&&(ball_down>=302 && ball_down<=321))||
     (ball_down>=302 && ((ball_right-8 )>=(ball_left2+2) && (ball_right-8)<=(ball_right2-1))) || 
     (ball_down>=302 && ((ball_left+8)>=(ball_left2+1) && (ball_left+8)<=(ball_right2-2))));        
  ////////////////////////   Location  to display SCORE /////////////////////////////////////////////////////////////////////////////////////////////////
  a5=((hcount>=455 && hcount<=460 && vcount>=110 && vcount<=112)| //  s
     (hcount>=455 && hcount<=457 && vcount>=110 && vcount<=115) | //
     (hcount>=455 && hcount<=460 && vcount>=115 && vcount<=117) | //
     (hcount>=458 && hcount<=460 && vcount>=117 && vcount<=122) | //
     (hcount>=455 && hcount<=460 && vcount>=120 && vcount<=122) | //
     (hcount>=465 && hcount<=470 && vcount>=110 && vcount<=112) | //   c
     (hcount>=465 && hcount<=467 && vcount>=110 && vcount<=122) | //
     (hcount>=465 && hcount<=470 && vcount>=120 && vcount<=122) | //
     (hcount>=475 && hcount<=480 && vcount>=110 && vcount<=112) | //
     (hcount>=475 && hcount<=477 && vcount>=110 && vcount<=122) | //
     (hcount>=475 && hcount<=480 && vcount>=120 && vcount<=122) | //   o
     (hcount>=479 && hcount<=480 && vcount>=110 && vcount<=122) | //
     (hcount>=485 && hcount<=490 && vcount>=110 && vcount<=112) | //
     (hcount>=485 && hcount<=487 && vcount>=110 && vcount<=122) | //
     (hcount>=485 && hcount<=490 && vcount>=115 && vcount<=117) | //   R
     (hcount>=488 && hcount<=490 && vcount>=110 && vcount<=117) | //
     (hcount>=485 && hcount<=487 && vcount>=117 && vcount<=119) | //
     (hcount>=487 && hcount<=489 && vcount>=118 && vcount<=120) | //
     (hcount>=488 && hcount<=490 && vcount>=120 && vcount<=122) | //
     (hcount>=495 && hcount<=497 && vcount>=110 && vcount<=122) | //   E
     (hcount>=495 && hcount<=500 && vcount>=110 && vcount<=112) | //
     (hcount>=495 && hcount<=500 && vcount>=115 && vcount<=117) | //
     (hcount>=495 && hcount<=500 && vcount>=120 && vcount<=122)); //
  ////////////////////////   Location  to display HI /////////////////////////////////////////////////////////////////////////////////////////////////    
   a6=((hcount>=74 && hcount<=76 && vcount>=110 && vcount<=122)|        
       (hcount>=77 && hcount<=82 && vcount>=115 && vcount<=117)|        
       (hcount>=83 && hcount<=85 && vcount>=110 && vcount<=122)|        
       (hcount>=90 && hcount<=95 && vcount>=110 && vcount<=112)|        
       (hcount>=92 && hcount<=93 && vcount>=110 && vcount<=122)|          
       (hcount>=90 && hcount<=95 && vcount>=120 && vcount<=122));     
  /////////////////////  Assignments of colors to each objects /////////////////////////////////////////////////////////////////////////////////////////////////
       if((square_ballon1 && rom_bit1) || (square_ballon2 && rom_bit2)) //cactus
                  begin                                                   
                     R<= 4'b0000;                                         
                     G<= 4'b1111;                                         
                     B<= 4'b0000;                                       
                  end 
      else if(a5)   //game over   
                 begin
                    R<= 4'b1111; 
                    G<= 4'b0000; 
                    B<= 4'b1111; 
          end   
       else if(a6)   //HI   
                     begin             
                        R<= 4'b1111;  
                        G<= 4'b0000;   
                        B<= 4'b1111;   
              end                      
       else if(square_ballon3 && rom_bit3 && ((a|b) && ~(start1)) )   //game over   
                 begin
                    R<= 4'b1111;
                    G<= 4'b0000; 
                    B<= 4'b0000; 
                 end        
       else if(square_ballon && rom_bit)      //dino
                 begin
                    R<= 4'b1111; 
                    G<= 4'b1111; 
                    B<= 4'b0000; 
                end        
         else if(square_ballon4 && rom_bit4)    //line
                 begin                        
                    R<= 4'b0000;                
                    G<= 4'b1111;                
                    B<= 4'b0000;                                                            
               end    
       else if((square_ballon5 && rom_bit5)||( square_ballon6 && rom_bit6) || (square_ballon7 && rom_bit7))  //clouds      
               begin                                
                   R<= 4'b1111;                        
                   G<= 4'b1111;                        
                   B<= 4'b1111;                        
               end   
      else if( (| seg1) || ( | seg2) || ( | seg3)) //display score
              begin
                   R<=4'hf;
                   G<=4'hf;
                   B<=4'hf;
              end 
      else if( (| seg21) || ( | seg22) || ( | seg23))   //high score display
              begin
                   R<=4'hf;
                   G<=4'hf;
                   B<=4'hf;
              end                                     
         else                                                             
             begin                                //background                        
                R <= 4'b0000;                                             
                G<= 4'b0000;                                              
                B<= 4'b0000;                                              
             end                                                          
                                                                                                                           
  end
/////////////////////// Instantiation of VGA Controller ///////////////////////////////////////////////////////////////////////////////////////////////////////////
vga_controller u1(clk_25,HS,VS,hcount,vcount,blank);
endmodule
