receiver_antenna_num = 1;%接收天线个数
modulate_mode = 2;%调制模式
stbc_block = 2;%stbc 输入的block长度
block_num = 400000;%仿真block个数
data_length = stbc_block*block_num;%数据长度
data = randi(modulate_mode, data_length, 1) - 1;%生成数据
data_modulated = pskmod(data, modulate_mode);%调制
coding_mode = 'siso';%编码方式
SNR_POINT = (0:1:20)';
BER_POINT_siso = SISO(data_length , 1, 'BPSK', SNR_POINT);

SNR_POINT = SNR_POINT';
BER_POINT_g2_1rx = SNR_POINT;
receiver_antenna_num = 1;%接收天线个数
modulate_mode = 2;%调制模式
stbc_block = 2;%stbc 输入的block长度
block_num = 40000;%仿真block个数
data_length = stbc_block*block_num;%数据长度
data = randi(modulate_mode, data_length, 1) - 1;%生成数据
data_modulated = pskmod(data, modulate_mode);%调制
coding_mode = 'g2';%编码方式
g2 = stbc_coding(data_modulated, coding_mode);%编码
count = 1;
for SNR = SNR_POINT
    [g2_corrupted, rayleigh_gain] = rayleigh_and_awgn(g2, coding_mode, receiver_antenna_num, SNR, modulate_mode);
    g2_decoded = stbc_decoding(g2_corrupted, coding_mode, rayleigh_gain, receiver_antenna_num, modulate_mode);
    data_demodulated = pskdemod(g2_decoded, modulate_mode);
    BER_POINT_g2_1rx(count) = calculate_error(data, data_demodulated);
    count = count + 1;
end

BER_POINT_g2_2rx = SNR_POINT;
receiver_antenna_num = 2;%接收天线个数
modulate_mode = 2;%调制模式
stbc_block = 2;%stbc 输入的block长度
block_num = 40000;%仿真block个数
data_length = stbc_block*block_num;%数据长度
data = randi(modulate_mode, data_length, 1) - 1;%生成数据
data_modulated = pskmod(data, modulate_mode);%调制
coding_mode = 'g2';%编码方式
g2 = stbc_coding(data_modulated, coding_mode);%编码
count = 1;
for SNR = SNR_POINT
    [g2_corrupted, rayleigh_gain] = rayleigh_and_awgn(g2, coding_mode, receiver_antenna_num, SNR, modulate_mode);
    g2_decoded = stbc_decoding(g2_corrupted, coding_mode, rayleigh_gain, receiver_antenna_num, modulate_mode);
    data_demodulated = pskdemod(g2_decoded, modulate_mode);
    BER_POINT_g2_2rx(count) = calculate_error(data, data_demodulated);
    count = count + 1;
end

BER_POINT_g2_4rx = SNR_POINT;%接收天线个数
receiver_antenna_num = 4;%调制模式
modulate_mode = 4;%stbc 输入的block长度
stbc_block = 2;%仿真block个数
block_num = 40000;%数据长度
data_length = stbc_block*block_num;%生成数据
data = randi(modulate_mode, data_length, 1) - 1;
data_modulated = pskmod(data, modulate_mode);%调制
coding_mode = 'g2';%编码方式
g2 = stbc_coding(data_modulated, coding_mode);%编码
count = 1;
for SNR = SNR_POINT
    [g2_corrupted, rayleigh_gain] = rayleigh_and_awgn(g2, coding_mode, receiver_antenna_num, SNR, modulate_mode);
    g2_decoded = stbc_decoding(g2_corrupted, coding_mode, rayleigh_gain, receiver_antenna_num, modulate_mode);
    data_demodulated = pskdemod(g2_decoded, modulate_mode);
    BER_POINT_g2_4rx(count) = calculate_error(data, data_demodulated);
    count = count + 1;
end

figure;
semilogy(SNR_POINT, BER_POINT_siso, 'b-*');
hold on;
semilogy(SNR_POINT, BER_POINT_g2_1rx, 'r-+');
hold on;
semilogy(SNR_POINT, BER_POINT_g2_2rx, 'g-o');
hold on;
semilogy(SNR_POINT, BER_POINT_g2_4rx, 'b-^');
hold on;
axis;
xlabel('SNR/db');
ylabel('BER');
legend('SISO(1Tx, 1Rx), BPSK', 'STBC(2Tx, 1Rx), BPSK', 'STBC(2Tx, 2Rx), BPSK', 'STBC(2Tx, 4Rx), QPSK');