classdef posClass < handle
    properties
        poid;%position mesh id
        podr;%partition in the mesh
        cos_pha;
        sin_pha;
    end
    methods
        function obj = posClass(num)
            obj.poid=zeros(num,1);
            obj.podr=zeros(num,LMAX+1);
            obj.cos_pha=zeros(LMAX+1,num);
            obj.sin_pha=zeros(LMAX+1,num);
        end
    end
end    
    
