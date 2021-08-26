function new_signal=filter_process(f_low,f_high,f_notch,N,Fs,signal)
 
new_signal=signal;
Wo = f_notch/(Fs/2); BW = Wo/125;
[b,a] = iirnotch(Wo,BW);
% N      = 3;   % Order
% [d,c]=butter(N,[f_low f_high]*2/Fs,'bandpass'); 
N      = 4;       % Order
Fpass1 = f_low;   % First Passband Frequency
Fpass2 = f_high;  % Second Passband Frequency
Apass  = 1;       % Passband Ripple (dB)
h  = fdesign.bandpass('N,Fp1,Fp2,Ap', N, Fpass1, Fpass2, Apass, Fs);
Hd = design(h,'cheby1');
norms=size(signal);
if length(norms)==1
    disp('输入数据错误')
elseif length(norms)==2
    [r,~]=size(signal);
    for i=1:r
        new_signal(i,:)=filtfilt(b,a,new_signal(i,:));
        new_signal(i,:)=filtfilt(Hd,new_signal(i,:));
    end
elseif length(norms)==3
    [r,~,n]=size(signal);
    for i=1:n
        for j=1:r
%             new_signal(j,:,i)=filter(b,a,new_signal(j,:,i));
%             new_signal(j,:,i)=filter(d,c,new_signal(j,:,i));
            new_signal(j,:,i)=filtfilt(b,a,new_signal(j,:,i));
            new_signal(j,:,i)=filtfilt(Hd.sosMatrix,Hd.ScaleValues,new_signal(j,:,i));
        end
    end
else
    disp('输入数据超出三维')
end
end