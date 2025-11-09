% plot contour
function cont(sim,data_n,ax,t,extr)
% simulation type: 3.6(R6F)
% data#, axial position, time, mode extract(0:OFF, 1:ON)
%
oldpath=path;
path('../com',oldpath);
f_path='path.txt';
%
switch sim
    case {'R6F', 'r6f'}
        FVER=3.6;
        dataC=r6fClass(f_path,data_n);
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
str=sprintf('%s%08d.dat',dataC.indir,dataC.TIME(b))
if extr == 1
    if tt==1
    m=input('m = ');
    n=input('n = ');
    Lm=find(dataC.LKY==m);
    Ln=find(dataC.LKZ==n);
    if (size(Lm,1)==0 || size(Ln,1)==0)
        return
    end
    end
    cont_data_1(dataC,str,ax,m,n);
    tt=tt+1;
else
    cont_data_s(dataC,str,ax);
end
drawnow
end
end
%
else
str=sprintf('%s%08d.dat',dataC.indir,t*100);
if extr == 1
    while 1
    m=input('m = ');
    n=input('n = ');
    Lm=find(dataC.LKY==m);
    Ln=find(dataC.LKZ==n);
    if (size(Lm,1)==0 || size(Ln,1)==0)
        return
    end
    cont_data_1(dataC,str,ax,m,n);
    end
else
    cont_data_s(dataC,str,ax);
end
end
%
end
