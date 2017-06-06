function [data_coded] = stbc_coding(data, coding_mode)

len = length(data);

if strcmp(coding_mode, 'g2')
    len = len * 1;
    data_coded = zeros(len, 2);
    for i = 1:2:len
        data_coded(i, 1) = data(i);
        data_coded(i, 2) = data(i+1);
        data_coded(i+1, 1) = -conj(data(i+1));
        data_coded(i+1, 2) = conj(data(i));
    end
elseif strcmp(coding_mode, 'g3')
    len = len * 2;
    data_coded = zeros(len, 3);
    for i = 1:8:len
        k = (i-1)/2 + 1;
        data_coded(i, 1) = data(k);
        data_coded(i, 2) = data(k+1);
        data_coded(i, 3) = data(k+2);
        
        data_coded(i+1, 1) = -data(k+1);
        data_coded(i+1, 2) = data(k);
        data_coded(i+1, 3) = -data(k+3);
        
        data_coded(i+2, 1) = -data(k+2);
        data_coded(i+2, 2) = data(k+3);
        data_coded(i+2, 3) = data(k);
        
        data_coded(i+3, 1) = -data(k+3);
        data_coded(i+3, 2) = -data(k+2);
        data_coded(i+3, 3) = data(k+1);
        
        data_coded(i+4:i+7, :) = conj(data_coded(i:i+3, :));
    end
elseif strcmp(coding_mode, 'g4')
    len = len*2;
    data_coded = zeros(len, 4);
    for i = 1:8:len
        k = (i-1)/2 + 1;
        data_coded(i, 1) = data(k);
        data_coded(i, 2) = data(k+1);
        data_coded(i, 3) = data(k+2);
        data_coded(i, 4) = data(k+3);
        
        data_coded(i+1, 1) = -data(k+1);
        data_coded(i+1, 2) = data(k);
        data_coded(i+1, 3) = -data(k+3);
        data_coded(i+1, 4) = data(k+2);
        
        data_coded(i+2, 1) = -data(k+2);
        data_coded(i+2, 2) = data(k+3);
        data_coded(i+2, 3) = data(k);
        data_coded(i+2, 4) = -data(k+1);
        
        data_coded(i+3, 1) = -data(k+3);
        data_coded(i+3, 2) = -data(k+2);
        data_coded(i+3, 3) = data(k+1);
        data_coded(i+3, 4) = data(k);
        
        data_coded(i+4:i+7, :) = conj(data_coded(i:i+3, :));
    end
elseif strcmp(coding_mode, 'h3')
    len = len*4/3;
    data_coded = zeros(len, 4);
    for i = 1:4:len
        k = (i-1)*3/4 + 1;
        data_coded(i, 1) = data(k);
        data_coded(i, 2) = data(k+1);
        data_coded(i, 3) = data(k+2)/sqrt(2);
        
        data_coded(i+1, 1) = -conj(data(k+1));
        data_coded(i+1, 2) = conj(data(k));
        data_coded(i+1, 3) = data(k+2)/sqrt(2);
        
        data_coded(i+2, 1) = conj(data(k+2))/sqrt(2);
        data_coded(i+2, 2) = conj(data(k+2))/sqrt(2);
        data_coded(i+2, 3) = (-data(k) - conj(data(k)) + data(k+1) - conj(data(k+1)))/2;
        
        data_coded(i+3, 1) = conj(data(k+2))/sqrt(2);
        data_coded(i+3, 2) = -conj(data(k+2))/sqrt(2);
        data_coded(i+3, 3) = (data(k) - conj(data(k)) + data(k+1) + conj(data(k+1)))/2;
    end
elseif strcmp(coding_mode, 'h4')
    len = len*4/3;
    data_coded = zeros(len, 4);
    for i = 1:4:len
        k = (i-1)*3/4 + 1;
        data_coded(i, 1) = data(k);
        data_coded(i, 2) = data(k+1);
        data_coded(i, 3) = data(k+2)/sqrt(2);
        data_coded(i, 4) = data(k+2)/sqrt(2);
        
        data_coded(i+1, 1) = -conj(data(k+1));
        data_coded(i+1, 2) = conj(data(k));
        data_coded(i+1, 3) = data(k+2)/sqrt(2);
        data_coded(i+1, 4) = -data(k+2)/sqrt(2);
        
        data_coded(i+2, 1) = conj(data(k+2))/sqrt(2);
        data_coded(i+2, 2) = conj(data(k+2))/sqrt(2);
        data_coded(i+2, 3) = (-data(k) - conj(data(k)) + data(k+1) - conj(data(k+1)))/2;
        data_coded(i+2, 4) = (data(k) - conj(data(k)) - data(k+1) - conj(data(k+1)))/2;
        
        data_coded(i+3, 1) = conj(data(k+2))/sqrt(2);
        data_coded(i+3, 2) = -conj(data(k+2))/sqrt(2);
        data_coded(i+3, 3) = (data(k) - conj(data(k)) + data(k+1) + conj(data(k+1)))/2;
        data_coded(i+3, 4) = (-data(k) - conj(data(k)) - data(k+1) + conj(data(k+1)))/2;
    end
end
        