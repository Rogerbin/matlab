function out=filterD1(f2,f1,data)
%design filter 4-7s ,fs=1hz
%f1 second of cutoff freq1,
%f2 second of cutoff freq2
%sample:filterD1(4,7,x);  filter from 4s to 7s
% All frequency values are in Hz.
Fs = 1;  % Sampling Frequency

N    = 100;      % Order
Fc1  = 1/f1;%7s   % First Cutoff Frequency
Fc2  = 1/f2;     % Second Cutoff Frequency
flag = 'scale';  % Sampling Flag
% Create the window vector for the design algorithm.
win = hamming(N+1);
Fc2=Fc2-0.0001;
% Calculate the coefficients using the FIR1 function.
[b,a] = fir1(N, [Fc1 Fc2]/(Fs/2), 'bandpass', win, flag);
% Hd = dfilt.dffir(b);
out=filtfilt(b,a,data);
%---------------------------
[h1,w1]=freqz(b,a,8192,1);
hf=abs(h1).^2;
hangle=angle(hf);
figure;
plot(w1,20*log(hf),w1,hangle,'g');
set(gca,'ylim',[-400 10]);
legend('Amplitude','Phase');
% hold on 
% plot();
xlabel('Frequency(Hz)');
ylabel('Magnitude(dB)');
title(['FIR hamming ',num2str(f2),'-',num2str(f1),'s',' ','Order:',num2str(N)])
% plot([Fc1 Fc1],get(gca,'ylim'),'r');
% plot([Fc2 Fc2],get(gca,'ylim'),'r');