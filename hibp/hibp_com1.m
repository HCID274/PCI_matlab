% plot trajectory of HIBP
function hibp_com1(sim,data_n,t)
% simulation type: 1(NLD),2(DISA),3(R4F),3.5(R5F),4(MIPS),5(FORTEC3D)
% data#, time(0:time series)
%
oldpath=path;
path('../com',oldpath);
f_path='path.txt';
%
switch sim
    case {'NLD', 'nld'}
        FVER=1;
        oldpath=addpath('../sim_data/nld','../sim_data/nld/hibp');
        dataC=nldClass(f_path,data_n);
    case {'DISA', 'disa'}
        FVER=2;
        dataC=disaClass(f_path,data_n);
    case {'R4F', 'r4f'}
        FVER=3;
        dataC=r4fClass(f_path,data_n);
    case {'R5F', 'r5f'}
        FVER=3.5;
        dataC=r5fClass(f_path,data_n);
    case {'MIPS', 'mips'}
        FVER=4;
        oldpath=addpath('../sim_data/mips','../sim_data/mips/hibp');
        dataC=hibpClass_mips(f_path,data_n);
    case {'FORTEC', 'fortec'}
        FVER=5;
        dataC=fortecClass(f_path,data_n);
    otherwise
        error('Unexpected simulation type.')
end
%global TIME COUNT TS TE
%
%
% set beam probe condition
f_condition='condition.txt';
fread_condition(dataC,f_condition);
dataC.ion_p=dataC.tracemax*0.3;
vini=sqrt(dataC.in_ene/dataC.mass)*13.8; %[m/microsec]
%
% parameters
fread_param2(dataC);
if(FVER ~= fix(dataC.FVER))
         error('Simulation type mismatch.')
end  
% equilibrium
fread_EQ1(dataC);
% plasma
fread_plasma1(dataC,t);
%
% plot plasma contour 
plot_plasma1(dataC,0.0);
%
% search the trajectry 
x0=zeros(6,1);
%x0(1)=(dataC.RG1(1)+dataC.RG1(2))/2;
x0(1)=dataC.in_pos(1);
x0(4)=-vini*sin(dataC.in_ang1)*cos(dataC.in_ang2);
x0(2)=dataC.in_pos(2);
x0(5)=vini*sin(dataC.in_ang2)/x0(1);
%x0(3)=dataC.RG2(1);
x0(3)=dataC.in_pos(3);
x0(6)=-vini*cos(dataC.in_ang1)*cos(dataC.in_ang2);
%
for aa=1:20
x0(4)=-vini*sin(dataC.in_ang1)*cos(dataC.in_ang2);
x0(5)=vini*sin(dataC.in_ang2)/x0(1);
x0(6)=-vini*cos(dataC.in_ang1)*cos(dataC.in_ang2);
[x,y,z,v,bp,inten]=hibp_inj(dataC,x0,dataC.out_pos,dataC.tracemax,dataC.ion_p);
n1=fix(dataC.ion_p);
hold on
plot(sqrt(x(n1).^2+y(n1).^2),z(n1),'ro');
plot(sqrt(x(1:bp).^2+y(1:bp).^2),z(1:bp))
axis equal
drawnow
hold off
%sqrt(x(bp)^2+y(bp)^2)
Zcal=z(bp)-dataC.out_pos(3);
Fcal=atan2(y(bp),x(bp))-dataC.out_pos(2);
%0.5*(v(bp)^2-v(1)^2)*dataC.mass/9.58*1.0e5
%
[x,y,z,v,bp,inten]=hibp_inj(dataC,x0,dataC.out_pos,dataC.tracemax,dataC.ion_p+dataC.dti);
%sqrt(x(bp)^2+y(bp)^2)
Zcal_t=(z(bp)-dataC.out_pos(3)-Zcal)/dataC.dti;
Fcal_t=(atan2(y(bp),x(bp))-dataC.out_pos(2)-Fcal)/dataC.dti;
%
x0(4)=-vini*sin(dataC.in_ang1)*cos(dataC.in_ang2+dataC.dang);
x0(5)=vini*sin(dataC.in_ang2+dataC.dang)/x0(1);
x0(6)=-vini*cos(dataC.in_ang1)*cos(dataC.in_ang2+dataC.dang);
[x,y,z,v,bp,inten]=hibp_inj(dataC,x0,dataC.out_pos,dataC.tracemax,dataC.ion_p);
%sqrt(x(bp)^2+y(bp)^2)
Zcal_a=(z(bp)-dataC.out_pos(3)-Zcal)/dataC.dang;
Fcal_a=(atan2(y(bp),x(bp))-dataC.out_pos(2)-Fcal)/dataC.dang;
%
ZF=[Fcal_t -Zcal_t; -Fcal_a Zcal_a]/(Zcal_a*Fcal_t-Zcal_t*Fcal_a);
da=ZF*[Zcal; Fcal]
%
dataC.in_ang2=dataC.in_ang2-da(1);
dataC.ion_p=dataC.ion_p-da(2);
if ((abs(da(1)) < dataC.da1_min) && (abs(da(2)) < dataC.da2_min))
    break
end
end
0.5*(v(bp)^2-v(1)^2)*dataC.mass/9.58*1.0e5
pause
%
% solution with fine spatial resolution
dataC.tracemax=dataC.tracemax*10;
dataC.ion_p=dataC.ion_p*10;
%
x0=zeros(6,1);
%x0(1)=(dataC.RG1(1)+dataC.RG1(2))/2;
x0(1)=dataC.in_pos(1);
x0(4)=-vini*sin(dataC.in_ang1)*cos(dataC.in_ang2);
x0(2)=dataC.in_pos(2);
x0(5)=vini*sin(dataC.in_ang2)/x0(1);
%x0(3)=dataC.RG2(1);
x0(3)=dataC.in_pos(3);
x0(6)=-vini*cos(dataC.in_ang1)*cos(dataC.in_ang2);
%
[x,y,z,v,bp,inten]=hibp_inj(dataC,x0,dataC.out_pos,dataC.tracemax,dataC.ion_p);
n1=fix(dataC.ion_p);
%
0.5*(v(bp)^2-v(1)^2)*dataC.mass/9.58*1.0e5
%0.5*(v(bp)^2-v(1)^2)*dataC.mass/9.58*1.0e5/dataC.Te
%
% plot the final result
if 1==1
plot_plasma1(dataC,0.0)
hold on
plot(sqrt(x(n1).^2+y(n1).^2),z(n1),'ro');
plot(sqrt(x(1:bp).^2+y(1:bp).^2),z(1:bp))
axis equal
hold off
pause
plot_traj(dataC,x,y,z,bp,n1)
end
%
% data output
str=sprintf('%s/trace_%08.4f.mat',dataC.indir,dataC.in_ang1);
xout=x(1:bp);
yout=y(1:bp);
zout=z(1:bp);
vout=v(1:bp);
save(str,'bp','n1','xout','yout','zout','vout');
%
path(oldpath);
end
