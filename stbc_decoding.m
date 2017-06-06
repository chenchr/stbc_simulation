function [data_decoded] = stbc_decoding(data, coding_mode, gain, receiver_num, modulate_mode)

if strcmp(coding_mode, 'g2')
    [len, wid] = size(data);
    data_decoded = zeros(len, 1);
    for i = 1:2:len
        num1 = 0; num2 = -1; num3 = 0; num4 = -1;
        for k = 1:receiver_num
            num1 = num1 + data(i, k)*conj(gain(i, (k-1)*2+1)) + conj(data(i+1, k))*gain(i, (k-1)*2+2);
            num2 = num2 + (abs(gain(i, (k-1)*2+1))^2 + abs(gain(i, (k-1)*2+2))^2);
            
            num3 = num3 + data(i, k)*conj(gain(i, (k-1)*2+2)) - conj(data(i+1, k))*gain(i, (k-1)*2+1);
            num4 = num2;
        end
        if modulate_mode == 2
            corres = [abs(num1 - 1)^2 + num2, abs(num1 + 1)^2 + num2; 1, -1];
            ans_m = min(corres, [], 2);
            if corres(1, 1) == ans_m(1)
                data_decoded(i) = 1;
            else
                data_decoded(i) = -1;
            end
            
            corres = [abs(num3 - 1)^2 + num4, abs(num3 + 1)^2 + num4; 1, -1];
            ans_m = min(corres, [], 2);
            if corres(1, 1) == ans_m(1)
                data_decoded(i+1) = 1;
            else
                data_decoded(i+1) = -1;
            end
        end
        
        if modulate_mode == 4
            corres = [abs(num1 - 1)^2 + num2, abs(num1 - 1i)^2 + num2, abs(num1 + 1)^2 + num2, abs(num1 + 1i)^2 + num2; 1, 1i, -1, -1i];
            ans_m = min(corres, [], 2);
            if corres(1, 1) == ans_m(1)
                data_decoded(i) = 1;
            elseif corres(1, 2) == ans_m(1)
                data_decoded(i) = 1i;
            elseif corres(1, 3) == ans_m(1)
                data_decoded(i) = -1;
            else
                data_decoded(i) = -1i;
            end
            
            corres = [abs(num3 - 1)^2 + num4, abs(num3 - 1i)^2 + num4, abs(num3 + 1)^2 + num4, abs(num3 + 1i)^2 + num4; 1, 1i, -1, -1i];
            ans_m = min(corres, [], 2);
            if corres(1, 1) == ans_m(1)
                data_decoded(i+1) = 1;
            elseif corres(1, 2) == ans_m(1)
                data_decoded(i+1) = 1i;
            elseif corres(1, 3) == ans_m(1)
                data_decoded(i+1) = -1;
            else
                data_decoded(i+1) = -1i;
            end
        end
    end
end

