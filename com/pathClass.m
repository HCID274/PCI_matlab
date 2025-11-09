classdef pathClass < handle
    properties(SetAccess = private, GetAccess = public)
        indir;
        outdir;
        endian;
    end
    
    methods
function fread_path(obj,f_path,data_n)
%  add path, set the data and output directory, and endian
[p1 p2]=textread(f_path,'%s %s');
%
% set path directory
p3=find(strcmp(p1, 'path')==1);
p4=size(p3);
for a=1:p4(1)
    path(path,p2{p3(a)});
end
%
% set data directory
p3=find(strcmp(p1, 'in')==1);
if size(p3) ~= 1
    error('no description of the input directory!\n');
else
    obj.indir=sprintf('%s%03d/',p2{p3},data_n);
end
%
% set output directory
p3=find(strcmp(p1, 'out')==1);
if size(p3) ~= 1
    error('no description of the output directory!\n');
else
    obj.outdir=p2{p3};
end
%
% set endian
p3=find(strcmp(p1, 'endian')==1);
if size(p3) ~= 1
    error('no description of endian!\n');
else
    obj.endian=p2{p3};
end
end
    end
end