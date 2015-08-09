`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Middle East Technical University
// Engineer: Meriç SARIIŞIK
// 
// Create Date:    14:36:47 05/23/2015 
// Design Name: Dipole
// Module Name:    dipole
// Project Name: 
// Target Devices: Cyclone V
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module dipole(clk_in, clk_out, r_vga, g_vga, b_vga, h_sync, v_sync, h_c, v_c, cw, ccw, start, stop,led,led2);
	
	//clock defintion (clk_in = 50 mhz )
	input clk_in;
	output clk_out;
	reg clk_out;
	
	//button effects with clockwise btn<2> and counter clockwise btn<2>
	input cw;
	input ccw;
	
	//play and reset button
	input start;
	input stop;
	
	//rgb color decleration
	output reg [7:0] r_vga;
	output reg [7:0] g_vga;
	output reg [7:0] b_vga;
	
	//horizontal and vertical synch.
	output reg h_sync;
	output reg v_sync;
	
	// counter for horizontal and vertical axis
	output [9:0] h_c;
	output [9:0] v_c;
	
	// operating clock 25 mhz
	reg clk_op;
	
	// length of horizontal and vertical axis
	parameter h_end = 800;
	parameter h_on = 640;
	parameter h_fp = 16;
	parameter h_bp = 48;
	parameter h_sp = 96;
	parameter h_p = 0;
	parameter v_end = 525;
	parameter v_on = 480;
	parameter v_fp = 10;
	parameter v_bp = 33;
	parameter v_sp = 2;
	parameter v_p = 0;	
	
	// variable for counting axis
	reg [9:0] h_count = 0;
	reg [9:0] v_count = 0;

	assign h_c = h_count;
	assign v_c = v_count;
	
	// What we will see on screen 
	reg vga_out;
	reg circle;
	reg block1;
	reg block2;
	reg block3;
	reg block4;
	reg redball;
	reg blueball;
	
	// debug led
	output led;
	output led2;
	reg led2;
	reg led;
	
	
	//USER CODE/////////////////////////////////////////////////////////////
	
	
	//clock division from 50 mhz to 25 mhz
	always @ (posedge clk_in)
		begin
			clk_out = ~clk_out;
		end
	
	always @ (posedge clk_in)
		begin
			clk_op =~clk_op; 
		end
		
	always @ (posedge clk_op)
		begin
			if (h_count == (h_end - 1))
			begin
					h_count = 0;
				
				if (v_count == (v_end - 1))
					begin
					v_count = 0;
					end
				else
					begin
					v_count = v_count + 1;
					end
			end			
			else
				begin
				h_count = h_count + 1;
				end
			
		end
		
		
		always @*
			begin
				if (h_count>=0 && h_count<h_on && v_count>=0 && v_count<v_on)
					vga_out = 1;
				else
					vga_out = 0;
				if (h_count >= (h_on + h_fp) && h_count < (h_on + h_fp + h_sp))
					h_sync = h_p;
				else
					h_sync = ~h_p;
				if (v_count >= (v_on + v_fp) && v_count < (v_on + v_fp + v_sp))
					v_sync = v_p;
				else
					v_sync = ~v_p;
			end
			
			
			// color implementation
			always @ (posedge clk_in)
		begin
			if (vga_out)
				begin	
					r_vga= 8'b00000000;
					g_vga= 8'b00000000;
					b_vga= 8'b00000000;
				if (block1 || block2 || block3 || block4)
					begin
						r_vga = 8'b00000000;
						g_vga = 8'b11111111;
						b_vga = 8'b00000000;
					end
				else if (redball)
					begin
						r_vga = 8'b11111111;
						g_vga = 8'b00000000;
						b_vga = 8'b00000000;
					end
				else if (blueball)
					begin
						r_vga = 8'b00000000;
						g_vga = 8'b00000000;
						b_vga = 8'b11111111;
					end
				else if (circle || a1_rgb || b1_rgb || c1_rgb || d1_rgb || e1_rgb || f1_rgb || g1_rgb || a2_rgb || b2_rgb || c2_rgb || d2_rgb || e2_rgb || f2_rgb || g2_rgb || 
				a3_rgb || b3_rgb || c3_rgb || d3_rgb || e3_rgb || f3_rgb || g3_rgb ||a4_rgb || b4_rgb || c4_rgb || d4_rgb || e4_rgb || f4_rgb || g4_rgb || T_rgb_I || T_rgb_T ||
				S_rgb_b || S_rgb_l || S_rgb_m || S_rgb_r || S_rgb_t)
					begin
						r_vga = 8'b11111111;
						g_vga = 8'b11111111;
						b_vga = 8'b11111111;
					end
				end
			else
				begin
					r_vga= 8'b00000000;
					g_vga= 8'b00000000;
					b_vga= 8'b00000000;
				end
		end	

		//TEXT FOR SPEED AND TIME
		
		//7-seg decleration
		reg a1,b1,c1,d1,e1,f1,g1;
		reg a1_rgb,b1_rgb,c1_rgb,d1_rgb,e1_rgb,f1_rgb,g1_rgb;
		reg a2,b2,c2,d2,e2,f2,g2;
		reg a2_rgb,b2_rgb,c2_rgb,d2_rgb,e2_rgb,f2_rgb,g2_rgb;
		reg a3,b3,c3,d3,e3,f3,g3;
		reg a3_rgb,b3_rgb,c3_rgb,d3_rgb,e3_rgb,f3_rgb,g3_rgb;
		reg a4,b4,c4,d4,e4,f4,g4;
		reg a4_rgb,b4_rgb,c4_rgb,d4_rgb,e4_rgb,f4_rgb,g4_rgb;
		reg T_rgb_T,T_rgb_I,S_rgb_b,S_rgb_l,S_rgb_m,S_rgb_r,S_rgb_t;
		
		initial
			begin
			a1 = 1;
			b1 = 1;
			c1 = 1;
			d1 = 1;
			e1 = 1;
			f1 = 1;
			g1 = 0;
			a2 = 1;
			b2 = 1;
			c2 = 1;
			d2 = 1;
			e2 = 1;
			f2 = 1;
			g2 = 0;
			a3 = 1;
			b3 = 1;
			c3 = 1;
			d3 = 1;
			e3 = 1;
			f3 = 1;
			g3 = 0;
			a4 = 1;
			b4 = 1;
			c4 = 1;
			d4 = 1;
			e4 = 1;
			f4 = 1;
			g4 = 0;
			end
			
		//first segment
		always @ (posedge clk_in)
		begin
			if (a1==1)
				begin
					if (h_count<=49 && h_count>=42 && v_count>=20 && v_count<=21)
						a1_rgb = 1;
					else
						a1_rgb = 0;
				end
		end
		
		always @ (posedge clk_in)
		begin
			if (b1==1)
				begin
					if (h_count<=51 && h_count>=50 && v_count>=22 && v_count<=29)
						b1_rgb = 1;
					else
						b1_rgb = 0;
				end
		end
		
		always @ (posedge clk_in)
		begin
			if (c1==1)
				begin
					if (h_count<=51 && h_count>=50 && v_count>=32 && v_count<=39)
						c1_rgb = 1;
					else
						c1_rgb = 0;
				end
		end
		
		always @ (posedge clk_in)
		begin
			if (d1==1)
				begin
					if (h_count<=49 && h_count>=42 && v_count>=40 && v_count<=41)
						d1_rgb = 1;
					else
						d1_rgb = 0;
				end
		end
		
		always @ (posedge clk_in)
		begin
			if (e1==1)
				begin
					if (h_count<=41 && h_count>=40 && v_count>=32 && v_count<=39)
						e1_rgb = 1;
					else
						e1_rgb = 0;
				end
		end
		
		always @ (posedge clk_in)
		begin
			if (f1==1)
				begin
					if (h_count<=41 && h_count>=40 && v_count>=22 && v_count<=29)
						f1_rgb = 1;
					else
						f1_rgb = 0;
				end
		end

		always @ (posedge clk_in)
		begin
			if (g1==1)
				begin
					if (h_count<=49 && h_count>=42 && v_count>=30 && v_count<=31)
						g1_rgb = 1;
					else
						g1_rgb = 0;
				end
		end
		
		// second segment
		always @ (posedge clk_in)
		begin
			if (a2==1)
				begin
					if (h_count<=69 && h_count>=62 && v_count>=20 && v_count<=21)
						a2_rgb = 1;
					else
						a2_rgb = 0;
				end
		end
		
		always @ (posedge clk_in)
		begin
			if (b2==1)
				begin
					if (h_count<=71 && h_count>=70 && v_count>=22 && v_count<=29)
						b2_rgb = 1;
					else
						b2_rgb = 0;
				end
		end
		
		always @ (posedge clk_in)
		begin
			if (c2==1)
				begin
					if (h_count<=71 && h_count>=70 && v_count>=32 && v_count<=39)
						c2_rgb = 1;
					else
						c2_rgb = 0;
				end
		end
		
		always @ (posedge clk_in)
		begin
			if (d2==1)
				begin
					if (h_count<=69 && h_count>=62 && v_count>=40 && v_count<=41)
						d2_rgb = 1;
					else
						d2_rgb = 0;
				end
		end
		
		always @ (posedge clk_in)
		begin
			if (e2==1)
				begin
					if (h_count<=61 && h_count>=60 && v_count>=32 && v_count<=39)
						e2_rgb = 1;
					else
						e2_rgb = 0;
				end
		end
		
		always @ (posedge clk_in)
		begin
			if (f2==1)
				begin
					if (h_count<=61 && h_count>=60 && v_count>=22 && v_count<=29)
						f2_rgb = 1;
					else
						f2_rgb = 0;
				end
		end

		always @ (posedge clk_in)
		begin
			if (g2==1)
				begin
					if (h_count<=69 && h_count>=62 && v_count>=30 && v_count<=31)
						g2_rgb = 1;
					else
						g2_rgb = 0;
				end
		end
		
		//third segment
		always @ (posedge clk_in)
		begin
			if (a3==1)
				begin
					if (h_count<=49 && h_count>=42 && v_count>=60 && v_count<=61)
						a3_rgb = 1;
					else
						a3_rgb = 0;
				end
		end
		
		always @ (posedge clk_in)
		begin
			if (b3==1)
				begin
					if (h_count<=51 && h_count>=50 && v_count>=62 && v_count<=69)
						b3_rgb = 1;
					else
						b3_rgb = 0;
				end
		end
		
		always @ (posedge clk_in)
		begin
			if (c3==1)
				begin
					if (h_count<=51 && h_count>=50 && v_count>=72 && v_count<=79)
						c3_rgb = 1;
					else
						c3_rgb = 0;
				end
		end
		
		always @ (posedge clk_in)
		begin
			if (d3==1)
				begin
					if (h_count<=49 && h_count>=42 && v_count>=80 && v_count<=81)
						d3_rgb = 1;
					else
						d3_rgb = 0;
				end
		end
		
		always @ (posedge clk_in)
		begin
			if (e3==1)
				begin
					if (h_count<=41 && h_count>=40 && v_count>=72 && v_count<=79)
						e3_rgb = 1;
					else
						e3_rgb = 0;
				end
		end
		
		always @ (posedge clk_in)
		begin
			if (f3==1)
				begin
					if (h_count<=41 && h_count>=40 && v_count>=62 && v_count<=69)
						f3_rgb = 1;
					else
						f3_rgb = 0;
				end
		end

		always @ (posedge clk_in)
		begin
			if (g3==1)
				begin
					if (h_count<=49 && h_count>=42 && v_count>=70 && v_count<=71)
						g3_rgb = 1;
					else
						g3_rgb = 0;
				end
		end
		
		//forth segment
		always @ (posedge clk_in)
		begin
			if (a4==1)
				begin
					if (h_count<=69 && h_count>=62 && v_count>=60 && v_count<=61)
						a4_rgb = 1;
					else
						a4_rgb = 0;
				end
		end
		
		always @ (posedge clk_in)
		begin
			if (b4==1)
				begin
					if (h_count<=71 && h_count>=70 && v_count>=62 && v_count<=69)
						b4_rgb = 1;
					else
						b4_rgb = 0;
				end
		end
		
		always @ (posedge clk_in)
		begin
			if (c4==1)
				begin
					if (h_count<=71 && h_count>=70 && v_count>=72 && v_count<=79)
						c4_rgb = 1;
					else
						c4_rgb = 0;
				end
		end
		
		always @ (posedge clk_in)
		begin
			if (d4==1)
				begin
					if (h_count<=69 && h_count>=62 && v_count>=80 && v_count<=81)
						d4_rgb = 1;
					else
						d4_rgb = 0;
				end
		end
		
		always @ (posedge clk_in)
		begin
			if (e4==1)
				begin
					if (h_count<=61 && h_count>=60 && v_count>=72 && v_count<=79)
						e4_rgb = 1;
					else
						e4_rgb = 0;
				end
		end
		
		always @ (posedge clk_in)
		begin
			if (f4==1)
				begin
					if (h_count<=61 && h_count>=60 && v_count>=62 && v_count<=69)
						f4_rgb = 1;
					else
						f4_rgb = 0;
				end
		end

		always @ (posedge clk_in)
		begin
			if (g4==1)
				begin
					if (h_count<=69 && h_count>=62 && v_count>=70 && v_count<=71)
						g4_rgb = 1;
					else
						g4_rgb = 0;
				end
		end
		
		// Time display
		always @ (posedge clk_in)
		begin
			if (h_count<=32 && h_count>=20 && v_count>=20 && v_count<=22)
				T_rgb_T = 1;
			else
				T_rgb_T = 0;
		end
		
		always @ (posedge clk_in)
		begin
			if (h_count<=27 && h_count>=25 && v_count>=22 && v_count<=42)
				T_rgb_I = 1;
			else
				T_rgb_I = 0;
		end
		
		//Score display
		always @ (posedge clk_in)
		begin
			if (h_count<=32 && h_count>=20 && v_count>=60 && v_count<=62)
				S_rgb_t = 1;
			else
				S_rgb_t = 0;
		end
		
		always @ (posedge clk_in)
		begin
			if (h_count<=22 && h_count>=20 && v_count>=62 && v_count<=70)
				S_rgb_l = 1;
			else
				S_rgb_l = 0;
		end
		
		always @ (posedge clk_in)
		begin
			if (h_count<=32 && h_count>=20 && v_count>=70 && v_count<=72)
				S_rgb_m = 1;
			else
				S_rgb_m = 0;
		end
		
		always @ (posedge clk_in)
		begin
			if (h_count<=32 && h_count>=30 && v_count>=72 && v_count<=80)
				S_rgb_r = 1;
			else
				S_rgb_r = 0;
		end
		
		always @ (posedge clk_in)
		begin
			if (h_count<=32 && h_count>=20 && v_count>=80 && v_count<=82)
				S_rgb_b = 1;
			else
				S_rgb_b = 0;
		end
		
		reg zeroT,oneT,twoT,threeT,fourT,fiveT,sixT,sevenT,eightT,nineT,tenT,elevenT,twentyT,thirdteenT;
		
		always @ (posedge clk_in)
		begin
			if	(zeroT)
				begin
				a1 = 1;
				b1 = 1;
				c1 = 1;
				d1 = 1;
				e1 = 1;
				f1 = 1;
				g1 = 0;
				a2 = 1;
				b2 = 1;
				c2 = 1;
				d2 = 1;
				e2 = 1;
				f2 = 1;
				g2 = 0;	
				end
			else if (oneT)
				begin
			//zero	
				a1 = 1;
				b1 = 1;
				c1 = 1;
				d1 = 1;
				e1 = 1;
				f1 = 1;
				g1 = 0;
			//one	
				a2 = 0;
				b2 = 1;
				c2 = 1;
				d1 = 0;
				e1 = 0;
				f1 = 0;
				g1 = 0;
				end
			else if (twoT)
				begin
				a1 = 1;
				b1 = 1;
				c1 = 1;
				d1 = 1;
				e1 = 1;
				f1 = 1;
				g1 = 0;
				a2 = 1;
				b2 = 1;
				c2 = 0;
				d2 = 1;
				e2 = 1;
				f2 = 0;
				g2 = 1;
				end
			else if (threeT)
				begin
				a1 = 1;
				b1 = 1;
				c1 = 1;
				d1 = 1;
				e1 = 1;
				f1 = 1;
				g1 = 0;
				a2 = 1;
				b2 = 1;
				c2 = 1;
				d2 = 1;
				e2 = 0;
				f2 = 0;
				g2 = 1;
				end
			else if (fourT)
				begin
				a1 = 1;
				b1 = 1;
				c1 = 1;
				d1 = 1;
				e1 = 1;
				f1 = 1;
				g1 = 0;
				a2 = 0;
				b2 = 1;
				c2 = 1;
				d2 = 0;
				e2 = 0;
				f2 = 1;
				g2 = 1;
				end
			else if (fiveT)
				begin
				a1 = 1;
				b1 = 1;
				c1 = 1;
				d1 = 1;
				e1 = 1;
				f1 = 1;
				g1 = 0;
				a2 = 1;
				b2 = 0;
				c2 = 1;
				d2 = 1;
				e2 = 0;
				f2 = 1;
				g2 = 1;
				end
			else if (sixT)
				begin
				a1 = 1;
				b1 = 1;
				c1 = 1;
				d1 = 1;
				e1 = 1;
				f1 = 1;
				g1 = 0;
				a2 = 1;
				b2 = 0;
				c2 = 1;
				d2 = 1;
				e2 = 1;
				f2 = 1;
				g2 = 1;
				end
			else if (sevenT)
				begin
				a1 = 1;
				b1 = 1;
				c1 = 1;
				d1 = 1;
				e1 = 1;
				f1 = 1;
				g1 = 0;
				a2 = 1;
				b2 = 1;
				c2 = 1;
				d2 = 0;
				e2 = 0;
				f2 = 0;
				g2 = 0;
				end
			else if (eightT)
				begin
				a1 = 1;
				b1 = 1;
				c1 = 1;
				d1 = 1;
				e1 = 1;
				f1 = 1;
				g1 = 0;
				a2 = 1;
				b2 = 1;
				c2 = 1;
				d2 = 1;
				e2 = 1;
				f2 = 1;
				g2 = 1;
				end
			else if (nineT)
				begin
				a1 = 1;
				b1 = 1;
				c1 = 1;
				d1 = 1;
				e1 = 1;
				f1 = 1;
				g1 = 0;
				a2 = 1;
				b2 = 1;
				c2 = 1;
				d2 = 1;
				e2 = 0;
				f2 = 1;
				g2 = 1;
				end
			else if (tenT)
				begin
				a1 = 0;
				b1 = 1;
				c1 = 1;
				d1 = 0;
				e1 = 0;
				f1 = 0;
				a2 = 1;
				b2 = 1;
				c2 = 1;
				d2 = 1;
				e2 = 1;
				f2 = 1;
				g2 = 0;
				end
			else if (elevenT)
				begin
				a1 = 0;
				b1 = 1;
				c1 = 1;
				d1 = 0;
				e1 = 0;
				f1 = 0;
				g1 = 0;
				a2 = 0;
				b2 = 1;
				c2 = 1;
				d2 = 0;
				e2 = 0;
				f2 = 0;
				g2 = 0;
				end
			else if (twentyT)
				begin
				a1 = 0;
				b1 = 1;
				c1 = 1;
				d1 = 0;
				e1 = 0;
				f1 = 0;
				g1 = 0;
				a2 = 1;
				b2 = 1;
				c2 = 0;
				d2 = 1;
				e2 = 1;
				f2 = 0;
				g2 = 1;
				end
			else if (thirdteenT)
				begin
				a1 = 0;
				b1 = 1;
				c1 = 1;
				d1 = 0;
				e1 = 0;
				f1 = 0;
				g1 = 0;
				a2 = 1;
				b2 = 1;
				c2 = 1;
				d2 = 1;
				e2 = 0;
				f2 = 0;
				g2 = 1;
				end
			else
				begin
					a1 = 1;
					a2 = 1;
					a3 = 1;
					a4 = 1;
					b1 = 1;
					b2 = 1;
					b3 = 1;
					b4 = 1;
					c1 = 1;
					c2 = 1;
					c3 = 1;
					c4 = 1;
					d1 = 1;
					d2 = 1;
					d3 = 1;
					d4 = 1;
					e1 = 1;
					e2 = 1;
					e3 = 1;
					e4 = 1;
					f1 = 1;
					f2 = 1;
					f3 = 1;
					f4 = 1;
					g1 = 0;
					g2 = 0;
					g3 = 0;
					g4 = 0;
				end
		end
		
		//blocks
		
		reg [8:0] block1_x;
		reg [8:0] block2_x;
		reg [8:0] block3_x;
		reg [8:0] block4_x;
		reg [8:0] block_at_right = 390;
		reg [8:0] block_at_left = 250;
		reg [8:0] block_at_center = 320;
		wire [9:0] block1_y = top_screen[9:0] - 100;
		wire [9:0] block2_y = top_screen[9:0] - 250;
		wire [9:0] block3_y = top_screen[9:0] - 400;
		wire [9:0] block4_y = top_screen[9:0] - 500;
		reg [9:0] top_screen = 0;
		
				
		////balls on circle
		
		//circle
		reg [8:0] circle_mx=320;
		reg [8:0] circle_my=400;
		
		
		//small balls
		reg [9:0] redball_mx;
	   reg [9:0] blueball_mx;
	   reg [9:0] blueball_my;
		reg [9:0] redball_my;
		initial
			begin
				redball_mx=250;
				redball_my=400;
				blueball_mx=390;
				blueball_my=400;
			end
		
		// block speed 
		reg b_speed;
		reg circle_speed;
		reg clk_10000hz;
		reg mixed;
		reg [11:0] count1=0;
		reg [9:0] count2=0;
		reg [9:0] count3=0;
		
		always @ (posedge clk_in)
		begin
			if (count1<2499)
				begin
					count1 = count1+1;
				end
			else
				begin
					count1 = 0;
					clk_10000hz = ~clk_10000hz;
				end
			
		end
		
		always @ (posedge clk_10000hz)
		begin
			if (count2<99)
				begin
					count2 = count2+1;
				end
			else
				begin
					count2 = 0;
					b_speed = ~b_speed;
				end
		end
		
		always @ (posedge b_speed)
		begin
			if (count3<99)
				begin
					count3 = count3 + 1;
				end
			else
				begin
					count3 = 0;
					mixed = ~mixed;
				end
		end
		
		//random blocks falling
		reg [3:0] block_rand = 0;
		reg [4:0]second;
		
		always @ (posedge mixed)
		begin
			block_rand = (block_rand + 3) % 8;
			if (on == 1 && rst == 0)
			second = second + 1;
			else if (on == 0 && rst == 1)
			second = 0;
		end
		
		always @ (posedge clk_in)
		begin
			case (second)
			0:zeroT=1;
			1:oneT=1;
			2:twoT=1;
			3:threeT=1;
			4:fourT=1;
			5:fiveT=1;
			6:sixT=1;
			7:sevenT=1;
			8:eightT=1;
			9:nineT=1;
			endcase
		end
		
		always @ (posedge clk_in)
		begin
			if (top_screen <20)
				begin
					case (block_rand)
						0:begin
							block1_x = block_at_right;
							block2_x = block_at_left;
							block3_x = block_at_center;
							block4_x = block_at_center;
						end
						1:begin
							block1_x = block_at_left;
							block2_x = block_at_right;
							block3_x = block_at_right;
							block4_x = block_at_left;
						end
						2:begin
							block1_x = block_at_right;
							block2_x = block_at_left;
							block3_x = block_at_right;
							block4_x = block_at_left;
						end
						3:begin
							block1_x = block_at_left;
							block2_x = block_at_right;
							block3_x = block_at_left;
							block4_x = block_at_right;
						end
						4:begin
							block1_x = block_at_right;
							block2_x = block_at_left;
							block3_x = block_at_left;
							block4_x = block_at_right;
						end
						5:begin
							block1_x = block_at_left;
							block2_x = block_at_right;
							block3_x = block_at_center;
							block4_x = block_at_center;
						end
						6:begin
							block1_x = block_at_left;
							block2_x = block_at_right;
							block3_x = block_at_center;
							block4_x = block_at_right;
						end
						7:begin
							block1_x = block_at_right;
							block2_x = block_at_left;
							block3_x = block_at_left;
							block4_x = block_at_center;
						end
					endcase
				end
		end
		
		//drawing
		always @ (posedge clk_in)
		begin
			if (h_count<=block2_x+70 && h_count>=block2_x-70 && v_count>=block2_y-20 && v_count<=block2_y+20)
				begin
					block2=1;					
				end
			else
				begin
					block2=0;
				end
		end
		
		always @ (posedge clk_in)
		begin
			if (h_count<=block1_x+70 && h_count>=block1_x-70 && v_count>=block1_y-20 && v_count<=block1_y+20)
				begin
					block1=1;
				end
			else
				begin
					block1=0;
				end
		end
		
		always @ (posedge clk_in)
		begin
			if (h_count<=block3_x+20 && h_count>=block3_x-20 && v_count>=block3_y-20 && v_count<=block3_y+20)
				begin
					block3=1;
				end
			else
				begin
					block3=0;
				end
		end
		
		always @ (posedge clk_in)
		begin
			if (h_count<=block4_x+20 && h_count>=block4_x-20 && v_count>=block4_y-20 && v_count<=block4_y+20)
				begin
					block4=1;
				end
			else
				begin
					block4=0;
				end
		end
		
		always  @ (posedge clk_in)
		begin
			if(5041 >= ((((h_count-circle_mx)*(h_count-circle_mx)) + ((v_count-circle_my)*(v_count-circle_my)))) && (4761 <= ((h_count-circle_mx)*(h_count-circle_mx)) + ((v_count-circle_my)*(v_count-circle_my))))
				begin
					circle=1;
				end
			else
				circle = 0;
		end
		
		always @ (posedge clk_in)
		begin
			if (225 >= ((h_count-redball_mx)*(h_count-redball_mx)) + ((v_count-redball_my)*(v_count-redball_my)))
				begin
					redball=1;
				end			
			else
				redball=0;
		end
		
		always @ (posedge clk_in)
		begin
			if (225 >= ((h_count - blueball_mx)*(h_count - blueball_mx) + (v_count - blueball_my)*(v_count - blueball_my)))
				begin
					blueball=1;
				end
			else 
				blueball = 0;
		end
		
		// blocks move down
		reg [1:0] state; 
		
		always @ (posedge b_speed)
		begin
			case (state)
				0: top_screen = 0;
				1: top_screen = top_screen + 3;
				2:top_screen = top_screen + 6;
				3:top_screen = top_screen + 9;
			endcase
			circle_speed = ~circle_speed;
		end
		
		//collision and start and stop
		
		reg on;
		reg rst;
		
		initial
			begin
				on = 0;
				rst = 0;
			end
		
		always @ (posedge clk_in)
		begin
			if (!start)
				begin
					on = 1;
					rst = 0;
					led = 1;
					led2 = 0;
				end
			else if (!stop)
				begin
					rst = 1;
					on = 0;
					led2 = 1;
					led = 0;
				end
		end
		
		always @ (posedge clk_in)
		begin
			if (on == 1 && rst == 0)
				begin
					if (((redball_mx - 10 >= block1_x - 70) && (redball_mx - 10 <= block1_x + 70) && (redball_my - 10 <= block1_y + 20) && (redball_my + 10 >= block1_y - 20)) ||
					((blueball_mx - 10 >= block1_x - 70) && (blueball_mx - 10 <= block1_x + 70) && (blueball_my - 10 <= block1_y + 20) && (blueball_my + 10 >= block1_y - 20)) ||
					((redball_mx - 10 >= block3_x - 20) && (redball_mx - 10 <= block3_x + 20) && (redball_my - 10 <= block3_y + 20) && (redball_my + 10 >= block3_y - 20)) ||
					((blueball_mx - 10 >= block3_x - 20) && (blueball_mx - 10 <= block3_x + 20) && (blueball_my - 10 <= block3_y + 20) && (blueball_my + 10 >= block3_y - 20)) ||
					((redball_mx - 10 >= block2_x - 70) && (redball_mx - 10 <= block2_x + 70) && (redball_my - 10 <= block2_y + 20) && (redball_my + 10 >= block2_y - 20)) ||
					((blueball_mx - 10 >= block2_x - 70) && (blueball_mx - 10 <= block2_x + 70) && (blueball_my - 10 <= block2_y + 20) && (blueball_my + 10 >= block2_y - 20)) ||
					((redball_mx - 10 >= block4_x - 20) && (redball_mx - 10 <= block4_x + 20) && (redball_my - 10 <= block4_y + 20) && (redball_my + 10 >= block4_y - 20)) ||
					((blueball_mx - 10 >= block4_x - 20) && (blueball_mx - 10 <= block4_x + 20) && (blueball_my - 10 <= block4_y + 20) && (blueball_my + 10 >= block4_y - 20)))
						begin
							state = 0;
						end
					else 
						if (second<=5)
						state = 1;
						else if (second >= 6 && second <= 15)
						state = 2;
						else if (second >= 16)
						state = 3;
				end
			else if (on == 0 && rst == 1)
				begin
					state = 0;
				end
		end
		
		
		
		// movement on circle via Newton–Raphson method to find square root of circle equation then find Y-axis position
		
		reg [12:0] y;
		reg [7:0] my;
		reg [7:0] my1;
		reg [7:0] my2;
		reg [7:0] my3;
		reg [7:0] my4;
		reg [7:0] my5;
		reg [7:0] my6;
		reg [8:0] mx; 
		
		always @(posedge circle_speed)
		begin
				if (!cw)
					begin
						if (redball_mx>=250 && redball_mx<=390)
							begin
								if (redball_mx == 250)
									begin
										redball_my = 375;
										redball_mx = 260;
										blueball_my = 425;
										blueball_mx = 380;
									end
								else if (redball_mx == 390)
									begin
										redball_my = 425;
										redball_mx = 380;
										blueball_my = 375;
										blueball_mx = 260;
									end
								else
									begin
										if (redball_my < 400 && redball_mx > 389)
											begin	
												redball_my = 400;
												redball_mx = 390;
												blueball_my = 400;
												blueball_mx = 250;
											end
										else if (redball_my < 400 && redball_mx <= 389)
											begin
												mx = redball_mx + 10;
												y = 4900 - (320 - mx)*(320 - mx);
												my6 = 70 - (4900-y)/140;
												my5 = my6 - (my6*my6 - y)/(my6+my6);
												my4 = my5 - (my5*my5 - y)/(my5+my5);
												my3 = my4 - (my4*my4 - y)/(my4+my4);
												my2 = my3 - (my3*my3 - y)/(my3+my3);
												my1 = my2 - (my2*my2 - y)/(my2+my2);
												my = my1 - (my1*my1 - y)/(my1+my1);
												redball_my = 400 - my - (my*my-y)/(2*my);
												redball_mx = redball_mx + 10;
												blueball_mx = 640 - redball_mx;
												blueball_my = 800 - redball_my;
											end
										else if (redball_my > 400 && redball_mx < 251)
											begin
												redball_my = 400;
												redball_mx = 250;
												blueball_mx = 390;
												blueball_my = 400;
											end	
										else if (redball_my > 400 && redball_mx >= 251)
											begin		
												mx = redball_mx - 10;
												y = 4900 - (320 - mx)*(320 - mx);
												my6 = 70 - (4900-y)/140;
												my5 = my6 - (my6*my6 - y)/(my6+my6);
												my4 = my5 - (my5*my5 - y)/(my5+my5);
												my3 = my4 - (my4*my4 - y)/(my4+my4);
												my2 = my3 - (my3*my3 - y)/(my3+my3);
												my1 = my2 - (my2*my2 - y)/(my2+my2);
												my = my1 - (my1*my1 - y)/(my1+my1);
												redball_my = 400 + my - (my*my-y)/(2*my);
												redball_mx = redball_mx - 10;
												blueball_mx = 640 - redball_mx;
												blueball_my = 800 - redball_my;
											end
									end
							 end
					end
				else if (!ccw)
					begin
						if (redball_mx>=250 && redball_mx<=390)
							begin
								if (redball_mx == 250)
									begin
										redball_my = 425;
										redball_mx = 260;
										blueball_my = 375;
										blueball_mx = 380;
									end
								else if (redball_mx == 390)
									begin
										redball_my = 375;
										redball_mx = 380;
										blueball_my = 425;
										blueball_mx = 260;
									end
								else
									begin
										if (redball_my < 400 && redball_mx < 251)
											begin	
												redball_my = 400;
												redball_mx = 390;
												blueball_my = 400;
												blueball_mx = 250;
											end
										else if (redball_my < 400 && redball_mx >= 251)
											begin
												mx = redball_mx - 10;
												y = 4900 - (320 - mx)*(320 - mx);
												my6 = 70 - (4900-y)/140;
												my5 = my6 - (my6*my6 - y)/(my6+my6);
												my4 = my5 - (my5*my5 - y)/(my5+my5);
												my3 = my4 - (my4*my4 - y)/(my4+my4);
												my2 = my3 - (my3*my3 - y)/(my3+my3);
												my1 = my2 - (my2*my2 - y)/(my2+my2);
												my = my1 - (my1*my1 - y)/(my1+my1);
												redball_my = 400 - my - (my*my-y)/(2*my);
												redball_mx = redball_mx - 10;
												blueball_mx = 640 - redball_mx;
												blueball_my = 800 - redball_my;
											end
										else if (redball_my > 400 && redball_mx > 389)
											begin
												redball_my = 400;
												redball_mx = 250;
												blueball_mx = 390;
												blueball_my = 400;
											end	
										else if (redball_my > 400 && redball_mx <= 389)
											begin		
												mx = redball_mx + 10;
												y = 4900 - (320 - mx)*(320 - mx);
												my6 = 70 - (4900-y)/140;
												my5 = my6 - (my6*my6 - y)/(my6+my6);
												my4 = my5 - (my5*my5 - y)/(my5+my5);
												my3 = my4 - (my4*my4 - y)/(my4+my4);
												my2 = my3 - (my3*my3 - y)/(my3+my3);
												my1 = my2 - (my2*my2 - y)/(my2+my2);
												my = my1 - (my1*my1 - y)/(my1+my1);
												redball_my = 400 + my - (my*my-y)/(2*my);
												redball_mx = redball_mx + 10;
												blueball_mx = 640 - redball_mx;
												blueball_my = 800 - redball_my;
											end
									end
							end
					end
		end
endmodule



















