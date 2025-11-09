% plot a profile of (m,n) mode at time t
function mode_structure2(sim,data_n,t,m,n)
% simulation type: 1(NLD),2(DISA),3(R4F),4(R5F)
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
str2=sprintf('%smode_out.mat',dataC.outdir)
R=dataC.R;
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
tt=tt+1;
end
end
ttn=tt-1;
data_mode=zeros(dataC.IRMAX+1,5,ttn);
tt=1;
for b=1:dataC.COUNT
if (dataC.TIME(b)>=TCS & dataC.TIME(b)<=TCE & mod(dataC.TIME(b),TIN)==0)
t=dataC.TIME(b)/100;
timep(tt)=t;
str=sprintf('%s%08d.dat',dataC.indir,dataC.TIME(b))
p2=fread_data_1(5,dataC,str,m,n);
plot_mode_structure(dataC,p2,m,n)
data_mode(:,:,tt)=p2;
tt=tt+1;
end
drawnow
end
save(str2,'tt','timep','R','data_mode');
%
else
str=sprintf('%s%08d.dat',dataC.indir,t*100);
p0=fread_data_1(5,dataC,str,0,0);
p2=fread_data_1(5,dataC,str,m,n);
clf;
plot_mode_structure(dataC,p2,m,n)
pause
%plot_mode_flux(dataC,p0,p2,m,n)
data_flux=plot_mode_3flux(dataC,p0,p2,m,n);
save(str2,'R','data_flux');
end
%
path(oldpath);
end