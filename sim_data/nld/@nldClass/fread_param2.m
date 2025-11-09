% read 'PARAM.dat', including simulation parameters
function fread_param2(obj)
file='PARAM.dat';
str=sprintf('%s%s',obj.indir,file)
fid=fopen(str,'r',obj.endian);
RET=fread(fid,1,'int');%return key
obj.FVER=fread(fid,1,'float');
RET=fread(fid,1,'double');
if fix(obj.FVER) ~= 1
    error('Simulation type mismatch 1.')
end
%
obj.IRMAX=fread(fid,1,'int');
obj.KYM=fread(fid,1,'int');
obj.KZM=fread(fid,1,'int');
obj.WIN=fread(fid,1,'double');
obj.WEN=fread(fid,1,'double');
obj.WEI=fread(fid,1,'double');
obj.RHOS=fread(fid,1,'double');
obj.A=fread(fid,1,'double');
obj.BT=fread(fid,1,'double');
obj.MASSN=fread(fid,1,'double');
obj.LAMBDA=fread(fid,1,'double');
obj.VISVOL=fread(fid,1,'double');
obj.VISVPL=fread(fid,1,'double');
obj.VISNE=fread(fid,1,'double');
RET=fread(fid,1,'double');%return key
obj.LMAX=fread(fid,1,'int');
obj.LSTA=fread(fid,1,'int');
obj.LEND=fread(fid,1,'int');
RET=fread(fid,1,'double');%return key
LKYt=fread(fid,2*obj.LMAX+1,'int');
LKZt=fread(fid,2*obj.LMAX+1,'int');
obj.LKY=LKYt(obj.LMAX+1:2*obj.LMAX+1);
obj.LKZ=LKZt(obj.LMAX+1:2*obj.LMAX+1);
obj.R=fread(fid,obj.IRMAX+1,'double');
obj.PHIEQ=fread(fid,obj.IRMAX+1,'double');
obj.VEQ=fread(fid,obj.IRMAX+1,'double');
obj.NEQ=fread(fid,obj.IRMAX+1,'double');
obj.PHIS=fread(fid,obj.IRMAX+1,'double');
obj.VPLS=fread(fid,obj.IRMAX+1,'double');
obj.NES=fread(fid,obj.IRMAX+1,'double');
fclose(fid);
%
end