% plot a profile of flux at time t
function flux_profile(sim,data_n,t,sum)
% simulation type: 3.6(R6F)
% data#, time(0:time series), mode extract(0:OFF, 1:ON)
%
oldpath=path;
path('../com',oldpath);
f_path='path.txt';
%
switch sim
    case {'R6F', 'r6f'}
        FVER=3.6;
        dataC=r6fClass(f_path,data_n);
        fnum=6;
    otherwise
        error('Unexpected simulation type.')
end
%
% parameters
fread_param2(dataC);
if(FVER ~= dataC.FVER)
         error('Simulation type mismatch 2.')
end
str2=sprintf('%sflux_out.mat',dataC.outdir)
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
data_flux=zeros(obj.IRMAX+1,4,ttn);
tt=1;
if sum == 1
    m=input('m = ');
    n=input('n = ');
end    
%
for b=1:dataC.COUNT
if (dataC.TIME(b)>=TCS & dataC.TIME(b)<=TCE & mod(dataC.TIME(b),TIN)==0)
t=dataC.TIME(b)/100;
timep(tt)=t;
str=sprintf('%s%08d.dat',dataC.indir,dataC.TIME(b))
p0=fread_data_1(fnum,dataC,str,0,0);
if sum == 1
p2=fread_data_1(fnum,dataC,str,m,n);
data_flux(:,:,tt)=plot_mode_3flux(dataC,p0,p2,m,n);
else
p1=fread_data_s(fnum,dataC,str);
data_flux(:,:,tt)=plot_flux_profile(dataC,p0,p1);
end
tt=tt+1;
end
drawnow
end
save(str2,'tt','timep','R','data_flux');
%
else
str=sprintf('%s%08d.dat',dataC.indir,t*100);
p0=fread_data_1(fnum,dataC,str,0,0);
if sum == 1
while 1
    m=input('m = ');
    n=input('n = ');
    if n < 0
        break;
    end
p2=fread_data_1(fnum,dataC,str,m,n);
clf;
data_flux=plot_mode_3flux(dataC,p0,p2,m,n);
save(str2,'R','data_flux');
end
else
p1=fread_data_s(fnum,dataC,str);
[data_flux,datac_total]=plot_flux_profile(dataC,p0,p1);
save(str2,'R','data_flux');
LKY=dataC.LKY;
LKZ=dataC.LKZ;
str3=sprintf('%sflux_mn_out.mat',dataC.outdir)
save(str3,'R','LKY','LKZ','datac_total');
str4=sprintf('%smodeamp_mn_out.mat',dataC.outdir)
save(str4,'R','LKY','LKZ','p1');
end

end
%
path(oldpath);
end