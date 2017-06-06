function [error] = calculate_error(data1, data2)

error = 0;
len = length(data1);
for i = 1:len
    if data1(i) ~= data2(i)
        error = error + 1;
    end
end
error = error/len;