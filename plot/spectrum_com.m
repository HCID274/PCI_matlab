% plot energy spectrum
function spectrum_com(sim,data_n,t)
% simulation type: 1(NLD),2(DISA),3(R4F),3.5(R5F),3.6(R6F),5(GENE)
% data#, time
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
    case {'R6F', 'r6f'}
        FVER=3.6;
        oldpath=addpath('../sim_data/r6f','../sim_data/rd_model','../sim_data/task_eq','../sim_data/r6f/plot');
    case {'GENE', 'gene'}
        FVER=5;
        oldpath=addpath('../sim_data/GENE','../sim_data/task_eq','../sim_data/GENE/plot');
    otherwise
        error('Unexpected simulation type.')
end
spectrum(sim,data_n,t);
%
path(oldpath);
end
