% plot a time evolution of any profile
function [pout,R,Z]=probe_multi(sim,data_n,t,num1,x1,var)
% simulation type: 5(GENE)
% data#, time, probe#, positions
% var(1:potential,2:A,3:v,4:n,5:Te)
%
oldpath=path;
path('../com',oldpath);
f_path='path.txt';
%
switch sim
    case {'GENE', 'gene'}
        FVER=5;
        dataC=GENEClass(f_path,data_n);
    otherwise
        error('Unexpected simulation type.')
end
%
%Generate time data (00****.dat) from TORUSIons_act.dat
GENEdata = sprintf('%sTORUSIons_act_%.0f.dat', dataC.indir, t*100);
generate_timedata(dataC,GENEdata,t);

% parameters
fread_param2(dataC);
%
if(FVER ~= dataC.FVER)
         error('Simulation type mismatch (PARAM).')
end  
%
fread_EQ1(dataC);
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
p2=fread_data_s(5,dataC,str);
p3=squeeze(p2(:,:,:,var));
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
R=zeros(num1,1);
Z=zeros(num1,1);
str=sprintf('%s%08d.dat',dataC.indir,t*100)
%str=sprintf('%s%08d.mat',dataC.indir,t*100)
%str=sprintf('%sdata.dat',dataC.indir)

p2=fread_data_s(5,dataC,str);
p2_s=zeros(dataC.LYM2/(dataC.KZMt+1), dataC.nx0+1, dataC.KZMt+1);
size(p2)
length(p2)
for i = 1:dataC.KZMt+1
    p2_s(:,:,i)=[p2(:,:,i),zeros(length(p2),1,1)];
end

data2=zeros(dataC.LYM2/(dataC.KZMt+1), dataC.nx0+1+dataC.inside+dataC.outside,dataC.KZMt+1);
data2(:,dataC.inside+1:end-dataC.outside,:) = p2_s;

data3=zeros(size(data2,1),size(data2,2),size(data2,3));
for i = 1:dataC.NTGMAX
    md = mod(i+(dataC.NTGMAX/2),dataC.NTGMAX);
    data3(md+1,:,:) = data2(i,:,:);
end
data3 = [data3; data3(1,:,:)];

%Constant for Understanding the Progress of Calculation
separation = 0
loc=zeros(num1,1);
nonloc=zeros(num1,1);

for a=1:num1
    pout(a)=probeEQ_local_s(dataC,x1(a,1),x1(a,2),x1(a,3),data3);
    R(a) = x1(a,1);
    Z(a) = x1(a,2);
    s = a/num1*100;
    if s > separation
       now = fix(s)
       separation = separation + 1;
    end
    if pout(a)~=0
        loc(a)=probeEQ_rho(dataC,x1(a,1),x1(a,2),x1(a,3));
        nonloc(a)=NaN;
    else 
        loc(a)=NaN;
        nonloc(a)=probeEQ_rho(dataC,x1(a,1),x1(a,2),x1(a,3));
    end
end

figure(2)
plot(pout);
figure(22)
plot(loc,".b")
hold on
plot(nonloc,".r")
hold off
ylim([0,1])
xlabel('beam path')
ylabel('ρ')
minmax = sprintf('ρ_{min} = %.2f , ρ_{max} = %.2f',min(loc, [], 'omitnan'), max(loc, [], 'omitnan'));
title(minmax);
legend("With fluctuation","Without fluctuation",'Location', 'Best')

end
%
end
