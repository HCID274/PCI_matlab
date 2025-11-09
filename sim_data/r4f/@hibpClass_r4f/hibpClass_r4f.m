classdef hibpClass_r4f < r4fClass & handle
    properties
        in_pos;%(x1,x2,x3)
        in_ene;%[MeV]
        in_ang1;%incicent angle in (x1-x3)
        in_ang2;%incicent angle in (x3-x2)
        tracemax;
        ion_p;
        out_pos;%(x1,x2,x3)
        mass;%Au(197),Rb(85)
        dang;
        dti;
        da1_min;
        da2_min;
        phi_d;
        in_width;
        out_width;
        t;
        t_end;
        t_dt;
        disk_n;
        data_n;
        num;
        fi;
        TEtmp;
        PHInorm;
    end
    %
    methods 
        function obj = hibpClass_r4f(f_path, data_n)
            obj@data(f_path, data_n);
            obj.in_pos = zeros(3, 1);
            obj.out_pos = zeros(3, 1);
            %
            obj.TEtmp=200;
            obj.PHInorm=3.5e4; %epsilon * v_A * B_T * a for reduced MHD
        end
        %
        fread_condition1(obj,f_condition)
        [x,y,z,v,bp,inten]=hibp_inj(obj,x0,out_pos,tracemax,ion_p);
        plot_traj(obj,x,y,z,bp,n1);
        x1=Runge_motion(obj,x0,dt,cof1,cof2,data1);
        c=co_atten(obj,Te);
    end
end