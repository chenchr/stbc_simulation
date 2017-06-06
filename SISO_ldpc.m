function BER=SISO_ldpc(data_length,receiver_num,coding_mode,SNR_DIFF)
hEnc = comm.LDPCEncoder;
hDec = comm.LDPCDecoder;
if strcmp(coding_mode, 'BPSK')
    x= randi([0 1],1,data_length);
    data = logical(x');
    data_LDPCencoded = step(hEnc, data);
    sb=pskmod(double(data_LDPCencoded),2);
    M=1;
else
    x= randi([0 3],1,data_length);
    sb=pskmod(x,4);
    M=2;  
end
BER=zeros(1,length(SNR_DIFF));

for L=1:length(SNR_DIFF)
    
    No=(10^(SNR_DIFF(L)/10));
    sigma=sqrt(1/(No*2*M)); 
    n=(randn(receiver_num,data_length*2)+1i*randn(receiver_num,data_length*2)).*sigma;
    h=(randn(receiver_num,data_length*2)+1i*randn(receiver_num,data_length*2))/sqrt(2);
    
    y=h.*sb'+n; 
    y1 = y.*conj(h); 
    h1 = (abs(h)).^2;
    y2 = sum(y1,1)./sum(h1,1);
    r = pskdemod(y2,2^M);
    r_decoded = step(hDec, r');
    [~,BER(L)]=biterr(x,r_decoded',M); 
end
end
