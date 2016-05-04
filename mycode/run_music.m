function [aoa_packet_data, tof_packet_data] = run_music(csi_trace, frequency, sub_freq_delta, antenna_distance, data_name)
    path('../linux-80211n-csitool-supplementary/matlab', path);    
    if nargin < 5
        data_name = ' - ';
    end
    
    num_packets = length(csi_trace);
    % Loop over packets, estimate AoA and ToF from the CSI data for each packet
    aoa_packet_data = cell(num_packets, 1);
    tof_packet_data = cell(num_packets, 1);
    packet_one_phase_matrix = 0;

    % Do computations for packet one so the packet loop can be parallelized
    % Get CSI for current packet
    csi_entry = csi_trace{1};
    csi = get_scaled_csi(csi_entry);
    % Only consider measurements for transmitting on one antenna
    csi = csi(1, :, :);
    % Remove the single element dimension
    csi = squeeze(csi);

    % Sanitize ToFs with Algorithm 1
    packet_one_phase_matrix = unwrap(angle(csi), pi, 2);
    sanitized_csi = spotfi_algorithm_1(csi, sub_freq_delta);
    % Acquire smoothed CSI matrix
    smoothed_sanitized_csi = smooth_csi(sanitized_csi);
    % Run SpotFi's AoA-ToF MUSIC algorithm on the smoothed and sanitized CSI matrix
    [aoa_packet_data{1}, tof_packet_data{1}] = aoa_tof_music(...
            smoothed_sanitized_csi, antenna_distance, frequency, sub_freq_delta, data_name);

    %% TODO: REMEMBER THIS IS A PARFOR LOOP, AND YOU CHANGED THE ABOVE CODE AND THE BEGIN INDEX
    parfor (packet_index = 2:num_packets, 4)
        % Get CSI for current packet
        csi_entry = csi_trace{packet_index};
        csi = get_scaled_csi(csi_entry);
        % Only consider measurements for transmitting on one antenna
        csi = csi(1, :, :);
        % Remove the single element dimension
        csi = squeeze(csi);

        % Sanitize ToFs with Algorithm 1
        sanitized_csi = spotfi_algorithm_1(csi, sub_freq_delta, packet_one_phase_matrix);

        % Acquire smoothed CSI matrix
        smoothed_sanitized_csi = smooth_csi(sanitized_csi);
        % Run SpotFi's AoA-ToF MUSIC algorithm on the smoothed and sanitized CSI matrix
        [aoa_packet_data{packet_index}, tof_packet_data{packet_index}] = aoa_tof_music(...
                smoothed_sanitized_csi, antenna_distance, frequency, sub_freq_delta, data_name);
    end
end