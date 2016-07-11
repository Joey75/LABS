function [estimated_aoas, estimated_tofs] = run_music
    aoa=[25.5,15,9,-13.5,-42,-59.5];
    tof=[43,10,25,37,8,76];
    csi=construct_csi(aoa,tof);
    smoothed_csi=smooth_csi(csi);
    [estimated_aoas, estimated_tofs] = aoa_tof_music(smoothed_csi,1*10^6);
end