% plot a profile of (m,n) mode at time t
function mode_structure2(sim,data_n,t,m,n)
% simulation type: 1(NLD),2(DISA),3(R4F),3.5(R5F)
% data#, time(0:time series), mode#
%
oldpath=path;
path('../com',oldpath);
f_path='path.txt';
%
switch sim
    case {'R5F', 'r5f'}
        FVER=3.5;
        dataC=r5fClass(f_path,data_n);
    otherwise
        error('Unexpected simulation type.')
end
%
% parameters
fread_param2(dataC);
if(FVER ~= dataC.FVER)
         error('Simulation type mismatch 2.')
end  
%
% time series
if t == 0
fread_ptprflist(dataC);
%
tt=1;
TCS=input('from = ');
TCE=input('to = ');
TIN=input('interval = ');
TCS=TCS*100;
TCE=TCE*100;
TIN=TIN*100;
for b=1:dataC.COUNT
if (dataC.TIME(b)>=TCS & dataC.TIME(b)<=TCE & mod(dataC.TIME(b),TIN)==0)
t=dataC.TIME(b)/100;
timep(tt)=t;
str=sprintf('%s%08d.dat',dataC.indir,dataC.TIME(b))
fread_data(dataC,str,m,n);
%fread_data_phi(dataC,str,m,n);
%fread_data_NLcov2(dataC,str,m,n);
end
drawnow
end
%
else
str=sprintf('%s%08d.dat',dataC.indir,t*100);
fread_data(dataC,str,m,n);
%fread_data_phi(dataC,str,m,n);
%fread_data_NLcov2(dataC,str,m,n);
end
%
end