module sim;
reg clk, rst;
reg signed [31:0] in0_re, in0_im;
reg signed [31:0] in1_re, in1_im;
reg signed [31:0] in2_re, in2_im;
reg signed [31:0] in3_re, in3_im;
reg signed [31:0] in4_re, in4_im;
reg signed [31:0] in5_re, in5_im;
reg signed [31:0] in6_re, in6_im;
reg signed [31:0] in7_re, in7_im;
wire signed [31:0] fft_1_re [7:0];
wire signed [31:0] fft_1_im [7:0];
wire signed [31:0] fft_2_re [7:0];
wire signed [31:0] fft_2_im [7:0];
wire signed [31:0] fft_3_re [7:0];
wire signed [31:0] fft_3_im [7:0];
wire signed [31:0] ifft_1_re [7:0];
wire signed [31:0] ifft_1_im [7:0];
wire signed [31:0] ifft_2_re [7:0];
wire signed [31:0] ifft_2_im [7:0];
wire signed [31:0] ifft_3_re [7:0];
wire signed [31:0] ifft_3_im [7:0];

reg fft1_en, fft2_en, fft3_en, ifft1_en, ifft2_en, ifft3_en, result_en;
wire fft2_en1, fft2_en2, fft2_en3, fft2_en4;
wire fft3_en1, fft3_en2, fft3_en3, fft3_en4;
wire ifft1_en1, ifft1_en2, ifft1_en3, ifft1_en4;
wire ifft2_en1, ifft2_en2, ifft2_en3, ifft2_en4;
wire ifft3_en1, ifft3_en2, ifft3_en3, ifft3_en4;
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
    fft1_en <= 0;
    fft2_en <= 0;
    fft3_en <= 0;
    ifft1_en <= 0;
    ifft2_en <= 0;
    ifft3_en <= 0;
    result_en <= 0;
    in0_im <= 32'b0;
    in1_im <= 32'b0;
    in2_im <= 32'b0;
    in3_im <= 32'b0;
    in4_im <= 32'b0;
    in5_im <= 32'b0;
    in6_im <= 32'b0;
    in7_im <= 32'b0;
    #120000 $finish;
end

initial begin
    file_in = $fopen("taiga_target.txt", "r"); // ファイルを読み込みモードで開く
    file_out = $fopen("output.txt", "w");
    $display("Default format: Current time=%t", $realtime);
end

always #1 begin
    clk <= ~clk;    

    if (fft2_en1 && fft2_en2 && fft2_en3 && fft2_en4) fft2_en <= 1;
    if (fft3_en1 && fft3_en2 && fft3_en3 && fft3_en4) fft3_en <= 1;
    if (ifft1_en1 && ifft1_en2 && ifft1_en3 && ifft1_en4) ifft1_en <= 1;
    if (ifft2_en1 && ifft2_en2 && ifft2_en3 && ifft2_en4) ifft2_en <= 1;
    if (ifft3_en1 && ifft3_en2 && ifft3_en3 && ifft3_en4) ifft3_en <= 1; 
    if (result_en1 && result_en2 && result3_en && result4_en) result_en <= 1;
    //$monitor("0r: %b, 0i: %b, 1r: %b, 1i: %b, 2r: %b, 2i: %b, 3r: %b, 3i: %b, 4r: %b, 4i: %b, 5r: %b, 5i: %b, 6r: %b, 6i: %b, 7r: %b, 7i: %b", fft_1_re[0], fft_1_im[0], fft_1_re[1], fft_1_im[1], fft_1_re[2], fft_1_im[2], fft_1_re[3], fft_1_im[3], fft_1_re[4], fft_1_im[4], fft_1_re[5], fft_1_im[5], fft_1_re[6], fft_1_im[6], fft_1_re[7], fft_1_im[7]); 
    //$monitor("0r: %b, 0i: %b, 1r: %b, 1i: %b, 2r: %b, 2i: %b, 3r: %b, 3i: %b, 4r: %b, 4i: %b, 5r: %b, 5i: %b, 6r: %b, 6i: %b, 7r: %b, 7i: %b", fft_2_re[0], fft_2_im[0], fft_2_re[1], fft_2_im[1], fft_2_re[2], fft_2_im[2], fft_2_re[3], fft_2_im[3], fft_2_re[4], fft_2_im[4], fft_2_re[5], fft_2_im[5], fft_2_re[6], fft_2_im[6], fft_2_re[7], fft_2_im[7]); 
    //$monitor("0r: %b, 0i: %b, 1r: %b, 1i: %b, 2r: %b, 2i: %b, 3r: %b, 3i: %b, 4r: %b, 4i: %b, 5r: %b, 5i: %b, 6r: %b, 6i: %b, 7r: %b, 7i: %b", ifft_3_re[0], ifft_3_im[0], ifft_3_re[1], ifft_3_im[1], ifft_3_re[2], ifft_3_im[2], ifft_3_re[3], ifft_3_im[3], ifft_3_re[4], ifft_3_im[4],ifft_3_re[5], ifft_3_im[5], ifft_3_re[6], ifft_3_im[6], ifft_3_re[7], ifft_3_im[7]);
    //$monitor("0r: %b, 0i: %b, 1r: %b, 1i: %b, 2r: %b, 2i: %b, 3r: %b, 3i: %b, 4r: %b, 4i: %b, 5r: %b, 5i: %b, 6r: %b, 6i: %b, 7r: %b, 7i: %b", fft_3_re[0], fft_3_im[0], fft_3_re[1], fft_3_im[1], fft_3_re[2], fft_3_im[2], fft_3_re[3], fft_3_im[3], fft_3_re[4], fft_3_im[4], fft_3_re[5], fft_3_im[5], fft_3_re[6], fft_3_im[6], fft_3_re[7], fft_3_im[7]); 
