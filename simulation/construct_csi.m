function csi=construct_csi(aoa,tof)
    sub_freq_delta=1*10^6;
    snr=100;
    for m=1:1:3
        for l=1:1:length(aoa)
            a(m,l)=exp(-1i*2*pi*(m-1)*sin(aoa(l)*pi/180)/2);
        end
    end
    for l=1:1:length(tof)
        for i=1:1:30
            x(l,i)=exp(-1i*2*pi*(i-1)*sub_freq_delta*tof(l)*10^(-9));
        end
    end
    noise=(randn(3,30)+1i*randn(3,30))/sqrt(2);
    amp=sqrt(cov(noise(1,:))*10^(snr/10));
    csi=amp*a*x+noise;
end
