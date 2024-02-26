`include "define.vh"

module FFT1(
    input clk,
    input [31:0] a_re,
    input [31:0] a_im,
    input [31:0] b_re,
    input [31:0] b_im,
    output wire [31:0] c_re,
    output wire [31:0] c_im,
    output wire [31:0] d_re,
    output wire [31:0] d_im
); 

reg [31:0] c_re_dum, c_im_dum, d_re_dum, d_im_dum;

always @(posedge clk) begin
        c_re_dum <= a_re + b_re;
        c_im_dum <= a_im + b_im;
        d_re_dum <= a_re - b_re;
        d_im_dum <= a_im - b_im;
end

assign c_re = c_re_dum[31:0];
assign c_im = c_im_dum[31:0];
assign d_re = d_re_dum[31:0];
assign d_im = d_im_dum[31:0];
endmodule


module FFT2(
    input clk,
    input rotate,
    input [31:0] a_re,
    input [31:0] a_im,
    input [31:0] b_re,
    input [31:0] b_im,
    output wire [31:0] c_re,
    output wire [31:0] c_im,
    output wire [31:0] d_re,
    output wire [31:0] d_im
); 

reg [31:0] c_re_dum, c_im_dum, d_re_dum, d_im_dum; 

always @(posedge clk) begin
    case (rotate)
        0: begin
            c_re_dum <= a_re + b_re;
            c_im_dum <= a_im + b_im;
            d_re_dum <= a_re - b_re;
            d_im_dum <= a_im - b_im; 
        end
        1: begin
            c_re_dum <= a_re + b_re * `cos2 + b_im * `sin2;
            c_im_dum <= a_re - b_re * `sin2 + b_im * `cos2;
            d_re_dum <= a_re - b_re * `cos2 - b_im * `sin2;
            d_im_dum <= a_re - b_re * `cos2 + b_im * `sin2; 
        end
        default: ;
    endcase
end

assign c_re = c_re_dum[31:0];
assign c_im = c_im_dum[31:0];
assign d_re = d_re_dum[31:0];
assign d_im = d_im_dum[31:0];
endmodule

module FFT3(
    input clk,
    input [1:0] rotate,
    input [31:0] a_re,
    input [31:0] a_im,
    input [31:0] b_re,
    input [31:0] b_im,
    output wire [31:0] c_re,
    output wire [31:0] c_im,
    output wire [31:0] d_re,
    output wire [31:0] d_im,
    output result_en
); 

reg [31:0] c_re_dum, c_im_dum, d_re_dum, d_im_dum; 

always @(posedge clk) begin
    case (rotate)
        0: begin
            c_re_dum <= a_re + b_re;
            c_im_dum <= a_im + b_im;
            d_re_dum <= a_re - b_re;
            d_im_dum <= a_im - b_im; 
        end
        1: begin
            c_re_dum <= a_re + b_re * `cos1 + b_im * `sin1;
            c_im_dum <= a_re - b_re * `sin1 + b_im * `cos1;
            d_re_dum <= a_re - b_re * `cos1 - b_im * `sin1;
            d_im_dum <= a_re - b_re * `cos1 + b_im * `sin1; 
        end
        2: begin
            c_re_dum <= a_re + b_re * `cos2 + b_im * `sin2;
            c_im_dum <= a_re - b_re * `sin2 + b_im * `cos2;
            d_re_dum <= a_re - b_re * `cos2 - b_im * `sin2;
            d_im_dum <= a_re - b_re * `cos2 + b_im * `sin2; 
        end
        3: begin
            c_re_dum <= a_re + b_re * `cos3 + b_im * `sin3;
            c_im_dum <= a_re - b_re * `sin3 + b_im * `cos3;
            d_re_dum <= a_re - b_re * `cos3 - b_im * `sin3;
            d_im_dum <= a_re - b_re * `cos3 + b_im * `sin3; 
        end
        default: ;
    endcase
end

assign c_re = c_re_dum[31:0];
assign c_im = c_im_dum[31:0];
assign d_re = d_re_dum[31:0];
assign d_im = d_im_dum[31:0];
assign result_en = 1'b1;
endmodule