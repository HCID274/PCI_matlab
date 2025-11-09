classdef r6fClass < pathClass
    properties
    %PRM
        FVER;
        IRMAX;
        KYM;%max m
        KZM;%max n
        LYM2;%original KYM, data(0:IRMAX,1:LYM2,1:LZM2)
        LZM2;%original LZM
        LKY;
        LKZ;
        LMAX;%LMAX+1=(number of modes)
%        
        BETAI;
        BETAE;
        DELTA;
        EPSILON;
        VISPSI;
        VISVPL_PAR;
        VISPRE_PAR;
        VISVOL;
        VISCUR;
        VISPRE;
        VISVPL;
        VIS_TEME;
        VIS_KAIE_PARA;
        VIS_KAIE_PERP;
        VIS_KAII_PARA;
        VIS_KAII_PERP;
%        
        R;
        Q;
        AEQ;
        CURQ;
        PREQ;
        DENSQ;
        TEMEQ;
        TEMIQ;
        TEMTQ;
    %PLASMA
        PLASMA_PHI0;
        PLASMA_PHI1;
        PLASMA_PHI_total;
        PLASMA_PSI0;
        PLASMA_PSI1;
        PLASMA_PSI_total;
        PLASMA_VPL0;
        PLASMA_VPL1;
        PLASMA_VPL_total;
        PLASMA_NE0;
        PLASMA_NE1;
        PLASMA_NE_total;
        PLASMA_TE0;
        PLASMA_TE1;
        PLASMA_TE_total;
        PLASMA_TI0;
        PLASMA_TI1;
        PLASMA_TI_total;
    %ptprflist
        TIME;
        COUNT;
        TS;
        TE;
    end
%    
    methods
        function obj = r6fClass(f_path,data_n)
            fread_path(obj,f_path,data_n);
        end
%
        fread_param2(obj);
        fread_plasma1(obj,t);
    end
end