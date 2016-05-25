function plot_phase_beforeSanitization(csi_trace,packet1,packet2)
	path('../linux-80211n-csitool-supplementary/matlab', path);
	csi_entry1 = csi_trace{packet1};
	csi_entry2 = csi_trace{packet2};
	csi1 = get_scaled_csi(csi_entry1);
	csi1 = csi1(1, :, :);
	csi1 = squeeze(csi1);
	
	csi2 = get_scaled_csi(csi_entry2);
	csi2 = csi2(1, :, :);
	csi2 = squeeze(csi2);
	
	ang1=angle(csi1);
    ang2=angle(csi2);
    unwrapAng1=unwrap(ang1,pi,2);
    unwrapAng2=unwrap(ang2,pi,2);
    figure('Name', 'Unmodified CSI Phase', 'NumberTitle', 'off')
    hold on;
    plot(unwrapAng1(1,:),'--r');
    plot(unwrapAng1(2,:),'--g');
    plot(unwrapAng1(3,:),'--b');
    plot(unwrapAng2(1,:),'^r');
    plot(unwrapAng2(2,:),'^g');
    plot(unwrapAng2(3,:),'^b');
    xlabel('Subcarrier Index')
    ylabel('Unwrapped CSI Phase')
    title('Unmodified CSI Phase')
    legend('Packet 1, Antenna 1', 'Packet 1, Antenna 2', 'Packet 1, Antenna 3', ...
            'Packet 2, Antenna 1', 'Packet 2, Antenna 2', 'Packet 2, Antenna 3')
    grid on
    hold off;
end