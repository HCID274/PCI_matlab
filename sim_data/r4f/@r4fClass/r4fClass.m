classdef r4fClass < pathClass
    properties
    %PRM
        FVER;
        IRMAX;
        KYM;
        KZM;
        BETA;
        DELTA;
        EPSILON;
        PREPW;
        TAU;
        VISVOL;
        VISCUR;
        VISPSI;
        VISVPL;
        VISPRE;
        LMAX;
        LSTA;
        LEND;
        LKY;
        LKZ;
        R;
        Q;
        CURQ;
        NEQ;
        AEQ;
    %EQ
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
        
        NRGM;
        NZGM;
        NPHIGM;
        RG1;
        RG2;
        RG3;
        DR1;
        DR2;
        DR3;
        GBPR_3d;
        GBPZ_3d;
        GBTP_3d;
        GBPP_3d;
        GBPR_2d;
        GBPZ_2d;
        GBTP_2d;
        GBPP_2d;
    %PLASMA
        PHI;
        NE;
        TE;
        PHIt;
        NEt;
        TEt;
        PHIt_re;
        PHIt_im;
    end
    %
    methods
        function obj = r4fClass(f_path, data_n)
            fread_path(obj, f_path, data_n);
            obj.TEtmp=200;
            obj.PHInorm=3.5e4; %epsilon * v_A * B_T * a for reduced MHD
        end
        %
        fread_param2(obj);
        fread_EQ1(obj);
            fread_EQcod3(obj,f_EQcod);
            fread_EQmag(obj,f_EQmag);
        fread_plasma1(obj,t);
        [BR, BZ, BT, PP]=probeEQ_mag(obj, R0, Z0, PHI0);
        [g_R, g_Z, g_T]=probeEQ_local_grad(obj,R0,Z0,PHI0,data1,dR,dZ);
        [z1, z2]=probeEQ_local_para(obj,R0,Z0,PHI0,data11,data12);
        z=probeEQ_local(obj,R0,Z0,PHI0,data1);
        z=probeEQ_local1(obj,R0,Z0,PHI0,data11,data12)
        plot_plasma1(obj);
    end
    methods (Static)
        function yc=bisec(xx,data)
            [m1,n1]=size(data);
            m=max(m1,n1);
            %
            if (data(1)<data(m))
                ya=1;
                yb=m;
            else
                ya=m;
                yb=1;
            end
            if (data(ya)>xx || data(yb)<xx)
                yc=[0;0];
                return
            end
            for k=1:40
                yt=round((ya+yb)/2.0);
                ymid=data(yt);
                if (ymid<=xx)
                    ya=yt;
                else
                    yb=yt;
                end
                if (abs(ya-yb)<=1)
                    yc=[ya; yb];
                    return 
                end
            end
            yc=[0;0];
            return
        end
    end
end