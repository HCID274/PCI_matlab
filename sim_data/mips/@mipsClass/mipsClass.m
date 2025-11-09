classdef mipsClass < pathClass
    properties
    %PRM
        FVER;
        Te;
        B0;
    %EQ cod
        NSGMAX;
        NTGMAX;
        GRC;
        GZC;
        GFC;
        Rmax;
        Rmin;
        Zmax;
        Zmin;
        PA;%plasma axis
        GAC;%minor r
        GTC_f;%theta(0:2pi) flux coord
        GTC_c;%theta(0:2pi) cylindrical coord
     %EQ mag
        NRGM;
        NZGM;
        NPHIGM;
        RG1;
        RG2;
        RG3;
        DR1;
        DR2;
        DR3;
        GBPR_2d;
        GBPZ_2d;
        GBTP_2d;
        GBPP_2d;
        GBPR_3d;
        GBPZ_3d;
        GBTP_3d;
        GBPP_3d;
    %PLASMA
        PLASMA_NE0;
        PLASMA_NE1;
        PLASMA_NE_total;
        PLASMA_TE0;
        PLASMA_TE1;
        PLASMA_TE_total;
        PLASMA_PHI_total;
%        EF0;
%        BF0;
        EF;
        BF;
    end
    
    methods
        function obj = mipsClass(f_path,data_n)
            fread_path(obj,f_path,data_n);
        end

        fread_param2(obj);
        fread_EQ1(obj);
        fread_EQcod3(obj,f_EQcod);
        fread_EQmag(obj,f_EQmag);
        fread_plasma1(obj,t);
        [BR BZ BT PP poid_mag da_mag]=probeEQ_mag(obj,R0,Z0,PHI0);
        z=probeEQ_local_s(obj,R0,Z0,PHI0,data1);
        [BR BZ BT]=probeEQ_local_v(obj,R0,Z0,PHI0,data2);
        plot_plasma1(obj,phi_d);
        rho=probeEQ_rho(obj,R0,Z0,PHI0)
    end
end