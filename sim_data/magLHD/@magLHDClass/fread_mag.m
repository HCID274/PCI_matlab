function fread_mag(obj,f_mag,endian)
%
%str=sprintf('%s%s.dat',obj.indir,f_mag)
fid=fopen(f_mag,'r',endian);
obj.NRGM=fread(fid,1,'float');
obj.NPHIGM=fread(fid,1,'float');
obj.NZGM=fread(fid,1,'float');
num1=obj.NRGM;
num2=obj.NPHIGM;
num3=obj.NZGM;
%num1=451;
%num2=101;
%num3=651;
obj.R_mag=fread(fid,num1,'float');
obj.Phi_mag=fread(fid,num2,'float');
obj.Z_mag=fread(fid,num3,'float');
data=fread(fid,num1*num2*num3,'float');
obj.BF1=reshape(data,num1,num2,num3);
data=fread(fid,num1*num2*num3,'float');
obj.BF2=reshape(-data,num1,num2,num3);
data=fread(fid,num1*num2*num3,'float');
obj.BF3=reshape(data,num1,num2,num3);
data=fread(fid,num1*num2*num3,'float');
obj.BFmag=reshape(data,num1,num2,num3);
fclose(fid);
%LHD positive(anti clockwise) <-> (R,Z,phi) positive(clockwise)
obj.BF1=-obj.BF1;%B inversion when HIBP measurement
obj.BF2=-obj.BF2;%
obj.BF3=-obj.BF3;%
phi0=obj.Phi_mag(num2);
obj.Phi_mag=-obj.Phi_mag+phi0;
obj.BF3D=zeros(3,num1+6,num2+6,num3+6);
obj.BF3D(1,4:end-3,4:end-3,4:end-3)=obj.BF1;
%obj.BF3D(1,:,1:3,:)=obj.BF3D(1,:,end-6:end-4,:);%cyclic
%obj.BF3D(1,:,end-2:end,:)=obj.BF3D(1,:,5:7,:);%cyclic
obj.BF3D(2,4:end-3,4:end-3,4:end-3)=obj.BF2;
%obj.BF3D(2,:,1:3,:)=obj.BF3D(2,:,end-6:end-4,:);%cyclic
%obj.BF3D(2,:,end-2:end,:)=obj.BF3D(2,:,5:7,:);%cyclic
obj.BF3D(3,4:end-3,4:end-3,4:end-3)=obj.BF3;
%obj.BF3D(3,:,1:3,:)=obj.BF3D(3,:,end-6:end-4,:);%cyclic
%obj.BF3D(3,:,end-2:end,:)=obj.BF3D(3,:,5:7,:);%cyclic
%{
[Z,R]=meshgrid(obj.Z_mag,obj.R_mag);
data=squeeze(obj.BF1(:,1,:));
figure(3)
subplot(1,1,1)
contourf(R,Z,data,100,'LineStyle','none')
axis equal
%}
% for spl3d
XSD=obj.R_mag(1);
XLD=obj.R_mag(end);
YSD=obj.Phi_mag(end);
YLD=obj.Phi_mag(1);
ZSD=obj.Z_mag(1);
ZLD=obj.Z_mag(end);
NCDX6=obj.NRGM+6;
NCDY6=obj.NPHIGM+6;
NCDZ6=obj.NZGM+6;
SPLIN3(XSD,XLD, YSD,YLD, ZSD,ZLD, NCDX6,NCDY6,NCDZ6);
%
end

