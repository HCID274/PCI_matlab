% read plasma variables from Fourier decomposition
function fread_EQ1(obj)
%
num1=obj.num1;
num2=obj.num2;
num3=obj.num3;
%
data2=zeros(num1*num2*num3,1);
str=sprintf('%s/strow2D_FORTEC2_EQ_%04d_%04d_%04d_%08.4f_%08.4f.dat' ...
    ,obj.indir,num1,num2,num3,obj.phi_s,obj.phi_e)
fid=fopen(str,'r',obj.endian);
obj.theta_si=fread(fid,num2,'float');
obj.phi_si=fread(fid,num3,'float');
data2=fread(fid,num1*num2*num3,'float');
obj.R=reshape(data2,num2,num3,num1);
data2=fread(fid,num1*num2*num3,'float');
obj.phi=reshape(data2,num2,num3,num1);
data2=fread(fid,num1*num2*num3,'float');
obj.z=reshape(data2,num2,num3,num1);
data2=fread(fid,num1*num2*num3,'float');
obj.radius=reshape(data2,num2,num3,num1);
obj.Rax=fread(fid,num3,'float');
obj.zax=fread(fid,num3,'float');
data2=fread(fid,num1*num2*num3,'float');
obj.Bx3=reshape(data2,num2,num3,num1);
data2=fread(fid,num1*num2*num3,'float');
obj.By3=reshape(data2,num2,num3,num1);
data2=fread(fid,num1*num2*num3,'float');
obj.Bz3=reshape(data2,num2,num3,num1);
data2=fread(fid,num1*num2*num3,'float');
obj.rho=reshape(data2,num2,num3,num1);
fclose(fid);
obj.BF=zeros(num2,num3,num1,3);
obj.BF(:,:,:,1)=obj.Bx3;
obj.BF(:,:,:,2)=obj.Bz3;
obj.BF(:,:,:,3)=obj.By3;
%
r=obj.rho;
obj.EQ_poten=108.7+6180.8*r.^2-3951.6*r.^4+2209.2*r.^6-(4547.1);%[V]
obj.EQ_NE= 1.238 - 0.18816*r.^2 -0.36092*r.^4 + 4.1859*r.^6 - 4.2331*r.^8;%[10^19m^-3]
obj.EQ_TE= 3.633 - 2.6128*r.^2 + 0.10186*r.^4 - 0.56081*r.^6;%[keV]
%obj.EQ_TE=0.2*ones(num2,num3,num1);%[keV]
%
obj.PA=[obj.Rax(1,1),obj.zax(1,1)];
%
end