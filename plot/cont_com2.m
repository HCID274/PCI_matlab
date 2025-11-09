% plot contour
function cont_com2(sim,data_n,ax,t,sum)
% simulation type: 1(NLD),2(DISA),3(R4F),4(R5F)
% data#, axial position, time, mode extract(0:OFF, 1:ON)
oldpath=path;
path('../com',oldpath);
f_path='path.txt';
%
switch sim
    case {'NLD', 'nld'}
        FVER=1;
        oldpath=addpath('../sim_data/nld','../sim_data/nld/plot');
    case {'R5F', 'r5f'}
        FVER=3.5;
        oldpath=addpath('../sim_data/r5f','../sim_data/task_eq','../sim_data/r5f/plot');
    case {'GENE', 'gene'}
        FVER=5;
        oldpath=addpath('../sim_data/GENE','../sim_data/GENE/plot','../sim_data/task_eq');       
    otherwise
        error('Unexpected simulation type.')
end
cont2(sim,data_n,ax,t,sum);
%
path(oldpath);
end
