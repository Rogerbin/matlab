function plotFFT(signal,fs)
% display the fft spectrum of signal

Ln = length(signal);
Nt = 2^nextpow2(Ln);% fft points
Y = fft(signal,Nt);
Y2 = Y.*conj(Y)/Nt;
f = fs*(0:Nt/2)/Nt;
front =(0:fix(Nt/2))+1;
figure;
loglog(f,Y2(front));
set(gca,'xlim',[7e-5, fs/2]);
grid on
xlabel('Frequency/Hz');
ylabel('Magnitude');
title('DFU')