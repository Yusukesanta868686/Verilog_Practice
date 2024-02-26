module sim;
reg clk, rst;
reg [31:0] in0_re, in0_im;
reg [31:0] in1_re, in1_im;
reg [31:0] in2_re, in2_im;
reg [31:0] in3_re, in3_im;
reg [31:0] in4_re, in4_im;
reg [31:0] in5_re, in5_im;
reg [31:0] in6_re, in6_im;
reg [31:0] in7_re, in7_im;
wire [31:0] out0_1_re, out0_1_im, out0_2_re, out0_2_im, out0_3_re, out0_3_im;
wire [31:0] out1_1_re, out1_1_im, out1_2_re, out1_2_im, out1_3_re, out1_3_im;
wire [31:0] out2_1_re, out2_1_im, out2_2_re, out2_2_im, out2_3_re, out2_3_im;
wire [31:0] out3_1_re, out3_1_im, out3_2_re, out3_2_im, out3_3_re, out3_3_im;
wire [31:0] out4_1_re, out4_1_im, out4_2_re, out4_2_im, out4_3_re, out4_3_im;
wire [31:0] out5_1_re, out5_1_im, out5_2_re, out5_2_im, out5_3_re, out5_3_im;
wire [31:0] out6_1_re, out6_1_im, out6_2_re, out6_2_im, out6_3_re, out6_3_im;
wire [31:0] out7_1_re, out7_1_im, out7_2_re, out7_2_im, out7_3_re, out7_3_im;
reg result_en;
wire result_en1, result_en2, result3_en, result4_en;

integer file_in, file_out, data_cnt;
integer a_in, a_out;

reg signed [31:0] target_buf[7:0];
reg signed [31:0] output_buf[7:0];

integer i, j;

initial begin
    clk <= 0;
    rst <= 0;
    data_cnt <= 0;
    result_en <= 0;
    in0_im <= 32'b0;
    in1_im <= 32'b0;
    in2_im <= 32'b0;
    in3_im <= 32'b0;
    in4_im <= 32'b0;
    in5_im <= 32'b0;
    in6_im <= 32'b0;
    in7_im <= 32'b0;
    #400000 $finish;
end

initial begin
    file_in = $fopen("target32.txt", "r"); // ファイルを読み込みモードで開く
    file_out = $fopen("output.txt", "w");
    $display("Default format: Current time=%t", $realtime);
end

always #1 begin
    clk <= ~clk;    

    if (result_en1 && result_en2 && result3_en && result4_en) result_en <= 1;
/*
    $monitor("0r: %b, 0i: %b, 1r: %b, 1i: %b, 2r: %b, 2i: %b, 3r: %b, 3i: %b, 4r: %b, 4i: %b, 5r: %b, 5i: %b, 6r: %b, 6i: %b, 7r: %b, 7i: %b", 
    out0_3_re, out0_3_im, out1_3_re, out1_3_im, out2_3_re, out2_3_im, out3_3_re, out3_3_im, out4_3_re, out4_3_im,
    out5_3_re, out5_3_im, out6_3_re, out6_3_im, out7_3_re, out7_3_im);
*/
end

always #2 begin
    if (!$feof(file_in) && data_cnt < 400000) begin
        for (i = 0; i < 8; i = i + 1) begin
            a_in = $fscanf(file_in, "%b\n", target_buf[i]);
        end
        data_cnt <= data_cnt + 1;
    end

    if (file_out) begin
        if (result_en) begin
            $fdisplay(file_out, "%b", out0_3_re);
            $fdisplay(file_out, "%b", out1_3_re);
            $fdisplay(file_out, "%b", out2_3_re);
            $fdisplay(file_out, "%b", out3_3_re);
            $fdisplay(file_out, "%b", out4_3_re);
            $fdisplay(file_out, "%b", out5_3_re);
            $fdisplay(file_out, "%b", out6_3_re);
            $fdisplay(file_out, "%b", out7_3_re);
        end
    end
end 