end

always #2 begin
    //$display("%b", result_en);
    if (!$feof(file_in) && data_cnt < 400000) begin
        for (i = 0; i < 8; i = i + 1) begin
            a_in = $fscanf(file_in, "%b\n", target_buf[i]);
            data_cnt <= data_cnt + 1;
        end
        fft1_en <= 1;
    end

    if (file_out) begin
        if (result_en) begin
            $fdisplay(file_out, "%b", ifft_3_re[0]);
            $fdisplay(file_out, "%b", ifft_3_re[1]);
            $fdisplay(file_out, "%b", ifft_3_re[2]);
            $fdisplay(file_out, "%b", ifft_3_re[3]);
            $fdisplay(file_out, "%b", ifft_3_re[4]);
            $fdisplay(file_out, "%b", ifft_3_re[5]);
            $fdisplay(file_out, "%b", ifft_3_re[6]);
            $fdisplay(file_out, "%b", ifft_3_re[7]);
        end
    end
end 

/////////FFT//////////
//1段目
FFT1 fft1_1(
    .clk(clk),
    .in_en(fft1_en),
    .a_re(target_buf[0]),
    .a_im(in0_im),
    .b_re(target_buf[4]),
    .b_im(in4_im),
    .c_re(fft_1_re[0]),
    .c_im(fft_1_im[0]),
    .d_re(fft_1_re[1]),
    .d_im(fft_1_im[1]),
    .out_en(fft2_en1)
);
FFT1 fft1_2(
    .clk(clk),
    .in_en(fft1_en),
    .a_re(target_buf[2]),
    .a_im(in2_im),
    .b_re(target_buf[6]),
    .b_im(in6_im),
    .c_re(fft_1_re[2]),
    .c_im(fft_1_im[2]),
    .d_re(fft_1_re[3]),
    .d_im(fft_1_im[3]),
    .out_en(fft2_en2)
);
FFT1 fft1_3(
    .clk(clk),
    .in_en(fft1_en),
    .a_re(target_buf[1]),
    .a_im(in1_im),
    .b_re(target_buf[5]),
    .b_im(in5_im),
    .c_re(fft_1_re[4]),
    .c_im(fft_1_im[4]),
    .d_re(fft_1_re[5]),
    .d_im(fft_1_im[5]),
    .out_en(fft2_en3)
);
FFT1 fft1_4(
    .clk(clk),
    .in_en(fft1_en),
    .a_re(target_buf[3]),
    .a_im(in3_im),
    .b_re(target_buf[7]),
    .b_im(in7_im),
    .c_re(fft_1_re[6]),
    .c_im(fft_1_im[6]),
    .d_re(fft_1_re[7]),
    .d_im(fft_1_im[7]),
    .out_en(fft2_en4)
);

