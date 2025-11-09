classdef hibpClass_mips < mipsClass & handle
    properties
        % (x(1),x(2),x(3))=(R[m],phi[rad],z[m]),(x[m],y[m],z[m])
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
        in_width;
    end
    
    methods
        function obj = hibpClass_mips(f_path,data_n)
            obj@mipsClass(f_path,data_n);
            obj.in_pos=zeros(3,1);
            obj.out_pos=zeros(3,1);
        end

%        fread_condition(obj,f_condition)
        [x,y,z,v,bp,inten]=hibp_inj(obj,x0,out_pos,tracemax,ion_p);
        plot_traj(obj,x,y,z,bp,n1);
        x1=Runge_motion(obj,x0,dt,cof1,cof2);
        c=co_atten(obj,Te);
    end
end
