module Clock (Clkin, Reset, HEX0, HEX6, HEX7, HEX2, HEX3, HEX4, HEX5, LEDR);
	input Clkin;
	input Reset;
	output [6:0] HEX0, HEX6, HEX2, HEX3, HEX4, HEX5, HEX7;
	output LEDR;
	wire [3:0]HR1,HR0,MI1,MI0,SE1,SE0;
	wire [3:0]temp;
	ClktoCounter (Clkin, Reset,HR1,HR0,MI1,MI0,SE1,SE0,temp);
	assign LEDR =temp;
	FourTo7Seg H1 (HR1,HEX7);
	FourTo7Seg H0 (HR0,HEX6);
	FourTo7Seg M1 (MI1,HEX5);
	FourTo7Seg M0 (MI0,HEX4);
	FourTo7Seg S1 (SE1,HEX3);
	FourTo7Seg S0 (SE0,HEX2);
	FourTo7Seg AM (temp,HEX0);
	
endmodule




module ClktoCounter (Clk, reset, Hrs1, Hrs0, Min1, Min0, Sec1, Sec0, AP);
	input Clk;
	input reset;
	output [3:0]Hrs0, Min0, Sec0;
	output [2:0]Hrs1, Min1, Sec1;
	output [3:0]AP;
	
	reg [25:0]Counter;
	reg [3:0]h0, m0, s0;
	reg [3:0]h1, m1, s1;
	reg ap;
	reg [3:0]alap; //am = 1, pm = 0;
	
	initial 
		begin 
			Counter = 0;
			h1 = 1;	h0 = 1;
			m1 = 5;	m0 = 9;
			s1 = 5;	s0 = 0;
			ap = 1;  alap = 10;
		end
	always @(posedge Clk)
	begin
	
		if (reset)
			begin 
				Counter = 0;
				h1 = 0;	h0 = 0;
				m1 = 0;	m0 = 0;
				s1 = 0;	s0 = 0;
				ap = 1;  alap = 10;
			end //if(reset)
		else 
		begin
		if (ap)
			begin 
				if (Counter > 50)
					begin
						Counter <= 0;
						s0 <= s0 + 1;
					end
				else Counter <= Counter + 1;
				if (s0 > 9)
					begin 
						s0 <= 0;
						s1 <= s1 + 1;
					end //if (s0 > 9)
				if (s1 > 5)
					begin 
						s1 <= 0;
						m0 <= m0 + 1;
					end //if (s1 > 5)
				if (m0 > 9)
					begin
						m0 <= 0;
						m1 <= m1 + 1;
					end //if (m0 > 9)
				if (m1 > 5)
					begin
						m1 <= 0;
						h0 <= h0 + 1;
					end //if (m2 > 5)
				if (h0 > 9)
					begin 
						h0 <= 0;
						h1 <= h1 + 1; 
					end //if (h0 > 9)	
				if (h1 == 1 && h0 > 1) alap <= 11;
				if (h1 == 1 && h0 > 2) 
					begin 
						h0 <= 1;
						h1 <= 0;
						ap <= 0;
					end
			end //ap
		else
		begin
				if (Counter > 50)
					begin
						Counter <= 0;
						s0 <= s0 + 1;
					end
				else Counter <= Counter + 1;
				if (s0 > 9)
					begin 
						s0 <= 0;
						s1 <= s1 + 1;
					end //if (s0 > 9)
				if (s1 > 5)
					begin 
						s1 <= 0;
						m0 <= m0 + 1;
					end //if (s1 > 5)
				if (m0 > 9)
					begin
						m0 <= 0;
						m1 <= m1 + 1;
					end //if (m0 > 9)
				if (m1 > 5)
					begin
						m1 <= 0;
						h0 <= h0 + 1;
					end //if (m2 > 5)
				if (h0 > 9)
					begin 
						h0 <= 0;
						h1 <= h1 + 1; 
					end //if (h0 > 9)	
				if (h1 == 1 && h0 > 1) 
					begin 
						h0 <= 0;
						h1 <= 0;
						ap <= 1;
						alap <= 10;
					end
		end //~ap
	end //~reset	
	end //always
	assign Hrs0 = h0;
	assign Hrs1 = h1;
	assign Min0 = m0;
	assign Min1 = m1;
	assign Sec0 = s0;
	assign Sec1 = s1;
	assign AP = alap;
	
endmodule
	
module FourTo7Seg (Inp,Seg);
	input [3:0]Inp;
	output [6:0]Seg;
	reg [6:0]Seg;
	always @(Inp)
	begin
		case (Inp)
		0: Seg = 7'b1000000; 
		1: Seg = 7'b1111001; 
		2: Seg = 7'b0100100; 
		3: Seg = 7'b0110000; 
		4: Seg = 7'b0011001; 
		5: Seg = 7'b0010010; 
		6: Seg = 7'b0000010; 
		7: Seg = 7'b1111000; 
		8: Seg = 7'b0000000;
		9: Seg = 7'b0010000; 
		10: Seg = 7'b0001000;
		11: Seg = 7'b0001100;
		endcase
	end
endmodule