if strcmp(coding_mode, 'g3')
    [len, wid] = size(data);
    data_decoded = zeros(len/2, 1);
    for i = 1:8:len
        num1 = 0; num2 = -1; num3 = 0; num4 = -1; num5 = 0; num6 = -1; num7 = 0; num8 = -1;
        for k = 1:receiver_num
            num1_temp1 = data(i, k)*conj(gain(i, (k-1)*3+1)) + data(i+1, k)*conj(gain(i, (k-1)*3+2)) + data(i+2, k)*conj(gain(i, (k-1)*3+3));
            num1_temp2 = conj(data(i+4, k))*gain(i, (k-1)*3+1) + conj(data(i+5, k))*gain(i, (k-1)*3+2) + conj(data(i+6, k))*gain(i, (k-1)*3+3);
            num1 = num1 + num1_temp1 + num1_temp2;
            num2 = num2 + 2*(abs(gain(i, (k-1)*3+1))^2 + abs(gain(i, (k-1)*3+2))^2 + abs(gain(i, (k-1)*3+3))^2);
            
            num3_temp1 = data(i, k)*conj(gain(i, (k-1)*3+2)) - data(i+1, k)*conj(gain(i, (k-1)*3+1)) + data(i+3, k)*conj(gain(i, (k-1)*3+3));
            num3_temp2 = conj(data(i+4, k))*gain(i, (k-1)*3+2) - conj(data(i+5, k))*gain(i, (k-1)*3+1) + conj(data(i+7, k))*gain(i, (k-1)*3+3);
            num3 = num3 + num3_temp1 + num3_temp2;
            num4 = num2;
            
            num5_temp1 = data(i, k)*conj(gain(i, (k-1)*3+3)) - data(i+2, k)*conj(gain(i, (k-1)*3+1)) - data(i+3, k)*conj(gain(i, (k-1)*3+2));
            num5_temp2 = conj(data(i+4, k))*gain(i, (k-1)*3+3) - conj(data(i+6, k))*gain(i, (k-1)*3+1) - conj(data(i+7, k))*gain(i, (k-1)*3+2);
            num5 = num5 + num5_temp1 + num5_temp2;
            num6 = num2;
            
            num7_temp1 = -data(i+1, k)*conj(gain(i, (k-1)*3+3)) + data(i+2, k)*conj(gain(i, (k-1)*3+2)) - data(i+3, k)*conj(gain(i, (k-1)*3+1));
            num7_temp2 = -conj(data(i+5, k))*gain(i, (k-1)*3+3) + conj(data(i+6, k))*gain(i, (k-1)*3+2) - conj(data(i+7, k))*gain(i, (k-1)*3+1);
            num7 = num7 + num7_temp1 + num7_temp2;
            num8 = num2;
        end
        if modulate_mode == 4
            corres = [abs(num1 - 1)^2 + num2, abs(num1 - 1i)^2 + num2, abs(num1 + 1)^2 + num2, abs(num1 + 1i)^2 + num2; 1, 1i, -1, -1i];
            ans_m = min(corres, [], 2);
            if corres(1, 1) == ans_m(1)
                data_decoded((i-1)/2 + 1) = 1;
            elseif corres(1, 2) == ans_m(1)
                data_decoded((i-1)/2 + 1) = 1i;
            elseif corres(1, 3) == ans_m(1)
                data_decoded((i-1)/2 + 1) = -1;
            else
                data_decoded((i-1)/2 + 1) = -1i;
            end

            corres = [abs(num3 - 1)^2 + num4, abs(num3 - 1i)^2 + num4, abs(num3 + 1)^2 + num4, abs(num3 + 1i)^2 + num4; 1, 1i, -1, -1i];
            ans_m = min(corres, [], 2);
            if corres(1, 1) == ans_m(1)
                data_decoded((i-1)/2 + 2) = 1;
            elseif corres(1, 2) == ans_m(1)
                data_decoded((i-1)/2 + 2) = 1i;
            elseif corres(1, 3) == ans_m(1)
                data_decoded((i-1)/2 + 2) = -1;
            else
                data_decoded((i-1)/2 + 2) = -1i;
            end

            corres = [abs(num5 - 1)^2 + num6, abs(num5 - 1i)^2 + num6, abs(num5 + 1)^2 + num6, abs(num5 + 1i)^2 + num6; 1, 1i, -1, -1i];
            ans_m = min(corres, [], 2);
            if corres(1, 1) == ans_m(1)
                data_decoded((i-1)/2 + 3) = 1;
            elseif corres(1, 2) == ans_m(1)
                data_decoded((i-1)/2 + 3) = 1i;
            elseif corres(1, 3) == ans_m(1)
                data_decoded((i-1)/2 + 3) = -1;
            else
                data_decoded((i-1)/2 + 3) = -1i;
            end

            corres = [abs(num7 - 1)^2 + num8, abs(num7 - 1i)^2 + num8, abs(num7 + 1)^2 + num8, abs(num7 + 1i)^2 + num8; 1, 1i, -1, -1i];
            ans_m = min(corres, [], 2);
            if corres(1, 1) == ans_m(1)
                data_decoded((i-1)/2 + 4) = 1;
            elseif corres(1, 2) == ans_m(1)
                data_decoded((i-1)/2 + 4) = 1i;
            elseif corres(1, 3) == ans_m(1)
                data_decoded((i-1)/2 + 4) = -1;
            else
                data_decoded((i-1)/2 + 4) = -1i;
            end
        end
        if modulate_mode == 16
            temp_a = 0:15;
            temp_complex = pskmod(temp_a, 16);
            temp_result = [];
            for i_temp = 1:16
                temp_result = [temp_result, abs(num1 - temp_complex(i_temp))^2 + num2];
            end
            max_likelihood = min(temp_result);
            for i_temp = 1:16
                if temp_result(i_temp) == max_likelihood;
                    data_decoded((i-1)/2 + 1) = temp_complex(i_temp);
                    break;
                end
            end
            
            temp_result = [];
            for i_temp = 1:16
                temp_result = [temp_result, abs(num3 - temp_complex(i_temp))^2 + num4];
            end
            max_likelihood = min(temp_result);
            for i_temp = 1:16
                if temp_result(i_temp) == max_likelihood;
                    data_decoded((i-1)/2 + 2) = temp_complex(i_temp);
                    break;
                end
            end
            
            temp_result = [];
            for i_temp = 1:16
                temp_result = [temp_result, abs(num5 - temp_complex(i_temp))^2 + num6];
            end
            max_likelihood = min(temp_result);
            for i_temp = 1:16
                if temp_result(i_temp) == max_likelihood;
                    data_decoded((i-1)/2 + 3) = temp_complex(i_temp);
                    break;
                end
            end
            
            temp_result = [];
            for i_temp = 1:16
                temp_result = [temp_result, abs(num7 - temp_complex(i_temp))^2 + num8];
            end
            max_likelihood = min(temp_result);
            for i_temp = 1:16
                if temp_result(i_temp) == max_likelihood;
                    data_decoded((i-1)/2 + 4) = temp_complex(i_temp);
                    break;
                end
            end
        end
    end
