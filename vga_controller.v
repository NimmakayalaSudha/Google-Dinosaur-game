`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/15/2020 04:09:36 PM
// Design Name: 
// Module Name: vga_controller
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


module vga_controller (pixel_clk,HS,VS,hcounter,vcounter,blank);

	input pixel_clk;	// It is the 25MHz clk to drive the VGA
	output reg HS, VS;  // synchronization pulses to VGA
	output reg blank;	// To indicate the blank region
	output reg [10:0] hcounter, vcounter;	
	parameter HMAX = 800; 	//Maximum Horizontal pixel count
	parameter VMAX = 525; 	//Maximum Vertical pixel count
	parameter HLINES = 640;	// Horizontal display pixels
	parameter VLINES = 480;		//Vertical display pixels
	parameter HSP = 744;   // Horizontal sync pulse pixels 
    parameter HFP = 648;   // Horizontal Front porch pixels
	parameter VFP = 482;  // Vertical Front porch pixels
	parameter VSP = 484;  //Vertical sync pulse pixels
	parameter SPP = 0;	

	wire video_enable;
	
	always@(posedge pixel_clk)begin
		blank <= ~video_enable;    //Idicating the region where video is disabled(blank region)
	end

// Incrementation of horizontal count
	always@(posedge pixel_clk)begin
		if(hcounter == HMAX) hcounter <= 0;
		else hcounter <= hcounter + 1'b1;
	end
	
// Incrementation of vertical count
	always@(posedge pixel_clk)begin
		if(hcounter == HMAX) begin
			if(vcounter == VMAX) vcounter <= 0;
			else vcounter <= vcounter + 1'b1; 
		end
	end

// For Horizontal sync pulse	
	always@(posedge pixel_clk)begin
		if(hcounter >= HFP && hcounter < HSP) HS <= SPP;
		else HS <= ~SPP; 
	end

// For vertical sync pulse	
	always@(posedge pixel_clk)begin
		if(vcounter >= VFP && vcounter < VSP) VS <= SPP;
		else VS <= ~SPP; 
	end
	
	
//For video enable region	
	assign video_enable = (hcounter < HLINES && vcounter < VLINES) ? 1'b1 : 1'b0;

endmodule

