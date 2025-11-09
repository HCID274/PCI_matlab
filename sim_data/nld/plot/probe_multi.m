% plot a time evolution of poloidal profile
function probe_multi(sim,data_n,t,num1,x1,var)
% simulation type: 1(NLD)
% data#, time, probe#, positions
% var(1:potential,2:v,3:n)
%
oldpath=path;
path('../com',oldpath);
f_path='path.txt';
%
switch sim
    case {'NLD', 'nld'}
        FVER=1.0;
        dataC=nldClass(f_path,data_n);
    otherwise
        error('Unexpected simulation type.')
end
%
% parameters
fread_param2(dataC);
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
tt=tt+1;
end
end
tnum=tt-1;
pout=zeros(tnum,num1);
%
for b=1:tnum
str=sprintf('%s%08d.dat',dataC.indir,timep(b)*100)
p2=fread_data_s(3,dataC,str);
p3=squeeze(p2(:,:,var));
for a=1:num1
pout(b,a)=probeEQ_local_s(dataC,x1(a,1),x1(a,2),x1(a,3),p3);
end
end
%
t=timep;
y=[1:num1];
[tt,yy]=meshgrid(t,y);
contourf(tt,yy,pout.',30,'LineStyle','none');
shading flat;
title('probe');
xlabel('t');
ylabel('position');
axis tight
colorbar
%
str=sprintf('%sprobe_%03d_%08d.dat',dataC.outdir,data_n,num1)
save(str,'timep','num1','x1','pout');
%
else
pout=zeros(num1,1);
str=sprintf('%s%08d.dat',dataC.indir,t*100)
p2=fread_data_s(3,dataC,str);
p3=squeeze(p2(:,:,var));
for a=1:num1
    pout(a)=probeEQ_local_s(dataC,x1(a,1),x1(a,2),x1(a,3),p3);
end
plot(pout);
end
%
end
