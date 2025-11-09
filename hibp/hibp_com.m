function hibp_com(sim,cal,data_n,t,c_num,c_num2)
% simulation type: 1(NLD),2(DISA),3(R4F),3.5(R5F),4(MIPS),5(FORTEC3D)
% calculation type: 'scan', 'test' 
% data#, time(0:time series), traj#(if t/=0)
%
arguments
    sim;
    cal;
    data_n;
    t;
    c_num=1;
    c_num2=1;
end

oldpath = path;
path('../com',oldpath);
f_path='path.txt';
%
switch sim
    case {'NLD', 'nld'}
        FVER=1;
        oldpath=addpath('../sim_data/nld','../sim_data/nld/hibp');
        dataC=nldClass(f_path,data_n);
    case {'DISA', 'disa'}
        FVER=2;
        dataC=disaClass(f_path,data_n);
    case {'R4F', 'r4f'}
        FVER=3;
        oldpath=addpath('../sim_data/r4f');
        dataC=r4fClass(f_path,data_n);
    case {'R5F', 'r5f'}
        FVER=3.5;
        oldpath=addpath('../sim_data/r5f','../sim_data/task_eq');
        dataC=hibpClass_r5f(f_path,data_n);
    case {'MIPS', 'mips'}
        FVER=4;
        oldpath=addpath('../sim_data/mips','../sim_data/mips/hibp');
        dataC=hibpClass_mips(f_path,data_n);
    case {'FORTEC', 'fortec'}
        FVER=5;
        oldpath=addpath('../sim_data/fortec','../sim_data/magLHD');
        dataC=hibpClass_fortec(f_path,data_n);
        t=1;%[no time slice]
    otherwise
        error('Unexpected simulation type.')
end
%
% set beam probe condition
f_condition='condition.txt';
fread_condition(dataC,f_condition);
dataC.ion_p=dataC.tracemax*dataC.trace_n;
%vini=sqrt(dataC.in_ene/dataC.mass)*13.8; %[m/microsec]
%
% parameters
fread_param2(dataC);
if(FVER ~= dataC.FVER)
    error('Simulation type mismatch.')
end
%
% equilibrium
fread_EQ1(dataC);
dataC
%
if t == 0
    search_trajectory_ts(dataC);
else
switch cal
    case {'scan'}
%    search_trajectory_rho(dataC,t,c_num);
%    search_trajectory_scan0(dataC,t);
    search_trajectory_scan(dataC,t,c_num,c_num2);
    case {'test'}
    search_trajectory_test(dataC,t);
    otherwise
        error('Unexpected calculation type.')
end
%
path(oldpath)
end

