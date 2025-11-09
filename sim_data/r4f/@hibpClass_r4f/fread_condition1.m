function fread_condition1(obj,f_condition)
fid=fopen(f_condition);
p1=textscan(fid,'%s %s');
%
p3=find(strcmp(p1{1}, 'in_pos1')==1);
if size(p3) ~= 1
    error('no description of in_pos1!\n');
else
    obj.in_pos(1)=str2num(p1{2}{p3});
end
%
p3=find(strcmp(p1{1}, 'in_pos2')==1);
if size(p3) ~= 1
    error('no description of in_pos2!\n');
else
    obj.in_pos(2)=str2num(p1{2}{p3});
end
%
p3=find(strcmp(p1{1}, 'in_pos3')==1);
if size(p3) ~= 1
    error('no description of in_pos3!\n');
else
    obj.in_pos(3)=str2num(p1{2}{p3});
end
%
p3=find(strcmp(p1{1}, 'in_ene')==1);
if size(p3) ~= 1
    error('no description of in_ene!\n');
else
    obj.in_ene=str2num(p1{2}{p3});
end
%
p3=find(strcmp(p1{1}, 'in_ang1')==1);
if size(p3) ~= 1
    error('no description of in_ang1!\n');
else
    obj.in_ang1=str2num(p1{2}{p3});
end
%
p3=find(strcmp(p1{1}, 'in_ang2')==1);
if size(p3) ~= 1
    error('no description of in_ang2!\n');
else
    obj.in_ang2=str2num(p1{2}{p3});
end
%
p3=find(strcmp(p1{1}, 'tracemax')==1);
if size(p3) ~= 1
    error('no description of tracemaxt!\n');
else
    obj.tracemax=str2num(p1{2}{p3});
    obj.ion_p=obj.tracemax*0.4;
end
%
p3=find(strcmp(p1{1}, 'out_pos1')==1);
if size(p3) ~= 1
    error('no description of out_pos1!\n');
else
    obj.out_pos(1)=str2num(p1{2}{p3});
end
%
p3=find(strcmp(p1{1}, 'out_pos2')==1);
if size(p3) ~= 1
    error('no description of out_pos2!\n');
else
    obj.out_pos(2)=str2num(p1{2}{p3});
end
%
p3=find(strcmp(p1{1}, 'out_pos3')==1);
if size(p3) ~= 1
    error('no description of out_pos3!\n');
else
    obj.out_pos(3)=str2num(p1{2}{p3});
end
%
p3=find(strcmp(p1{1}, 'mass')==1);
if size(p3) ~= 1
    error('no description of mass!\n');
else
    obj.mass=str2num(p1{2}{p3});
end
%
p3=find(strcmp(p1{1}, 'dang')==1);
if size(p3) ~= 1
    error('no description of dang!\n');
else
    obj.dang=str2num(p1{2}{p3});
end
%
p3=find(strcmp(p1{1}, 'dti')==1);
if size(p3) ~= 1
    error('no description of dti!\n');
else
    obj.dti=str2num(p1{2}{p3});
end
%
p3=find(strcmp(p1{1}, 'da1_min')==1);
if size(p3) ~= 1
    error('no description of da1_min!\n');
else
    obj.da1_min=str2num(p1{2}{p3});
end
%
p3=find(strcmp(p1{1}, 'da2_min')==1);
if size(p3) ~= 1
    error('no description of da2_min!\n');
else
    obj.da2_min=str2num(p1{2}{p3});
end
%
p3=find(strcmp(p1{1}, 'phi_d')==1);
if size(p3) ~= 1
    error('no description of phi_d!\n');
else
    obj.phi_d=str2num(p1{2}{p3});
end
%
p3=find(strcmp(p1{1}, 'in_width')==1);
if size(p3) ~= 1
    error('no description of in_width!\n');
else
    obj.in_width=str2num(p1{2}{p3});
end
%
p3=find(strcmp(p1{1}, 'out_width')==1);
if size(p3) ~= 1
    error('no description of out_width!\n');
else
    obj.out_width=str2num(p1{2}{p3});
end
%
p3=find(strcmp(p1{1}, 't')==1);
if size(p3) ~= 1
    error('no description of t!\n');
else
    obj.t=str2num(p1{2}{p3});
end
%
p3=find(strcmp(p1{1}, 't_end')==1);
if size(p3) ~= 1
    error('no description of t_end!\n');
else
    obj.t_end=str2num(p1{2}{p3});
end
%
p3=find(strcmp(p1{1}, 't_dt')==1);
if size(p3) ~= 1
    error('no description of t_dt!\n');
else
    obj.t_dt=str2num(p1{2}{p3});
end
%
p3=find(strcmp(p1{1}, 'fi')==1);
if size(p3) ~= 1
    error('no description of fi!\n');
else
    obj.fi=str2num(p1{2}{p3});
end
%
p3=find(strcmp(p1{1}, 'disk_n')==1);
if size(p3) ~= 1
    error('no description of disk_n!\n');
else
    obj.disk_n=str2num(p1{2}{p3});
end
%
p3=find(strcmp(p1{1}, 'data_n')==1);
if size(p3) ~= 1
    error('no description of data_n!\n');
else
    obj.data_n=str2num(p1{2}{p3});
end
%
end