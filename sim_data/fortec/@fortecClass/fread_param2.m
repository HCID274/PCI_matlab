% read 'PARAM.dat', including simulation parameters for FORTEC data
function fread_param2(obj)
file='PARAM.dat';
str=strcat(obj.indir,file)
fid=fopen(str,'r',obj.endian);
obj.FVER=fread(fid,1,'float');
obj.num1=fread(fid,1,'float');
obj.num2=fread(fid,1,'float');
obj.num3=fread(fid,1,'float');
obj.phi_s=fread(fid,1,'float');
obj.phi_e=fread(fid,1,'float');
fclose(fid);