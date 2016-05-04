function output_top_aoas = run_spotfi(filepath)
	antenna_distance = 0.1;
    % frequency = 5 * 10^9;
    % frequency = 5.785 * 10^9;
    frequency = 5.32 * 10^9;
    sub_freq_delta = (40 * 10^6) / 30;
	
	csi_trace=readfile(filepath);
	num_packets = length(csi_trace);
	sampled_csi_trace = csi_sampling(csi_trace, num_packets, 1, length(csi_trace));
	[aoa_packet_data, tof_packet_data] = run_music(sampled_csi_trace, frequency, sub_freq_delta, antenna_distance);
	[output_top_aoas] = normalized_likelihood(tof_packet_data, aoa_packet_data, num_packets);
end