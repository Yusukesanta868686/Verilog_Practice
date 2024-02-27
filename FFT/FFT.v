`include "define.vh"

module FFT1(
    input clk,
    input in_en,
    input signed [31:0] a_re,
    input signed [31:0] a_im,
    input signed [31:0] b_re,
    input signed [31:0] b_im,
    output wire signed [31:0] c_re,
    output wire signed [31:0] c_im,
    output wire signed [31:0] d_re,
    output wire signed [31:0] d_im,
    output out_en
); 

reg signed [32:0] c_re_dum, c_im_dum, d_re_dum, d_im_dum;
reg en;

always @(posedge clk) begin
    en <= (in_en)? 1 : 0;
    c_re_dum <= a_re + b_re;
    c_im_dum <= a_im + b_im;
    d_re_dum <= a_re - b_re;
    d_im_dum <= a_im - b_im;
end

assign c_re = c_re_dum >>> 1;
assign c_im = c_im_dum >>> 1;
assign d_re = d_re_dum >>> 1;
assign d_im = d_im_dum >>> 1;
assign out_en = (en)? 1 : 0;
endmodule


module FFT2(
    input clk,
    input in_en,
    input rotate,
    input signed [31:0] a_re,
    input signed [31:0] a_im,
    input signed [31:0] b_re,
    input signed [31:0] b_im,
    output wire signed [31:0] c_re,
    output wire signed [31:0] c_im,
    output wire signed [31:0] d_re,
    output wire signed [31:0] d_im,
    output out_en
); 

reg signed [63:0] c_re_dum, c_im_dum, d_re_dum, d_im_dum; 
reg en;
always @(posedge clk) begin
    en <= (in_en)? 1: 0;
    case (rotate)
        0: begin
            c_re_dum <= a_re + b_re;
            c_im_dum <= a_im + b_im;
            d_re_dum <= a_re - b_re;
            d_im_dum <= a_im - b_im; 
        end
        1: begin
            c_re_dum <= {{16{a_re[31]}}, a_re, {16{1'b0}}} + b_re * `cos2 + b_im * `sin2;
            c_im_dum <= {{16{a_im[31]}}, a_im, {16{1'b0}}} - b_re * `sin2 + b_im * `cos2;
            d_re_dum <= {{16{a_re[31]}}, a_re, {16{1'b0}}} - b_re * `cos2 - b_im * `sin2;
            d_im_dum <= {{16{a_im[31]}}, a_im, {16{1'b0}}} + b_re * `sin2 - b_im * `cos2; 
        end
        default: ;
    endcase
end

assign c_re = (rotate == 0)? c_re_dum[32:1] : c_re_dum[48:17];
assign c_im = (rotate == 0)? c_im_dum[32:1] : c_im_dum[48:17];
assign d_re = (rotate == 0)? d_re_dum[32:1] : d_re_dum[48:17];
assign d_im = (rotate == 0)? d_im_dum[32:1] : d_im_dum[48:17];
assign out_en = (en == 1)? 1 : 0;
endmodule

module FFT3(
    input clk,
    input in_en,
    input [1:0] rotate,
    input signed [31:0] a_re,
    input signed [31:0] a_im,
    input signed [31:0] b_re,
    input signed [31:0] b_im,
    output wire signed [31:0] c_re,
    output wire signed [31:0] c_im,
    output wire signed [31:0] d_re,
    output wire signed [31:0] d_im,
    output out_en
); 

reg signed [63:0] c_re_dum, c_im_dum, d_re_dum, d_im_dum; 
reg en;

always @(posedge clk) begin
    en <= (in_en)? 1 : 0;
    case (rotate)
        0: begin
            c_re_dum <= a_re + b_re;
            c_im_dum <= a_im + b_im;
            d_re_dum <= a_re - b_re;
            d_im_dum <= a_im - b_im; 
        end
        1: begin
            c_re_dum <= {{16{a_re[31]}}, a_re, {16{1'b0}}} + b_re * `cos1 + b_im * `sin1;
            c_im_dum <= {{16{a_im[31]}}, a_im, {16{1'b0}}} - b_re * `sin1 + b_im * `cos1;
            d_re_dum <= {{16{a_re[31]}}, a_re, {16{1'b0}}} - b_re * `cos1 - b_im * `sin1;
            d_im_dum <= {{16{a_im[31]}}, a_im, {16{1'b0}}} + b_re * `sin1 - b_im * `cos1;
        end
        2: begin
            c_re_dum <= {{16{a_re[31]}}, a_re, {16{1'b0}}} + b_re * `cos2 + b_im * `sin2;
            c_im_dum <= {{16{a_im[31]}}, a_im, {16{1'b0}}} - b_re * `sin2 + b_im * `cos2;
            d_re_dum <= {{16{a_re[31]}}, a_re, {16{1'b0}}} - b_re * `cos2 - b_im * `sin2;
            d_im_dum <= {{16{a_im[31]}}, a_im, {16{1'b0}}} + b_re * `sin2 - b_im * `cos2;
        end
        3: begin
            c_re_dum <= {{16{a_re[31]}}, a_re, {16{1'b0}}} + b_re * `cos3 + b_im * `sin3;
            c_im_dum <= {{16{a_im[31]}}, a_im, {16{1'b0}}} - b_re * `sin3 + b_im * `cos3;
            d_re_dum <= {{16{a_re[31]}}, a_re, {16{1'b0}}} - b_re * `cos3 - b_im * `sin3;
            d_im_dum <= {{16{a_im[31]}}, a_im, {16{1'b0}}} + b_re * `sin3 - b_im * `cos3;
        end
        default: ;
    endcase
end

assign c_re = (rotate == 0)? c_re_dum[32:1] : c_re_dum[48:17];
assign c_im = (rotate == 0)? c_im_dum[32:1] : c_im_dum[48:17];
assign d_re = (rotate == 0)? d_re_dum[32:1] : d_re_dum[48:17];
assign d_im = (rotate == 0)? d_im_dum[32:1] : d_im_dum[48:17];
assign out_en = (en == 1)? 1 : 0;
endmodule