//1段目
FFT1 fft1_1(
    .clk(clk),
    .a_re(target_buf[0]),
    .a_im(in0_im),
    .b_re(target_buf[3]),
    .b_im(in3_im),
    .c_re(out0_1_re),
    .c_im(out0_1_im),
    .d_re(out1_1_re),
    .d_im(out1_1_im)
);
FFT1 fft1_2(
    .clk(clk),
    .a_re(target_buf[2]),
    .a_im(in2_im),
    .b_re(target_buf[6]),
    .b_im(in6_im),
    .c_re(out2_1_re),
    .c_im(out2_1_im),
    .d_re(out3_1_re),
    .d_im(out3_1_im)
);
FFT1 fft1_3(
    .clk(clk),
    .a_re(target_buf[1]),
    .a_im(in1_im),
    .b_re(target_buf[5]),
    .b_im(in5_im),
    .c_re(out4_1_re),
    .c_im(out4_1_im),
    .d_re(out5_1_re),
    .d_im(out5_1_im)
);
FFT1 fft1_4(
    .clk(clk),
    .a_re(target_buf[3]),
    .a_im(in3_im),
    .b_re(target_buf[7]),
    .b_im(in7_im),
    .c_re(out6_1_re),
    .c_im(out6_1_im),
    .d_re(out7_1_re),
    .d_im(out7_1_im)
);

//2段目
FFT2 fft2_1(
    .clk(clk),
    .rotate(1'b0),
    .a_re(out0_1_re),
    .a_im(out0_1_im),
    .b_re(out2_1_re),
    .b_im(out2_1_im),
    .c_re(out0_2_re),
    .c_im(out0_2_im),
    .d_re(out2_2_re),
    .d_im(out2_2_im)
);
FFT2 fft2_2(
    .clk(clk),
    .rotate(1'b1),
    .a_re(out1_1_re),
    .a_im(out1_1_im),
    .b_re(out3_1_re),
    .b_im(out3_1_im),
    .c_re(out1_2_re),
    .c_im(out1_2_im),
    .d_re(out3_2_re),
    .d_im(out3_2_im)
);
FFT2 fft2_3(
    .clk(clk),
    .rotate(1'b0),
    .a_re(out4_1_re),
    .a_im(out4_1_im),
    .b_re(out6_1_re),
    .b_im(out6_1_im),
    .c_re(out4_2_re),
    .c_im(out4_2_im),
    .d_re(out6_2_re),
    .d_im(out6_2_im)
);
FFT2 fft2_4(
    .clk(clk),
    .rotate(1'b1),
    .a_re(out5_1_re),
    .a_im(out5_1_im),
    .b_re(out7_1_re),
    .b_im(out7_1_im),
    .c_re(out5_2_re),
    .c_im(out5_2_im),
    .d_re(out7_2_re),
    .d_im(out7_2_im)
);

//3段目
FFT3 fft3_1(
    .clk(clk),
    .rotate(2'b00),
    .a_re(out0_2_re),
    .a_im(out0_2_im),
    .b_re(out4_2_re),
    .b_im(out4_2_im),
    .c_re(out0_3_re),
    .c_im(out0_3_im),
    .d_re(out4_3_re),
    .d_im(out4_3_im),
    .result_en(result_en1)
);
FFT3 fft3_2(
    .clk(clk),
    .rotate(2'b01),
    .a_re(out1_2_re),
    .a_im(out1_2_im),
    .b_re(out5_2_re),
    .b_im(out5_2_im),
    .c_re(out1_3_re),
    .c_im(out1_3_im),
    .d_re(out5_3_re),
    .d_im(out5_3_im),
    .result_en(result_en2)
);
FFT3 fft3_3(
    .clk(clk),
    .rotate(2'b10),
    .a_re(out2_2_re),
    .a_im(out2_2_im),
    .b_re(out6_2_re),
    .b_im(out6_2_im),
    .c_re(out2_3_re),
    .c_im(out2_3_im),
    .d_re(out6_3_re),
    .d_im(out6_3_im),
    .result_en(result3_en)
);
FFT3 fft3_4(
    .clk(clk),
    .rotate(2'b11),
    .a_re(out3_2_re),
    .a_im(out3_2_im),
    .b_re(out7_2_re),
    .b_im(out7_2_im),
    .c_re(out3_3_re),
    .c_im(out3_3_im),
    .d_re(out7_3_re),
    .d_im(out7_3_im),
    .result_en(result4_en)
);

endmodule
