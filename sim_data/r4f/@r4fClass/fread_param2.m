% read 'PARAM.dat', including simulation parameters
function fread_param2(obj)
file='PARAM.dat';
str=strcat(obj.indir,file)
fid=fopen(str,'r',obj.endian);
RET=fread(fid,1,'int');%return key
obj.FVER=fread(fid,1,'float');
RET=fread(fid,1,'double');
%
obj.IRMAX=fread(fid,1,'int');
obj.KYM=fread(fid,1,'int');
obj.KZM=fread(fid,1,'int');
obj.BETA=fread(fid,1,'double');
obj.DELTA=fread(fid,1,'double');
obj.EPSILON=fread(fid,1,'double');
obj.PREPW=fread(fid,1,'double');
obj.TAU=fread(fid,1,'double');
obj.VISVOL=fread(fid,1,'double');
obj.VISCUR=fread(fid,1,'double');
obj.VISPSI=fread(fid,1,'double');
obj.VISVPL=fread(fid,1,'double');
obj.VISPRE=fread(fid,1,'double');
RET=fread(fid,1,'double');%return key
obj.LMAX=fread(fid,1,'int');
obj.LSTA=fread(fid,1,'int');
obj.LEND=fread(fid,1,'int');
RET=fread(fid,1,'double');%return key
LKYt=fread(fid,2*obj.LMAX+1,'int');
LKZt=fread(fid,2*obj.LMAX+1,'int');
obj.LKY=LKYt(obj.LMAX+1:2*obj.LMAX+1);
obj.LKZ=LKZt(obj.LMAX+1:2*obj.LMAX+1);
%obj.LKY=fread(fid,obj.LMAX,'int');%for Yagi code
%obj.LKZ=fread(fid,obj.LMAX,'int');%for Yagi code
obj.R=fread(fid,obj.IRMAX+1,'double');
obj.Q=fread(fid,obj.IRMAX+1,'double');
obj.CURQ=fread(fid,obj.IRMAX+1,'double');
obj.NEQ=fread(fid,obj.IRMAX+1,'double');
obj.AEQ=fread(fid,obj.IRMAX+1,'double');

%
fclose(fid);
end