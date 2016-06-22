%% MUSIC algorithm with SpotFi method including ToF and AoA
function [estimated_aoas, estimated_tofs] = aoa_tof_music(x, sub_freq_delta)
    
    % Data covarivance matrix
    R = x * x'; 
    %R=cov(x * x');
    % Find the eigenvalues and eigenvectors of the covariance matrix
    [eigenvectors, eigenvalue_matrix] = eig(R);
    % Find max eigenvalue for normalization
    max_eigenvalue = max(diag(eigenvalue_matrix));
    eigenvalue_matrix = eigenvalue_matrix / max_eigenvalue;

    num_computed_paths = 6;
    
    % Estimate noise subspace
    column_indices = 1:(size(eigenvalue_matrix, 1) - num_computed_paths);
    eigenvectors = eigenvectors(:, column_indices); 
    % Peak search
    % Angle in degrees (converts to radians in phase calculations)
    %% TODO: Tuning theta too??
    theta = -90:0.5:90; 
    % time in milliseconds
    %% TODO: Tuning tau....
    %tau = 0:(1.0 * 10^-9):(50 * 10^-9);
    tau = 0:(1 * 10^-9):(100 * 10^-9);
    Pmusic = zeros(length(theta), length(tau));
    % Angle of Arrival Loop (AoA)
    for ii = 1:length(theta)
        % Time of Flight Loop (ToF)
        for jj = 1:length(tau)
            steering_vector = compute_steering_vector(theta(ii), tau(jj), sub_freq_delta);
            PP = steering_vector' * (eigenvectors * eigenvectors') * steering_vector;
            Pmusic(ii, jj) = abs(1 /  PP);
            Pmusic(ii, jj) = 10 * log10(Pmusic(ii, jj));% / max(Pmusic(:, jj)));
            %Pmusic(ii, jj) = abs(Pmusic(ii, jj));
        end
    end
    

	% Theta (AoA) & Tau (ToF) 3D Plot
	figure('Name', 'AoA & ToF MUSIC Peaks', 'NumberTitle', 'off')
	mesh(tau, theta, Pmusic)
	xlabel('Time of Flight')
	ylabel('Angle of Arrival in degrees')
	zlabel('Spectrum Peaks')
	title('AoA and ToF Estimation from Modified MUSIC Algorithm')
	grid on

    % Find AoA && TOF peaks
    [estimated_aoas, estimated_tofs]=find_music_peak(Pmusic,theta,tau);
    
end

%% Computes the steering vector for SpotFi. 
function steering_vector = compute_steering_vector(theta, tau, sub_freq_delta)
    steering_vector = zeros(30, 1);
    k = 1;
    base_element = 1;
    for ii = 1:2
        for jj = 1:15
            steering_vector(k, 1) = base_element * omega_tof_phase(tau, sub_freq_delta)^(jj - 1);
            k = k + 1;
        end
        base_element = base_element * phi_aoa_phase(theta);
    end
end

%% Compute the phase shifts across subcarriers as a function of ToF
function time_phase = omega_tof_phase(tau, sub_freq_delta)
    time_phase = exp(-1i * 2 * pi * sub_freq_delta * tau);
end

%% Compute the phase shifts across the antennas as a function of AoA
function angle_phase = phi_aoa_phase(theta)
    % Speed of light (in m/s)
    c = 3.0 * 10^8;
    % Convert to radians
    theta = theta / 180 * pi;
    angle_phase = exp(-1i * pi * sin(theta));
end