end

if strcmp(coding_mode, 'g4')
    [len, wid] = size(data);
    data_decoded = zeros(len/2, 1);
    for i = 1:8:len
        num1 = 0; num2 = -1; num3 = 0; num4 = -1; num5 = 0; num6 = -1; num7 = 0; num8 = -1;
        for k = 1:receiver_num
            num1_temp1 = data(i, k)*conj(gain(i, (k-1)*4+1)) + data(i+1, k)*conj(gain(i, (k-1)*4+2)) + data(i+2, k)*conj(gain(i, (k-1)*4+3)) + data(i+3, k)*conj(gain(i, (k-1)*4+4));
            num1_temp2 = conj(data(i+4, k))*gain(i, (k-1)*4+1) + conj(data(i+5, k))*gain(i, (k-1)*4+2) + conj(data(i+6, k))*gain(i, (k-1)*4+3) + conj(data(i+7, k))*gain(i, (k-1)*4+4);
            num1 = num1 + num1_temp1 + num1_temp2;
            num2 = num2 + 2*(abs(gain(i, (k-1)*4+1))^2 + abs(gain(i, (k-1)*4+2))^2 + abs(gain(i, (k-1)*4+3))^2 + abs(gain(i, (k-1)*4+4))^2);
            
            num3_temp1 = data(i, k)*conj(gain(i, (k-1)*4+2)) - data(i+1, k)*conj(gain(i, (k-1)*4+1)) - data(i+2, k)*conj(gain(i, (k-1)*4+4)) + data(i+3, k)*conj(gain(i, (k-1)*4+3));
            num3_temp2 = conj(data(i+4, k))*gain(i, (k-1)*4+2) - conj(data(i+5, k))*gain(i, (k-1)*4+1) - conj(data(i+6, k))*gain(i, (k-1)*4+4) + conj(data(i+7, k))*gain(i, (k-1)*4+3);
            num3 = num3 + num3_temp1 + num3_temp2;
            num4 = num2;
            
            num5_temp1 = data(i, k)*conj(gain(i, (k-1)*4+3)) + data(i+1, k)*conj(gain(i, (k-1)*4+4)) - data(i+2, k)*conj(gain(i, (k-1)*4+1)) - data(i+3, k)*conj(gain(i, (k-1)*4+2));
            num5_temp2 = conj(data(i+4, k))*gain(i, (k-1)*4+3) + conj(data(i+5, k))*gain(i, (k-1)*4+4) - conj(data(i+6, k))*gain(i, (k-1)*4+1) - conj(data(i+7, k))*gain(i, (k-1)*4+2);
            num5 = num5 + num5_temp1 + num5_temp2;
            num6 = num2;
            
            num7_temp1 = data(i, k)*conj(gain(i, (k-1)*4+4)) - data(i+1, k)*conj(gain(i, (k-1)*4+3)) + data(i+2, k)*conj(gain(i, (k-1)*4+2)) - data(i+3, k)*conj(gain(i, (k-1)*4+1));
            num7_temp2 = conj(data(i+4, k))*gain(i, (k-1)*4+4) - conj(data(i+5, k))*gain(i, (k-1)*4+3) + conj(data(i+6, k))*gain(i, (k-1)*4+2) - conj(data(i+7, k))*gain(i, (k-1)*4+1);
            num7 = num7 + num7_temp1 + num7_temp2;
            num8 = num2;
        end
        
        if modulate_mode == 4
            corres = [abs(num1 - 1)^2 + num2, abs(num1 - 1i)^2 + num2, abs(num1 + 1)^2 + num2, abs(num1 + 1i)^2 + num2; 1, 1i, -1, -1i];
            ans_m = min(corres, [], 2);
            if corres(1, 1) == ans_m(1)
                data_decoded((i-1)/2 + 1) = 1;
            elseif corres(1, 2) == ans_m(1)
                data_decoded((i-1)/2 + 1) = 1i;
            elseif corres(1, 3) == ans_m(1)
                data_decoded((i-1)/2 + 1) = -1;
            else
                data_decoded((i-1)/2 + 1) = -1i;
            end

            corres = [abs(num3 - 1)^2 + num4, abs(num3 - 1i)^2 + num4, abs(num3 + 1)^2 + num4, abs(num3 + 1i)^2 + num4; 1, 1i, -1, -1i];
            ans_m = min(corres, [], 2);
            if corres(1, 1) == ans_m(1)
                data_decoded((i-1)/2 + 2) = 1;
            elseif corres(1, 2) == ans_m(1)
                data_decoded((i-1)/2 + 2) = 1i;
            elseif corres(1, 3) == ans_m(1)
                data_decoded((i-1)/2 + 2) = -1;
            else
                data_decoded((i-1)/2 + 2) = -1i;
            end

            corres = [abs(num5 - 1)^2 + num6, abs(num5 - 1i)^2 + num6, abs(num5 + 1)^2 + num6, abs(num5 + 1i)^2 + num6; 1, 1i, -1, -1i];
            ans_m = min(corres, [], 2);
            if corres(1, 1) == ans_m(1)
                data_decoded((i-1)/2 + 3) = 1;
            elseif corres(1, 2) == ans_m(1)
                data_decoded((i-1)/2 + 3) = 1i;
            elseif corres(1, 3) == ans_m(1)
                data_decoded((i-1)/2 + 3) = -1;
            else
                data_decoded((i-1)/2 + 3) = -1i;
            end

            corres = [abs(num7 - 1)^2 + num8, abs(num7 - 1i)^2 + num8, abs(num7 + 1)^2 + num8, abs(num7 + 1i)^2 + num8; 1, 1i, -1, -1i];
            ans_m = min(corres, [], 2);
            if corres(1, 1) == ans_m(1)
                data_decoded((i-1)/2 + 4) = 1;
            elseif corres(1, 2) == ans_m(1)
                data_decoded((i-1)/2 + 4) = 1i;
            elseif corres(1, 3) == ans_m(1)
                data_decoded((i-1)/2 + 4) = -1;
            else
                data_decoded((i-1)/2 + 4) = -1i;
            end
        end
        
        if modulate_mode == 16
            temp_a = 0:15;
            temp_complex = pskmod(temp_a, 16);
            temp_result = [];
            for i_temp = 1:16
                temp_result = [temp_result, abs(num1 - temp_complex(i_temp))^2 + num2];
            end
            max_likelihood = min(temp_result);
            for i_temp = 1:16
                if temp_result(i_temp) == max_likelihood;
                    data_decoded((i-1)/2 + 1) = temp_complex(i_temp);
                    break;
                end
            end
            
            temp_result = [];
            for i_temp = 1:16
                temp_result = [temp_result, abs(num3 - temp_complex(i_temp))^2 + num4];
            end
            max_likelihood = min(temp_result);
            for i_temp = 1:16
                if temp_result(i_temp) == max_likelihood;
                    data_decoded((i-1)/2 + 2) = temp_complex(i_temp);
                    break;
                end
            end
            
            temp_result = [];
            for i_temp = 1:16
                temp_result = [temp_result, abs(num5 - temp_complex(i_temp))^2 + num6];
            end
            max_likelihood = min(temp_result);
            for i_temp = 1:16
                if temp_result(i_temp) == max_likelihood;
                    data_decoded((i-1)/2 + 3) = temp_complex(i_temp);
                    break;
                end
            end
            
            temp_result = [];
            for i_temp = 1:16
                temp_result = [temp_result, abs(num7 - temp_complex(i_temp))^2 + num8];
            end
            max_likelihood = min(temp_result);
            for i_temp = 1:16
                if temp_result(i_temp) == max_likelihood;
                    data_decoded((i-1)/2 + 4) = temp_complex(i_temp);
                    break;
                end
            end
        end
    end
