dataC=magLHDClass;
indir='E:/Documents/data/FORTEC/yoshihara/001/';
endian='ieee-be';
str='mag_dt0.01';
f_mag=sprintf('%s%s.dat',indir,str)
fread_mag(dataC,f_mag,endian);
dataC


