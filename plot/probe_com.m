% values at the specified positions
function probe_com(sim,data_n,t,var)
% simulation type: 1(NLD),2(DISA),3(R4F),3.5(R5F)
% data#, time(0:time series), var
% using the condition file 'probe_condition.txt'
%
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
    otherwise
        error('Unexpected simulation type.')
end
f_condition='./probe_condition.txt';
pp=fread_probe_condition(f_condition);
num=zeros(3,1);
for a=1:3
num(a)=pp(a,1);
end
x=zeros(max(num),3);
for a=1:3
x_min=pp(a,2);
x_max=pp(a,3);
x(1,a)=x_min;
if num(a) > 1
    dd=(x_max-x_min)/(num(a)-1);
    for b=2:num(a)
        x(b,a)=x_min+dd*(b-1);
    end
end
end
%
num1=pp(1,1)*pp(2,1)*pp(3,1);
x1=zeros(num1,3);
for a=1:num(1)
    for b=1:num(2)
        for c=1:num(3)
            x1(a+(b-1)*num(1)+(c-1)*num(1)*num(2),1)=x(a,1);
            x1(a+(b-1)*num(1)+(c-1)*num(1)*num(2),2)=x(b,2);
            x1(a+(b-1)*num(1)+(c-1)*num(1)*num(2),3)=x(c,3);
        end
    end
end
probe_multi(sim,data_n,t,num1,x1,var);
%
path(oldpath);
end