end

if strcmp(coding_mode, 'h3')
    [len, wid] = size(data);
    data_decoded = zeros(len*3/4, 1);
    for i = 1:4:len
        num1 = 0; num2 = -1; num3 = 0; num4 = -1; num5 = 0; num6 = -1;
        for k = 1:receiver_num
            num1 = num1 + data(i, k)*conj(gain(i, (k-1)*3+1)) + conj(data(i+1, k))*gain(i, (k-1)*3+2);
            num1 = num1 + (data(i+3, k) - data(i+2, k))*conj(gain(i, (k-1)*3+3))/2 - conj(data(i+3, k) + data(i+2, k))*gain(i, (k-1)*3+3)/2;
            num2 = num2 + abs(gain(i, (k-1)*3+1))^2 + abs(gain(i, (k-1)*3+2))^2 + abs(gain(i, (k-1)*3+3))^2;
            
            num3 = num3 + data(i, k)*conj(gain(i, (k-1)*3+2)) - conj(data(i+1, k))*gain(i, (k-1)*3+1);
            num3 = num3 + (data(i+3, k) + data(i+2, k))*conj(gain(i, (k-1)*3+3))/2 + conj(data(i+3, k) - data(i+2, k))*gain(i, (k-1)*3+3)/2;
            num4 = num2;
            
            num5 = num5 + (data(i, k) + data(i+1, k))*conj(gain(i, (k-1)*3+3))/sqrt(2) + conj(data(i+2, k))*(gain(i, (k-1)*3+1) + gain(i, (k-1)*3+2))/sqrt(2);
            num5 = num5 + conj(data(i+3, k))*(gain(i, (k-1)*3+1) - gain(i, (k-1)*3+2))/sqrt(2);
            num6 = num2;
        end
        
        temp_a = 0:7;
        temp_complex = pskmod(temp_a, 8);
        temp_result = [];
        for i_temp = 1:8
            temp_result = [temp_result, abs(num1 - temp_complex(i_temp))^2 + num2];
        end
        max_likelihood = min(temp_result);
        for i_temp = 1:8
            if temp_result(i_temp) == max_likelihood;
                data_decoded((i-1)*3/4 + 1) = temp_complex(i_temp);
                break;
            end
        end

        temp_result = [];
        for i_temp = 1:8
            temp_result = [temp_result, abs(num3 - temp_complex(i_temp))^2 + num4];
        end
        max_likelihood = min(temp_result);
        for i_temp = 1:8
            if temp_result(i_temp) == max_likelihood;
                data_decoded((i-1)*3/4 + 2) = temp_complex(i_temp);
                break;
            end
        end

        temp_result = [];
        for i_temp = 1:8
            temp_result = [temp_result, abs(num5 - temp_complex(i_temp))^2 + num6];
        end
        max_likelihood = min(temp_result);
        for i_temp = 1:8
            if temp_result(i_temp) == max_likelihood;
                data_decoded((i-1)*3/4 + 3) = temp_complex(i_temp);
                break;
            end
        end
    end
