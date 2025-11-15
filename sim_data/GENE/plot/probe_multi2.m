% plot a time evolution of any profile
function [pout,R,Z]=probe_multi2(sim,data_n,t,num1,x1,var,p1)
% simulation type: 5(GENE)
% data#, time, probe#, positions
% var(1:potential,2:A,3:v,4:n,5:Te)
%
oldpath=path;
path('../com',oldpath);
f_path='path_matlab.txt';
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
GENEdata = sprintf('%sTORUSIons_act_%d.dat', dataC.indir, round(t*100));
generate_timedata(dataC,GENEdata,t);
% parameters
fread_param2(dataC);
%
if(FVER ~= dataC.FVER)
         error('Simulation type mismatch (PARAM).')
end  
%
fread_EQ1(dataC);
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
str=sprintf('%s%08d.dat',dataC.indir,round(t*100))

p2=fread_data_s(5,dataC,str);
p2_s=zeros(dataC.LYM2/(dataC.KZMt+1), dataC.nx0+1, dataC.KZMt+1+1);

for i = 1:dataC.KZMt+1
    p2_s(:,:,i)=[p2(:,:,i),zeros(length(p2),1,1)];
end
p2_s(:,:,end) = p2_s(:,:,1);

data2=zeros(dataC.LYM2/(dataC.KZMt+1), dataC.nx0+1+dataC.inside+dataC.outside,dataC.KZMt+1+1);

% overall
data2(:,dataC.inside+1:end-dataC.outside,:) = p2_s;

% inside (strong) only
%data2(1:100,dataC.inside+1:end-dataC.outside,:) = p2_s(1:100,:,:);
%data2(301:400,dataC.inside+1:end-dataC.outside,:) = p2_s(301:400,:,:);

% outside (weak) only
%data2(100:300,dataC.inside+1:end-dataC.outside,:) = p2_s(100:300,:,:);

data3=zeros(size(data2,1),size(data2,2),size(data2,3));
for i = 1:dataC.NTGMAX
    md = mod(i+(dataC.NTGMAX/2),dataC.NTGMAX);
    data3(md+1,:,:) = data2(i,:,:);
end
data3 = [data3; data3(1,:,:)];

processed_density_field_ml = data3;
save('processed_density_field_ml.mat', 'processed_density_field_ml', '-v7');

loc=zeros(num1,1);
nonloc=zeros(num1,1);
xx = NaN(num1,1);
yy = NaN(num1,1);
ang = NaN(num1,1);
ang2 = NaN(num1,1);
non_xx = NaN(num1,1);
non_yy = NaN(num1,1);
non_ang = NaN(num1,1);
non_ang2 = NaN(num1,1);

% Lx, Ly and Lz are beam vectors
Lx = [-p1(2)/p1(1); 1; 0]/((-p1(2)/p1(1))^2+1)^(1/2);
Ly = [p1(1)/p1(2); 1; -(p1(1)^2+p1(2)^2)/(p1(2)*p1(3))]/((p1(1)/p1(2))^2+1+(-(p1(1)^2+p1(2)^2)/(p1(2)*p1(3)))^2)^(1/2);
Lz = p1/(p1(1)^2+p1(2)^2+p1(3)^2)^(1/2);
%
for a=1:num1
    pout(a)=probeEQ_local_s(dataC,x1(a,1),x1(a,2),x1(a,3),data3);
    R(a) = x1(a,1);
    Z(a) = x1(a,2);
    %
    if pout(a)~=0
        loc(a)=probeEQ_rho(dataC,x1(a,1),x1(a,2),x1(a,3));
        nonloc(a)=NaN;
        [xx(end-a+1), yy(end-a+1), ang(end-a+1), ang2(end-a+1)] = LSmag2(dataC,x1(a,1),x1(a,2),x1(a,3),Lx,Ly,Lz);
    else 
        loc(a)=NaN;
        nonloc(a)=probeEQ_rho(dataC,x1(a,1),x1(a,2),x1(a,3));
        [non_xx(end-a+1), non_yy(end-a+1), non_ang(end-a+1), non_ang2(end-a+1)] = LSmag2(dataC,x1(a,1),x1(a,2),x1(a,3),Lx,Ly,Lz);
    end
end

figure(2)
plot(abs(pout));
%
figure(21)
plot(loc,".b")
hold on
plot(nonloc,".r")
hold off
ylim([0,1])
xlabel('beam path')
ylabel('ρ')
minmax = sprintf('ρ_{min} = %.2f , ρ_{max} = %.2f',min(loc), max(loc));
title(minmax);
legend("With fluctuation","Without fluctuation",'Location', 'Best')
%
figure(301)
plot(yy,".b")
hold on
plot(non_yy,".r")
hold off 
xlabel('beam path')
ylabel('By')
legend("With fluctuation","Without fluctuation",'Location', 'Best')

figure(302)
plot(xx,".b")
hold on
plot(non_xx,".r")
hold off 
xlabel('beam path')
ylabel('Bx')
legend("With fluctuation","Without fluctuation",'Location', 'Best')

figure(303)
plot(ang,".b")
hold on
plot(non_ang,".r")
hold off 
xlabel('beam path')
ylabel('theta')
legend("With fluctuation","Without fluctuation",'Location', 'Best')

figure(304)
plot(ang2,".b")
hold on
plot(non_ang2,".r")
hold off 
xlabel('beam path')
ylabel('theta cutout')
legend("With fluctuation","Without fluctuation",'Location', 'Best')
%
end
%
end