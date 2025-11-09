% mag from FORTEC data
classdef fortecClass < pathClass
    properties
     %PRM
        FVER;
        num1;
        num2;
        num3;
        phi_s;
        phi_e;
     %EQ
        theta_si;
        phi_si;
        R;
        phi;
        z;
        radius;
        Rax;
        zax;
        Bx3;
        By3;
        Bz3;
        rho;
        BF;
        EQ_poten;
        EQ_NE;
        EQ_TE;
        PA;
    %PLASMA
        PLASMA_PHI;
        PLASMA_NE;
        PLASMA_TE;
    %
        PLASMA_PHI_total;
        PLASMA_NE_total;
        PLASMA_TE_total;
    end
    
    methods
        function obj = fortecClass(f_path,data_n)
            fread_path(obj,f_path,data_n);
        end

        fread_param2(obj);
        fread_EQ1(obj);
        fread_plasma1(obj,t);
        z=probeEQ_local_s(obj,R0,Z0,PHI0,data1);
        [poid2, aw, bw, cw]=probe_local_PID(obj,R0,Z0,PHI0);
        pcs=probe_local_1(obj,poid,aw,bw,cw,data);
        [BR, BZ, BT]=probeEQ_mag(obj,R0,Z0,PHI0);
        [BR, BZ, BT]=probeEQ_local_v(obj,R0,Z0,PHI0,data2);
        pcs=probe_local_3(obj,poid,aw,bw,cw,data);
        [ER, EZ, ET]=probeEQ_ef(obj,R0,Z0,PHI0);
        plot_plasma1(obj,phi_d);
        plot_3d(obj);
    end
end