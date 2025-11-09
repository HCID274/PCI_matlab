function fread_VMEC_FORTEC(obj,f_VMEC)
%
num1=obj.num1;
num2=obj.num2;
num3=obj.num3;

%
data2=zeros(num1*num2*num3,1);
str=sprintf('%s%s_%04d_%04d_%04d_%08.4f_%08.4f.dat' ...
    ,obj.indir,f_VMEC,num1,num2,num3,obj.phi_s,obj.phi_e)
%str=sprintf('%s/strow2D_FORTEC2_%04d_%04d_%04d_%08.4f_%08.4f.dat' ...
%    ,obj.indir,num1,num2,num3,obj.phi_s,obj.phi_e)
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
%
for i=1:num3
   obj.R(:,i,1)=obj.Rax(i,1);
   obj.z(:,i,1)=obj.zax(i,1);
end
%
obj.phi(:,:,1)=obj.phi(:,:,2);
obj.phi(:,1,:)=0.0;
%
%
for l=1:num2
for i=1:num2
    obj.Bx3(i,l,1)=mean(obj.Bx3(:,l,2));
    obj.By3(i,l,1)=mean(obj.By3(:,l,2));
    obj.Bz3(i,l,1)=mean(obj.Bz3(:,l,2));
end
end
%
data1=zeros(num2,num2,num1);
data2=zeros(num2,num2,num1);
obj.BF=zeros(num2,num3,num1,3);
obj.BF(:,:,:,2)=obj.Bz3;
obj.BF(:,:,1,2)=0.0;
%
for i=1:num2
data1(:,i,:)=obj.Bx3(:,i,:)*cos(obj.phi_si(i))+obj.By3(:,i,:)*sin(obj.phi_si(i));
data2(:,i,:)=-obj.Bx3(:,i,:)*sin(obj.phi_si(i))+obj.By3(:,i,:)*cos(obj.phi_si(i));
end
obj.BF(:,1:num2,:,1)=data1;
obj.BF(:,num2:end,:,1)=data1;
obj.BF(:,1:num2,:,3)=data2;
obj.BF(:,num2:end,:,3)=data2;
obj.BF=-obj.BF; %B inversion when HIBP measurement
%

%
obj.rho(:,:,1)=0.0;
r=obj.rho;
%
%Fujita_PRF(2019)___________________________________________________________
obj.EQ_poten=108.7+6180.8*r.^2-3951.6*r.^4+2209.2*r.^6-4547.1;%[V]

%_________________________________________________________________________
%Fujita_IAEA(2021)__________________________________________________________
obj.EQ_NE= 1.238 - 0.18816*r.^2 -0.36092*r.^4 + 4.1859*r.^6 - 4.2331*r.^8;%[1x10^19m^-3]
obj.EQ_TE= 3.633 - 2.6128*r.^2 + 0.10186*r.^4 - 0.56081*r.^6;%[keV]
%_________________________________________________________________________
%Model____________________________________________________________________
%obj.EQ_poten=-4e3*(1-r.^2);
%obj.EQ_NE= 1*(1-r.^2);%[1x10^19m^-3]
%obj.EQ_TE=0.2*ones(num2,num3,num1);%[keV]
%_________________________________________________________________________
obj.PA=[obj.Rax(1,1),obj.zax(1,1)];
%
end