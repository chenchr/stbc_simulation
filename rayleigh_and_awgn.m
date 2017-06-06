function [output_data, rayleigh_gain] = rayleigh_and_awgn(data, coding_mode, receiver_antenna_num, SNR, modulate_mode)

[len, wid] = size(data);
emitter_antenna_num = wid;

if strcmp(coding_mode, 'g2')
    block_length = 2;
    %码率
    bit_rate = 1;
    %每位含有的信息
    if modulate_mode == 2
        log_bit = 1;
    else
        log_bit = 2;
    end
    %发射天线个数
    emitter_num = 2;
elseif strcmp(coding_mode, 'g3')
    block_length = 8;
    %码率
    bit_rate = 1/2;
    %每位含有的信息
    if modulate_mode == 4
        log_bit = 2;
    else
        log_bit = 4;
    end
    %发射天线个数
    emitter_num = 3;
elseif strcmp(coding_mode, 'g4')
    block_length = 8;
    %码率
    bit_rate = 1/2;
    %每位含有的信息
    if modulate_mode == 4
        log_bit = 2;
    else
        log_bit = 4;
    end
    %发射天线个数
    emitter_num = 4;
elseif strcmp(coding_mode, 'h3')
    block_length = 4;
    %码率
    bit_rate = 3/4;
    %每位含有的信息
    log_bit = 3;
    %发射天线个数
    emitter_num = 3;
elseif strcmp(coding_mode, 'h4')
    block_length = 4;
    %码率
    bit_rate = 3/4;
    %每位含有的信息
    log_bit = 3;
    %发射天线个数
    emitter_num = 4;
elseif strcmp(coding_mode, 'siso')
    bit_rate = 1;
    if modulate_mode == 2
        log_bit = 1;
    elseif modulate_mode == 4
        log_bit = 2;
    end
    emitter_num = 1;
end

%计算噪声方差
variance = emitter_num/(2*log_bit*bit_rate*(10^(SNR/10)));

block_num = len/block_length;

output_data = [];
rayleigh_gain = [];
for i = 1:receiver_antenna_num
    rayleigh_gain_short = (randn(block_num, emitter_antenna_num) + randn(block_num, emitter_antenna_num)*1i)/sqrt(2);
    rayleigh_gain_long = zeros(len, emitter_antenna_num);
    for k = 1:block_length:len
        for k_in = 0:block_length-1
            rayleigh_gain_long(k+k_in, :) = rayleigh_gain_short((k-1)/block_length + 1, :);
        end
    end
    data_faded = data .* rayleigh_gain_long; 
    noise = sqrt(variance)*(randn(len, 1) + randn(len, 1)*1i);
    data_corrupted = sum(data_faded, 2) + noise;
    output_data = [output_data, data_corrupted];
    rayleigh_gain = [rayleigh_gain, rayleigh_gain_long];
end

