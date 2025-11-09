% plot a time evolution of poloidal profile
function probe_poloidal(sim,data_n,r0,ax0,t,var)
% simulation type: 1(NLD)
% radius(0:1), axial/2pi(0:1), time
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
num=64;
theta=2.0/num*([0:num-1].')-1.0;


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
p2=fread_data_s(3,dataC,str);
p3=squeeze(p2(:,:,var));
for a=1:num
pout(tt,a)=probeEQ_local_s(obj,r0,theta(a),ax0,p3);
end
tt=tt+1;
end
end
%
contourf
plot_spectrum(dataC,p2,4);
drawnow
%
else
pout=zeros(num,1);
str=sprintf('%s%08d.dat',dataC.indir,t*100);
p2=fread_data_s(3,dataC,str);
p3=squeeze(p2(:,:,var));
for a=1:num
pout(a)=probeEQ_local_s(obj,r0,theta(a),ax0,p3);
end
plot(theta,pout);








pout=probe_1(str,num,var);
fprintf(fid1,'%f',t);
fprintf(fid1,'\t%f',pout);
fprintf(fid1,'\t%f',pout(1));
fprintf(fid1,'\n');
tt=tt+1;
end
end
%
else
str=sprintf('%s%08d.dat',dir,t*100)
pout=probe_1(str,num,var);
fprintf(fid1,'%f',t);
fprintf(fid1,'\t%f',pout);
fprintf(fid1,'\t%f',pout(1));
fprintf(fid1,'\n');
end
fclose(fid1);
%toc
end