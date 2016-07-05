%% Time of Flight (ToF) Sanitization Algorithm
function [csi_matrix, phase_matrix] = spotfi_algorithm_1(csi_matrix, delta_f, packet_one_phase_matrix)
    R = abs(csi_matrix);
    phase_matrix = unwrap(angle(csi_matrix), pi, 2);
    
    % Parse input args
    if nargin < 3
        packet_one_phase_matrix = phase_matrix;
    end

    fit_X(1:30, 1) = 0:1:29;
    fit_X(31:60, 1) = 0:1:29;
    fit_X(61:90, 1) = 0:1:29;
    fit_X = fit_X * 2 * pi * delta_f;
    fit_Y = zeros(90, 1);
    for i = 1:size(phase_matrix, 1)
        for j = 1:size(phase_matrix, 2)
            fit_Y((i - 1) * 30 + j) = packet_one_phase_matrix(i, j);
        end
    end

    % Linear fit is common across all antennas
    result = polyfit(fit_X, fit_Y, 1);
    tau = result(1);
        
    for m = 1:size(phase_matrix, 1)
        for n = 1:size(phase_matrix, 2)
            % Subtract the phase added from sampling time offset (STO)
            phase_matrix(m, n) = packet_one_phase_matrix(m, n) - (2 * pi * delta_f * (n - 1) * tau);
            %phase_matrix(m, n) = packet_one_phase_matrix(m, n) - (n - 1) * tau;
        end
    end
    
    % Reconstruct the CSI matrix with the adjusted phase
    csi_matrix = R .* exp(1i * phase_matrix);
end

