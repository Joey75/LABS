function csi = get_csi( csi_entry )
    path('../linux-80211n-csitool-supplementary/matlab', path);
    csi = get_scaled_csi(csi_entry);
    csi = csi(1, :, :);
    csi = squeeze(csi);
end