end

if strcmp(coding_mode, 'h4')
    [len, wid] = size(data);
    data_decoded = zeros(len*3/4, 1);
    for i = 1:4:len
        num1 = 0; num2 = -1; num3 = 0; num4 = -1; num5 = 0; num6 = -1;
        for k = 1:receiver_num
            num1 = num1 + data(i, k)*conj(gain(i, (k-1)*4+1)) + conj(data(i+1, k))*gain(i, (k-1)*4+2);
            num1 = num1 + (data(i+3, k) - data(i+2, k))*conj(gain(i, (k-1)*4+3) - gain(i, (k-1)*4+4))/2 - conj(data(i+3, k) + data(i+2, k))*(gain(i, (k-1)*4+3) + gain(i, (k-1)*4+4))/2;
            num2 = num2 + abs(gain(i, (k-1)*4+1))^2 + abs(gain(i, (k-1)*4+2))^2 + abs(gain(i, (k-1)*4+3))^2 + abs(gain(i, (k-1)*4+4))^2;
            
            num3 = num3 + data(i, k)*conj(gain(i, (k-1)*4+2)) - conj(data(i+1, k))*gain(i, (k-1)*4+1);
            num3 = num3 + (data(i+3, k) + data(i+2, k))*conj(gain(i, (k-1)*4+3) - gain(i, (k-1)*4+4))/2 + conj(data(i+3, k) - data(i+2, k))*(gain(i, (k-1)*4+3) + gain(i, (k-1)*4+4))/2;
            num4 = num2;
            
            num5 = num5 + (data(i, k) + data(i+1, k))*conj(gain(i, (k-1)*4+3))/sqrt(2) + (data(i, k) - data(i+1, k))*conj(gain(i, (k-1)*4+4))/sqrt(2);
            num5 = num5 + conj(data(i+2, k))*(gain(i, (k-1)*4+1) + gain(i, (k-1)*4+2))/sqrt(2) + conj(data(i+3, k))*(gain(i, (k-1)*4+1) - gain(i, (k-1)*4+2))/sqrt(2);
            num6 = num2;
        end
        
        temp_a = 0:7;
        temp_complex = pskmod(temp_a, 8);
        temp_result = [];
        for i_temp = 1:8
            temp_result = [temp_result, abs(num1 - temp_complex(i_temp))^2 + num2];
        end
        max_likelihood = min(temp_result);
        for i_temp = 1:8
            if temp_result(i_temp) == max_likelihood;
                data_decoded((i-1)*3/4 + 1) = temp_complex(i_temp);
                break;
            end
        end

        temp_result = [];
        for i_temp = 1:8
            temp_result = [temp_result, abs(num3 - temp_complex(i_temp))^2 + num4];
        end
        max_likelihood = min(temp_result);
        for i_temp = 1:8
            if temp_result(i_temp) == max_likelihood;
                data_decoded((i-1)*3/4 + 2) = temp_complex(i_temp);
                break;
            end
        end

        temp_result = [];
        for i_temp = 1:8
            temp_result = [temp_result, abs(num5 - temp_complex(i_temp))^2 + num6];
        end
        max_likelihood = min(temp_result);
        for i_temp = 1:8
            if temp_result(i_temp) == max_likelihood;
                data_decoded((i-1)*3/4 + 3) = temp_complex(i_temp);
                break;
            end
        end
    end
end
    