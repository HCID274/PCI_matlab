classdef hibpClass_r5f < r5fClass & hibpClass & handle
    methods
        function obj = hibpClass_r5f(f_path,data_n)
            obj@r5fClass(f_path,data_n);
            obj@hibpClass;
        end
    end
end

