function fread_EQ1(obj)
%
% mag, fluc from FORTEC output 
%fread_EQ_FORTEC(obj);
%
% mag from IDO sensei code, fluc from FORTEC output 
f_VMEC='strow2D_FORTEC2_EQ';
str='mag_dt0.01';
f_mag=sprintf('%s%s.dat',obj.indir,str);
fread_VMEC_FORTEC(obj,f_VMEC)
fread_mag(obj,f_mag,obj.endian)
%
end