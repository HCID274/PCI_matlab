% read plasma variables from Fourier decomposition
function fread_plasma1(obj,t)
%
num1=obj.num1;
num2=obj.num2;
num3=obj.num3;
%
%norm_poten=0.2e3;%[keV]
norm_poten=4e3;%[eV]
norm_NE=1.0;%[10^19m-3]
%
data2=zeros(num1*num2*num3,1);
str=sprintf('%s/strow2D_FORTEC2_PL_%04d_%04d_%04d_%08.4f_%08.4f.dat' ...
    ,obj.indir,num1,num2,num3,obj.phi_s,obj.phi_e)
fid=fopen(str,'r',obj.endian);
data2=fread(fid,num1*num2*num3,'float');%real unit
obj.PLASMA_PHI=reshape(data2,num2,num3,num1);%*norm_poten;
fclose(fid);
obj.PLASMA_PHI(:,:,1)=0.0;
obj.PLASMA_PHI=obj.PLASMA_PHI*1.0;
%
obj.PLASMA_PHI_total=(obj.EQ_poten*1.0+obj.PLASMA_PHI*1.0)*1.0;%[V]
%obj.PLASMA_PHI_total(:,:,end)=obj.PLASMA_PHI_total(:,:,end-1);
%obj.PLASMA_PHI_total(:,:,end-1)=obj.PLASMA_PHI_total(:,:,end-2);
%
% density
obj.PLASMA_NE=obj.PLASMA_PHI/norm_poten*norm_NE;
obj.PLASMA_NE_total=(obj.EQ_NE+obj.PLASMA_NE)*1e19;%[m^-3]
%
% temperature
obj.PLASMA_TE=zeros(num2,num3,num1);
obj.PLASMA_TE_total=(obj.EQ_TE+obj.PLASMA_TE)*1e3;%[eV]
%plot_plasma1(obj,0);
%
set_EFspl(obj);
if 1==0
R0=3.7;
PHI0=0.0;
Z0=0.4;
[ER1,EZ1,ET1]=probeEQ_ef1(obj,R0,Z0,PHI0);
[ER2,EZ2,ET2]=probeEQ_ef2(obj,R0,Z0,PHI0);
[ER1,EZ1,ET1,sqrt(ER1^2+EZ1^2+(R0*ET1)^2);ER2,EZ2,ET2,sqrt(ER2^2+EZ2^2+(R0*ET2)^2)]
R0=3.8;
PHI0=0.1;
Z0=0.4;
[ER1,EZ1,ET1]=probeEQ_ef1(obj,R0,Z0,PHI0);
[ER2,EZ2,ET2]=probeEQ_ef2(obj,R0,Z0,PHI0);
[ER1,EZ1,ET1,sqrt(ER1^2+EZ1^2+(R0*ET1)^2);ER2,EZ2,ET2,sqrt(ER2^2+EZ2^2+(R0*ET2)^2)]
R0=3.9;
PHI0=0.0;
Z0=-1.2;
[ER1,EZ1,ET1]=probeEQ_ef1(obj,R0,Z0,PHI0);
[ER2,EZ2,ET2]=probeEQ_ef2(obj,R0,Z0,PHI0);
[ER1,EZ1,ET1,sqrt(ER1^2+EZ1^2+(R0*ET1)^2);ER2,EZ2,ET2,sqrt(ER2^2+EZ2^2+(R0*ET2)^2)]
pause
end
%
data_convert1(obj)%fine mesh
data_convert(obj)%extended mesh
end