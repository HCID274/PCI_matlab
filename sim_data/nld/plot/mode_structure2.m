% plot a profile of (m,n) mode at time t
function mode_structure2(sim,data_n,t,m,n)
% simulation type: 1(NLD),2(DISA),3(R4F)
% data#, time(0:time series), mode#
%
oldpath=path;
path('../com',oldpath);
f_path='path.txt';
%
switch sim
    case {'NLD', 'nld'}
        FVER=1;
        dataC=nldClass(f_path,data_n);
    otherwise
        error('Unexpected simulation type.')
end
%
% parameters
fread_param2(dataC);
if(FVER ~= fix(dataC.FVER))
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
%fread_data(dataC,str,m,n);
p2=fread_data_1(3,dataC,str,m,n);
plot_mode_structure(dataC,p2,m,n)
%fread_data_NLcov2(dataC,str,m,n);
tt=tt+1;
drawnow
end
end
%
else
str=sprintf('%s%08d.dat',dataC.indir,t*100);
%fread_data(dataC,str,m,n);
p2=fread_data_1(3,dataC,str,m,n);
plot_mode_structure(dataC,p2,m,n)
end
%
end