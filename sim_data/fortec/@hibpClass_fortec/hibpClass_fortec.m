classdef hibpClass_fortec < fortecClass & hibpClass & handle
    methods
        function obj = hibpClass_fortec(f_path,data_n)
            obj@fortecClass(f_path,data_n);
            obj@hibpClass;
        end

        function [BR, BZ, BT]=probeEQ_mag(obj,R0,Z0,PHI0)
            rho=probeEQ_local_s(obj,R0,Z0,PHI0,obj.rho);
            if rho < 1.0 & rho > 0.0
                [BR, BZ, BT]=probeEQ_mag@fortecClass(obj,R0,Z0,PHI0);
            else
                [BR, BZ, BT]=probeEQ_mag@magLHDClass(obj,R0,Z0,PHI0);
            end
        end
    end
end

