classdef hibpClass_fortec < fortecClass & handle
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
        in_width;
        out_width;
        t;
        t_end;
        t_dt;
        num;
        fi;
    end
    
    methods
        function obj = hibpClass_fortec(f_path,data_n)
            obj@fortecClass(f_path,data_n);
            obj.in_pos=zeros(3,1);
            obj.out_pos=zeros(3,1);
        end
        %
        fread_condition1(obj,f_condition);
        [x,y,z,v,bp,inten]=hibp_inj(obj,x0,out_pos,tracemax,ion_p);
        x1=Runge_motion(obj,x0,dt,cof1,cof2);
        c=co_atten(mass,v0,Te);
    end
end

