classdef magLHDClass < handle
    properties
    %mag
        R_mag;
        Phi_mag;
        Z_mag;
        NRGM;
        NZGM;
        NPHIGM;
        BF1;
        BF2;
        BF3;
        BF3D;%for SPL3D
        BFmag
    end
 %
    methods
        fread_mag(obj,f_EQmag,endian);
        [BR, BZ, BT]=probeEQ_mag(obj,R0,Z0,PHI0);
    end
end