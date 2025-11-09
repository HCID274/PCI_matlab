% read 'PARAM.dat', including simulation parameters
function fread_param2(obj)
file='PARAM.dat';
str=sprintf('%s%s',obj.indir,file)
fid=fopen(str,'r',obj.endian);
RET=fread(fid,1,'int');%return key
obj.FVER=fread(fid,1,'float');
RET=fread(fid,1,'double');
%{
if obj.FVER ~= 3.5
    error('Simulation type mismatch 1.')
end
%}
% original
% R[0:IRMAX],LKY[-LYM+2:LYM-1],LKZ[0:LZM-1]
% LYM=KYM/2+1,LZM=KZM/2+1
% adjusted to NLD format
% R[0:IRMAX],m[-KYM+1:KYM],n[0:KZM]
% LMAX=2*KYM*KZM+1
obj.IRMAX=fread(fid,1,'int');
KYMt=fread(fid,1,'int');
KZMt=fread(fid,1,'int');
obj.LYM2=KYMt;
obj.LZM2=KZMt/2+1;
obj.KYM=KYMt/2+1-1;
obj.KZM=obj.LZM2-1;
obj.LMAX=2*obj.KYM*(obj.KZM+1)-1;
LKYt=fread(fid,KYMt,'int');
LKZt=fread(fid,obj.LZM2,'int');
obj.LKY=reshape(repmat(LKYt,1,obj.LZM2),obj.LMAX+1,1);
obj.LKZ=reshape(repmat(LKZt.',obj.LYM2,1),obj.LMAX+1,1);
RET=fread(fid,1,'double');%return key
obj.BETAI=fread(fid,1,'double');
obj.BETAE=fread(fid,1,'double');
obj.DELTA=fread(fid,1,'double');
obj.EPSILON=fread(fid,1,'double');
obj.VISPSI=fread(fid,1,'double');
obj.VISVPL_PAR=fread(fid,1,'double');
obj.VISPRE_PAR=fread(fid,1,'double');
obj.VISVOL=fread(fid,1,'double');
obj.VISCUR=fread(fid,1,'double');
obj.VISPRE=fread(fid,1,'double');
obj.VISVPL=fread(fid,1,'double');
obj.VIS_TEME=fread(fid,1,'double');
obj.VIS_KAIE_PARA=fread(fid,1,'double');
obj.VIS_KAIE_PERP=fread(fid,1,'double');
obj.VIS_KAII_PARA=fread(fid,1,'double');
obj.VIS_KAII_PERP=fread(fid,1,'double');
RET=fread(fid,1,'double');%return key
obj.R=fread(fid,obj.IRMAX+1,'double');
obj.Q=fread(fid,obj.IRMAX+1,'double');
obj.AEQ=fread(fid,obj.IRMAX+1,'double');
obj.CURQ=fread(fid,obj.IRMAX+1,'double');
obj.PREQ=fread(fid,obj.IRMAX+1,'double');
obj.DENSQ=fread(fid,obj.IRMAX+1,'double');
obj.TEMEQ=fread(fid,obj.IRMAX+1,'double');
obj.TEMIQ=fread(fid,obj.IRMAX+1,'double');
obj.TEMTQ=fread(fid,obj.IRMAX+1,'double');
fclose(fid);
%
end