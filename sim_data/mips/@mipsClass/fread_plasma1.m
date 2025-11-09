% read plasma variables from Fourier decomposition
function fread_plasma1(obj,t)
%
lrnet=obj.NRGM;
lznet=obj.NZGM;
lphinet=obj.NPHIGM;
%
data1=zeros(lrnet*lznet*lphinet,1);
data2=zeros(3*lrnet*lznet*lphinet,1);
str=sprintf('%s%08d_2.dat',obj.indir,t*100)
fid=fopen(str,'r',obj.endian);
fread(fid,1,'int');
kstep=fread(fid,1,'int')
t=fread(fid,1,'double')
% rho
data1=fread(fid,lrnet*lznet*lphinet,'double');
%obj.NE=reshape(data1,lrnet,lznet,lphinet);
% pressure
data1=fread(fid,lrnet*lznet*lphinet,'double');
p=reshape(data1,lrnet,lznet,lphinet);
obj.PLASMA_NE_total=p;
obj.PLASMA_NE0=zeros(lrnet,lznet,lphinet);
obj.PLASMA_NE1=zeros(lrnet,lznet,lphinet);
obj.PLASMA_TE0=obj.Te*ones(lrnet,lznet,lphinet);
obj.PLASMA_TE1=zeros(lrnet,lznet,lphinet);
obj.PLASMA_TE_total=obj.PLASMA_TE0+obj.PLASMA_TE1;
% electric field
data2=fread(fid,3*lrnet*lznet*lphinet,'double');
obj.EF=reshape(data2,lrnet,lznet,lphinet,3);
obj.EF=obj.EF*obj.B0*1.38e6;
% magnetic field (perturbation)
data2=fread(fid,3*lrnet*lznet*lphinet,'double');
obj.BF=reshape(data2,lrnet,lznet,lphinet,3);
obj.BF=obj.BF*obj.B0;
%
obj.PLASMA_PHI_total=zeros(lrnet,lznet,lphinet);
%
fclose(fid);
%
end