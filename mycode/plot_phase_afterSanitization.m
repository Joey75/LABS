function plot_phase_afterSanitization(csi_trace,packet1,packet2)
	delta_f=4e7;
	
	path('../linux-80211n-csitool-supplementary/matlab', path);
	csi_entry1 = csi_trace{packet1};
	csi_entry2 = csi_trace{packet2};
	csi1 = get_scaled_csi(csi_entry1);
	csi1 = csi1(1, :, :);
	csi1 = squeeze(csi1);
	
	csi2 = get_scaled_csi(csi_entry2);
	csi2 = csi2(1, :, :);
	csi2 = squeeze(csi2);
	
	[~, phase_matrix1] = spotfi_algorithm_1(csi1, delta_f);
	[~, phase_matrix2] = spotfi_algorithm_1(csi1, delta_f);
	
    hold on;
    plot(phase_matrix1(1,:),'r');
    plot(phase_matrix1(2,:),'g');
    plot(phase_matrix1(3,:),'b');
    plot(phase_matrix2(1,:),'--r');
    plot(phase_matrix2(2,:),'--g');
    plot(phase_matrix2(3,:),'--b');
    hold off;
end