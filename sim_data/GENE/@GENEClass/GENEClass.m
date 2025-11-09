classdef GENEClass < task_eqClass & pathClass
    properties
        %PRM
        FVER;
        IRMAX;
        KYMt;
        KZMt;
        LYM2;%original KYM, data(0:IRMAX,1:LYM2,1:LZM2)
        LZM2;%original LZM
        KYM;%max m
        KZM;%max n
        LMAX;%LMAX+1=(number of modes)
        LKY;
        LKZ;
 
        B0; %essential

        %from parameters.dat
        %parallelization
        n_procs_s;
        n_procs_v;
        n_procs_w;
        n_procs_x;
        n_procs_y;
        n_procs_z;
        n_procs_sim;

        %box
        n_spec;
        nx0;%IRMAX
        nky0;
        nz0;
        nv0;
        nw0;

        kymin;
        lv;   
        lw;   
        lx;   
        nexc;

        %in_out
        istep_field;
        istep_mom;   
        istep_nrg;   
        istep_vsp;   
        istep_schpt; 
        istep_energy;
        istep_energy3d;
        istep_neoclass;

        %general
        beta;   
        debye2;

        %geometry
        q0;   
        shat;   
        trpeps;   
        major_R;

        %species
        name1;
        omn1;      
        omt1;      
        mass1;     
        temp1;     
        dens1;     
        charge1;
        name2;
        omn2;      
        omt2;      
        mass2;     
        temp2;     
        dens2;     
        charge2;   
        
        %units
        B_ref;
        T_ref;
        T_ref2;
        n_ref;
        L_ref;
        m_ref;

        %other parameters
        q_ref;
        c_ref;
        omega_ref;
        rho_ref;

        inside;
        outside;


    end
    methods
        function obj = GENEClass(f_path,data_n)
            fread_path(obj,f_path,data_n);
        end
%
        fread_param2(obj);
        fread_param3(obj,file2,data_n);
        fread_plasma1(obj,t);
        plot_plasma1(obj,phi_d);
        z=probeEQ_local_s(obj,R0,Z0,PHI0,data1);
        [ER, EZ, ET]=probeEQ_ef(obj,R0,Z0,PHI0);
        [BR, BZ, BT, PP]=probeEQ_mag(obj,R0,Z0,PHI0)
        rho=probeEQ_rho(obj,R0,Z0,PHI0)
    end

end