//2段目
FFT2 fft2_1(
    .clk(clk),
    .in_en(fft2_en),
    .rotate(1'b0),
    .a_re(fft_1_re[0]),
    .a_im(fft_1_im[0]),
    .b_re(fft_1_re[2]),
    .b_im(fft_1_im[2]),
    .c_re(fft_2_re[0]),
    .c_im(fft_2_im[0]),
    .d_re(fft_2_re[2]),
    .d_im(fft_2_im[2]),
    .out_en(fft3_en1)
);
FFT2 fft2_2(
    .clk(clk),
    .in_en(fft2_en),
    .rotate(1'b1),
    .a_re(fft_1_re[1]),
    .a_im(fft_1_im[1]),
    .b_re(fft_1_re[3]),
    .b_im(fft_1_im[3]),
    .c_re(fft_2_re[1]),
    .c_im(fft_2_im[1]),
    .d_re(fft_2_re[3]),
    .d_im(fft_2_im[3]),
    .out_en(fft3_en2)
);
FFT2 fft2_3(
    .clk(clk),
    .in_en(fft2_en),
    .rotate(1'b0),
    .a_re(fft_1_re[4]),
    .a_im(fft_1_im[4]),
    .b_re(fft_1_re[6]),
    .b_im(fft_1_im[6]),
    .c_re(fft_2_re[4]),
    .c_im(fft_2_im[4]),
    .d_re(fft_2_re[6]),
    .d_im(fft_2_im[6]),
    .out_en(fft3_en3) 
);
FFT2 fft2_4(
    .clk(clk),
    .in_en(fft2_en),
    .rotate(1'b1),
    .a_re(fft_1_re[5]),
    .a_im(fft_1_im[5]),
    .b_re(fft_1_re[7]),
    .b_im(fft_1_im[7]),
    .c_re(fft_2_re[5]),
    .c_im(fft_2_im[5]),
    .d_re(fft_2_re[7]),
    .d_im(fft_2_im[7]),
    .out_en(fft3_en4)
);

//3段目
FFT3 fft3_1(
    .clk(clk),
    .in_en(fft3_en),
    .rotate(2'b00),
    .a_re(fft_2_re[0]),
    .a_im(fft_2_im[0]),
    .b_re(fft_2_re[4]),
    .b_im(fft_2_im[4]),
    .c_re(fft_3_re[0]),
    .c_im(fft_3_im[0]),
    .d_re(fft_3_re[4]),
    .d_im(fft_3_im[4]),
    .out_en(ifft1_en1)
);
FFT3 fft3_2(
    .clk(clk),
    .in_en(fft3_en),
    .rotate(2'b01),
    .a_re(fft_2_re[1]),
    .a_im(fft_2_im[1]),
    .b_re(fft_2_re[5]),
    .b_im(fft_2_im[5]),
    .c_re(fft_3_re[1]),
    .c_im(fft_3_im[1]),
    .d_re(fft_3_re[5]),
    .d_im(fft_3_im[5]),
    .out_en(ifft1_en2)
);
FFT3 fft3_3(
    .clk(clk),
    .in_en(fft3_en),
    .rotate(2'b10),
    .a_re(fft_2_re[2]),
    .a_im(fft_2_im[2]),
    .b_re(fft_2_re[6]),
    .b_im(fft_2_im[6]),
    .c_re(fft_3_re[2]),
    .c_im(fft_3_im[2]),
    .d_re(fft_3_re[6]),
    .d_im(fft_3_im[6]),
    .out_en(ifft1_en3)
);
FFT3 fft3_4(
    .clk(clk),
    .in_en(fft3_en),
    .rotate(2'b11),
    .a_re(fft_2_re[3]),
    .a_im(fft_2_im[3]),
    .b_re(fft_2_re[7]),
    .b_im(fft_2_im[7]),
    .c_re(fft_3_re[3]),
    .c_im(fft_3_im[3]),
    .d_re(fft_3_re[7]),
    .d_im(fft_3_im[7]),
    .out_en(ifft1_en4)
);


//////////iFFT//////////
//1段目
iFFT1 ifft1_1(
    .clk(clk),
    .in_en(ifft1_en),
    .a_re(fft_3_re[0]),
    .a_im(fft_3_im[0]),
    .b_re(fft_3_re[4]),
    .b_im(fft_3_im[4]),
    .c_re(ifft_1_re[0]),
    .c_im(ifft_1_im[0]),
    .d_re(ifft_1_re[1]),
    .d_im(ifft_1_im[1]),
    .out_en(ifft2_en1)
);
iFFT1 ifft1_2(
    .clk(clk),
    .in_en(ifft1_en),
    .a_re(fft_3_re[2]),
    .a_im(fft_3_im[2]),
    .b_re(fft_3_re[6]),
    .b_im(fft_3_im[6]),
    .c_re(ifft_1_re[2]),
    .c_im(ifft_1_im[2]),
    .d_re(ifft_1_re[3]),
    .d_im(ifft_1_im[3]),
    .out_en(ifft2_en2)
);
iFFT1 ifft1_3(
    .clk(clk),
    .in_en(ifft1_en),
    .a_re(fft_3_re[1]),
    .a_im(fft_3_im[1]),
    .b_re(fft_3_re[5]),
    .b_im(fft_3_im[5]),
    .c_re(ifft_1_re[4]),
    .c_im(ifft_1_im[4]),
    .d_re(ifft_1_re[5]),
    .d_im(ifft_1_im[5]),
    .out_en(ifft2_en3)
);
iFFT1 ifft1_4(
    .clk(clk),
    .in_en(ifft1_en),
    .a_re(fft_3_re[3]),
    .a_im(fft_3_im[3]),
    .b_re(fft_3_re[7]),
    .b_im(fft_3_im[7]),
    .c_re(ifft_1_re[6]),
    .c_im(ifft_1_im[6]),
    .d_re(ifft_1_re[7]),
    .d_im(ifft_1_im[7]),
    .out_en(ifft2_en4)
);

//2段目
iFFT2 ifft2_1(
    .clk(clk),
    .in_en(ifft2_en),
    .rotate(1'b0),
    .a_re(ifft_1_re[0]),
    .a_im(ifft_1_im[0]),
    .b_re(ifft_1_re[2]),
    .b_im(ifft_1_im[2]),
    .c_re(ifft_2_re[0]),
    .c_im(ifft_2_im[0]),
    .d_re(ifft_2_re[2]),
    .d_im(ifft_2_im[2]),
    .out_en(ifft3_en1)
);
iFFT2 ifft2_2(
    .clk(clk),
    .in_en(ifft2_en),
    .rotate(1'b1),
    .a_re(ifft_1_re[1]),
    .a_im(ifft_1_im[1]),
    .b_re(ifft_1_re[3]),
    .b_im(ifft_1_im[3]),
    .c_re(ifft_2_re[1]),
    .c_im(ifft_2_im[1]),
    .d_re(ifft_2_re[3]),
    .d_im(ifft_2_im[3]),
    .out_en(ifft3_en2)
);
iFFT2 ifft2_3(
    .clk(clk),
    .in_en(ifft2_en),
    .rotate(1'b0),
    .a_re(ifft_1_re[4]),
    .a_im(ifft_1_im[4]),
    .b_re(ifft_1_re[6]),
    .b_im(ifft_1_im[6]),
    .c_re(ifft_2_re[4]),
    .c_im(ifft_2_im[4]),
    .d_re(ifft_2_re[6]),
    .d_im(ifft_2_im[6]),
    .out_en(ifft3_en3)
);
iFFT2 ifft2_4(
    .clk(clk),
    .in_en(ifft2_en),
    .rotate(1'b1),
    .a_re(ifft_1_re[5]),
    .a_im(ifft_1_im[5]),
    .b_re(ifft_1_re[7]),
    .b_im(ifft_1_im[7]),
    .c_re(ifft_2_re[5]),
    .c_im(ifft_2_im[5]),
    .d_re(ifft_2_re[7]),
    .d_im(ifft_2_im[7]),
    .out_en(ifft3_en4)
);

//3段目
iFFT3 ifft3_1(
    .clk(clk),
    .in_en(ifft3_en),
    .rotate(2'b00),
    .a_re(ifft_2_re[0]),
    .a_im(ifft_2_im[0]),
    .b_re(ifft_2_re[4]),
    .b_im(ifft_2_im[4]),
    .c_re(ifft_3_re[0]),
    .c_im(ifft_3_im[0]),
    .d_re(ifft_3_re[4]),
    .d_im(ifft_3_im[4]),
    .out_en(result_en1)
);
iFFT3 ifft3_2(
    .clk(clk),
    .in_en(ifft3_en),
    .rotate(2'b01),
    .a_re(ifft_2_re[1]),
    .a_im(ifft_2_im[1]),
    .b_re(ifft_2_re[5]),
    .b_im(ifft_2_im[5]),
    .c_re(ifft_3_re[1]),
    .c_im(ifft_3_im[1]),
    .d_re(ifft_3_re[5]),
    .d_im(ifft_3_im[5]),
    .out_en(result_en2)
);
iFFT3 ifft3_3(
    .clk(clk),
    .in_en(ifft3_en),
    .rotate(2'b10),
    .a_re(ifft_2_re[2]),
    .a_im(ifft_2_im[2]),
    .b_re(ifft_2_re[6]),
    .b_im(ifft_2_im[6]),
    .c_re(ifft_3_re[2]),
    .c_im(ifft_3_im[2]),
    .d_re(ifft_3_re[6]),
    .d_im(ifft_3_im[6]),
    .out_en(result3_en)
);
iFFT3 ifft3_4(
    .clk(clk),
    .in_en(ifft3_en),
    .rotate(2'b11),
    .a_re(ifft_2_re[3]),
    .a_im(ifft_2_im[3]),
    .b_re(ifft_2_re[7]),
    .b_im(ifft_2_im[7]),
    .c_re(ifft_3_re[3]),
    .c_im(ifft_3_im[3]),
    .d_re(ifft_3_re[7]),
    .d_im(ifft_3_im[7]),
    .out_en(result4_en)
);
endmodule
