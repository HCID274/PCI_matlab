% read EQ magnetic field
function fread_EQmag(obj,f_EQmag)
%
file=sprintf('%s%s',obj.indir,f_EQmag)
fid=fopen(file,'r','ieee-be');
NPHIGM_set=68; % 32*n+4
%
%RET=fread(fid,1,'int');%return key
NRGM=fread(fid,1,'int')
NZGM=fread(fid,1,'int')
NPHIGM=fread(fid,1,'int')
RG=fread(fid,6,'double')
DR=fread(fid,3,'double')
GBPR2=fread(fid,NRGM*NZGM*NPHIGM,'double');
GBPZ2=fread(fid,NRGM*NZGM*NPHIGM,'double');
GBTP2=fread(fid,NRGM*NZGM*NPHIGM,'double');
GBPP2=fread(fid,NRGM*NZGM*NPHIGM,'double');
fclose(fid);
%
if (NPHIGM == 1)
NPHIGM=NPHIGM_set;
sprintf('NPHIGM changed to %d',NPHIGM)
GBPR2=repmat(GBPR2,[NPHIGM 1]);
GBPZ2=repmat(GBPZ2,[NPHIGM 1]);
GBTP2=repmat(GBTP2,[NPHIGM 1]);
GBPP2=repmat(GBPP2,[NPHIGM 1]);
RG(5)=0.0;
DR(3)=2.0*pi/(NPHIGM-1);
end
%
GBPR=reshape(GBPR2,NRGM,NZGM,NPHIGM);
GBPZ=reshape(GBPZ2,NRGM,NZGM,NPHIGM);
GBTP=reshape(GBTP2,NRGM,NZGM,NPHIGM);
GBPP=reshape(GBPP2,NRGM,NZGM,NPHIGM);
%
if 1==0
x0=RG(1)+[0:NRGM-1]*DR(1);
y0=RG(3)+[0:NRGM-1]*DR(2);
[x,y]=meshgrid(x0,y0);
subplot(221)
GBPRt=squeeze(GBPR(:,:,1));
contourf(x,y,GBPRt.',30,'LineStyle','none')
axis equal
title('B_R');
subplot(222)
GBPRt=GBPZ(:,:,1);
contourf(x,y,GBPRt.',30,'LineStyle','none')
axis equal
title('B_z');
subplot(223)
GBPRt=GBTP(:,:,1);
contourf(x,y,GBPRt.',30,'LineStyle','none')
axis equal
title('B_t');
subplot(224)
GBPRt=GBPP(:,:,1);
contourf(x,y,GBPRt.',30,'LineStyle','none')
axis equal
title('P');
xlabel('R');
end
%
obj.NRGM=NRGM;
obj.NZGM=NZGM;
obj.NPHIGM=NPHIGM;
obj.RG1=RG(1:2);
obj.RG2=RG(3:4);
obj.RG3=RG(5:6);
obj.DR1=DR(1);
obj.DR2=DR(2);
obj.DR3=DR(3);
obj.GBPR_3d=GBPR;
obj.GBPZ_3d=GBPZ;
obj.GBTP_3d=GBTP;
obj.GBPP_3d=GBPP;
obj.GBPR_2d=squeeze(GBPR(:,:,1));
obj.GBPZ_2d=squeeze(GBPZ(:,:,1));
obj.GBTP_2d=squeeze(GBTP(:,:,1));
obj.GBPP_2d=squeeze(GBPP(:,:,1));
%
[B(1) B(3) B(2) PP]=probeEQ_mag(obj,obj.PA(1),obj.PA(2),0.0);
obj.B0=B(2);
end