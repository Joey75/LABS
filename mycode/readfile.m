function csi_trace = readfile(filepath)
	path('../linux-80211n-csitool-supplementary/matlab', path);
	csi_trace = read_bf_file(filepath);
end