% plot energy spectrum
function spectrum(sim,data_n,t)
% simulation type: 3.5(R5F)
% data#, time
%
oldpath=path;
path('../com',oldpath);
f_path='path.txt';
%
switch sim
    case {'R5F', 'r5f'}
        FVER=3.5;
        dataC=r5fClass(f_path,data_n);
        fnum=5;
    otherwise
        error('Unexpected simulation type.')
end
%
% parameters
fread_param2(dataC);
dataC

if(FVER ~= dataC.FVER)
         error('Simulation type mismatch (PARAM).')
end  
clf;
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
if (dataC.TIME(b)>=TCS && dataC.TIME(b)<=TCE && mod(dataC.TIME(b),TIN)==0)
t=dataC.TIME(b)/100;
timep(tt)=t;
str=sprintf('%s%08d.dat',dataC.indir,dataC.TIME(b))
p2=fread_data_s(fnum,dataC,str);
plot_spectrum(dataC,p2,4);
drawnow
end
end
%
else
str=sprintf('%s%08d.dat',dataC.indir,t*100);
p2=fread_data_s(fnum,dataC,str);
%plot_spectrum(dataC,p2,5);
%plot_spectrum_d(dataC,p2,1);
plot_spectrum_d(dataC,p2,4);
pause
plot_spectrum_d_HT(dataC,p2);
end
%
end
